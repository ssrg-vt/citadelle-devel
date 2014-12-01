(*****************************************************************************
 * Featherweight-OCL --- A Formal Semantics for UML-OCL Version OCL 2.4
 *                       for the OMG Standard.
 *                       http://www.brucker.ch/projects/hol-testgen/
 *
 * OCL_compiler_floor1_istypeof.thy ---
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

theory  OCL_compiler_floor1_istypeof
imports OCL_compiler_core_init
begin

section{* Translation of AST *}

subsection{* IsTypeOf *}
definition "print_istypeof_consts = start_map Thy_consts_class o
  map_class (\<lambda>isub_name name _ _ _ _.
    Consts (isub_name const_oclistypeof) (Ty_base ty_boolean) (const_mixfix dot_oclistypeof name))"

definition "print_istypeof_class = start_m_gen Thy_defs_overloaded m_class_default
  (\<lambda> l_inh _ _ compare (isub_name, name, _). \<lambda> OclClass h_name hl_attr h_last \<Rightarrow>
   [Defs_overloaded
          (flatten [isub_name const_oclistypeof, ''_'', h_name])
          (let var_x = ''x'' in
           Expr_rewrite
             (Expr_postunary (Expr_annot (Expr_basic [var_x]) h_name) (Expr_basic [dot_istypeof name]))
             unicode_equiv
             (Expr_lam unicode_tau
                  (\<lambda>var_tau. let ocl_tau = (\<lambda>v. Expr_apply v [Expr_basic [var_tau]]) in
                  Expr_case
                    (ocl_tau var_x)
                    ( (Expr_basic [unicode_bottom], ocl_tau ''invalid'')
                    # (Expr_some (Expr_basic [unicode_bottom]), ocl_tau ''true'')
                    # (let l_false = [(Expr_basic [wildcard], ocl_tau ''false'')]
                         ; pattern_complex_gen = (\<lambda>f1 f2.
                            let isub_h = (\<lambda> s. s @@ isub_of_str h_name) in
                             (Expr_some (Expr_some
                               (Expr_apply (isub_h datatype_constr_name)
                                           ( Expr_apply (f2 (\<lambda>s. isub_name (s @@ ''_'')) (isub_h datatype_ext_constr_name))
                                                        (Expr_basic [wildcard] # f1)
                                           # List_map (\<lambda>_. Expr_basic [wildcard]) hl_attr))), ocl_tau ''true'')
                             # (if h_last = [] then [] else l_false)) in
                       case compare
                       of EQ \<Rightarrow> pattern_complex_gen (flatten (List_map (List_map (\<lambda>_. Expr_basic [wildcard]) o (\<lambda> OclClass _ l _ \<Rightarrow> l)) (of_linh l_inh))) (\<lambda>_. id)
                        | GT \<Rightarrow> pattern_complex_gen [] id
                        | _ \<Rightarrow> l_false) ) )))] )"

definition "print_istypeof_from_universe = start_m Thy_definition_hol
  (\<lambda> name _ _ l.
    let const_istypeof = flatten [const_oclistypeof, isub_of_str name, ''_'', unicode_AA] in
    [ Definition (Expr_rewrite (Expr_basic [const_istypeof]) ''='' (Expr_function l))])
  (\<lambda>_ (_, name, _). \<lambda> OclClass h_name _ _ \<Rightarrow>
     let isub_h = (\<lambda> s. s @@ isub_of_str h_name) in
     [( Expr_apply (isub_h datatype_in) [Expr_basic [h_name]]
      , Expr_warning_parenthesis
        (Expr_postunary (Expr_annot (Expr_applys (bug_ocaml_extraction (let var_x = ''x'' in
                                                       Expr_lambdas [var_x, wildcard] (Expr_some (Expr_some (Expr_basic [var_x]))))) [Expr_basic [h_name]])
                                    h_name)
                        (Expr_basic [dot_istypeof name])))])"

definition "print_istypeof_lemma_cp_set =
  (if activate_simp_optimization then
    map_class (\<lambda>isub_name name _ _ _ _. ((isub_name, name), name))
   else (\<lambda>_. []))"

definition "print_istypeof_lemmas_id = start_map' (\<lambda>expr.
  (let name_set = print_istypeof_lemma_cp_set expr in
   case name_set of [] \<Rightarrow> [] | _ \<Rightarrow> List_map Thy_lemmas_simp
  [ Lemmas_simp '''' (List_map (\<lambda>((isub_name, _), name).
    Thm_str (flatten [isub_name const_oclistypeof, ''_'', name] )) name_set) ]))"

definition "print_istypeof_lemma_cp expr = (start_map Thy_lemma_by o
  (get_hierarchy_map (
  let check_opt =
    let set = print_istypeof_lemma_cp_set expr in
    (\<lambda>n1 n2. list_ex (\<lambda>((_, name1), name2). name1 = n1 & name2 = n2) set) in
  (\<lambda>name1 name2 name3.
    Lemma_by
      (flatten [''cp_'', const_oclistypeof, isub_of_str name1, ''_'', name3, ''_'', name2])
      (bug_ocaml_extraction (let var_p = ''p'' in
       List_map
         (\<lambda>x. Expr_apply ''cp'' [x])
         [ Expr_basic [var_p]
         , Expr_lam ''x''
             (\<lambda>var_x. Expr_warning_parenthesis (Expr_postunary
               (Expr_annot (Expr_apply var_p [Expr_annot (Expr_basic [var_x]) name3]) name2)
               (Expr_basic [dot_istypeof name1])))]))
      []
      (Tacl_by [Tac_rule (Thm_str ''cpI1''), if check_opt name1 name2 then Tac_simp
                                             else Tac_simp_add [flatten [const_oclistypeof, isub_of_str name1, ''_'', name2]]])
  )) (\<lambda>x. (x, x, x))) ) expr"

definition "print_istypeof_lemmas_cp = start_map'
 (if activate_simp_optimization then List_map Thy_lemmas_simp o
    (\<lambda>expr. [Lemmas_simp ''''
  (get_hierarchy_map (\<lambda>name1 name2 name3.
      Thm_str (flatten [''cp_'', const_oclistypeof, isub_of_str name1, ''_'', name3, ''_'', name2]))
   (\<lambda>x. (x, x, x)) expr)])
  else (\<lambda>_. []))"

definition "print_istypeof_lemma_strict expr = (start_map Thy_lemma_by o
  get_hierarchy_map (
  let check_opt =
    let set = print_istypeof_lemma_cp_set expr in
    (\<lambda>n1 n2. list_ex (\<lambda>((_, name1), name2). name1 = n1 & name2 = n2) set) in
  (\<lambda>name1 (name2,name2') name3.
    Lemma_by
      (flatten [const_oclistypeof, isub_of_str name1, ''_'', name3, ''_'', name2])
      [ Expr_rewrite
             (Expr_warning_parenthesis (Expr_postunary
               (Expr_annot (Expr_basic [name2]) name3)
               (Expr_basic [dot_istypeof name1])))
             ''=''
             (Expr_basic [name2'])]
      []
      (Tacl_by (let l = List_map hol_definition (''bot_option'' # (if name2 = ''invalid'' then [''invalid'']
                                                              else [''null_fun'',''null_option''])) in
                [Tac_rule (Thm_str ''ext''), Tac_simp_add (if check_opt name1 name3 then l
                                                           else flatten [const_oclistypeof, isub_of_str name1, ''_'', name3] # l)]))
  )) (\<lambda>x. (x, [(''invalid'',''invalid''),(''null'',''true'')], x))) expr"

definition "print_istypeof_lemmas_strict_set =
  (if activate_simp_optimization then
    get_hierarchy_map (\<lambda>name1 name2 name3. (name1, name3, name2)) (\<lambda>x. (x, [''invalid'',''null''], x))
   else (\<lambda>_. []))"

definition "print_istypeof_lemmas_strict expr = start_map Thy_lemmas_simp
  (case print_istypeof_lemmas_strict_set expr
   of [] \<Rightarrow> []
    | l \<Rightarrow> [ Lemmas_simp '''' (List_map
      (\<lambda>(name1, name3, name2).
        Thm_str (flatten [const_oclistypeof, isub_of_str name1, ''_'', name3, ''_'', name2]))
      l) ])"

definition "print_istypeof_defined = start_m Thy_lemma_by m_class_default
  (\<lambda> _ (isub_name, name, _). \<lambda> OclClass h_name _ _ \<Rightarrow>
      let var_X = ''X''
        ; var_isdef = ''isdef''
        ; f = \<lambda>symb e. Expr_binop (Expr_basic [unicode_tau]) unicode_Turnstile (Expr_apply symb [e]) in
      [ Lemma_by_assum
          (print_istypeof_defined_name isub_name h_name)
          [(var_isdef, False, f unicode_upsilon (Expr_basic [var_X]))]
          (f unicode_delta (Expr_postunary (Expr_annot (Expr_basic [var_X]) h_name) (Expr_basic [dot_istypeof name])))
          [App [Tac_insert [Thm_simplified (Thm_str var_isdef) (Thm_str (''foundation18'' @@ [Char Nibble2 Nibble7])) ]
               ,Tac_simp_only [Thm_str (hol_definition ''OclValid'')]
               ,Tac_subst (Thm_str ''cp_defined'')]]
          (Tacl_by [Tac_auto_simp_add_split ( Thm_symmetric (Thm_str ''cp_defined'')
                                            # List_map Thm_str ( hol_definition ''bot_option''
                                                          # [ flatten [isub_name const_oclistypeof, ''_'', h_name] ]))
                                            (''option.split'' # split_ty h_name) ]) ])"

definition "print_istypeof_defined' = start_m Thy_lemma_by m_class_default
  (\<lambda> _ (isub_name, name, _). \<lambda> OclClass h_name _ _ \<Rightarrow>
      let var_X = ''X''
        ; var_isdef = ''isdef''
        ; f = \<lambda>e. Expr_binop (Expr_basic [unicode_tau]) unicode_Turnstile (Expr_apply unicode_delta [e]) in
      [ Lemma_by_assum
          (print_istypeof_defined'_name isub_name h_name)
          [(var_isdef, False, f (Expr_basic [var_X]))]
          (f (Expr_postunary (Expr_annot (Expr_basic [var_X]) h_name) (Expr_basic [dot_istypeof name])))
          []
          (Tacl_by [Tac_rule (Thm_OF (Thm_str (print_istypeof_defined_name isub_name h_name))
                                     (Thm_THEN (Thm_str var_isdef) (Thm_str ''foundation20'')))]) ])"

definition "print_istypeof_up_larger_name name_pers name_any = flatten [''actualType'', isub_of_str name_pers, ''_larger_staticType'', isub_of_str name_any]"
definition "print_istypeof_up_larger = start_map Thy_lemma_by o
  map_class_nupl2'_inh_large (\<lambda>name_pers name_any.
    let var_X = ''X''
      ; var_isdef = ''isdef''
      ; f = Expr_binop (Expr_basic [unicode_tau]) unicode_Turnstile in
    Lemma_by_assum
        (print_istypeof_up_larger_name name_pers name_any)
        [(var_isdef, False, f (Expr_apply unicode_delta [Expr_basic [var_X]]))]
        (f (Expr_binop (Expr_warning_parenthesis (Expr_postunary
               (Expr_annot (Expr_basic [var_X]) name_pers)
               (Expr_basic [dot_istypeof name_any]))
             ) unicode_triangleq (Expr_basic [''false''])))
        [App_using [Thm_str var_isdef]]
        (Tacl_by [Tac_auto_simp_add ( flatten [const_oclistypeof, isub_of_str name_any, ''_'', name_pers]
                                    # ''foundation22''
                                    # ''foundation16''
                                    # List_map hol_definition [''null_option'', ''bot_option'' ])]))"

definition "print_istypeof_up_d_cast expr = (start_map Thy_lemma_by o
  map_class_nupl3'_GE_inh (\<lambda>name_pers name_mid name_any.
    let var_X = ''X''
      ; var_istyp = ''istyp''
      ; var_isdef = ''isdef''
      ; f = Expr_binop (Expr_basic [unicode_tau]) unicode_Turnstile in
    Lemma_by_assum
        (print_istypeof_up_d_cast_name name_mid name_any name_pers)
        [(var_istyp, False, f (Expr_warning_parenthesis (Expr_postunary
               (Expr_annot (Expr_basic [var_X]) name_any)
               (Expr_basic [dot_istypeof name_mid]))))
        ,(var_isdef, False, f (Expr_apply unicode_delta [Expr_basic [var_X]]))]
        (f (Expr_binop (Expr_warning_parenthesis (Expr_postunary
               (Expr_basic [var_X])
               (Expr_basic [dot_astype name_pers]))
             ) unicode_triangleq (Expr_basic [''invalid''])))
        [App_using (List_map Thm_str [var_istyp, var_isdef])
        ,App [Tac_auto_simp_add_split (List_map Thm_str
                                      ( flatten [const_oclastype, isub_of_str name_pers, ''_'', name_any]
                                      # ''foundation22''
                                      # ''foundation16''
                                      # List_map hol_definition [''null_option'', ''bot_option'' ]))
                                      (split_ty name_any) ]]
        (Tacl_by [Tac_simp_add (let l = List_map hol_definition [''OclValid'', ''false'', ''true''] in
                                if name_mid = name_any & ~(print_istypeof_lemma_cp_set expr = []) then
                                  l
                                else
                                  flatten [const_oclistypeof, isub_of_str name_mid, ''_'', name_any] # l)]))) expr"

end