(*  Title:      HOL/Tools/Old_Datatype/old_size.ML
    Author:     Stefan Berghofer, Florian Haftmann, TU Muenchen

Size functions for old-style datatypes.
*)

structure Old_Size: sig end =
struct

fun plus (t1, t2) = Const (@{const_name Groups.plus},
  HOLogic.natT --> HOLogic.natT --> HOLogic.natT) $ t1 $ t2;

fun size_of_type f g h (T as Type (s, Ts)) =
      (case f s of
         SOME t => SOME t
       | NONE => (case g s of
           SOME size_name =>
             SOME (list_comb (Const (size_name,
               map (fn U => U --> HOLogic.natT) Ts @ [T] ---> HOLogic.natT),
                 map (size_of_type' f g h) Ts))
         | NONE => NONE))
  | size_of_type _ _ h (TFree (s, _)) = h s
and size_of_type' f g h T = (case size_of_type f g h T of
      NONE => Abs ("x", T, HOLogic.zero)
    | SOME t => t);

fun is_poly thy (Old_Datatype_Aux.DtType (name, dts)) =
      is_some (BNF_LFP_Size.size_of_global thy name) andalso exists (is_poly thy) dts
  | is_poly _ _ = true;

fun constrs_of thy name =
  let
    val {descr, index, ...} = Old_Datatype_Data.the_info thy name
    val SOME (_, _, constrs) = AList.lookup op = descr index
  in constrs end;

val app = curry (list_comb o swap);

fun prove_size_thms (info : Old_Datatype_Aux.info) new_type_names thy =
  let
    val {descr, rec_names, rec_rewrites, induct, ...} = info;
    val l = length new_type_names;
    val descr' = List.take (descr, l);
    val tycos = map (#1 o snd) descr';
  in
    if forall (fn tyco => can (Sign.arity_sorts thy tyco) [HOLogic.class_size]) tycos then
      (* nothing to do -- the "size" function is already defined *)
      thy
    else
      let
        val recTs = Old_Datatype_Aux.get_rec_types descr;
        val (recTs1, recTs2) = chop l recTs;
        val (_, (_, paramdts, _)) :: _ = descr;
        val paramTs = map (Old_Datatype_Aux.typ_of_dtyp descr) paramdts;
        val ((param_size_fs, param_size_fTs), f_names) = paramTs |>
          map (fn T as TFree (s, _) =>
            let
              val name = "f" ^ unprefix "'" s;
              val U = T --> HOLogic.natT
            in
              (((s, Free (name, U)), U), name)
            end) |> split_list |>> split_list;
        val param_size = AList.lookup op = param_size_fs;

        val extra_rewrites = descr |> map (#1 o snd) |> distinct op = |>
          map_filter (Option.map (#2 o snd) o BNF_LFP_Size.size_of_global thy) |> flat;
        val extra_size = Option.map fst o BNF_LFP_Size.size_of_global thy;

        val (((size_names, size_fns), def_names), def_names') =
          recTs1 |> map (fn T as Type (s, _) =>
            let
              val s' = "size_" ^ Long_Name.base_name s;
              val s'' = Sign.full_bname thy s';
            in
              (s'',
               (list_comb (Const (s'', param_size_fTs @ [T] ---> HOLogic.natT),
                  map snd param_size_fs),
                (s' ^ "_def", s' ^ "_overloaded_def")))
            end) |> split_list ||>> split_list ||>> split_list;
        val overloaded_size_fns = map HOLogic.size_const recTs1;

        (* instantiation for primrec combinator *)
        fun size_of_constr b size_ofp ((_, cargs), (_, cargs')) =
          let
            val Ts = map (Old_Datatype_Aux.typ_of_dtyp descr) cargs;
            val k = length (filter Old_Datatype_Aux.is_rec_type cargs);
            val (ts, _, _) = fold_rev (fn ((dt, dt'), T) => fn (us, i, j) =>
              if Old_Datatype_Aux.is_rec_type dt then (Bound i :: us, i + 1, j + 1)
              else
                (if b andalso is_poly thy dt' then
                   case size_of_type (K NONE) extra_size size_ofp T of
                     NONE => us | SOME sz => sz $ Bound j :: us
                 else us, i, j + 1))
                  (cargs ~~ cargs' ~~ Ts) ([], 0, k);
            val t =
              if null ts andalso (not b orelse not (exists (is_poly thy) cargs'))
              then HOLogic.zero
              else foldl1 plus (ts @ [HOLogic.Suc_zero])
          in
            fold_rev (fn T => fn t' => Abs ("x", T, t')) (Ts @ replicate k HOLogic.natT) t
          end;

        val fs = maps (fn (_, (name, _, constrs)) =>
          map (size_of_constr true param_size) (constrs ~~ constrs_of thy name)) descr;
        val fs' = maps (fn (n, (name, _, constrs)) =>
          map (size_of_constr (l <= n) (K NONE)) (constrs ~~ constrs_of thy name)) descr;
        val fTs = map fastype_of fs;

        val (rec_combs1, rec_combs2) = chop l (map (fn (T, rec_name) =>
          Const (rec_name, fTs @ [T] ---> HOLogic.natT))
            (recTs ~~ rec_names));

        fun define_overloaded (def_name, eq) lthy =
          let
            val (Free (c, _), rhs) = (Logic.dest_equals o Syntax.check_term lthy) eq;
            val (thm, lthy') = lthy
              |> Local_Theory.define ((Binding.name c, NoSyn), ((Binding.name def_name, []), rhs))
              |-> (fn (t, (_, thm)) => Spec_Rules.add Spec_Rules.Equational ([t], [thm]) #> pair thm);
            val ctxt_thy = Proof_Context.init_global (Proof_Context.theory_of lthy');
            val thm' = singleton (Proof_Context.export lthy' ctxt_thy) thm;
          in (thm', lthy') end;

        val ((size_def_thms, size_def_thms'), thy') =
          thy
          |> Sign.add_consts (map (fn (s, T) => (Binding.name (Long_Name.base_name s),
              param_size_fTs @ [T] ---> HOLogic.natT, NoSyn))
            (size_names ~~ recTs1))
          |> Global_Theory.add_defs false
            (map (Thm.no_attributes o apsnd (Logic.mk_equals o apsnd (app fs)))
               (map Binding.name def_names ~~ (size_fns ~~ rec_combs1)))
          ||> Class.instantiation (tycos, map dest_TFree paramTs, [HOLogic.class_size])
          ||>> fold_map define_overloaded
            (def_names' ~~ map Logic.mk_equals (overloaded_size_fns ~~ map (app fs') rec_combs1))
          ||> Class.prove_instantiation_instance (fn ctxt => Class.intro_classes_tac ctxt [])
          ||> Local_Theory.exit_global;

        val ctxt = Proof_Context.init_global thy';

        val simpset1 =
          put_simpset HOL_basic_ss ctxt addsimps @{thm Nat.add_0} :: @{thm Nat.add_0_right} ::
            size_def_thms @ size_def_thms' @ rec_rewrites @ extra_rewrites;
        val xs = map (fn i => "x" ^ string_of_int i) (1 upto length recTs2);

        fun mk_unfolded_size_eq tab size_ofp fs (p as (_, T), r) =
          HOLogic.mk_eq (app fs r $ Free p,
            the (size_of_type tab extra_size size_ofp T) $ Free p);

        fun prove_unfolded_size_eqs size_ofp fs =
          if null recTs2 then []
          else Old_Datatype_Aux.split_conj_thm (Goal.prove_sorry ctxt xs []
            (HOLogic.mk_Trueprop (Old_Datatype_Aux.mk_conj (replicate l @{term True} @
               map (mk_unfolded_size_eq (AList.lookup op =
                   (new_type_names ~~ map (app fs) rec_combs1)) size_ofp fs)
                 (xs ~~ recTs2 ~~ rec_combs2))))
            (fn _ => (Old_Datatype_Aux.ind_tac ctxt induct xs THEN_ALL_NEW asm_simp_tac simpset1) 1));

        val unfolded_size_eqs1 = prove_unfolded_size_eqs param_size fs;
        val unfolded_size_eqs2 = prove_unfolded_size_eqs (K NONE) fs';

        (* characteristic equations for size functions *)
        fun gen_mk_size_eq p size_of size_ofp size_const T (cname, cargs) =
          let
            val Ts = map (Old_Datatype_Aux.typ_of_dtyp descr) cargs;
            val tnames = Name.variant_list f_names (Old_Datatype_Prop.make_tnames Ts);
            val ts = map_filter (fn (sT as (_, T), dt) =>
              Option.map (fn sz => sz $ Free sT)
                (if p dt then size_of_type size_of extra_size size_ofp T
                 else NONE)) (tnames ~~ Ts ~~ cargs)
          in
            HOLogic.mk_Trueprop (HOLogic.mk_eq
              (size_const $ list_comb (Const (cname, Ts ---> T),
                 map2 (curry Free) tnames Ts),
               if null ts then HOLogic.zero
               else foldl1 plus (ts @ [HOLogic.Suc_zero])))
          end;

        val simpset2 =
          put_simpset HOL_basic_ss ctxt
            addsimps (rec_rewrites @ size_def_thms @ unfolded_size_eqs1);
        val simpset3 =
          put_simpset HOL_basic_ss ctxt
            addsimps (rec_rewrites @ size_def_thms' @ unfolded_size_eqs2);

        fun prove_size_eqs p size_fns size_ofp simpset =
          maps (fn (((_, (_, _, constrs)), size_const), T) =>
            map (fn constr => Drule.export_without_context (Goal.prove_sorry ctxt [] []
              (gen_mk_size_eq p (AList.lookup op = (new_type_names ~~ size_fns))
                 size_ofp size_const T constr)
              (fn _ => simp_tac simpset 1))) constrs)
            (descr' ~~ size_fns ~~ recTs1);

        val size_eqns = prove_size_eqs (is_poly thy') size_fns param_size simpset2 @
          prove_size_eqs Old_Datatype_Aux.is_rec_type overloaded_size_fns (K NONE) simpset3;

        val ([(_, size_thms)], thy'') = thy'
          |> Global_Theory.note_thmss ""
            [((Binding.name "size",
                [Simplifier.simp_add, Named_Theorems.add @{named_theorems nitpick_simp}]),
              [(size_eqns, [])])];

      in
        thy''
        |> fold2 (fn new_type_name => fn size_name =>
            BNF_LFP_Size.register_size_global new_type_name size_name refl(*dummy*) size_thms [])
          new_type_names size_names 
        |> Code.declare_default_eqns_global (map (rpair true) size_thms)
      end
  end;

fun add_size_thms config (new_type_names as name :: _) =
  if #skip_level config >= 1 then I else fn thy =>
  let
    val info as {descr, ...} = Old_Datatype_Data.the_info thy name;
    val prefix = space_implode "_" (map Long_Name.base_name new_type_names);
    val no_size = exists (fn (_, (_, _, constrs)) => exists (fn (_, cargs) => exists (fn dt =>
      Old_Datatype_Aux.is_rec_type dt andalso
        not (null (fst (Old_Datatype_Aux.strip_dtyp dt)))) cargs) constrs) descr
  in
    if no_size then thy
    else
      thy
      |> Sign.add_path prefix
      |> prove_size_thms info new_type_names
      |> Sign.restore_naming thy
  end;

val _ = Theory.setup (Old_Datatype_Data.interpretation add_size_thms);

end;
