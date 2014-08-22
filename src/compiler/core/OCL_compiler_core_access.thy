(*****************************************************************************
 * Featherweight-OCL --- A Formal Semantics for UML-OCL Version OCL 2.4
 *                       for the OMG Standard.
 *                       http://www.brucker.ch/projects/hol-testgen/
 *
 * OCL_compiler_core_access.thy ---
 * This file is part of HOL-TestGen.
 *
 * Copyright (c) 2013-2014 Universite Paris-Sud, France
 *               2013-2014 IRT SystemX, France
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *
 *     * Redistributions in binary form must reproduce the above
 *       copyright notice, this list of conditions and the following
 *       disclaimer in the documentation and/or other materials provided
 *       with the distribution.
 *
 *     * Neither the name of the copyright holders nor the names of its
 *       contributors may be used to endorse or promote products derived
 *       from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 ******************************************************************************)
(* $Id:$ *)

header{* Part ... *}

theory  OCL_compiler_core_access
imports OCL_compiler_core_init
begin

section{* Translation of AST *}

subsection{* accessors *}

definition "print_access_oid_uniq_gen Thy_def D_oid_start_upd def_rewrite =
  (\<lambda>expr ocl.
      (\<lambda>(l, oid_start). (List_map Thy_def l, D_oid_start_upd ocl oid_start))
      (let (l, (acc, _)) = fold_class (\<lambda>isub_name name l_attr l_inh _ _ cpt.
         let l_inh = List_map (\<lambda> OclClass _ l _ \<Rightarrow> l) (of_inh l_inh) in
         let (l, cpt) = fold_list (fold_list
           (\<lambda> (attr, OclTy_class ty_obj) \<Rightarrow> bug_ocaml_extraction (let obj_oid = TyObj_ass_id ty_obj
                                                                     ; obj_name_from_nat = TyObjN_ass_switch (TyObj_from ty_obj) in \<lambda>(cpt, rbt) \<Rightarrow>
             let (cpt_obj, cpt_rbt) =
               case lookup rbt obj_oid of
                 None \<Rightarrow> (cpt, oidSucAssoc cpt, insert obj_oid cpt rbt)
               | Some cpt_obj \<Rightarrow> (cpt_obj, cpt, rbt) in
             ( [def_rewrite obj_name_from_nat name isub_name attr (oidGetAssoc cpt_obj)]
             , cpt_rbt))
            | _ \<Rightarrow> \<lambda>cpt. ([], cpt)))
           (l_attr # l_inh) cpt in
         (flatten (flatten l), cpt)) (D_oid_start ocl, empty) expr in
       (flatten l, acc)))"
definition "print_access_oid_uniq_ml =
  print_access_oid_uniq_gen
    Thy_ml
    (\<lambda>x _. x)
    (\<lambda>obj_name_from_nat name _ attr cpt_obj.
      Ml (Sexpr_rewrite_val
                   (Sexpr_basic [print_access_oid_uniq_mlname obj_name_from_nat name attr])
                   ''=''
                   (Sexpr_oid '''' cpt_obj)))"
definition "print_access_oid_uniq =
  print_access_oid_uniq_gen
    Thy_definition_hol
    (\<lambda>ocl oid_start. ocl \<lparr> D_oid_start := oid_start \<rparr>)
    (\<lambda>obj_name_from_nat _ isub_name attr cpt_obj.
      Definition (Expr_rewrite
                   (Expr_basic [print_access_oid_uniq_name obj_name_from_nat isub_name attr])
                   ''=''
                   (Expr_oid '''' cpt_obj)))"

definition "print_access_eval_extract _ = start_map Thy_definition_hol
  (let lets = \<lambda>var def. Definition (Expr_rewrite (Expr_basic [var]) ''='' (Expr_basic [def])) in
  [ bug_ocaml_extraction
    (let var_x = ''x''
      ; var_f = ''f''
      ; some_some = (\<lambda>x. Expr_some (Expr_some x))
      ; var_obj = ''obj'' in
    Definition (Expr_rewrite
                  (Expr_basic [var_eval_extract, var_x, var_f])
                  ''=''
                  (Expr_lam unicode_tau
                     (\<lambda>var_tau. Expr_case (Expr_basic [var_x, var_tau])
                     [ (some_some (Expr_basic [var_obj]), Expr_apply var_f [Expr_apply ''oid_of'' [Expr_basic [var_obj]], Expr_basic [var_tau]])
                     , (Expr_basic [wildcard], Expr_basic [''invalid'', var_tau])]))))
  , lets var_in_pre_state ''fst''
  , lets var_in_post_state ''snd''
  , lets var_reconst_basetype ''id'' ])"


definition "print_access_choose_switch
              lets mk_var expr
              print_access_choose_n
              sexpr_list sexpr_function sexpr_pair =
  flatten
       (List_map
          (\<lambda>n.
           let l = List_upto 0 (n - 1) in
           List_map (let l = sexpr_list (List_map mk_var l) in (\<lambda>(i,j).
             (lets
                (print_access_choose_n n i j)
                (sexpr_function [(l, (sexpr_pair (mk_var i) (mk_var j)))]))))
             ((flatten o flatten) (List_map (\<lambda>i. List_map (\<lambda>j. if i = j then [] else [(i, j)]) l) l)))
          (class_arity expr))"
definition "print_access_choose_ml = start_map'''' Thy_ml o (\<lambda>expr _.
  (let a = \<lambda>f x. Sexpr_apply f [x]
     ; b = \<lambda>s. Sexpr_basic [s]
     ; lets = \<lambda>var exp. Ml (Sexpr_rewrite_val (Sexpr_basic [var]) ''='' exp)
     ; mk_var = \<lambda>i. b (flatten [''x'', natural_of_str i]) in
   flatten
   [ print_access_choose_switch
       lets mk_var expr
       print_access_choose_mlname
       Sexpr_list Sexpr_function Sexpr_pair ]))"
definition "print_access_choose = start_map'''' Thy_definition_hol o (\<lambda>expr _.
  (let a = \<lambda>f x. Expr_apply f [x]
     ; b = \<lambda>s. Expr_basic [s]
     ; lets = \<lambda>var exp. Definition (Expr_rewrite (Expr_basic [var]) ''='' exp)
     ; lets' = bug_scala_extraction (\<lambda>var exp. Definition (Expr_rewrite (Expr_basic [var]) ''='' (b exp)))
     ; lets'' = bug_scala_extraction (\<lambda>var exp. Definition (Expr_rewrite (Expr_basic [var]) ''='' (Expr_lam ''l'' (\<lambda>var_l. Expr_binop (b var_l) ''!'' (b exp)))))
     ; l_flatten = ''List_flatten''
     ; _(* ignored *) = lets var_map_of_list (Expr_apply ''foldl''
      [ Expr_lam ''map'' (\<lambda>var_map.
          let var_x = ''x''
            ; var_l0 = ''l0''
            ; var_l1 = ''l1''
            ; f_map = a var_map in
          Expr_lambdas0 (Expr_pair (b var_x) (b var_l1))
            (Expr_case (f_map (b var_x))
              (List_map (\<lambda>(pat, e). (pat, f_map (Expr_binop (b var_x) unicode_mapsto e)))
                [ (b ''None'', b var_l1)
                , (Expr_some (b var_l0), a l_flatten (Expr_list (List_map b [var_l0, var_l1])))])))
      , b ''Map.empty'']) in
  flatten
  [ (bug_ocaml_extraction
    (let a = \<lambda>f x. Expr_apply f [x]
       ; b = \<lambda>s. Expr_basic [s]
       ; lets = \<lambda>var exp. Definition (Expr_rewrite (Expr_basic [var]) ''='' exp)
       ; mk_var = \<lambda>i. b (flatten [''x'', natural_of_str i]) in
     print_access_choose_switch
       lets mk_var expr
       print_access_choose_name
       Expr_list Expr_function Expr_pair))
  ,
  [ lets l_flatten (let fun_foldl = \<lambda>f base.
                       Expr_lam ''l'' (\<lambda>var_l. Expr_apply ''foldl'' [Expr_lam ''acc'' f, base, a ''rev'' (b var_l)]) in
                     fun_foldl (\<lambda>var_acc.
                       fun_foldl (\<lambda>var_acc.
                         Expr_lam ''l'' (\<lambda>var_l. Expr_apply ''Cons'' (List_map b [var_l, var_acc]))) (b var_acc)) (b ''Nil''))
  ,   let var_pre_post = ''pre_post''
        ; var_to_from = ''to_from''
        ; var_assoc_oid = ''assoc_oid''
        ; var_f = ''f''
        ; var_oid = ''oid'' in
      Definition (Expr_rewrite
        (Expr_basic [var_deref_assocs, var_pre_post, var_to_from, var_assoc_oid, var_f, var_oid ])
        ''=''
        (Expr_lam
           unicode_tau
           (\<lambda>var_tau.
           Expr_case (Expr_apply var_assocs [Expr_apply var_pre_post [Expr_basic [var_tau]]
                                                                      ,Expr_basic [var_assoc_oid]])
             [ bug_ocaml_extraction (let var_S = ''S'' in
               ( Expr_some (Expr_basic [var_S])
               , Expr_apply var_f
                   [ Expr_apply var_deref_assocs_list (List_map b [var_to_from, var_oid, var_S])
                   , Expr_basic [var_tau]]))
             , (Expr_basic[wildcard], Expr_apply ''invalid'' [Expr_basic [var_tau]]) ]))) ]] ))"

definition "print_access_deref_oid = start_map Thy_definition_hol o
  map_class (\<lambda>isub_name _ _ _ _ _.
    let var_fs = ''fst_snd''
      ; var_f = ''f''
      ; var_oid = ''oid''
      ; var_obj = ''obj'' in
    Definition (Expr_rewrite
                  (Expr_basic [isub_name var_deref_oid, var_fs, var_f, var_oid])
                  ''=''
                  (Expr_lam unicode_tau
                     (\<lambda>var_tau. Expr_case (Expr_apply ''heap'' [Expr_basic [var_fs, var_tau], Expr_basic [var_oid]])
                     [ (Expr_some (Expr_basic [isub_name datatype_in, var_obj]), Expr_basic [var_f, var_obj, var_tau])
                     , (Expr_basic [wildcard], Expr_basic [''invalid'', var_tau]) ]))))"

definition "print_access_deref_assocs_name' name_from isub_name isup_attr =
  flatten [var_deref, ''_'', isub_name var_assocs, ''_'', natural_of_str name_from, isup_attr ''_'']"
definition "print_access_deref_assocs_name name_from isub_name attr =
  print_access_deref_assocs_name' name_from isub_name (\<lambda>s. s @@ isup_of_str attr)"
definition "print_access_deref_assocs = start_map'''' Thy_definition_hol o (\<lambda>expr design_analysis.
  (if design_analysis = Gen_design then \<lambda>_. [] else (\<lambda>expr. flatten (flatten (map_class (\<lambda>isub_name name l_attr l_inherited _ _.
  let l_inherited = map_class_inh l_inherited in
  let var_fst_snd = ''fst_snd''
    ; var_f = ''f''
    ; b = \<lambda>s. Expr_basic [s] in
    flatten (List_map (List_map
      (\<lambda> (attr, OclTy_class ty_obj) \<Rightarrow>
           let name_from = TyObjN_ass_switch (TyObj_from ty_obj) in
           [Definition (Expr_rewrite
                  (Expr_basic [print_access_deref_assocs_name name_from isub_name attr, var_fst_snd, var_f])
                  ''=''
                  (Expr_binop
                    (Expr_apply
                      var_deref_assocs
                        (List_map b [ var_fst_snd
                               , print_access_choose_name (TyObj_ass_arity ty_obj) name_from (TyObjN_ass_switch (TyObj_to ty_obj))
                               , print_access_oid_uniq_name name_from isub_name attr
                               , var_f ]))
                    unicode_circ
                    (b ''oid_of'')))]
       | _ \<Rightarrow> []))
      (l_attr # l_inherited))) expr)))) expr)"

definition "print_access_select_object = start_map'''' Thy_definition_hol o (\<lambda>expr design_analysis.
  (\<lambda>_.
   bug_ocaml_extraction
   (let var_mt = ''mt''
      ; var_incl = ''incl''
      ; var_smash = ''smash''
      ; var_deref = ''deref''
      ; var_l = ''l''
      ; b = \<lambda>s. Expr_basic [s] in
    Definition (Expr_rewrite
                  (Expr_basic [var_select_object, var_mt, var_incl, var_smash, var_deref, var_l])
                  ''=''
                  (Expr_apply var_smash
                     [ Expr_apply ''foldl''
                         [ b var_incl
                         , b var_mt
                         , Expr_apply ''List.map''
                             [ b var_deref
                             , b var_l ] ]])))
  #
   (if design_analysis = Gen_design then
  [ bug_ocaml_extraction
    (let var_f = ''f''
       ; var_p = ''p''
       ; a = \<lambda>f x. Expr_apply f [x]
       ; b = \<lambda>s. Expr_basic [s] in
    Definition
      (Expr_rewrite
        (Expr_basic [var_select_object_set, var_f, var_p])
        ''=''
        (Expr_apply var_select_object
           [ b ''mtSet''
           , b ''OCL_collection_type_Set.OclIncluding''
           , b ''id''
           , a var_f (b var_p)])))
  , (let var_f = ''f''
       ; var_p = ''p''
       ; var_s_set = ''s_set''
       ; a = \<lambda>f x. Expr_apply f [x]
       ; b = \<lambda>s. Expr_basic [s] in
    Definition
      (Expr_rewrite
        (Expr_basic [var_select_object_set_any, var_f, var_p, var_s_set])
        ''=''
        (a ''OclANY'' (Expr_apply var_select_object_set (List_map b [var_f, var_p, var_s_set]))))) ]
    else [])) expr)"

definition "print_access_select = start_map'' Thy_definition_hol o (\<lambda>expr base_attr _ base_attr''.
  map_class_arg_only0 (\<lambda>isub_name name l_attr.
    let l_attr = base_attr l_attr in
    let var_f = ''f''
      ; wildc = Expr_basic [wildcard] in
    let (_, _, l) = (foldl
      (\<lambda>(l_wildl, l_wildr, l_acc) (attr, _).
        let isup_attr = (\<lambda>s. s @@ isup_of_str attr) in
        ( wildc # l_wildl
        , tl l_wildr
        , Definition (Expr_rewrite
                       (Expr_basic [isup_attr (isub_name var_select), var_f])
                       ''=''
                       (let var_attr = attr in
                        Expr_function
                          (List_map (\<lambda>(lhs,rhs). ( Expr_apply
                                                         (isub_name datatype_constr_name)
                                                         ( wildc
                                                         # flatten [l_wildl, [lhs], l_wildr])
                                                     , rhs))
                            [ ( Expr_basic [unicode_bottom], Expr_basic [''null''] )
                            , ( Expr_some (Expr_basic [var_attr])
                              , Expr_apply var_f [ bug_ocaml_extraction
                                                   (let var_x = ''x'' in
                                                      Expr_lambdas [var_x, wildcard] (Expr_some (Expr_some (Expr_basic [var_x]))))
                                                 , Expr_basic [var_attr]]) ]))) # l_acc))
      ([], List_map (\<lambda>_. wildc) (tl l_attr), [])
      l_attr) in
    rev l)
  (\<lambda>isub_name name (l_attr, l_inherited, l_cons).
    let l_inherited = flatten (List_map (\<lambda> OclClass _ l _ \<Rightarrow> l) (of_inh l_inherited)) in
    let (l_attr, l_inherited) = base_attr'' (l_attr, l_inherited) in
    let var_f = ''f''
      ; wildc = Expr_basic [wildcard] in
    let (_, _, l) = (foldl
      (\<lambda>(l_wildl, l_wildr, l_acc) (attr, _).
        let isup_attr = (\<lambda>s. s @@ isup_of_str attr) in
        ( wildc # l_wildl
        , tl l_wildr
        , Definition (Expr_rewrite
                       (Expr_basic [isup_attr (isub_name var_select), var_f])
                       ''=''
                       (let var_attr = attr in
                        Expr_function
                          (flatten (List_map (\<lambda>(lhs,rhs). ( Expr_apply
                                                         (isub_name datatype_constr_name)
                                                         ( Expr_apply (isub_name datatype_ext_constr_name)
                                                             (wildc # flatten [l_wildl, [lhs], l_wildr])
                                                         # List_map (\<lambda>_. wildc) l_attr)
                                                     , rhs))
                            [ ( Expr_basic [unicode_bottom], Expr_basic [''null''] )
                            , ( Expr_some (Expr_basic [var_attr])
                              , Expr_apply var_f [ bug_ocaml_extraction
                                                   (let var_x = ''x'' in
                                                      Expr_lambdas [var_x, wildcard] (Expr_some (Expr_some (Expr_basic [var_x]))))
                                                 , Expr_basic [var_attr]]) ]
                            # (List_map (\<lambda> OclClass x _ _ \<Rightarrow> let var_x = lowercase_of_str x in
                                             (Expr_apply
                                                         (isub_name datatype_constr_name)
                                                         ( Expr_apply (datatype_ext_constr_name @@ mk_constr_name name x)
                                                             [Expr_basic [var_x]]
                                                         # List_map (\<lambda>_. wildc) l_attr), (Expr_apply (isup_attr (var_select @@ isub_of_str x))
                                                                                                     (List_map (\<lambda>x. Expr_basic [x]) [var_f, var_x]) ))) (of_sub l_cons))
                            # [])))) # l_acc))
      ([], List_map (\<lambda>_. wildc) (tl l_inherited), [])
      l_inherited) in
    rev l) expr)"

definition "print_access_select_obj = start_map'''' Thy_definition_hol o (\<lambda>expr design_analysis.
  (if design_analysis = Gen_design then \<lambda>_. [] else (\<lambda>expr. flatten (flatten (map_class (\<lambda>isub_name name l_attr l_inh _ _.
    let l_inh = map_class_inh l_inh in
    flatten (fst (fold_list (fold_list
      (\<lambda> (attr, OclTy_class ty_obj) \<Rightarrow> \<lambda>rbt.
          if lookup2 rbt (name, attr) = None then
           ([Definition (let var_f = ''f''
                          ; b = \<lambda>s. Expr_basic [s] in
              Expr_rewrite
                  (Expr_basic [isub_name var_select @@ isup_of_str attr, var_f])
                  ''=''
                  (Expr_apply var_select_object
                    [ b ''mtSet''
                    , b ''OCL_collection_type_Set.OclIncluding''
                    , b (if single_multip (TyObjN_role_multip (TyObj_to ty_obj)) then ''OclANY'' else ''id'')
                    , Expr_apply var_f [let var_x = ''x'' in
                                        Expr_lambdas [var_x, wildcard] (Expr_some (Expr_some (Expr_basic [var_x])))]]))], insert2 (name, attr) () rbt)
         else ([], rbt)
       | _ \<Rightarrow> Pair []))
      (l_attr # l_inh) empty))) expr)))) expr)"

definition "print_access_dot_consts =
 (fold_list (\<lambda>(f_update, x) ocl. (Thy_consts_class x, ocl \<lparr> D_accessor_rbt := f_update (D_accessor_rbt ocl) \<rparr> ))) o
  (flatten o flatten o map_class (\<lambda>isub_name name l_attr _ _ _.
    List_map (\<lambda>(attr_n, attr_ty).
      List_map
        (\<lambda>(var_at_when_hol, var_at_when_ocl, f_update_ocl).
          let name =
             flatten [ ''dot''
                     , case attr_ty of
                         OclTy_class ty_obj \<Rightarrow> flatten [''_'', natural_of_str (TyObjN_ass_switch (TyObj_from ty_obj)), ''_'']
                       | _ \<Rightarrow> ''''
                     , isup_of_str attr_n, var_at_when_hol] in
          ( f_update_ocl (\<lambda> l. name # l)
          , Consts_raw0
            name
            (Ty_arrow
              (Ty_apply (Ty_base ''val'') [Ty_base unicode_AA, Ty_base (Char Nibble2 Nibble7 # unicode_alpha)])

              (let ty_base = \<lambda>attr_ty. 
                 Ty_apply (Ty_base ''val'') [Ty_base unicode_AA,
                    let option = \<lambda>x. Ty_apply (Ty_base ''option'') [x] in
                    option (option (Ty_base attr_ty))] in
               case attr_ty of
                  OclTy_raw attr_ty \<Rightarrow> ty_base attr_ty
                | OclTy_class ty_obj \<Rightarrow>
                    let ty_obj = TyObj_to ty_obj
                      ; name = TyObjN_role_ty ty_obj in
                    Ty_base (if single_multip (TyObjN_role_multip ty_obj) then
                               name
                             else
                               print_infra_type_synonym_class_set_name name)
                | _ \<Rightarrow> ty_base (str_hol_of_ty attr_ty)))
            (let dot_name = mk_dot attr_n var_at_when_ocl
               ; mk_par =
                   let esc = \<lambda>s. Char Nibble2 Nibble7 # s in
                   (\<lambda>s1 s2. flatten [s1, '' '', esc ''/'', ''* '', s2, '' *'', esc ''/'']) in
             case attr_ty of OclTy_class ty_obj \<Rightarrow>
               (case apply_optim_ass_arity ty_obj (mk_par dot_name (bug_ocaml_extraction (let ty_obj = TyObj_from ty_obj in case TyObjN_role_name ty_obj of None => natural_of_str (TyObjN_ass_switch ty_obj) | Some s => s))) of
                  None \<Rightarrow> dot_name
                | Some dot_name \<Rightarrow> dot_name)
                           | _ \<Rightarrow> dot_name)
            None))
        [ (var_at_when_hol_post, var_at_when_ocl_post, update_D_accessor_rbt_post)
        , (var_at_when_hol_pre, var_at_when_ocl_pre, update_D_accessor_rbt_pre)]) l_attr))"

definition "print_access_dot_name isub_name dot_at_when attr_ty isup_attr =
  flatten [isup_attr (let dot_name = isub_name ''dot'' in
                      case attr_ty of
                        OclTy_class ty_obj \<Rightarrow> flatten [dot_name, ''_'', natural_of_str (TyObjN_ass_switch (TyObj_from ty_obj)), ''_'']
                      | _ \<Rightarrow> dot_name), dot_at_when]"

definition "print_access_dot = start_map'''' Thy_defs_overloaded o (\<lambda>expr design_analysis.
  map_class_arg_only_var'
    (\<lambda>isub_name name (var_in_when_state, dot_at_when) attr_ty isup_attr dot_attr.
            [ Defs_overloaded
                (print_access_dot_name isub_name dot_at_when attr_ty isup_attr)
                (let var_x = ''x'' in
                 Expr_rewrite
                   (dot_attr (Expr_annot (Expr_basic [var_x]) name))
                   unicode_equiv
                   (Expr_apply var_eval_extract [Expr_basic [var_x],
                    let deref_oid = \<lambda>attr_orig l. Expr_apply (case attr_orig of None \<Rightarrow> isub_name var_deref_oid
                                                                              | Some orig_n \<Rightarrow> var_deref_oid @@ isub_of_str orig_n) (Expr_basic [var_in_when_state] # l) in
                    deref_oid None
                      [ ( case (design_analysis, attr_ty) of
                            (Gen_analysis, OclTy_class ty_obj) \<Rightarrow>
                              \<lambda>l. Expr_apply (print_access_deref_assocs_name' (TyObjN_ass_switch (TyObj_from ty_obj)) isub_name isup_attr) (Expr_basic [var_in_when_state] # [l])
                        | _ \<Rightarrow> id)
                          (Expr_apply (isup_attr (isub_name var_select))
                            [let ty_base = Expr_basic [var_reconst_basetype] in
                             case attr_ty of OclTy_raw _ \<Rightarrow> ty_base
                                           | OclTy_base_void \<Rightarrow> ty_base
                                           | OclTy_base_boolean \<Rightarrow> ty_base
                                           | OclTy_base_integer \<Rightarrow> ty_base
                                           | OclTy_base_unlimitednatural \<Rightarrow> ty_base
                                           | OclTy_base_real \<Rightarrow> ty_base
                                           | OclTy_base_string \<Rightarrow> ty_base
                                           | OclTy_class ty_obj \<Rightarrow>
                             let ty_obj = TyObj_to ty_obj
                               ; der_name = deref_oid (Some (TyObjN_role_ty ty_obj)) [] in
                             if design_analysis = Gen_design then
                               Expr_apply (if single_multip (TyObjN_role_multip ty_obj) then
                                             var_select_object_set_any
                                           else
                                             var_select_object_set) [der_name]
                             else
                               der_name]) ] ])) ]) expr)"

definition "print_access_dot_lemmas_id_set =
  (if activate_simp_optimization then
     map_class_arg_only_var'
       (\<lambda>isub_name _ (_, dot_at_when) attr_ty isup_attr _. [print_access_dot_name isub_name dot_at_when attr_ty isup_attr])
   else (\<lambda>_. []))"

definition "print_access_dot_lemmas_id = start_map' (\<lambda>expr.
       (let name_set = print_access_dot_lemmas_id_set expr in
       case name_set of [] \<Rightarrow> [] | _ \<Rightarrow> List_map Thy_lemmas_simp
         [ Lemmas_simp '''' (List_map Thm_str name_set) ]))"

definition "print_access_dot_cp_lemmas_set =
  (if activate_simp_optimization then [hol_definition var_eval_extract] else [])"

definition "print_access_dot_cp_lemmas = start_map' (\<lambda>_.
  List_map (\<lambda>x. Thy_lemmas_simp (Lemmas_simp '''' [Thm_str x])) print_access_dot_cp_lemmas_set)"

definition "print_access_dot_lemma_cp_name isub_name dot_at_when attr_ty isup_attr = flatten [''cp_'', print_access_dot_name isub_name dot_at_when attr_ty isup_attr]"
definition "print_access_dot_lemma_cp = start_map Thy_lemma_by o
  map_class_arg_only_var
    (\<lambda>isub_name name (_, dot_at_when) attr_ty isup_attr dot_attr.
            [ Lemma_by
                (print_access_dot_lemma_cp_name isub_name dot_at_when attr_ty isup_attr)
                [Expr_apply ''cp'' [Expr_lam ''X'' (\<lambda>var_x. dot_attr (Expr_annot (Expr_basic [var_x]) name)) ]]
                []
                (Tacl_by [if print_access_dot_cp_lemmas_set = [] then
                            Tac_auto_simp_add (List_map hol_definition [''cp'', var_eval_extract, flatten [isup_attr (isub_name ''dot''), dot_at_when]])
                          else
                            Tac_auto_simp_add (List_map hol_definition [''cp''])]) ])
    (\<lambda>isub_name name (_, dot_at_when) attr_ty isup_attr dot_attr.
            [ Lemma_by
                (print_access_dot_lemma_cp_name isub_name dot_at_when attr_ty isup_attr)
                [Expr_apply ''cp'' [Expr_lam ''X'' (\<lambda>var_x. dot_attr (Expr_annot (Expr_basic [var_x]) name)) ]]
                []
                (if print_access_dot_cp_lemmas_set = [] then Tacl_sorry (* fold l_hierarchy, take only subclass, unfold the corresponding definition *)
                 else Tacl_by [Tac_auto_simp_add (List_map hol_definition [''cp''])]) ])"

definition "print_access_dot_lemmas_cp = start_map Thy_lemmas_simp o (\<lambda>expr.
  case map_class_arg_only_var'
    (\<lambda>isub_name _ (_, dot_at_when) attr_ty isup_attr _.
      [Thm_str (print_access_dot_lemma_cp_name isub_name dot_at_when attr_ty isup_attr) ])
    expr
  of [] \<Rightarrow> []
   | l \<Rightarrow> [Lemmas_simp '''' l])"

definition "print_access_lemma_strict expr = (start_map Thy_lemma_by o
  map_class_arg_only_var' (\<lambda>isub_name name (_, dot_at_when) attr_ty isup_attr dot_attr.
            List_map (\<lambda>(name_invalid, tac_invalid). Lemma_by
                  (flatten [print_access_dot_name isub_name dot_at_when attr_ty isup_attr, ''_'', name_invalid])
                  [Expr_rewrite
                     (dot_attr (Expr_annot (Expr_basic [name_invalid]) name))
                     ''=''
                     (Expr_basic [''invalid''])]
                  []
                  (if print_access_dot_lemmas_id_set expr = [] | print_access_dot_cp_lemmas_set = [] then
                     Tacl_sorry else
                   Tacl_by [ Tac_rule (Thm_str ''ext''),
                             Tac_simp_add (List_map hol_definition
                                             (let l = (let l = (''bot_option'' # tac_invalid) in
                                              if print_access_dot_lemmas_id_set expr = [] then
                                                flatten [isup_attr (isub_name ''dot''), dot_at_when] # l
                                              else l) in
                                              if print_access_dot_cp_lemmas_set = []
                                              then
                                                ''eval_extract'' # l
                                              else l))]) )
                [(''invalid'', [''invalid'']), (''null'', [''null_fun'', ''null_option''])])) expr"

end