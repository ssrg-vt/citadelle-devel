(*****************************************************************************
 * Featherweight-OCL --- A Formal Semantics for UML-OCL Version OCL 2.4
 *                       for the OMG Standard.
 *                       http://www.brucker.ch/projects/hol-testgen/
 *
 * OCL_compiler_printer_SML.thy ---
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

theory  OCL_compiler_printer_SML
imports OCL_compiler_meta_SML
        OCL_compiler_printer_oid
begin


subsection{* s of ... *} (* s_of *)

context s_of
begin
fun_quick s_of_sexpr where "s_of_sexpr e = (\<lambda>
    Sexpr_string l \<Rightarrow> let c = STR [Char Nibble2 Nibble2] in
                      sprintf3 (STR ''%s%s%s'') c (String_concat (STR '' '') (List_map To_string l)) c
  | Sexpr_rewrite_val e1 symb e2 \<Rightarrow> sprintf3 (STR ''val %s %s %s'') (s_of_sexpr e1) (To_string symb) (s_of_sexpr e2)
  | Sexpr_rewrite_fun e1 symb e2 \<Rightarrow> sprintf3 (STR ''fun %s %s %s'') (s_of_sexpr e1) (To_string symb) (s_of_sexpr e2)
  | Sexpr_basic l \<Rightarrow> sprintf1 (STR ''%s'') (String_concat (STR '' '') (List_map To_string l))
  | Sexpr_oid tit s \<Rightarrow> sprintf2 (STR ''%s%d'') (To_string tit) (To_oid s)
  | Sexpr_binop e1 s e2 \<Rightarrow> sprintf3 (STR ''%s %s %s'') (s_of_sexpr e1) (s_of_sexpr (Sexpr_basic [s])) (s_of_sexpr e2)
  | Sexpr_annot e s \<Rightarrow> sprintf2 (STR ''(%s:%s)'') (s_of_sexpr e) (To_string s)
  | Sexpr_function l \<Rightarrow> sprintf1 (STR ''(fn %s)'') (String_concat (STR ''
    | '') (List.map (\<lambda> (s1, s2) \<Rightarrow> sprintf2 (STR ''%s => %s'') (s_of_sexpr s1) (s_of_sexpr s2)) l))
  | Sexpr_apply s l \<Rightarrow> sprintf2 (STR ''(%s %s)'') (To_string s) (String_concat (STR '' '') (List.map (\<lambda> e \<Rightarrow> sprintf1 (STR ''(%s)'') (s_of_sexpr e)) l))
  | Sexpr_paren p_left p_right e \<Rightarrow> sprintf3 (STR ''%s%s%s'') (To_string p_left) (s_of_sexpr e) (To_string p_right)
  | Sexpr_let_open s e \<Rightarrow> sprintf2 (STR ''let open %s in %s end'') (To_string s) (s_of_sexpr e)) e"

end

lemmas [code] =
  (* def *)
  (* fun *)
  s_of.s_of_sexpr.simps

end