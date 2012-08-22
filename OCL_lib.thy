theory OCL_lib
imports OCL_core
begin

section{* Simple, Basic Types like Void, Boolean and Integer *}

text{* Since Integer is again a basic type, we define its semantic domain
as the valuations over @{typ "int option option"}*}
type_synonym ('\<AA>)Integer = "('\<AA>,int option option) val"

type_synonym ('\<AA>)Void = "('\<AA>,unit option) val"
text {* Note that this \emph{minimal} OCL type contains only two elements:
undefined and null. For technical reasons, he does not contain to the null-class yet.*}

section{* Strict equalities. *}

text{* Note that the strict equality on basic types (actually on all types) 
must be exceptionally defined on null --- otherwise the entire concept of 
null in the language does not make much sense. This is an important exception
from the general rule that null arguments --- especially if passed as "self"-argument ---
lead to invalid results. *}
 
defs   StrictRefEq_int[code_unfold] : 
      "(x::('\<AA>)Integer) \<doteq> y \<equiv> \<lambda> \<tau>. if (\<upsilon> x) \<tau> = true \<tau> \<and> (\<upsilon> y) \<tau> = true \<tau>
                                    then (x \<triangleq> y) \<tau>
                                    else invalid \<tau>"

defs   StrictRefEq_bool[code_unfold] : 
      "(x::('\<AA>)Boolean) \<doteq> y \<equiv> \<lambda> \<tau>. if (\<upsilon> x) \<tau> = true \<tau> \<and> (\<upsilon> y) \<tau> = true \<tau>
                                    then (x \<triangleq> y)\<tau>
                                    else invalid \<tau>"

lemma RefEq_int_refl[simp,code_unfold] : 
"((x::('\<AA>)Integer) \<doteq> x) = (if (\<upsilon> x) then true else invalid endif)"
by(rule ext, simp add: StrictRefEq_int if_ocl_def)

lemma RefEq_bool_refl[simp,code_unfold] : 
"((x::('\<AA>)Boolean) \<doteq> x) = (if (\<upsilon> x) then true else invalid endif)"
by(rule ext, simp add: StrictRefEq_bool if_ocl_def)

lemma StrictRefEq_int_strict1[simp] : "((x::('\<AA>)Integer) \<doteq> invalid) = invalid"
by(rule ext, simp add: StrictRefEq_int true_def false_def)

lemma StrictRefEq_int_strict2[simp] : "(invalid \<doteq> (x::('\<AA>)Integer)) = invalid"
by(rule ext, simp add: StrictRefEq_int true_def false_def)

lemma StrictRefEq_bool_strict1[simp] : "((x::('\<AA>)Boolean) \<doteq> invalid) = invalid"
by(rule ext, simp add: StrictRefEq_bool true_def false_def)

lemma StrictRefEq_bool_strict2[simp] : "(invalid \<doteq> (x::('\<AA>)Boolean)) = invalid"
by(rule ext, simp add: StrictRefEq_bool true_def false_def)


lemma strictEqBool_vs_strongEq: 
"\<tau> \<Turnstile>(\<upsilon> x) \<Longrightarrow> \<tau> \<Turnstile>(\<upsilon> y) \<Longrightarrow> (\<tau> \<Turnstile> ((x::('\<AA>)Boolean) \<doteq> y)) = (\<tau> \<Turnstile> (x \<triangleq> y))"
by(simp add: StrictRefEq_bool OclValid_def)

lemma strictEqInt_vs_strongEq: 
"\<tau> \<Turnstile>(\<upsilon> x) \<Longrightarrow> \<tau> \<Turnstile>(\<upsilon> y) \<Longrightarrow> (\<tau> \<Turnstile> ((x::('\<AA>)Integer) \<doteq> y)) = (\<tau> \<Turnstile> (x \<triangleq> y))"
by(simp add: StrictRefEq_int OclValid_def)

lemma strictEqBool_defargs:
"\<tau> \<Turnstile> ((x::('\<AA>)Boolean) \<doteq> y) \<Longrightarrow> (\<tau> \<Turnstile> (\<upsilon> x)) \<and> (\<tau> \<Turnstile>(\<upsilon> y))"
by(simp add: StrictRefEq_bool OclValid_def true_def invalid_def
             bot_option_def
        split: bool.split_asm HOL.split_if_asm)

lemma strictEqInt_defargs:
"\<tau> \<Turnstile> ((x::('\<AA>)Integer) \<doteq> y) \<Longrightarrow> (\<tau> \<Turnstile> (\<upsilon> x)) \<and> (\<tau> \<Turnstile> (\<upsilon> y))"
by(simp add: StrictRefEq_int OclValid_def true_def invalid_def valid_def bot_option_def
           split: bool.split_asm HOL.split_if_asm)

lemma strictEqBool_valid_args_valid: 
"(\<tau> \<Turnstile> \<upsilon>((x::('\<AA>)Boolean) \<doteq> y)) = ((\<tau> \<Turnstile>(\<upsilon> x)) \<and> (\<tau> \<Turnstile>(\<upsilon> y)))"
by(auto simp: StrictRefEq_bool OclValid_def true_def valid_def false_def StrongEq_def 
                 defined_def invalid_def valid_def bot_option_def bot_fun_def
        split: bool.split_asm HOL.split_if_asm option.split)

lemma strictEqInt_valid_args_valid: 
"(\<tau> \<Turnstile> \<upsilon>((x::('\<AA>)Integer) \<doteq> y)) = ((\<tau> \<Turnstile>(\<upsilon> x)) \<and> (\<tau> \<Turnstile>(\<upsilon> y)))"
by(auto simp: StrictRefEq_int OclValid_def true_def valid_def false_def StrongEq_def 
                 defined_def invalid_def bot_fun_def bot_option_def
        split: bool.split_asm HOL.split_if_asm option.split)

lemma gen_ref_eq_defargs: 
"\<tau> \<Turnstile> (gen_ref_eq x (y::('\<AA>,'a::{null,object})val))\<Longrightarrow> (\<tau> \<Turnstile>(\<delta> x)) \<and> (\<tau> \<Turnstile>(\<delta> y))"
by(simp add: gen_ref_eq_def OclValid_def true_def invalid_def
             defined_def invalid_def bot_fun_def bot_option_def
        split: bool.split_asm HOL.split_if_asm)


lemma StrictRefEq_int_strict :
  assumes A: "\<upsilon> (x::('\<AA>)Integer) = true"
  and     B: "\<upsilon> y = true"
  shows   "\<upsilon> (x \<doteq> y) = true"
  apply(insert A B)
  apply(rule ext, simp add: StrongEq_def StrictRefEq_int true_def valid_def defined_def
                            bot_fun_def bot_option_def)
  done


lemma StrictRefEq_int_strict' :
  assumes A: "\<upsilon> (((x::('\<AA>)Integer)) \<doteq> y) = true"
  shows      "\<upsilon> x = true \<and> \<upsilon> y = true"
  apply(insert A, rule conjI) 
  apply(rule ext, drule_tac x=xa in fun_cong)
  prefer 2
  apply(rule ext, drule_tac x=xa in fun_cong)
  apply(simp_all add: StrongEq_def StrictRefEq_int 
                            false_def true_def valid_def defined_def)
  apply(case_tac "y xa", auto)
  apply(simp_all add: true_def invalid_def bot_fun_def)
  done

(* should be simply: *)
lemma StrictRefEq_int_strict'' : "\<upsilon> ((x::('\<AA>)Integer) \<doteq> y) = (\<upsilon>(x) and \<upsilon>(y))"
sorry

lemma cp_StrictRefEq_bool: 
"((X::('\<AA>)Boolean) \<doteq> Y) \<tau> = ((\<lambda> _. X \<tau>) \<doteq> (\<lambda> _. Y \<tau>)) \<tau>"
by(auto simp: StrictRefEq_bool StrongEq_def defined_def valid_def  cp_defined[symmetric])

lemma cp_StrictRefEq_int: 
"((X::('\<AA>)Integer) \<doteq> Y) \<tau> = ((\<lambda> _. X \<tau>) \<doteq> (\<lambda> _. Y \<tau>)) \<tau>"
by(auto simp: StrictRefEq_int StrongEq_def valid_def  cp_defined[symmetric])


lemmas cp_intro[simp,intro!] = 
       cp_intro
       cp_StrictRefEq_bool[THEN allI[THEN allI[THEN allI[THEN cpI2]], of "StrictRefEq"]]
       cp_StrictRefEq_int[THEN allI[THEN allI[THEN allI[THEN cpI2]],  of "StrictRefEq"]]


lemma StrictRefEq_strict :
  assumes A: "\<upsilon> (x::('\<AA>)Integer) = true"
  and     B: "\<upsilon> y = true"
  shows      "\<upsilon> (x \<doteq> y) = true"
  apply(insert A B)
  apply(rule ext, simp add: StrongEq_def StrictRefEq_int true_def valid_def
                            bot_fun_def bot_option_def)
  done


definition ocl_zero ::"('\<AA>)Integer" ("\<zero>")
where      "\<zero> = (\<lambda> _ . \<lfloor>\<lfloor>0::int\<rfloor>\<rfloor>)"

definition ocl_one ::"('\<AA>)Integer" ("\<one> ")
where      "\<one>  = (\<lambda> _ . \<lfloor>\<lfloor>1::int\<rfloor>\<rfloor>)"

definition ocl_two ::"('\<AA>)Integer" ("\<two>")
where      "\<two> = (\<lambda> _ . \<lfloor>\<lfloor>2::int\<rfloor>\<rfloor>)"

definition ocl_three ::"('\<AA>)Integer" ("\<three>")
where      "\<three> = (\<lambda> _ . \<lfloor>\<lfloor>3::int\<rfloor>\<rfloor>)"

definition ocl_four ::"('\<AA>)Integer" ("\<four>")
where      "\<four> = (\<lambda> _ . \<lfloor>\<lfloor>4::int\<rfloor>\<rfloor>)"

definition ocl_five ::"('\<AA>)Integer" ("\<five>")
where      "\<five> = (\<lambda> _ . \<lfloor>\<lfloor>5::int\<rfloor>\<rfloor>)"

definition ocl_six ::"('\<AA>)Integer" ("\<six>")
where      "\<six> = (\<lambda> _ . \<lfloor>\<lfloor>6::int\<rfloor>\<rfloor>)"

definition ocl_seven ::"('\<AA>)Integer" ("\<seven>")
where      "\<seven> = (\<lambda> _ . \<lfloor>\<lfloor>7::int\<rfloor>\<rfloor>)"

definition ocl_eight ::"('\<AA>)Integer" ("\<eight>")
where      "\<eight> = (\<lambda> _ . \<lfloor>\<lfloor>8::int\<rfloor>\<rfloor>)"

definition ocl_nine ::"('\<AA>)Integer" ("\<nine>")
where      "\<nine> = (\<lambda> _ . \<lfloor>\<lfloor>9::int\<rfloor>\<rfloor>)"

definition ten_nine ::"('\<AA>)Integer" ("\<one>\<zero>")
where      "\<one>\<zero> = (\<lambda> _ . \<lfloor>\<lfloor>10::int\<rfloor>\<rfloor>)"

text{* Here is a way to cast in standard operators 
via the type class system of Isabelle. *}

text{* Here follows a list of code-examples, that explain the meanings 
of the above definitions by compilation to code and execution to "True".*}

text{* Elementary computations on Booleans *}
value "\<tau>\<^isub>0 \<Turnstile> \<upsilon>(true)"
value "\<tau>\<^isub>0 \<Turnstile> \<delta>(false)"
value "\<not>(\<tau>\<^isub>0 \<Turnstile> \<delta>(null))"
value "\<not>(\<tau>\<^isub>0 \<Turnstile> \<delta>(invalid))"
value "\<tau>\<^isub>0 \<Turnstile> \<upsilon>((null::('\<AA>)Boolean))"
value "\<not>(\<tau>\<^isub>0 \<Turnstile> \<upsilon>(invalid))"
value "\<tau>\<^isub>0 \<Turnstile> (true and true)"     
value "\<tau>\<^isub>0 \<Turnstile> (true and true \<triangleq> true)"     
value "\<tau>\<^isub>0 \<Turnstile> ((null or null) \<triangleq> null)"     
value "\<tau>\<^isub>0 \<Turnstile> ((null or null) \<doteq> null)"     
value "\<tau>\<^isub>0 \<Turnstile> ((true \<triangleq> false) \<triangleq> false)"     
value "\<tau>\<^isub>0 \<Turnstile> ((invalid \<triangleq> false) \<triangleq> false)"     
value "\<tau>\<^isub>0 \<Turnstile> ((invalid \<doteq> false) \<triangleq> invalid)"     


text{* Elementary computations on Integer *}
value "\<tau>\<^isub>0 \<Turnstile> \<upsilon>(\<four>)"
value "\<tau>\<^isub>0 \<Turnstile> \<delta>(\<four>)"
value "\<tau>\<^isub>0 \<Turnstile> \<upsilon>((null::('\<AA>)Integer))"
value "\<tau>\<^isub>0 \<Turnstile> (invalid \<triangleq> invalid )" 
value "\<tau>\<^isub>0 \<Turnstile> (null \<triangleq> null )" 
value "\<tau>\<^isub>0 \<Turnstile> (\<four> \<triangleq> \<four>)"
value "\<not>(\<tau>\<^isub>0 \<Turnstile> (\<nine> \<triangleq> \<one>\<zero> ))"     
value "\<not>(\<tau>\<^isub>0 \<Turnstile> (invalid \<triangleq> \<one>\<zero> ))" 
value "\<not>(\<tau>\<^isub>0 \<Turnstile> (null \<triangleq> \<one>\<zero> ))"    
value "\<not>(\<tau>\<^isub>0 \<Turnstile> (invalid \<doteq> (invalid::('\<AA>)Integer)))" (* Without typeconstraint not executable.*)
value "\<tau>\<^isub>0 \<Turnstile> (null \<doteq> (null::('\<AA>)Integer) )" (* Without typeconstraint not executable.*)
value "\<tau>\<^isub>0 \<Turnstile> (null \<doteq> (null::('\<AA>)Integer) )" (* Without typeconstraint not executable.*)
value "\<tau>\<^isub>0 \<Turnstile> (\<four> \<doteq> \<four>)"
value "\<not>(\<tau>\<^isub>0 \<Turnstile> (\<four> \<doteq> \<one>\<zero> ))"


lemma  "\<delta>(null::('\<AA>)Integer) = false" by simp (* recall *)
lemma  "\<upsilon>(null::('\<AA>)Integer) = true"  by simp (* recall *)

lemma [simp,code_unfold]:"\<delta> \<zero> = true" 
by(simp add:ocl_zero_def defined_def true_def 
               bot_fun_def bot_option_def null_fun_def null_option_def)

lemma [simp,code_unfold]:"\<upsilon> \<zero> = true" 
by(simp add:ocl_zero_def valid_def true_def 
               bot_fun_def bot_option_def null_fun_def null_option_def)

lemma [simp,code_unfold]:"\<delta> \<one> = true" 
by(simp add:ocl_one_def defined_def true_def 
               bot_fun_def bot_option_def null_fun_def null_option_def)

lemma [simp,code_unfold]:"\<upsilon> \<one> = true" 
by(simp add:ocl_one_def valid_def true_def 
               bot_fun_def bot_option_def null_fun_def null_option_def)

lemma [simp,code_unfold]:"\<delta> \<two> = true" 
by(simp add:ocl_two_def defined_def true_def 
               bot_fun_def bot_option_def null_fun_def null_option_def)

lemma [simp,code_unfold]:"\<upsilon> \<two> = true" 
by(simp add:ocl_two_def valid_def true_def 
               bot_fun_def bot_option_def null_fun_def null_option_def)


lemma zero_non_null [simp]: "(\<zero> \<doteq> null) = false"
by(rule ext,auto simp:ocl_zero_def  null_def StrictRefEq_int valid_def invalid_def 
                         bot_fun_def bot_option_def null_fun_def null_option_def StrongEq_def) 
lemma null_non_zero [simp]: "(null \<doteq> \<zero>) = false"
by(rule ext,auto simp:ocl_zero_def  null_def StrictRefEq_int valid_def invalid_def 
                         bot_fun_def bot_option_def null_fun_def null_option_def StrongEq_def) 

lemma one_non_null [simp]: "(\<one> \<doteq> null) = false"
by(rule ext,auto simp:ocl_one_def  null_def StrictRefEq_int valid_def invalid_def 
                         bot_fun_def bot_option_def null_fun_def null_option_def StrongEq_def) 
lemma null_non_one [simp]: "(null \<doteq> \<one>) = false"
by(rule ext,auto simp:ocl_one_def  null_def StrictRefEq_int valid_def invalid_def 
                         bot_fun_def bot_option_def null_fun_def null_option_def StrongEq_def) 

lemma two_non_null [simp]: "(\<two> \<doteq> null) = false"
by(rule ext,auto simp:ocl_two_def  null_def StrictRefEq_int valid_def invalid_def 
                         bot_fun_def bot_option_def null_fun_def null_option_def StrongEq_def) 
lemma null_non_two [simp]: "(null \<doteq> \<two>) = false"
by(rule ext,auto simp:ocl_two_def  null_def StrictRefEq_int valid_def invalid_def 
                         bot_fun_def bot_option_def null_fun_def null_option_def StrongEq_def) 


(* plus all the others ...*)

text{* Here is a common case of a built-in operation on built-in types.
Note that the arguments must be both defined (non-null, non-bot). *}
text{* Note that we can not follow the lexis of standard OCL for Isabelle-
technical reasons; these operators are heavily overloaded in the library
that a further overloading would lead to heavy technical buzz in this 
document... *}
definition ocl_add_int ::"('\<AA>)Integer \<Rightarrow> ('\<AA>)Integer \<Rightarrow> ('\<AA>)Integer" (infix "\<oplus>" 40) 
where "x \<oplus> y \<equiv> \<lambda> \<tau>. if (\<delta> x) \<tau> = true \<tau> \<and> (\<delta> y) \<tau> = true \<tau>
                then \<lfloor>\<lfloor>\<lceil>\<lceil>x \<tau>\<rceil>\<rceil> + \<lceil>\<lceil>y \<tau>\<rceil>\<rceil>\<rfloor>\<rfloor>
                else invalid \<tau> "   


definition ocl_less_int ::"('\<AA>)Integer \<Rightarrow> ('\<AA>)Integer \<Rightarrow> ('\<AA>)Boolean" (infix "\<prec>" 40) 
where "x \<prec> y \<equiv> \<lambda> \<tau>. if (\<delta> x) \<tau> = true \<tau> \<and> (\<delta> y) \<tau> = true \<tau>
                then \<lfloor>\<lfloor>\<lceil>\<lceil>x \<tau>\<rceil>\<rceil> < \<lceil>\<lceil>y \<tau>\<rceil>\<rceil>\<rfloor>\<rfloor>
                else invalid \<tau> "   

definition ocl_le_int ::"('\<AA>)Integer \<Rightarrow> ('\<AA>)Integer \<Rightarrow> ('\<AA>)Boolean" (infix "\<preceq>" 40) 
where "x \<preceq> y \<equiv> \<lambda> \<tau>. if (\<delta> x) \<tau> = true \<tau> \<and> (\<delta> y) \<tau> = true \<tau>
                then \<lfloor>\<lfloor>\<lceil>\<lceil>x \<tau>\<rceil>\<rceil> \<le> \<lceil>\<lceil>y \<tau>\<rceil>\<rceil>\<rfloor>\<rfloor>
                else invalid \<tau> "   

text{* Here follows a list of code-examples, that explain the meanings 
of the above definitions by compilation to code and execution to "True".*}

value "\<tau>\<^isub>0 \<Turnstile> (\<nine> \<preceq> \<one>\<zero> )"     
value "\<tau>\<^isub>0 \<Turnstile> (( \<four> \<oplus> \<four> ) \<preceq> \<one>\<zero> )"     
value "\<not>(\<tau>\<^isub>0 \<Turnstile> ((\<four> \<oplus>( \<four> \<oplus> \<four> )) \<prec> \<one>\<zero> ))"     


subsection {* Example: The Set-Collection Type on the Abstract Interface *}

no_notation None ("\<bottom>")
notation bot ("\<bottom>")


text{* For the semantic construction of the collection types, we have two goals:
\begin{enumerate}
\item we want the types to be \emph{fully abstract}, i.e. the type should not
      contain junk-elements that are not representable by OCL expressions.
\item We want a possibility to nest collection types (so, we want the 
      potential to talking about @{text "Set(Set(Sequences(Pairs(X,Y))))"}), and
\end{enumerate}
The former principe rules out the option to define @{text "'\<alpha> Set"} just by 
 @{text "('\<AA>, ('\<alpha> option option) set) val"}. This would allow sets to contain
junk elements such as @{text "{\<bottom>}"} which we need to identify with undefinedness
itself. Abandoning fully abstractness of rules would later on produce all sorts
of problems when quantifying over the elements of a type.
However, if we build an own type, then it must conform to our abstract interface
in order to have nested types: arguments of type-constructors must conform to our
abstract interface, and the result type too.
*}

text{* The core of an own type construction is done via a type definition which
provides the raw-type @{text "'\<alpha> Set_0"}. it is shown that this type "fits" indeed
into the abstract type interface discussed in the previous section. *}

typedef  '\<alpha> Set_0 = "{X::('\<alpha>\<Colon>null) set option option.
                      X = bot \<or> X = null \<or> (\<forall>x\<in>\<lceil>\<lceil>X\<rceil>\<rceil>. x \<noteq> bot)}"
          by (rule_tac x="bot" in exI, simp)

instantiation   Set_0  :: (null)bot
begin 

   definition bot_Set_0_def: "(bot::('a::null) Set_0) \<equiv> Abs_Set_0 None"

   instance proof show "\<exists>x\<Colon>'a Set_0. x \<noteq> bot"
                  apply(rule_tac x="Abs_Set_0 \<lfloor>None\<rfloor>" in exI)
                  apply(simp add:bot_Set_0_def)
                  apply(subst Abs_Set_0_inject) 
                  apply(simp_all add: Set_0_def bot_Set_0_def 
                                      null_option_def bot_option_def)
                  done
            qed
end


instantiation   Set_0  :: (null)null
begin 
 
   definition null_Set_0_def: "(null::('a::null) Set_0) \<equiv> Abs_Set_0 \<lfloor> None \<rfloor>"

   instance proof show "(null::('a::null) Set_0) \<noteq> bot"
                  apply(simp add:null_Set_0_def bot_Set_0_def)
                  apply(subst Abs_Set_0_inject) 
                  apply(simp_all add: Set_0_def bot_Set_0_def 
                                      null_option_def bot_option_def)
                  done
            qed
end


text{* ...  and lifting this type to the format of a valuation gives us:*}
type_synonym    ('\<AA>,'\<alpha>) Set  = "('\<AA>, '\<alpha> Set_0) val"

lemma Set_inv_lemma: "\<tau> \<Turnstile> (\<delta> X) \<Longrightarrow> (X \<tau> = Abs_Set_0 \<lfloor>bot\<rfloor>) \<or> (\<forall>x\<in>\<lceil>\<lceil>Rep_Set_0 (X \<tau>)\<rceil>\<rceil>. x \<noteq> bot)"
apply(insert OCL_lib.Set_0.Rep_Set_0 [of "X \<tau>"], simp add:Set_0_def)
apply(auto simp: OclValid_def defined_def false_def true_def cp_def 
                 bot_fun_def bot_Set_0_def null_Set_0_def null_fun_def
           split:split_if_asm)
apply(erule contrapos_pp [of "Rep_Set_0 (X \<tau>) = bot"]) 
apply(subst Abs_Set_0_inject[symmetric], simp add:Rep_Set_0)
apply(simp add: Set_0_def)
apply(simp add: Rep_Set_0_inverse bot_Set_0_def bot_option_def)
apply(erule contrapos_pp [of "Rep_Set_0 (X \<tau>) = null"]) 
apply(subst Abs_Set_0_inject[symmetric], simp add:Rep_Set_0)
apply(simp add: Set_0_def)
apply(simp add: Rep_Set_0_inverse  null_option_def)
done

lemma invalid_set_not_defined [simp,code_unfold]:"\<delta>(invalid::('\<AA>,'\<alpha>::null) Set) = false" by simp
lemma null_set_not_defined [simp,code_unfold]:"\<delta>(null::('\<AA>,'\<alpha>::null) Set) = false" 
by(simp add: defined_def null_fun_def)
lemma invalid_set_valid [simp,code_unfold]:"\<upsilon>(invalid::('\<AA>,'\<alpha>::null) Set) = false"
by simp 
lemma null_set_valid [simp,code_unfold]:"\<upsilon>(null::('\<AA>,'\<alpha>::null) Set) = true" 
apply(simp add: valid_def null_fun_def bot_fun_def bot_Set_0_def null_Set_0_def)
apply(subst Abs_Set_0_inject,simp_all add: Set_0_def null_option_def bot_option_def)
done

text{* ... which means that we can have a type @{text "('\<AA>,('\<AA>,('\<AA>) Integer) Set) Set"}
corresponding exactly to Set(Set(Integer)) in OCL notation. Note that the parameter
@{text "\<AA>"} still refers to the object universe; making the OCL semantics entirely parametric
in the object universe makes it possible to study (and prove) its properties 
independently from a concrete class diagram. *}


definition mtSet::"('\<AA>,'\<alpha>::null) Set"  ("Set{}")
where "Set{} \<equiv> (\<lambda> \<tau>.  Abs_Set_0 \<lfloor>\<lfloor>{}::'\<alpha> set\<rfloor>\<rfloor> )"


lemma mtSet_defined[simp,code_unfold]:"\<delta>(Set{}) = true"  
apply(rule ext, auto simp: mtSet_def defined_def null_Set_0_def 
                           bot_Set_0_def bot_fun_def null_fun_def)
apply(simp_all add: Abs_Set_0_inject Set_0_def bot_option_def null_Set_0_def null_option_def)
done

lemma mtSet_valid[simp,code_unfold]:"\<upsilon>(Set{}) = true" 
apply(rule ext,auto simp: mtSet_def valid_def null_Set_0_def 
                          bot_Set_0_def bot_fun_def null_fun_def)
apply(simp_all add: Abs_Set_0_inject Set_0_def bot_option_def null_Set_0_def null_option_def)
done

text{* Note that the collection types in OCL allow for null to be included;
  however, there is the null-collection into which inclusion yields invalid. *}

text{* The case of the size definition is somewhat special, we admit
explicitly in Essential OCL the possibility of infinite sets. For
the size definition, this requires an extra condition that assures
that the cardinality of the set is actually a defined integer. *}

definition OclSize     :: "('\<AA>,'\<alpha>::null)Set \<Rightarrow> '\<AA> Integer"    
where     "OclSize x = (\<lambda> \<tau>. if (\<delta> x) \<tau> = true \<tau> \<and> finite(\<lceil>\<lceil>Rep_Set_0 (x \<tau>)\<rceil>\<rceil>)
                             then \<lfloor>\<lfloor> int(card \<lceil>\<lceil>Rep_Set_0 (x \<tau>)\<rceil>\<rceil>) \<rfloor>\<rfloor>
                             else \<bottom> )"


definition OclIncluding   :: "[('\<AA>,'\<alpha>::null) Set,('\<AA>,'\<alpha>) val] \<Rightarrow> ('\<AA>,'\<alpha>) Set"
where     "OclIncluding x y = (\<lambda> \<tau>. if (\<delta> x) \<tau> = true \<tau> \<and> (\<upsilon> y) \<tau> = true \<tau>
                                    then Abs_Set_0 \<lfloor>\<lfloor> \<lceil>\<lceil>Rep_Set_0 (x \<tau>)\<rceil>\<rceil>  \<union> {y \<tau>} \<rfloor>\<rfloor> 
                                    else \<bottom> )"


definition OclIncludes   :: "[('\<AA>,'\<alpha>::null) Set,('\<AA>,'\<alpha>) val] \<Rightarrow> '\<AA> Boolean"
where     "OclIncludes x y = (\<lambda> \<tau>.   if (\<delta> x) \<tau> = true \<tau> \<and> (\<upsilon> y) \<tau> = true \<tau> 
                                     then \<lfloor>\<lfloor>(y \<tau>) \<in> \<lceil>\<lceil>Rep_Set_0 (x \<tau>)\<rceil>\<rceil> \<rfloor>\<rfloor>
                                     else \<bottom>  )"

definition OclExcluding   :: "[('\<AA>,'\<alpha>::null) Set,('\<AA>,'\<alpha>) val] \<Rightarrow> ('\<AA>,'\<alpha>) Set"
where     "OclExcluding x y = (\<lambda> \<tau>.  if (\<delta> x) \<tau> = true \<tau> \<and> (\<upsilon> y) \<tau> = true \<tau>
                                     then Abs_Set_0 \<lfloor>\<lfloor> \<lceil>\<lceil>Rep_Set_0 (x \<tau>)\<rceil>\<rceil> - {y \<tau>} \<rfloor>\<rfloor> 
                                     else \<bottom> )"

definition OclExcludes   :: "[('\<AA>,'\<alpha>::null) Set,('\<AA>,'\<alpha>) val] \<Rightarrow> '\<AA> Boolean"
where     "OclExcludes x y = (not(OclIncludes x y))"


definition OclIsEmpty   :: "('\<AA>,'\<alpha>::null) Set \<Rightarrow> '\<AA> Boolean"
where     "OclIsEmpty x =  ((OclSize x) \<doteq> \<zero>)"

definition OclNotEmpty   :: "('\<AA>,'\<alpha>::null) Set \<Rightarrow> '\<AA> Boolean"
where     "OclNotEmpty x =  not(OclIsEmpty x)"


definition OclForall     :: "[('\<AA>,'\<alpha>::null)Set,('\<AA>,'\<alpha>)val\<Rightarrow>('\<AA>)Boolean] \<Rightarrow> '\<AA> Boolean"
where     "OclForall S P = (\<lambda> \<tau>. if (\<delta> S) \<tau> = true \<tau> 
                                 then if (\<forall>x\<in>\<lceil>\<lceil>Rep_Set_0 (S \<tau>)\<rceil>\<rceil>. P (\<lambda> _. x) \<tau> = true \<tau>)
                                      then true \<tau>
                                      else if (\<forall>x\<in>\<lceil>\<lceil>Rep_Set_0 (S \<tau>)\<rceil>\<rceil>. P(\<lambda> _. x) \<tau> = true \<tau> \<or>
                                                                      P(\<lambda> _. x) \<tau> = false \<tau>)
                                           then false \<tau>
                                           else \<bottom>
                                 else \<bottom>)"
 

definition OclExists     :: "[('\<AA>,'\<alpha>::null) Set,('\<AA>,'\<alpha>)val\<Rightarrow>('\<AA>)Boolean] \<Rightarrow> '\<AA> Boolean"
where     "OclExists S P = not(OclForall S (\<lambda> X. not (P X)))"

syntax
  "_OclForall" :: "[('\<AA>,'\<alpha>::null) Set,id,('\<AA>)Boolean] \<Rightarrow> '\<AA> Boolean"    ("(_)->forall'(_|_')")
translations
  "X->forall(x | P)" == "CONST OclForall X (%x. P)"

syntax
  "_OclExist" :: "[('\<AA>,'\<alpha>::null) Set,id,('\<AA>)Boolean] \<Rightarrow> '\<AA> Boolean"    ("(_)->exists'(_|_')")
translations
  "X->exists(x | P)" == "CONST OclExists X (%x. P)"


consts (* abstract set collection operations *)
 (* OclSize        :: " ('\<AA>,'\<alpha>::null) Set \<Rightarrow> '\<AA> Integer"      *) 
 (* OclIncludes    :: "[('\<AA>,'\<alpha>::null) Set,('\<AA>,'\<alpha>) val'] \<Rightarrow> '\<AA> Boolean"    *)
 (* OclExcludes    :: "[('\<AA>,'\<alpha>::null) Set,('\<AA>,'\<alpha>) val'] \<Rightarrow> '\<AA> Boolean"    *)   
 (* OclIncluding   :: "[('\<AA>,'\<alpha>::null) Set,('\<AA>,'\<alpha>) val'] \<Rightarrow> ('\<AA>,'\<alpha>) Set"   *)
 (* OclExcluding   :: "[('\<AA>,'\<alpha>::null) Set,('\<AA>,'\<alpha>) val'] \<Rightarrow> ('\<AA>,'\<alpha>) Set"   *)
 (* OclIsEmpty     :: " ('\<AA>,'\<alpha>::null) Set \<Rightarrow> '\<AA> Boolean" *)
 (* OclNotEmpty    :: " ('\<AA>,'\<alpha>::null) Set \<Rightarrow> '\<AA> Boolean"*)
    OclUnion       :: "[('\<AA>,'\<alpha>::null) Set,('\<AA>,'\<alpha>) Set] \<Rightarrow> ('\<AA>,'\<alpha>) Set"
    OclIntersection:: "[('\<AA>,'\<alpha>::null) Set,('\<AA>,'\<alpha>) Set] \<Rightarrow> ('\<AA>,'\<alpha>) Set"
    OclIncludesAll :: "[('\<AA>,'\<alpha>::null) Set,('\<AA>,'\<alpha>) Set] \<Rightarrow> '\<AA> Boolean"
    OclExcludesAll :: "[('\<AA>,'\<alpha>::null) Set,('\<AA>,'\<alpha>) Set] \<Rightarrow> '\<AA> Boolean"
    OclComplement  :: " ('\<AA>,'\<alpha>::null) Set \<Rightarrow> ('\<AA>,'\<alpha>) Set"
    OclSum         :: " ('\<AA>,'\<alpha>::null) Set \<Rightarrow> '\<AA> Integer"
    OclCount       :: "[('\<AA>,'\<alpha>::null) Set,('\<AA>,'\<alpha>) Set] \<Rightarrow> '\<AA> Integer"    
  
notation  (* standard ascii syntax *)
    OclSize        ("_->size'(')" [66])
and
    OclCount       ("_->count'(_')" [66,65]65)
and
    OclIncludes    ("_->includes'(_')" [66,65]65)
and
    OclExcludes    ("_->excludes'(_')" [66,65]65)
and
    OclSum         ("_->sum'(')" [66])
and
    OclIncludesAll ("_->includesAll'(_')" [66,65]65)
and
    OclExcludesAll ("_->excludesAll'(_')" [66,65]65)
and
    OclIsEmpty     ("_->isEmpty'(')" [66])
and
    OclNotEmpty    ("_->notEmpty'(')" [66])
and
    OclIncluding   ("_->including'(_')")
and
    OclExcluding   ("_->excluding'(_')")
and
    OclComplement  ("_->complement'(')")
and
    OclUnion       ("_->union'(_')"          [66,65]65)
and
    OclIntersection("_->intersection'(_')"   [71,70]70)

lemma cp_OclIncluding: 
"(X->including(x)) \<tau> = ((\<lambda> _. X \<tau>)->including(\<lambda> _. x \<tau>)) \<tau>"
by(auto simp: OclIncluding_def StrongEq_def invalid_def  
                 cp_defined[symmetric] cp_valid[symmetric])

lemma cp_OclExcluding: 
"(X->excluding(x)) \<tau> = ((\<lambda> _. X \<tau>)->excluding(\<lambda> _. x \<tau>)) \<tau>"
by(auto simp: OclExcluding_def StrongEq_def invalid_def  
                 cp_defined[symmetric] cp_valid[symmetric])

lemma cp_OclIncludes: 
"(X->includes(x)) \<tau> = (OclIncludes (\<lambda> _. X \<tau>) (\<lambda> _. x \<tau>) \<tau>)"
by(auto simp: OclIncludes_def StrongEq_def invalid_def  
                 cp_defined[symmetric] cp_valid[symmetric])

(* Why does this not work syntactically ???
   lemma cp_OclIncludes: "(X->includes(x)) \<tau> = (((\<lambda> _. X \<tau>)->includes( \<lambda> _. x \<tau>)) \<tau>)" *)


(* TODO later
lemmas cp_intro''[simp,intro!] = 
       cp_intro'
       cp_OclIncludes  [THEN allI[THEN allI[THEN allI[THEN cp'I2]], of "OclIncludes"]]
       cp_OclIncluding [THEN allI[THEN allI[THEN allI[THEN cp'I2]], of "OclIncluding"]]
*)


lemma including_strict1[simp,code_unfold]:"(\<bottom>->including(x)) = \<bottom>"
by(simp add: bot_fun_def OclIncluding_def defined_def valid_def false_def true_def)

lemma including_strict2[simp,code_unfold]:"(X->including(\<bottom>)) = \<bottom>"
by(simp add: OclIncluding_def bot_fun_def defined_def valid_def false_def true_def)

lemma including_strict3[simp,code_unfold]:"(null->including(x)) = \<bottom>"
by(simp add: OclIncluding_def bot_fun_def defined_def valid_def false_def true_def)


lemma excluding_strict1[simp,code_unfold]:"(\<bottom>->excluding(x)) = \<bottom>"
by(simp add: bot_fun_def OclExcluding_def defined_def valid_def false_def true_def)

lemma excluding_strict2[simp,code_unfold]:"(X->excluding(\<bottom>)) = \<bottom>"
by(simp add: OclExcluding_def bot_fun_def defined_def valid_def false_def true_def)

lemma excluding_strict3[simp,code_unfold]:"(null->excluding(x)) = \<bottom>"
by(simp add: OclExcluding_def bot_fun_def defined_def valid_def false_def true_def)



lemma includes_strict1[simp,code_unfold]:"(\<bottom>->includes(x)) = \<bottom>"
by(simp add: bot_fun_def OclIncludes_def defined_def valid_def false_def true_def)

lemma includes_strict2[simp,code_unfold]:"(X->includes(\<bottom>)) = \<bottom>"
by(simp add: OclIncludes_def bot_fun_def defined_def valid_def false_def true_def)

lemma includes_strict3[simp,code_unfold]:"(null->includes(x)) = \<bottom>"
by(simp add: OclIncludes_def bot_fun_def defined_def valid_def false_def true_def)




lemma including_valid_args_valid: 
"(\<tau> \<Turnstile> \<delta>(X->including(x))) = ((\<tau> \<Turnstile>(\<delta> X)) \<and> (\<tau> \<Turnstile>(\<upsilon> x)))"
proof -
 have A : "\<bottom> \<in> Set_0" by(simp add: Set_0_def bot_option_def)
 have B : "\<lfloor>\<bottom>\<rfloor> \<in> Set_0" by(simp add: Set_0_def null_option_def bot_option_def)
 have C : "(\<tau> \<Turnstile>(\<delta> X)) \<Longrightarrow> (\<tau> \<Turnstile>(\<upsilon> x)) \<Longrightarrow> \<lfloor>\<lfloor>insert (x \<tau>) \<lceil>\<lceil>Rep_Set_0 (X \<tau>)\<rceil>\<rceil>\<rfloor>\<rfloor> \<in> Set_0"
          apply(frule Set_inv_lemma) 
          apply(simp add: Set_0_def bot_option_def null_Set_0_def null_fun_def 
                          foundation18 foundation16) 
          done
 have D: "(\<tau> \<Turnstile> \<delta>(X->including(x))) \<Longrightarrow> ((\<tau> \<Turnstile>(\<delta> X)) \<and> (\<tau> \<Turnstile>(\<upsilon> x)))" 
          by(auto simp: OclIncluding_def OclValid_def true_def valid_def false_def StrongEq_def 
                        defined_def invalid_def bot_fun_def null_fun_def
                  split: bool.split_asm HOL.split_if_asm option.split)
 have E: "(\<tau> \<Turnstile>(\<delta> X)) \<Longrightarrow> (\<tau> \<Turnstile>(\<upsilon> x)) \<Longrightarrow> (\<tau> \<Turnstile> \<delta>(X->including(x)))" 
          apply(frule C, simp)
          apply(auto simp: OclIncluding_def OclValid_def true_def false_def StrongEq_def 
                           defined_def invalid_def valid_def bot_fun_def null_fun_def
                     split: bool.split_asm HOL.split_if_asm option.split)
          apply(simp_all add: null_Set_0_def bot_Set_0_def bot_option_def)
          apply(simp_all add: Abs_Set_0_inject A B bot_option_def[symmetric], 
                simp_all add: bot_option_def)
          done
show ?thesis by(auto dest:D intro:E)
qed

lemma including_valid_args_valid'[simp,code_unfold]: 
"\<delta>(X->including(x)) = ((\<delta> X) and (\<upsilon> x))"
sorry

lemma including_valid_args_valid''[simp,code_unfold]: 
"\<upsilon>(X->including(x)) = ((\<delta> X) and (\<upsilon> x))"
sorry


lemma excluding_valid_args_valid'[simp,code_unfold]: 
"\<delta>(X->excluding(x)) = ((\<delta> X) and (\<upsilon> x))"
sorry

lemma excluding_valid_args_valid''[simp,code_unfold]: 
"\<upsilon>(X->excluding(x)) = ((\<delta> X) and (\<upsilon> x))"
sorry

lemma includes_valid_args_valid'[simp,code_unfold]: 
"\<delta>(X->includes(x)) = ((\<delta> X) and (\<upsilon> x))"
sorry

lemma includes_valid_args_valid''[simp,code_unfold]: 
"\<upsilon>(X->includes(x)) = ((\<delta> X) and (\<upsilon> x))"
sorry


(* and many more *) 

subsection{* Some computational laws:*}


lemma including_charn0[simp]:
assumes val_x:"\<tau> \<Turnstile> (\<upsilon> x)"
shows         "\<tau> \<Turnstile> not(Set{}->includes(x))"
using val_x
apply(auto simp: OclValid_def OclIncludes_def not_def false_def true_def)
apply(auto simp: mtSet_def OCL_lib.Set_0.Abs_Set_0_inverse Set_0_def)
done

lemma including_charn0'[simp,code_unfold]:
"Set{}->includes(x) = (if \<upsilon> x then false else undefined endif)"
sorry

(*declare [[names_long,show_types,show_sorts]]*)
lemma including_charn1:
assumes def_X:"\<tau> \<Turnstile> (\<delta> X)"
assumes val_x:"\<tau> \<Turnstile> (\<upsilon> x)"
shows         "\<tau> \<Turnstile> (X->including(x)->includes(x))"
proof -
 have A : "\<bottom> \<in> Set_0" by(simp add: Set_0_def bot_option_def)
 have B : "\<lfloor>\<bottom>\<rfloor> \<in> Set_0" by(simp add: Set_0_def null_option_def bot_option_def)
 have C : "\<lfloor>\<lfloor>insert (x \<tau>) \<lceil>\<lceil>Rep_Set_0 (X \<tau>)\<rceil>\<rceil>\<rfloor>\<rfloor> \<in> Set_0"
          apply(insert def_X[THEN foundation17] val_x[THEN foundation19] Set_inv_lemma[OF def_X])
          apply(simp add: Set_0_def bot_option_def null_Set_0_def null_fun_def) 
          done
 show ?thesis
   apply(insert def_X[THEN foundation17] val_x[THEN foundation19])
   apply(auto simp: OclValid_def bot_fun_def OclIncluding_def OclIncludes_def false_def true_def
                    defined_def valid_def bot_Set_0_def null_fun_def null_Set_0_def bot_option_def)
   apply(simp_all add: Abs_Set_0_inject A B C bot_option_def[symmetric], 
         simp_all add: bot_option_def Abs_Set_0_inverse C)
   done
qed



lemma including_charn2:
assumes def_X:"\<tau> \<Turnstile> (\<delta> X)"
and     val_x:"\<tau> \<Turnstile> (\<upsilon> x)"
and     val_y:"\<tau> \<Turnstile> (\<upsilon> y)"
and     neq  :"\<tau> \<Turnstile> not(x \<triangleq> y)" 
shows         "\<tau> \<Turnstile> (X->including(x)->includes(y)) \<triangleq> (X->includes(y))"
proof -
 have A : "\<bottom> \<in> Set_0" by(simp add: Set_0_def bot_option_def)
 have B : "\<lfloor>\<bottom>\<rfloor> \<in> Set_0" by(simp add: Set_0_def null_option_def bot_option_def)
 have C : "\<lfloor>\<lfloor>insert (x \<tau>) \<lceil>\<lceil>Rep_Set_0 (X \<tau>)\<rceil>\<rceil>\<rfloor>\<rfloor> \<in> Set_0"
          apply(insert def_X[THEN foundation17] val_x[THEN foundation19] Set_inv_lemma[OF def_X])
          apply(simp add: Set_0_def bot_option_def null_Set_0_def null_fun_def) 
          done
 have D : "y \<tau> \<noteq> x \<tau>" 
          apply(insert neq)
          by(auto simp: OclValid_def bot_fun_def OclIncluding_def OclIncludes_def 
                        false_def true_def defined_def valid_def bot_Set_0_def 
                        null_fun_def null_Set_0_def StrongEq_def not_def)
 show ?thesis
  apply(insert def_X[THEN foundation17] val_x[THEN foundation19])
  apply(auto simp: OclValid_def bot_fun_def OclIncluding_def OclIncludes_def false_def true_def
                   defined_def valid_def bot_Set_0_def null_fun_def null_Set_0_def StrongEq_def)
  apply(simp_all add: Abs_Set_0_inject Abs_Set_0_inverse A B C D) 
  apply(simp_all add: Abs_Set_0_inject A B C bot_option_def[symmetric], 
        simp_all add: bot_option_def Abs_Set_0_inverse C)
  done
qed

lemma includes_execute[code_unfold]:
"(X->including(x)->includes(y)) = (if \<delta> X then if x \<doteq> y
                                               then true
                                               else X->includes(y)
                                               endif
                                          else invalid endif)"
sorry


lemma excluding_charn0[simp]:
assumes val_x:"\<tau> \<Turnstile> (\<upsilon> x)"
shows         "\<tau> \<Turnstile> (Set{}->excluding(x))  \<triangleq>  Set{}"
proof -
  have A : "\<lfloor>None\<rfloor> \<in> Set_0" by(simp add: Set_0_def null_option_def bot_option_def)
  have B : "\<lfloor>\<lfloor>{}\<rfloor>\<rfloor> \<in> Set_0" by(simp add: Set_0_def bot_option_def)
  show ?thesis using val_x
    apply(auto simp: OclValid_def OclIncludes_def not_def false_def true_def StrongEq_def 
                     OclExcluding_def mtSet_def defined_def bot_fun_def null_fun_def null_Set_0_def)
    apply(auto simp: mtSet_def Set_0_def  OCL_lib.Set_0.Abs_Set_0_inverse 
                     OCL_lib.Set_0.Abs_Set_0_inject[OF B, OF A])
  done
qed


lemma excluding_charn1:
assumes def_X:"\<tau> \<Turnstile> (\<delta> X)"
and     val_x:"\<tau> \<Turnstile> (\<upsilon> x)"
and     val_y:"\<tau> \<Turnstile> (\<upsilon> y)"
and     neq  :"\<tau> \<Turnstile> not(x \<triangleq> y)" 
shows         "\<tau> \<Turnstile> ((X->including(x))->excluding(y)) \<triangleq> ((X->excluding(x))->including(y))"
proof -
 have A : "\<bottom> \<in> Set_0" by(simp add: Set_0_def bot_option_def)
 have B : "\<lfloor>\<bottom>\<rfloor> \<in> Set_0" by(simp add: Set_0_def null_option_def bot_option_def)
 have C : "\<lfloor>\<lfloor>insert (x \<tau>) \<lceil>\<lceil>Rep_Set_0 (X \<tau>)\<rceil>\<rceil>\<rfloor>\<rfloor> \<in> Set_0"
          apply(insert def_X[THEN foundation17] val_x[THEN foundation19] Set_inv_lemma[OF def_X])
          apply(simp add: Set_0_def bot_option_def null_Set_0_def null_fun_def) 
          done
 have D : "y \<tau> \<noteq> x \<tau>" 
          apply(insert neq)
          by(auto simp: OclValid_def bot_fun_def OclIncluding_def OclIncludes_def 
                        false_def true_def defined_def valid_def bot_Set_0_def 
                        null_fun_def null_Set_0_def StrongEq_def not_def)
 show ?thesis
  apply(insert def_X[THEN foundation17] val_x[THEN foundation19])
  apply(auto simp: OclValid_def bot_fun_def OclIncluding_def OclIncludes_def false_def true_def
                   defined_def valid_def bot_Set_0_def null_fun_def null_Set_0_def StrongEq_def)
  apply(subst cp_OclExcluding,simp add:true_def) 
  sorry
qed

lemma excluding_charn2:
assumes def_X:"\<tau> \<Turnstile> (\<delta> X)"
and     val_x:"\<tau> \<Turnstile> (\<upsilon> x)"
shows         "\<tau> \<Turnstile> (((X->including(x))->excluding(x)) \<triangleq> (X->excluding(x)))"
proof -
 have A : "\<bottom> \<in> Set_0" by(simp add: Set_0_def bot_option_def)
 have B : "\<lfloor>\<bottom>\<rfloor> \<in> Set_0" by(simp add: Set_0_def null_option_def bot_option_def)
 have C : "\<lfloor>\<lfloor>insert (x \<tau>) \<lceil>\<lceil>Rep_Set_0 (X \<tau>)\<rceil>\<rceil>\<rfloor>\<rfloor> \<in> Set_0 "
          apply(insert def_X[THEN foundation17] val_x[THEN foundation19] Set_inv_lemma[OF def_X])
          apply(simp add: Set_0_def bot_option_def null_Set_0_def null_fun_def) 
          done
 show ?thesis
   apply(insert def_X[THEN foundation17] val_x[THEN foundation19])
   apply(auto simp: OclValid_def bot_fun_def OclIncluding_def OclIncludes_def false_def true_def
                    defined_def valid_def bot_Set_0_def null_fun_def null_Set_0_def StrongEq_def)
   apply(subst cp_OclExcluding) back
   apply(simp add:true_def)
   apply(auto simp:OclExcluding_def)
   apply(simp add: Abs_Set_0_inverse[OF C])
   apply(simp_all add: false_def true_def defined_def valid_def 
                       null_fun_def bot_fun_def null_Set_0_def bot_Set_0_def
                  split: bool.split_asm HOL.split_if_asm option.split) 
   apply(simp_all add: Abs_Set_0_inject A B C bot_option_def[symmetric], 
         simp_all add: bot_option_def Abs_Set_0_inverse C)
  done
qed


syntax
  "_OclFinset" :: "args => ('\<AA>,'a::null) Set"    ("Set{(_)}")
translations
  "Set{x, xs}" == "CONST OclIncluding (Set{xs}) x"
  "Set{x}"     == "CONST OclIncluding (Set{}) x "

lemma syntax_test: "Set{\<two>,\<one>} = (Set{}->including(\<one>)->including(\<two>))"
by simp

lemma set_test1: "\<tau> \<Turnstile> (Set{\<two>,null}->includes(null))"
by(simp add: includes_execute) 

lemma set_test2: "\<not>(\<tau> \<Turnstile> (Set{\<two>,\<one>}->includes(null)))"
by(simp add: includes_execute) 


text{* Here is an example of a nested collection. Note that we have
to use the abstract null (since we did not (yet) define a concrete
constant @{term null} for the non-existing Sets) :*}
lemma semantic_test: "\<tau> \<Turnstile> (Set{Set{\<two>},null}->includes(null))"
oops

lemma syntax_test : "\<tau> \<Turnstile> Set{Set{\<two>},null} \<triangleq> Set{null,Set{\<two>}}"
oops


lemma semantic_test: "\<tau> \<Turnstile> (Set{null,\<two>}->includes(null))"
by(simp_all add: including_charn1 including_valid_args_valid)

(* legacy --- still better names ?
lemmas defined_charn = foundation16
lemmas definedD = foundation17
lemmas valid_charn = foundation18
lemmas validD = foundation19
lemmas valid_implies_defined = foundation20
 end legacy *)

definition OclIterate\<^isub>S\<^isub>e\<^isub>t :: "[('\<AA>,'\<alpha>::null) Set,('\<AA>,'\<beta>::null)val,('\<AA>,'\<alpha>)val\<Rightarrow>('\<AA>,'\<beta>)val\<Rightarrow>('\<AA>,'\<beta>)val]
                             \<Rightarrow> ('\<AA>,'\<beta>)val"
where "OclIterate\<^isub>S\<^isub>e\<^isub>t S A F = (\<lambda> \<tau>. if (\<delta> S) \<tau> = true \<tau> \<and> (\<upsilon> A) \<tau> = true \<tau> \<and> finite\<lceil>\<lceil>Rep_Set_0 (S \<tau>)\<rceil>\<rceil>
                                  then (fold F A ((\<lambda>a \<tau>. a) ` \<lceil>\<lceil>Rep_Set_0 (S \<tau>)\<rceil>\<rceil>))\<tau>
                                  else \<bottom>)"
(* TODO: Introduce nice OCL syntax for OclIterate\<^isub>S\<^isub>e\<^isub>t S A F = S->iterate(acc=A; x | F x acc) *)

lemma OclIterate\<^isub>S\<^isub>e\<^isub>t_strict1[simp]:"(OclIterate\<^isub>S\<^isub>e\<^isub>t \<bottom> A F) = \<bottom>"
by(simp add: bot_fun_def OclIterate\<^isub>S\<^isub>e\<^isub>t_def defined_def valid_def false_def true_def)

lemma OclIterate\<^isub>S\<^isub>e\<^isub>t_null1[simp]:"(OclIterate\<^isub>S\<^isub>e\<^isub>t null A F) = \<bottom>"
by(simp add: bot_fun_def OclIterate\<^isub>S\<^isub>e\<^isub>t_def defined_def valid_def false_def true_def)


lemma OclIterate\<^isub>S\<^isub>e\<^isub>t_strict2[simp]:"(OclIterate\<^isub>S\<^isub>e\<^isub>t S \<bottom> F) = \<bottom>"
by(simp add: bot_fun_def OclIterate\<^isub>S\<^isub>e\<^isub>t_def defined_def valid_def false_def true_def)

text{* An open question is this ... *}
lemma OclIterate\<^isub>S\<^isub>e\<^isub>t_null2[simp]:"(OclIterate\<^isub>S\<^isub>e\<^isub>t S null F) = \<bottom>"
oops  
text{* In the definition above, this does not hold in general. 
       And I believe, this is how it should be ... *}

lemma OclIterate\<^isub>S\<^isub>e\<^isub>t_infinite:
assumes non_finite: "\<tau> \<Turnstile> not(\<delta>(S->size()))"
shows "(OclIterate\<^isub>S\<^isub>e\<^isub>t S A F) = \<bottom>"
sorry

lemma OclIterate\<^isub>S\<^isub>e\<^isub>t_empty: "(OclIterate\<^isub>S\<^isub>e\<^isub>t (Set{}) A F) = A"
oops
text{* In particular, this does hold for A = null. *}


lemma OclIterate\<^isub>S\<^isub>e\<^isub>t_including:
assumes S_finite: "\<tau> \<Turnstile> \<delta>(S->size())"
and     F_strict1:"\<And> x. F x \<bottom> = \<bottom>"
and     F_strict2:"\<And> x. F \<bottom> x = \<bottom>"
and     F_commute:"\<And> x y. F y \<circ> F x = F x \<circ> F y"
and     F_cp:     "\<And> x y \<tau>. F x y \<tau> = F (\<lambda> _. x \<tau>) (\<lambda> _. y \<tau>) \<tau>"
shows   "(OclIterate\<^isub>S\<^isub>e\<^isub>t (S->including(a)) A F) = F a (OclIterate\<^isub>S\<^isub>e\<^isub>t (S->excluding(a)) A F)"
sorry

text{* Elementary cxomputations on Sets.*}
value "\<not> (\<tau>\<^isub>0 \<Turnstile> \<upsilon>(invalid::('\<AA>,'\<alpha>::null) Set))"
value "\<tau>\<^isub>0 \<Turnstile> \<upsilon>(null::('\<AA>,'\<alpha>::null) Set)"
value "\<not> (\<tau>\<^isub>0 \<Turnstile> \<delta>(null::('\<AA>,'\<alpha>::null) Set))"
value "\<tau>\<^isub>0 \<Turnstile> \<upsilon>(Set{})"
value "\<tau>\<^isub>0 \<Turnstile> \<upsilon>(Set{Set{\<two>},null})"
value "\<tau>\<^isub>0 \<Turnstile> \<delta>(Set{Set{\<two>},null})"
value "\<tau>\<^isub>0 \<Turnstile> (Set{\<two>,\<one>}->includes(\<one>))"
value "\<not> (\<tau>\<^isub>0 \<Turnstile> (Set{\<two>}->includes(\<one>)))"
value "\<not> (\<tau>\<^isub>0 \<Turnstile> (Set{\<two>,\<one>}->includes(null)))"
value "\<tau>\<^isub>0 \<Turnstile> (Set{\<two>,null}->includes(null))"

end
