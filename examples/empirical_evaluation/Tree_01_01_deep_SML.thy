theory Tree_01_01_deep_SML imports "../../src/OCL_compiler_generator_dynamic" begin
generation_syntax [ deep
                      (generation_semantics [ analysis (*, oid_start 10*) ])
                      skip_export
                      (THEORY Tree_01_01_generated_SML)
                      (IMPORTS ["../../../src/OCL_main", "../../../src/OCL_compiler_static"]
                               "../../../src/OCL_compiler_generator_dynamic")
                      SECTION
                      [ in SML module_name M (no_signatures) ]
                      (output_directory "./doc") ]

Class Aazz End

(* 1 *)

generation_syntax deep flush_all


end
