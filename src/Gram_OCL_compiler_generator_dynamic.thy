(*****************************************************************************
 * Featherweight-OCL --- A Formal Semantics for UML-OCL Version OCL 2.5
 *                       for the OMG Standard.
 *                       http://www.brucker.ch/projects/hol-testgen/
 *
 * Gram_OCL_compiler_generator_dynamic.thy ---
 * This file is part of HOL-TestGen.
 *
 * Copyright (c) 2013-2015 Université Paris-Saclay, Univ Paris Sud, France
 *               2013-2015 IRT SystemX, France
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

theory Gram_OCL_compiler_generator_dynamic
imports Gram_Main
begin

print_syntax' remove Main (*OCL_compiler_generator_dynamic*)
prods:
  Fun.updbind = any[0] ":=" any[0] => "_updbind" (1000)
  Fun.updbinds = Fun.updbind[0] "," Fun.updbinds[0] => "_updbinds" (1000)
  Fun.updbinds = Fun.updbind[-1] (-1)
  HOL.case_syn = any[0] "\<Rightarrow>" any[0] => "_case1" (10)
  HOL.case_syn = any[0] "=>" any[0] => "_case1" (10)
  HOL.cases_syn = HOL.case_syn[0] "|" HOL.cases_syn[0] => "_case2" (1000)
  HOL.cases_syn = HOL.case_syn[-1] (-1)
  HOL.letbind = pttrn[0] "=" any[0] => "_bind" (10)
  HOL.letbinds = HOL.letbind[0] ";" HOL.letbinds[0] => "_binds" (1000)
  HOL.letbinds = HOL.letbind[-1] (-1)
  List.lc_qual = logic[0] => "_lc_test" (1000)
  List.lc_qual = any[0] "\<leftarrow>" logic[0] => "_lc_gen" (1000)
  List.lc_qual = any[0] "<-" logic[0] => "_lc_gen" (1000)
  List.lc_quals = "," List.lc_qual[0] List.lc_quals[0] => "_lc_quals" (1000)
  List.lc_quals = "]" => "_lc_end" (1000)
  List.lupdbind = any[0] ":=" any[0] => "_lupdbind" (1000)
  List.lupdbinds = List.lupdbind[0] "," List.lupdbinds[0] => "_lupdbinds" (1000)
  List.lupdbinds = List.lupdbind[-1] (-1)
  Map.maplet = any[0] "\<mapsto>" any[0] => "_maplet" (1000)
  Map.maplet = any[0] "[\<mapsto>]" any[0] => "_maplets" (1000)
  Map.maplet = any[0] "|->" any[0] => "_maplet" (1000)
  Map.maplet = any[0] "[|->]" any[0] => "_maplets" (1000)
  Map.maplets = Map.maplet[0] "," Map.maplets[0] => "_Maplets" (1000)
  Map.maplets = Map.maplet[-1] (-1)
  Product_Type.patterns = pttrn[0] "," Product_Type.patterns[0] => "_patterns"
    (1000)
  Product_Type.patterns = pttrn[-1] (-1)
  Product_Type.tuple_args = any[0] => "_tuple_arg" (1000)
  Product_Type.tuple_args = any[0] "," Product_Type.tuple_args[0] => "_tuple_args"
    (1000)
  Record.field = Record.ident[0] "=" any[0] => "_field" (1000)
  Record.field_type = Record.ident[0] "::" type[0] => "_field_type" (1000)
  Record.field_types = Record.field_type[0] "," Record.field_types[0]
    => "_field_types" (1000)
  Record.field_types = Record.field_type[-1] (-1)
  Record.field_update = Record.ident[0] ":=" any[0] => "_field_update" (1000)
  Record.field_updates = Record.field_update[0] "," Record.field_updates[0]
    => "_field_updates" (1000)
  Record.field_updates = Record.field_update[-1] (-1)
  Record.fields = Record.field[0] "," Record.fields[0] => "_fields" (1000)
  Record.fields = Record.field[-1] (-1)
  Record.ident = longid => "_constify" (1000)
  Record.ident = id => "_constify" (1000)
  any = prop'[-1] (-1)
  any = logic[-1] (-1)
  aprop = "_" => "\<^const>Pure.dummy_pattern" (1000)
  aprop = "XCONST" longid_position[0] => "_context_xconst" (1000)
  aprop = "XCONST" id_position[0] => "_context_xconst" (1000)
  aprop = "CONST" longid_position[0] => "_context_const" (1000)
  aprop = "CONST" id_position[0] => "_context_const" (1000)
  aprop = "..." => "_DDDOT" (1000)
  aprop = "(" aprop[0] ")" (1000)
  aprop = "\<dots>" => "_DDDOT" (1000)
  aprop = logic[1000] cargs[1000] => "_applC" (999)
  aprop = var_position[-1] (-1)
  aprop = longid_position[-1] (-1)
  aprop = id_position[-1] (-1)
  args = any[0] "," args[0] => "_args" (1000)
  args = any[-1] (-1)
  asms = "prop"[0] ";" asms[0] => "_asms" (1000)
  asms = "prop"[0] => "_asm" (1000)
  cargs = any[1000] cargs[1000] => "_cargs" (1000)
  cargs = any[-1] (-1)
  cartouche_position = cartouche => "_position" (1000)
  class_name = longid => "_class_name" (1000)
  class_name = id => "_class_name" (1000)
  classes = class_name[0] "," classes[0] => "_classes" (1000)
  classes = class_name[-1] (-1)
  float_const = float_position[0] => "_constify" (1000)
  float_position = float_token => "_position" (1000)
  id_position = id => "_position" (1000)
  idt = "(" idt[0] ")" (1000)
  idt = "_" "::" type[0] => "_idtypdummy" (0)
  idt = "_" => "_idtdummy" (1000)
  idt = "_" "\<Colon>" type[0] => "_idtypdummy" (0)
  idt = id_position[0] "::" type[0] => "_idtyp" (0)
  idt = id_position[0] "\<Colon>" type[0] => "_idtyp" (0)
  idt = id_position[-1] (-1)
  idts = idt[1] idts[0] => "_idts" (0)
  idts = idt[-1] (-1)
  index = "\<index>" => "_indexvar" (1000)
  index = => "_indexdefault" (1000)
  index = "\<^bsub>" logic[0] "\<^esub>" => "_index" (1000) tex_raw 
  logic = "op" "&&&" => "\<^const>Pure.conjunction" (1000)
  logic = "op" "==>" => "\<^const>Pure.imp" (1000)
  logic = "op" "\<Longrightarrow>" => "\<^const>Pure.imp" (1000)
  logic = "op" "\<equiv>" => "\<^const>Pure.eq" (1000)
  logic = "op" "==" => "\<^const>Pure.eq" (1000)
  logic = "op" "-->" => "\<^const>HOL.implies" (1000)
  logic = "op" "=" => "\<^const>HOL.eq" (1000)
  logic = "op" "|" => "\<^const>HOL.disj" (1000)
  logic = "op" "&" => "\<^const>HOL.conj" (1000)
  logic = "op" "~=" => "\<^const>HOL.not_equal" (1000)
  logic = "op" "\<noteq>" => "\<^const>HOL.not_equal" (1000)
  logic = "op" "\<longrightarrow>" => "\<^const>HOL.implies" (1000)
  logic = "op" "\<or>" => "\<^const>HOL.disj" (1000)
  logic = "op" "\<and>" => "\<^const>HOL.conj" (1000)
  logic = "op" "<->" => "\<^const>HOL.iff" (1000)
  logic = "op" "\<longleftrightarrow>" => "\<^const>HOL.iff" (1000)
  logic = "op" "=simp=>" => "\<^const>HOL.simp_implies" (1000)
  logic = "op" "<" => "\<^const>Orderings.ord_class.less" (1000)
  logic = "op" "<=" => "\<^const>Orderings.ord_class.less_eq" (1000)
  logic = "op" "\<le>" => "\<^const>Orderings.ord_class.less_eq" (1000)
  logic = "op" ">=" => "\<^const>Orderings.ord_class.greater_eq" (1000)
  logic = "op" "\<ge>" => "\<^const>Orderings.ord_class.greater_eq" (1000)
  logic = "op" ">" => "\<^const>Orderings.ord_class.greater" (1000)
  logic = "op" "+" => "\<^const>Groups.plus_class.plus" (1000)
  logic = "op" "-" => "\<^const>Groups.minus_class.minus" (1000)
  logic = "op" "*" => "\<^const>Groups.times_class.times" (1000)
  logic = "op" ":" => "\<^const>Set.member" (1000)
  logic = "op" "~:" => "\<^const>Set.not_member" (1000)
  logic = "op" "\<notin>" => "\<^const>Set.not_member" (1000)
  logic = "op" "\<in>" => "\<^const>Set.member" (1000)
  logic = "op" "\<subseteq>" => "\<^const>Set.subset_eq" (1000)
  logic = "op" "\<subset>" => "\<^const>Set.subset" (1000)
  logic = "op" "\<supseteq>" => "\<^const>Set.supset_eq" (1000)
  logic = "op" "\<supset>" => "\<^const>Set.supset" (1000)
  logic = "op" "Int" => "\<^const>Set.inter" (1000)
  logic = "op" "\<inter>" => "\<^const>Set.inter" (1000)
  logic = "op" "Un" => "\<^const>Set.union" (1000)
  logic = "op" "\<union>" => "\<^const>Set.union" (1000)
  logic = "op" "`" => "\<^const>Set.image" (1000)
  logic = "op" "-`" => "\<^const>Set.vimage" (1000)
  logic = "op" "o" => "\<^const>Fun.comp" (1000)
  logic = "op" "\<circ>" => "\<^const>Fun.comp" (1000)
  logic = "op" "<*>" => "\<^const>Product_Type.Times" (1000)
  logic = "op" "\<times>" => "\<^const>Product_Type.Times" (1000)
  logic = "op" "<+>" => "\<^const>Sum_Type.Plus" (1000)
  logic = "op" "dvd" => "\<^const>Rings.dvd_class.dvd" (1000)
  logic = "op" "/" => "\<^const>Fields.inverse_class.divide" (1000)
  logic = "op" "^^" => "\<^const>Nat.compower" (1000)
  logic = "op" "O" => "\<^const>Relation.relcomp" (1000)
  logic = "op" "OO" => "\<^const>Relation.relcompp" (1000)
  logic = "op" "``" => "\<^const>Relation.Image" (1000)
  logic = "op" "<*lex*>" => "\<^const>Wellfounded.lex_prod" (1000)
  logic = "op" "<*mlex*>" => "\<^const>Wellfounded.mlex_prod" (1000)
  logic = "op" "initial_segment_of" => "\<^const>Zorn.initialSegmentOf" (1000)
  logic = "op" "//" => "\<^const>Equiv_Relations.quotient" (1000)
  logic = "op" "respects" => "\<^const>Equiv_Relations.RESPECTS" (1000)
  logic = "op" "respects2" => "\<^const>Equiv_Relations.RESPECTS2" (1000)
  logic = "op" "^" => "\<^const>Power.power_class.power" (1000)
  logic = "op" "div" => "\<^const>Divides.div_class.div" (1000)
  logic = "op" "mod" => "\<^const>Divides.div_class.mod" (1000)
  logic = "op" "#" => "\<^const>List.list.Cons" (1000)
  logic = "op" "@" => "\<^const>List.append" (1000)
  logic = "op" "!" => "\<^const>List.nth" (1000)
  logic = "op" "o_m" => "\<^const>Map.map_comp" (1000)
  logic = "op" "\<circ>\<^sub>m" => "\<^const>Map.map_comp" (1000)
  logic = "op" "++" => "\<^const>Map.map_add" (1000)
  logic = "op" "|`" => "\<^const>Map.restrict_map" (1000)
  logic = "op" "\<subseteq>\<^sub>m" => "\<^const>Map.map_le" (1000)
  logic = "op" "@@@@" => "\<^const>OCL_compiler_init.List_append" (1000)
  logic = "op" "@@" => "\<^const>OCL_compiler_init.String_flatten" (1000)
  logic = "op" "$" => "\<^const>OCL_compiler_meta_Pure.pure_term.PureApp" (1000)
  logic = "op" "|\<guillemotleft>" => "\<^const>RBT_Impl.ord_class.rbt_less_symbol" (1000)
  logic = "op" "\<guillemotleft>|" => "\<^const>RBT_Impl.ord_class.rbt_greater" (1000)
  logic = "XCONST" longid_position[0] => "_context_xconst" (1000)
  logic = "XCONST" id_position[0] => "_context_xconst" (1000)
  logic = "CONST" longid_position[0] => "_context_const" (1000)
  logic = "CONST" id_position[0] => "_context_const" (1000)
  logic = "\<struct>" index[1000] => "_struct" (1000)
  logic = "..." => "_DDDOT" (1000)
  logic = "TYPE" "(" type[0] ")" => "_TYPE" (1000)
  logic = "%" pttrns[0] "." any[3] => "_lambda" (3)
  logic = "%" HOL.cases_syn[0] => "_lam_pats_syntax" (10)
  logic = "(" logic[0] ")" (1000)
  logic = "(" any[0] "," Product_Type.tuple_args[0] ")" => "_tuple" (1000)
  logic = "\<dots>" => "_DDDOT" (1000)
  logic = "\<lambda>" pttrns[0] "." any[3] => "_lambda" (3)
  logic = "\<lambda>" HOL.cases_syn[0] => "_lam_pats_syntax" (10)
  logic = "_" => "\<^const>Pure.dummy_pattern" (1000)
  logic = "EX!" idts[0] "." logic[10] => "\<^const>HOL.Ex1_binder" (10)
  logic = "EX!" pttrn[0] ":" logic[0] "." logic[10] => "_Bex1" (10)
  logic = "EX" idts[0] "." logic[10] => "\<^const>HOL.Ex_binder" (10)
  logic = "EX" idt[0] ">=" any[0] "." logic[10] => "_Ex_greater_eq" (10)
  logic = "EX" idt[0] ">" any[0] "." logic[10] => "_Ex_greater" (10)
  logic = "EX" idt[0] "<=" any[0] "." logic[10] => "_Ex_less_eq" (10)
  logic = "EX" idt[0] "<" any[0] "." logic[10] => "_Ex_less" (10)
  logic = "EX" pttrn[0] ":" logic[0] "." logic[10] => "_Bex" (10)
  logic = "ALL" idts[0] "." logic[10] => "\<^const>HOL.All_binder" (10)
  logic = "ALL" idt[0] ">=" any[0] "." logic[10] => "_All_greater_eq" (10)
  logic = "ALL" idt[0] ">" any[0] "." logic[10] => "_All_greater" (10)
  logic = "ALL" idt[0] "<=" any[0] "." logic[10] => "_All_less_eq" (10)
  logic = "ALL" idt[0] "<" any[0] "." logic[10] => "_All_less" (10)
  logic = "ALL" pttrn[0] ":" logic[0] "." logic[10] => "_Ball" (10)
  logic = "~" logic[40] => "\<^const>HOL.Not" (40)
  logic = "\<not>" logic[40] => "\<^const>HOL.Not" (40)
  logic = "THE" pttrn[0] "." logic[10] => "_The" (10)
  logic = "let" HOL.letbinds[0] "in" any[10] => "_Let" (10)
  logic = "case" any[0] "of" HOL.cases_syn[0] => "_case_syntax" (10)
  logic = "\<exists>!" idts[0] "." logic[10] => "\<^const>HOL.Ex1_binder" (10)
  logic = "\<exists>!" pttrn[0] "\<in>" logic[0] "." logic[10] => "_Bex1" (10)
  logic = "\<exists>!" idt[0] "\<subseteq>" any[0] "." logic[10] => "_setleEx1" (10)
  logic = "\<exists>" idts[0] "." logic[10] => "\<^const>HOL.Ex_binder" (10)
  logic = "\<exists>" idt[0] "\<ge>" any[0] "." logic[10] => "_Ex_greater_eq" (10)
  logic = "\<exists>" idt[0] ">" any[0] "." logic[10] => "_Ex_greater" (10)
  logic = "\<exists>" idt[0] "\<le>" any[0] "." logic[10] => "_Ex_less_eq" (10)
  logic = "\<exists>" idt[0] "<" any[0] "." logic[10] => "_Ex_less" (10)
  logic = "\<exists>" pttrn[0] "\<in>" logic[0] "." logic[10] => "_Bex" (10)
  logic = "\<exists>" idt[0] "\<subseteq>" any[0] "." logic[10] => "_setleEx" (10)
  logic = "\<exists>" idt[0] "\<subset>" any[0] "." logic[10] => "_setlessEx" (10)
  logic = "\<forall>" idts[0] "." logic[10] => "\<^const>HOL.All_binder" (10)
  logic = "\<forall>" idt[0] "\<ge>" any[0] "." logic[10] => "_All_greater_eq" (10)
  logic = "\<forall>" idt[0] ">" any[0] "." logic[10] => "_All_greater" (10)
  logic = "\<forall>" idt[0] "\<le>" any[0] "." logic[10] => "_All_less_eq" (10)
  logic = "\<forall>" idt[0] "<" any[0] "." logic[10] => "_All_less" (10)
  logic = "\<forall>" pttrn[0] "\<in>" logic[0] "." logic[10] => "_Ball" (10)
  logic = "\<forall>" idt[0] "\<subseteq>" any[0] "." logic[10] => "_setleAll" (10)
  logic = "\<forall>" idt[0] "\<subset>" any[0] "." logic[10] => "_setlessAll" (10)
  logic = "?!" idts[0] "." logic[10] => "\<^const>HOL.Ex1_binder" (10)
  logic = "?!" pttrn[0] ":" logic[0] "." logic[10] => "_Bex1" (10)
  logic = "?" idts[0] "." logic[10] => "\<^const>HOL.Ex_binder" (10)
  logic = "?" idt[0] "<=" any[0] "." logic[10] => "_Ex_less_eq" (10)
  logic = "?" idt[0] "<" any[0] "." logic[10] => "_Ex_less" (10)
  logic = "?" pttrn[0] ":" logic[0] "." logic[10] => "_Bex" (10)
  logic = "!" idts[0] "." logic[10] => "\<^const>HOL.All_binder" (10)
  logic = "!" idt[0] "<=" any[0] "." logic[10] => "_All_less_eq" (10)
  logic = "!" idt[0] "<" any[0] "." logic[10] => "_All_less" (10)
  logic = "!" pttrn[0] ":" logic[0] "." logic[10] => "_Ball" (10)
  logic = "if" logic[0] "then" any[0] "else" any[10] => "\<^const>HOL.If" (10)
  logic = "LEAST" idts[0] "." logic[10]
    => "\<^const>Orderings.ord_class.Least_binder" (10)
  logic = "LEAST" id ":" logic[0] "." logic[10] => "_Bleast" (10)
  logic = "LEAST" id "\<in>" logic[0] "." logic[10] => "_Bleast" (10)
  logic = "LEAST" pttrn[0] "WRT" logic[4] "." logic[10] => "_LeastM" (10)
  logic = "0" => "\<^const>Groups.zero_class.zero" (1000)
  logic = "-" any[81] => "\<^const>Groups.uminus_class.uminus" (80)
  logic = "\<bar>" any[0] "\<bar>" => "\<^const>Groups.abs_class.abs" (1000)
  logic = "1" => "\<^const>Groups.one_class.one" (1000)
  logic = "{" pttrn[0] "." logic[0] "}" => "_Coll" (1000)
  logic = "{" pttrn[0] ":" logic[0] "." logic[0] "}" => "_Collect" (1000)
  logic = "{" pttrn[0] "\<in>" logic[0] "." logic[0] "}" => "_Collect" (1000)
  logic = "{" args[0] "}" => "_Finset" (1000)
  logic = "{" any[0] "|" idts[0] "." logic[0] "}" => "_Setcompr" (1000)
  logic = "{" any[0] "<..}" => "\<^const>Set_Interval.ord_class.greaterThan" (1000)
  logic = "{" any[0] "..}" => "\<^const>Set_Interval.ord_class.atLeast" (1000)
  logic = "{" any[0] "<..<" any[0] "}"
    => "\<^const>Set_Interval.ord_class.greaterThanLessThan" (1000)
  logic = "{" any[0] "..<" any[0] "}"
    => "\<^const>Set_Interval.ord_class.atLeastLessThan" (1000)
  logic = "{" any[0] "<.." any[0] "}"
    => "\<^const>Set_Interval.ord_class.greaterThanAtMost" (1000)
  logic = "{" any[0] ".." any[0] "}"
    => "\<^const>Set_Interval.ord_class.atLeastAtMost" (1000)
  logic = "{}" => "\<^const>Set.empty" (1000)
  logic = "SUP" pttrn[0] ":" logic[0] "." any[10] => "_SUP" (10)
  logic = "SUP" pttrns[0] "." any[10] => "_SUP1" (10)
  logic = "INF" pttrn[0] ":" logic[0] "." any[10] => "_INF" (10)
  logic = "INF" pttrns[0] "." any[10] => "_INF1" (10)
  logic = "\<Inter>" logic[900] => "\<^const>Complete_Lattices.Inter" (900)
  logic = "\<Inter>" pttrn[0] "\<in>" logic[0] "." logic[10] => "_INTER" (10)
  logic = "\<Inter>" pttrns[0] "." logic[10] => "_INTER1" (10)
  logic = "\<Inter>" any[0] "<" any[0] "." logic[10] => "_INTER_less" (10)
  logic = "\<Inter>" any[0] "\<le>" any[0] "." logic[10] => "_INTER_le" (10)
  logic = "INT" pttrn[0] ":" logic[0] "." logic[10] => "_INTER" (10)
  logic = "INT" pttrns[0] "." logic[10] => "_INTER1" (10)
  logic = "INT" any[0] "<" any[0] "." logic[10] => "_INTER_less" (10)
  logic = "INT" any[0] "<=" any[0] "." logic[10] => "_INTER_le" (10)
  logic = "\<Union>" logic[900] => "\<^const>Complete_Lattices.Union" (900)
  logic = "\<Union>" pttrn[0] "\<in>" logic[0] "." logic[10] => "_UNION" (10)
  logic = "\<Union>" pttrns[0] "." logic[10] => "_UNION1" (10)
  logic = "\<Union>" any[0] "<" any[0] "." logic[10] => "_UNION_less" (10)
  logic = "\<Union>" any[0] "\<le>" any[0] "." logic[10] => "_UNION_le" (10)
  logic = "UN" pttrn[0] ":" logic[0] "." logic[10] => "_UNION" (10)
  logic = "UN" pttrns[0] "." logic[10] => "_UNION1" (10)
  logic = "UN" any[0] "<" any[0] "." logic[10] => "_UNION_less" (10)
  logic = "UN" any[0] "<=" any[0] "." logic[10] => "_UNION_le" (10)
  logic = "()" => "\<^const>Product_Type.Unity" (1000)
  logic = "SIGMA" pttrn[0] ":" logic[0] "." logic[10] => "_Sigma" (10)
  logic = "\<nat>" => "\<^const>Nat.semiring_1_class.Nats" (1000)
  logic = "\<some>" pttrn[0] "." logic[10] => "_Eps" (10)
  logic = "@" pttrn[0] "." logic[10] => "_Eps" (10)
  logic = "SOME" pttrn[0] "." logic[10] => "_Eps" (10)
  logic = "GREATEST" idts[0] "." logic[10]
    => "\<^const>Hilbert_Choice.Greatest_binder" (10)
  logic = "GREATEST" pttrn[0] "WRT" logic[4] "." logic[10] => "_GreatestM" (10)
  logic = "chain\<^sub>\<subseteq>" => "\<^const>Zorn.chain_subset" (1000)
  logic = "CSUM" pttrn[0] ":" logic[51] "." logic[10] => "_Csum" (10)
  logic = num_const[0] => "_Numeral" (1000)
  logic = "\<Sum>" logic[1000] => "\<^const>Groups_Big.comm_monoid_add_class.Setsum"
    (999)
  logic = "\<Sum>" pttrn[0] "\<in>" logic[51] "." any[10] => "_setsum" (10)
  logic = "\<Sum>" pttrn[0] "|" logic[0] "." any[10] => "_qsetsum" (10)
  logic = "\<Sum>" idt[0] "\<le>" any[0] "." any[10] => "_upto_setsum" (10)
  logic = "\<Sum>" idt[0] "<" any[0] "." any[10] => "_upt_setsum" (10)
  logic = "\<Sum>" idt[0] "=" any[0] "..<" any[0] "." any[10] => "_from_upto_setsum"
    (10)
  logic = "\<Sum>" idt[0] "=" any[0] ".." any[0] "." any[10] => "_from_to_setsum" (10)
  logic = "\<Sum>" pttrn[0] "\<leftarrow>" logic[51] "." any[10] => "_listsum" (10)
  logic = "SUM" pttrn[0] ":" logic[51] "." any[10] => "_setsum" (10)
  logic = "SUM" pttrn[0] "|" logic[0] "." any[10] => "_qsetsum" (10)
  logic = "SUM" idt[0] "<=" any[0] "." any[10] => "_upto_setsum" (10)
  logic = "SUM" idt[0] "<" any[0] "." any[10] => "_upt_setsum" (10)
  logic = "SUM" idt[0] "=" any[0] "..<" any[0] "." any[10] => "_from_upto_setsum"
    (10)
  logic = "SUM" idt[0] "=" any[0] ".." any[0] "." any[10] => "_from_to_setsum" (10)
  logic = "SUM" pttrn[0] "<-" logic[51] "." any[10] => "_listsum" (10)
  logic = "\<Prod>" logic[1000] => "\<^const>Groups_Big.comm_monoid_mult_class.Setprod"
    (999)
  logic = "\<Prod>" pttrn[0] "\<in>" logic[51] "." any[10] => "_setprod" (10)
  logic = "\<Prod>" pttrn[0] "|" logic[0] "." any[10] => "_qsetprod" (10)
  logic = "\<Prod>" idt[0] "\<le>" any[0] "." any[10] => "_upto_setprod" (10)
  logic = "\<Prod>" idt[0] "<" any[0] "." any[10] => "_upt_setprod" (10)
  logic = "\<Prod>" idt[0] "=" any[0] "..<" any[0] "." any[10] => "_from_upto_setprod"
    (10)
  logic = "\<Prod>" idt[0] "=" any[0] ".." any[0] "." any[10] => "_from_to_setprod" (10)
  logic = "\<Prod>" pttrn[0] "\<leftarrow>" logic[51] "." any[10] => "_listprod" (10)
  logic = "PROD" pttrn[0] ":" logic[51] "." any[10] => "_setprod" (10)
  logic = "PROD" pttrn[0] "|" logic[0] "." any[10] => "_qsetprod" (10)
  logic = "PROD" idt[0] "<=" any[0] "." any[10] => "_upto_setprod" (10)
  logic = "PROD" idt[0] "<" any[0] "." any[10] => "_upt_setprod" (10)
  logic = "PROD" idt[0] "=" any[0] "..<" any[0] "." any[10] => "_from_upto_setprod"
    (10)
  logic = "PROD" idt[0] "=" any[0] ".." any[0] "." any[10] => "_from_to_setprod"
    (10)
  logic = "PROD" pttrn[0] "<-" logic[51] "." any[10] => "_listprod" (10)
  logic = "\<int>" => "\<^const>Int.ring_1_class.Ints" (1000)
  logic = "\<Sqinter>\<^sub>f\<^sub>i\<^sub>n" logic[900]
    => "\<^const>Lattices_Big.semilattice_inf_class.Inf_fin" (900)
  logic = "\<Squnion>\<^sub>f\<^sub>i\<^sub>n" logic[900]
    => "\<^const>Lattices_Big.semilattice_sup_class.Sup_fin" (900)
  logic = "{..<" any[0] "}" => "\<^const>Set_Interval.ord_class.lessThan" (1000)
  logic = "{.." any[0] "}" => "\<^const>Set_Interval.ord_class.atMost" (1000)
  logic = "[]" => "\<^const>List.list.Nil" (1000)
  logic = "[" args[0] "]" => "_list" (1000)
  logic = "[" pttrn[0] "<-" logic[0] "." logic[0] "]" => "_filter" (1000)
  logic = "[" pttrn[0] "\<leftarrow>" logic[0] "." logic[0] "]" => "_filter" (1000)
  logic = "[" logic[0] "..<" logic[0] "]" => "\<^const>List.upt" (1000)
  logic = "[" any[0] "." List.lc_qual[0] List.lc_quals[0] => "_listcompr" (1000)
  logic = "[" logic[0] ".." logic[0] "]" => "\<^const>List.upto" (1000)
  logic = "[" Map.maplets[0] "]" => "_Map" (1000)
  logic = "CHR" str_position[0] => "_Char" (1000)
  logic = str_position[0] => "_String" (1000)
  logic = "TYPEREP" "(" type[0] ")" => "_TYPEREP" (1000)
  logic = "(|" Record.fields[0] "," "..." "=" any[0] "|)" => "_record_scheme"
    (1000)
  logic = "(|" Record.fields[0] "|)" => "_record" (1000)
  logic = "\<lparr>" Record.fields[0] "," "\<dots>" "=" any[0] "\<rparr>" => "_record_scheme" (1000)
  logic = "\<lparr>" Record.fields[0] "\<rparr>" => "_record" (1000)
  logic = "\<forall>\<^sub>F" pttrn[0] "in" logic[0] "." logic[10] => "_eventually" (10)
  logic = "\<exists>\<^sub>F" pttrn[0] "in" logic[0] "." logic[10] => "_frequently" (10)
  logic = "INFM" idts[0] "." logic[10] => "\<^const>Filter.Inf_many_binder" (10)
  logic = "MOST" idts[0] "." logic[10] => "\<^const>Filter.Alm_all_binder" (10)
  logic = "\<forall>\<^sub>\<infinity>" idts[0] "." logic[10] => "\<^const>Filter.Alm_all_binder" (10)
  logic = "\<exists>\<^sub>\<infinity>" idts[0] "." logic[10] => "\<^const>Filter.Inf_many_binder" (10)
  logic = "LIM" pttrns[1000] any[10] "." any[0] ":>" any[10] => "_LIM" (10)
  logic = cartouche_position[0] => "_cartouche_string" (1000)
  logic = "\<langle>" logic[0] "\<rangle>" => "_string1" (1000)
  logic = "\<prec>" logic[0] "\<succ>" => "_string2" (1000)
  logic = "\<lless>" logic[0] "\<ggreater>" => "_string3" (1000)
  logic = "\<degree>" logic[0] "\<degree>" => "_char1" (1000)
  logic = "List.assoc" => "_list_assoc" (1000)
  logic = "List_member" => "_list_member" (1000)
  logic = "let\<^sub>O\<^sub>C\<^sub>a\<^sub>m\<^sub>l" HOL.letbinds[0] "in" any[10] => "_Let\<^sub>O\<^sub>C\<^sub>a\<^sub>m\<^sub>l" (10)
  logic = "case\<^sub>O\<^sub>C\<^sub>a\<^sub>m\<^sub>l" any[0] "of" HOL.cases_syn[0] => "_case_syntax\<^sub>O\<^sub>C\<^sub>a\<^sub>m\<^sub>l"
    (10)
  logic = "\<lambda>\<^sub>S\<^sub>c\<^sub>a\<^sub>l\<^sub>a" pttrn[0] pttrn[0] "." logic[10] => "_Lambda\<^sub>S\<^sub>c\<^sub>a\<^sub>l\<^sub>a" (10)
  logic = "\<lambda>\<^sub>S\<^sub>c\<^sub>a\<^sub>l\<^sub>a" pttrn[0] "." logic[10] => "_Lambda\<^sub>S\<^sub>c\<^sub>a\<^sub>l\<^sub>a" (10)
  logic = "case\<^sub>S\<^sub>c\<^sub>a\<^sub>l\<^sub>a" any[0] "of" HOL.cases_syn[0] => "_case_syntax\<^sub>S\<^sub>c\<^sub>a\<^sub>l\<^sub>a"
    (10)
  logic = "lookup" => "_rbt_lookup" (1000)
  logic = "insert" => "_rbt_insert" (1000)
  logic = "map_entry" => "_rbt_map_entry" (1000)
  logic = "modify_def" => "_rbt_modify_def" (1000)
  logic = "keys" => "_rbt_keys" (1000)
  logic = "lookup2" => "_rbt_lookup2" (1000)
  logic = "insert2" => "_rbt_insert2" (1000)
  logic = "fold" => "_rbt_fold" (1000)
  logic = "entries" => "_rbt_entries" (1000)
  logic = "sprint0" logic[0] "\<acute>" => "_sprint0" (1000)
  logic = "sprint1" logic[0] "\<acute>" => "_sprint1" (1000)
  logic = "sprint2" logic[0] "\<acute>" => "_sprint2" (1000)
  logic = "sprint3" logic[0] "\<acute>" => "_sprint3" (1000)
  logic = "sprint4" logic[0] "\<acute>" => "_sprint4" (1000)
  logic = "sprint5" logic[0] "\<acute>" => "_sprint5" (1000)
  logic = logic[51] "|\<guillemotleft>" any[51] => "\<^const>RBT_Impl.ord_class.rbt_less_symbol"
    (50)
  logic = logic[200] "$" logic[201]
    => "\<^const>OCL_compiler_meta_Pure.pure_term.PureApp" (200)
  logic = logic[66] "@@" logic[65] => "\<^const>OCL_compiler_init.String_flatten"
    (65)
  logic = logic[66] "@@@@" logic[65] => "\<^const>OCL_compiler_init.List_append"
    (65)
  logic = logic[900] "(" Map.maplets[0] ")" => "_MapUpd" (900)
  logic = logic[51] "\<subseteq>\<^sub>m" logic[51] => "\<^const>Map.map_le" (50)
  logic = logic[110] "|`" logic[111] => "\<^const>Map.restrict_map" (110)
  logic = logic[100] "++" logic[101] => "\<^const>Map.map_add" (100)
  logic = logic[55] "\<circ>\<^sub>m" logic[56] => "\<^const>Map.map_comp" (55)
  logic = logic[55] "o_m" logic[56] => "\<^const>Map.map_comp" (55)
  logic = logic[100] "!" logic[101] => "\<^const>List.nth" (100)
  logic = logic[66] "@" logic[65] => "\<^const>List.append" (65)
  logic = logic[81] "respects2" logic[80] => "\<^const>Equiv_Relations.RESPECTS2"
    (80)
  logic = logic[81] "respects" logic[80] => "\<^const>Equiv_Relations.RESPECTS"
    (80)
  logic = logic[90] "//" logic[91] => "\<^const>Equiv_Relations.quotient" (90)
  logic = logic[56] "initial_segment_of" logic[56]
    => "\<^const>Zorn.initialSegmentOf" (55)
  logic = logic[81] "<*mlex*>" logic[80] => "\<^const>Wellfounded.mlex_prod" (80)
  logic = logic[81] "<*lex*>" logic[80] => "\<^const>Wellfounded.lex_prod" (80)
  logic = logic[1000] "\<^sup>*\<^sup>*" => "\<^const>Transitive_Closure.rtranclp" (1000)
  logic = logic[1000] "\<^sup>+\<^sup>+" => "\<^const>Transitive_Closure.tranclp" (1000)
  logic = logic[1000] "\<^sup>=\<^sup>=" => "\<^const>Transitive_Closure.reflclp" (1000)
  logic = logic[1000] "\<^sup>*" => "\<^const>Transitive_Closure.rtrancl" (999)
  logic = logic[1000] "\<^sup>+" => "\<^const>Transitive_Closure.trancl" (999)
  logic = logic[1000] "\<^sup>=" => "\<^const>Transitive_Closure.reflcl" (999)
  logic = logic[1000] "^=" => "\<^const>Transitive_Closure.reflcl" (999)
  logic = logic[1000] "^==" => "\<^const>Transitive_Closure.reflclp" (1000)
  logic = logic[1000] "^**" => "\<^const>Transitive_Closure.rtranclp" (1000)
  logic = logic[1000] "^++" => "\<^const>Transitive_Closure.tranclp" (1000)
  logic = logic[1000] "^+" => "\<^const>Transitive_Closure.trancl" (999)
  logic = logic[1000] "^*" => "\<^const>Transitive_Closure.rtrancl" (999)
  logic = logic[91] "``" logic[90] => "\<^const>Relation.Image" (90)
  logic = logic[1000] "\<inverse>\<inverse>" => "\<^const>Relation.conversep" (1000)
  logic = logic[1000] "^--1" => "\<^const>Relation.conversep" (1000)
  logic = logic[1000] "\<inverse>" => "\<^const>Relation.converse" (999)
  logic = logic[1000] "^-1" => "\<^const>Relation.converse" (999)
  logic = logic[76] "OO" logic[75] => "\<^const>Relation.relcompp" (75)
  logic = logic[76] "O" logic[75] => "\<^const>Relation.relcomp" (75)
  logic = logic[66] "<+>" logic[65] => "\<^const>Sum_Type.Plus" (65)
  logic = logic[81] "\<times>" logic[80] => "\<^const>Product_Type.Times" (80)
  logic = logic[81] "<*>" logic[80] => "\<^const>Product_Type.Times" (80)
  logic = logic[55] "\<circ>" logic[56] => "\<^const>Fun.comp" (55)
  logic = logic[55] "o" logic[56] => "\<^const>Fun.comp" (55)
  logic = logic[91] "-`" logic[90] => "\<^const>Set.vimage" (90)
  logic = logic[91] "`" logic[90] => "\<^const>Set.image" (90)
  logic = logic[65] "\<union>" logic[66] => "\<^const>Set.union" (65)
  logic = logic[65] "Un" logic[66] => "\<^const>Set.union" (65)
  logic = logic[70] "\<inter>" logic[71] => "\<^const>Set.inter" (70)
  logic = logic[70] "Int" logic[71] => "\<^const>Set.inter" (70)
  logic = logic[51] "\<supset>" logic[51] => "\<^const>Set.supset" (50)
  logic = logic[51] "\<supseteq>" logic[51] => "\<^const>Set.supset_eq" (50)
  logic = logic[51] "\<subset>" logic[51] => "\<^const>Set.subset" (50)
  logic = logic[51] "\<subseteq>" logic[51] => "\<^const>Set.subset_eq" (50)
  logic = logic[26] "\<longleftrightarrow>" logic[25] => "\<^const>HOL.iff" (25)
  logic = logic[26] "<->" logic[25] => "\<^const>HOL.iff" (25)
  logic = logic[36] "\<and>" logic[35] => "\<^const>HOL.conj" (35)
  logic = logic[31] "\<or>" logic[30] => "\<^const>HOL.disj" (30)
  logic = logic[26] "\<longrightarrow>" logic[25] => "\<^const>HOL.implies" (25)
  logic = logic[36] "&" logic[35] => "\<^const>HOL.conj" (35)
  logic = logic[31] "|" logic[30] => "\<^const>HOL.disj" (30)
  logic = logic[26] "-->" logic[25] => "\<^const>HOL.implies" (25)
  logic = logic[4] "\<Colon>" type[0] => "_constrain" (3)
  logic = logic[1000] cargs[1000] => "_applC" (999)
  logic = logic[4] "::" type[0] => "_constrain" (3)
  logic = any[51] "\<guillemotleft>|" logic[51] => "\<^const>RBT_Impl.ord_class.rbt_greater" (50)
  logic = any[900] "\<lparr>" Record.field_updates[0] "\<rparr>" => "_record_update" (900)
  logic = any[900] "(|" Record.field_updates[0] "|)" => "_record_update" (900)
  logic = any[900] "[" List.lupdbinds[0] "]" => "_LUpdate" (900)
  logic = any[66] "#" logic[65] => "\<^const>List.list.Cons" (65)
  logic = any[70] "mod" any[71] => "\<^const>Divides.div_class.mod" (70)
  logic = any[70] "div" any[71] => "\<^const>Divides.div_class.div" (70)
  logic = any[1000] "\<^sup>2" => "\<^const>Power.power_class.power2" (999)
  logic = any[81] "^" logic[80] => "\<^const>Power.power_class.power" (80)
  logic = any[81] "^^" logic[80] => "\<^const>Nat.compower" (80)
  logic = any[70] "/" any[71] => "\<^const>Fields.inverse_class.divide" (70)
  logic = any[51] "dvd" any[51] => "\<^const>Rings.dvd_class.dvd" (50)
  logic = any[1000] "(" Fun.updbinds[0] ")" => "_Update" (900)
  logic = any[51] "\<in>" logic[51] => "\<^const>Set.member" (50)
  logic = any[51] "\<notin>" logic[51] => "\<^const>Set.not_member" (50)
  logic = any[51] "~:" logic[51] => "\<^const>Set.not_member" (50)
  logic = any[51] ":" logic[51] => "\<^const>Set.member" (50)
  logic = any[70] "*" any[71] => "\<^const>Groups.times_class.times" (70)
  logic = any[65] "-" any[66] => "\<^const>Groups.minus_class.minus" (65)
  logic = any[65] "+" any[66] => "\<^const>Groups.plus_class.plus" (65)
  logic = any[51] ">" any[51] => "\<^const>Orderings.ord_class.greater" (50)
  logic = any[51] "\<ge>" any[51] => "\<^const>Orderings.ord_class.greater_eq" (50)
  logic = any[51] ">=" any[51] => "\<^const>Orderings.ord_class.greater_eq" (50)
  logic = any[51] "\<le>" any[51] => "\<^const>Orderings.ord_class.less_eq" (50)
  logic = any[51] "<=" any[51] => "\<^const>Orderings.ord_class.less_eq" (50)
  logic = any[51] "<" any[51] => "\<^const>Orderings.ord_class.less" (50)
  logic = any[50] "\<noteq>" any[51] => "\<^const>HOL.not_equal" (50)
  logic = any[50] "~=" any[51] => "\<^const>HOL.not_equal" (50)
  logic = any[50] "=" any[51] => "\<^const>HOL.eq" (50)
  logic = var_position[-1] (-1)
  logic = longid_position[-1] (-1)
  logic = id_position[-1] (-1)
  longid_position = longid => "_position" (1000)
  num_const = num_position[0] => "_constify" (1000)
  num_position = num_token => "_position" (1000)
  "prop" = logic[0] => "\<^const>HOL.Trueprop" (5)
  "prop" = prop'[-1] (-1)
  prop' = "TERM" logic[0] => "\<^const>Pure.term" (1000)
  prop' = "SORT_CONSTRAINT" "(" type[0] ")" => "_sort_constraint" (1000)
  prop' = "OFCLASS" "(" type[0] "," logic[0] ")" => "_ofclass" (1000)
  prop' = "[|" asms[0] "|]" "==>" "prop"[1] => "_bigimpl" (1)
  prop' = "PROP" aprop[0] => "_aprop" (1000)
  prop' = "(" prop'[0] ")" (1000)
  prop' = "\<lbrakk>" asms[0] "\<rbrakk>" "\<Longrightarrow>" "prop"[1] => "_bigimpl" (1)
  prop' = "\<And>" idts[0] "." "prop"[0] => "\<^const>Pure.all_binder" (0)
  prop' = "!!" idts[0] "." "prop"[0] => "\<^const>Pure.all_binder" (0)
  prop' = any[3] "==" any[3] => "\<^const>Pure.eq" (2)
  prop' = any[3] "\<equiv>" any[3] => "\<^const>Pure.eq" (2)
  prop' = "prop"[2] "==>" "prop"[1] => "\<^const>Pure.imp" (1)
  prop' = "prop"[2] "\<Longrightarrow>" "prop"[1] => "\<^const>Pure.imp" (1)
  prop' = "prop"[3] "&&&" "prop"[2] => "\<^const>Pure.conjunction" (2)
  prop' = "prop"[2] "=simp=>" "prop"[1] => "\<^const>HOL.simp_implies" (1)
  prop' = prop'[4] "::" type[0] => "_constrain" (3)
  prop' = prop'[4] "\<Colon>" type[0] => "_constrain" (3)
  pttrn = "(" pttrn[0] "," Product_Type.patterns[0] ")" => "_pattern" (1000)
  pttrn = idt[-1] (-1)
  pttrns = pttrn[1] pttrns[0] => "_pttrns" (0)
  pttrns = pttrn[-1] (-1)
  sort = "{" classes[0] "}" => "_sort" (1000)
  sort = "{}" => "_topsort" (1000)
  sort = class_name[-1] (-1)
  str_position = str_token => "_position" (1000)
  string_position = string_token => "_position" (1000)
  tid_position = tid => "_position_sort" (1000)
  tvar_position = tvar => "_position_sort" (1000)
  type = "_" => "\<^type>dummy" (1000)
  type = "_" "::" sort[0] => "_dummy_ofsort" (1000)
  type = "(" type[0] ")" (1000)
  type = "(" type[0] "," types[0] ")" type_name[0] => "_tappl" (1000)
  type = "[" types[0] "]" "=>" type[0] => "_bracket" (0)
  type = "[" types[0] "]" "\<Rightarrow>" type[0] => "_bracket" (0)
  type = tvar_position[1000] "::" sort[0] => "_ofsort" (1000)
  type = tid_position[1000] "::" sort[0] => "_ofsort" (1000)
  type = tid_position[1000] "\<Colon>" sort[0] => "_ofsort" (1000)
  type = "(|" Record.field_types[0] "," "..." "::" type[0] "|)"
    => "_record_type_scheme" (1000)
  type = "(|" Record.field_types[0] "|)" => "_record_type" (1000)
  type = "\<lparr>" Record.field_types[0] "," "\<dots>" "::" type[0] "\<rparr>"
    => "_record_type_scheme" (1000)
  type = type[1] "\<rightharpoonup>" type[0] => "\<^type>Map.map" (0)
  type = type[1] "~=>" type[0] => "\<^type>Map.map" (0)
  type = type[11] "+" type[10] => "\<^type>Sum_Type.sum" (10)
  type = type[21] "\<times>" type[20] => "\<^type>Product_Type.prod" (20)
  type = type[21] "*" type[20] => "\<^type>Product_Type.prod" (20)
  type = type[1] "\<Rightarrow>" type[0] => "\<^type>fun" (0)
  type = type[1000] type_name[0] => "_tapp" (1000)
  type = type[1] "=>" type[0] => "\<^type>fun" (0)
  type = "\<lparr>" Record.field_types[0] "\<rparr>" => "_record_type" (1000)
  type = type_name[-1] (-1)
  type = tvar_position[-1] (-1)
  type = tid_position[-1] (-1)
  type_name = longid => "_type_name" (1000)
  type_name = id => "_type_name" (1000)
  types = type[0] "," types[0] => "_types" (1000)
  types = type[-1] (-1)
  var_position = var => "_position" (1000)

end
