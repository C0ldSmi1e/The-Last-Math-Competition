import Lake
open Lake DSL

package «hoffmanWielandt» where
  leanOptions := #[⟨`warningAsError, true⟩]

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.19.0"

@[default_target]
lean_lib HoffmanWielandt where
  roots := #[`NormalSpectral, `Frobenius, `Matching, `Reindexing, `HoffmanWielandt]

@[default_target]
lean_lib Verification
