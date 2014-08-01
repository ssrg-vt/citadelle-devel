(*****************************************************************************
 * Featherweight-OCL --- A Formal Semantics for UML-OCL Version OCL 2.4
 *                       for the OMG Standard.
 *                       http://www.brucker.ch/projects/hol-testgen/
 *
 * OCL_lib_common.thy ---
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




theory OCL_lib_common
imports  OCL_core
begin

section{* Common Infrastructure *}

text{* We use the Isabelle mechanism of a \emph{Locale} to generate the
common lemmas for each type and operator; Locales can be seen as a 
functor that takes a local theory and generates a number of theorems.
In our case, we will instantiate later these locales by the local theory 
of an operator definition and obtain the common rules for strictness, definedness
propagation, context-passingness and constance in a systematic way.
*}

locale binop_infra =
   fixes d:: "('\<AA>,'b::null)val \<Rightarrow> '\<AA> Boolean"
   fixes f::"('\<AA>,'a::null)val \<Rightarrow> ('\<AA>,'b::null)val \<Rightarrow> ('\<AA>,'c::null)val"
   fixes g::"'a::null \<Rightarrow> 'b::null \<Rightarrow> 'c::null"
   assumes d_strict[simp,code_unfold]: "d invalid = false"
   assumes d_cp0: "d Y \<tau> = d (\<lambda> _. Y \<tau>) \<tau>"
   assumes d_homo[simp]: "cp (f x) \<Longrightarrow> 
                          f x invalid = invalid \<Longrightarrow>
                          \<not> \<tau> \<Turnstile> d y \<Longrightarrow> \<tau> \<Turnstile> \<delta> f x y \<triangleq> (\<delta> x and d y)"
   assumes d_const[simp]: "const Y \<Longrightarrow> const (d Y)"
   assumes def_scheme': "f x y = (\<lambda> \<tau>. if (\<delta> x) \<tau> = true \<tau> \<and> (d y) \<tau> = true \<tau>
                                      then g (x \<tau>) (y \<tau>)
                                      else invalid \<tau> )"
   assumes 1: "\<tau> \<Turnstile> \<delta> x \<Longrightarrow> \<tau> \<Turnstile> d y \<Longrightarrow> \<tau> \<Turnstile> \<delta> f x y"
begin
      lemma strict1[simp,code_unfold]: " f invalid y = invalid"
      by(rule ext, simp add: def_scheme' true_def false_def)

      lemma strict2[simp,code_unfold]: " f x invalid = invalid"
      by(rule ext, simp add: def_scheme' true_def false_def)

      lemma strict3[simp,code_unfold]: " f null y = invalid"
      by(rule ext, simp add: def_scheme' true_def false_def)

      lemma cp0 : "f X Y \<tau> = f (\<lambda> _. X \<tau>) (\<lambda> _. Y \<tau>) \<tau>"
      by(simp add: def_scheme' d_cp0[symmetric] cp_defined[symmetric])
      
      lemma cp[simp] : " cp P \<Longrightarrow> cp Q \<Longrightarrow> cp (\<lambda>X. f (P X) (Q X))"
      by(rule OCL_core.cpI2[of "f"], intro allI, rule cp0, simp_all)

      lemma def_homo[simp]: "\<delta>(f x y) = (\<delta> x and d y)"
         apply(rule ext, rename_tac "\<tau>",subst OCL_core.foundation22[symmetric])
         apply(case_tac "\<not>(\<tau> \<Turnstile> \<delta> x)", simp add:defined_split, elim disjE)
           apply(erule OCL_core.StrongEq_L_subst2_rev, simp,simp)
          apply(erule OCL_core.StrongEq_L_subst2_rev, simp,simp)
         apply(case_tac "\<not>(\<tau> \<Turnstile> d y)", simp)
         apply(simp)
         apply(rule foundation13[THEN iffD2,THEN OCL_core.StrongEq_L_subst2_rev, where y ="\<delta> x"])
           apply(simp_all)
         apply(rule foundation13[THEN iffD2,THEN OCL_core.StrongEq_L_subst2_rev, where y ="d y"])
           apply(simp_all add: 1 foundation13)
         done

      lemma def_valid_then_def: "\<upsilon>(f x y) = (\<delta>(f x y))" (* [simp] ? *)
         apply(rule ext, rename_tac "\<tau>") 
         apply(simp_all add: valid_def defined_def def_scheme'
                             true_def false_def invalid_def 
                             null_def null_fun_def null_option_def bot_fun_def)
         by (metis "1" OclValid_def def_scheme' foundation16 true_def)

      lemma const[simp] : 
          assumes C1 :"const X" and C2 : "const Y"
          shows       "const(f X Y)"
      proof -
          have const_g : "const (\<lambda>\<tau>. g (X \<tau>) (Y \<tau>))" 
                  by(insert C1 C2, auto simp:const_def, metis)
        show ?thesis
        by(simp_all add : def_scheme' const_ss C1 C2 const_g)
      qed
end

locale binop_infra1 =
   fixes f::"('\<AA>,'a::null)val \<Rightarrow> ('\<AA>,'b::null)val \<Rightarrow> ('\<AA>,'c::null)val"
   fixes g::"'a::null \<Rightarrow> 'b::null \<Rightarrow> 'c::null"
   assumes def_scheme: "f x y = (\<lambda> \<tau>. if (\<delta> x) \<tau> = true \<tau> \<and> (\<delta> y) \<tau> = true \<tau>
                                      then g (x \<tau>) (y \<tau>)
                                      else invalid \<tau> )"
   assumes def_body:  "\<And> x y. g x y \<noteq> bot \<and> g x y \<noteq> null "
begin
      lemma strict4[simp,code_unfold]: " f x null = invalid"
      by(rule ext, simp add: def_scheme true_def false_def)
end

sublocale binop_infra1 < binop_infra defined
 apply(unfold_locales)
      apply(simp)
     apply(subst cp_defined, simp)
    apply(simp add:defined_split, elim disjE)
     apply(erule OCL_core.StrongEq_L_subst2_rev, simp, simp)
    apply(erule OCL_core.StrongEq_L_subst2_rev, simp, simp)
   apply(rule const_defined, simp)
  apply(rule def_scheme)
 by(simp add: defined_def OclValid_def false_def true_def 
              bot_fun_def null_fun_def def_scheme def_body)

locale binop_infra2 =
   fixes f::"('\<AA>,'a::null)val \<Rightarrow> ('\<AA>,'b::null)val \<Rightarrow> ('\<AA>,'c::null)val"
   fixes g::"'a::null \<Rightarrow> 'b::null \<Rightarrow> 'c::null"
   assumes def_scheme: "f x y = (\<lambda> \<tau>. if (\<delta> x) \<tau> = true \<tau> \<and> (\<upsilon> y) \<tau> = true \<tau>
                                      then g (x \<tau>) (y \<tau>)
                                      else invalid \<tau> )"
   assumes def_body:  "\<And> x y. x\<noteq>bot \<Longrightarrow> x\<noteq>null \<Longrightarrow> y\<noteq>bot \<Longrightarrow> g x y \<noteq> bot \<and> g x y \<noteq> null"

sublocale binop_infra2 < binop_infra valid
 apply(unfold_locales)
      apply(simp)
     apply(subst cp_valid, simp)
    apply(simp add:foundation18'')
    apply(erule OCL_core.StrongEq_L_subst2_rev, simp, simp)
   apply(rule const_valid, simp)
  apply(rule def_scheme)
 by (metis OclValid_def def_body def_scheme foundation16 foundation18')

end