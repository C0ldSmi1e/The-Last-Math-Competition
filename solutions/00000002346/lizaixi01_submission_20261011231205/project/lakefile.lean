import Lake
open Lake DSL
package MomentCounterexample where
  moreLeanArgs := #["-j2"]
require mathlib from git "https://github.com/leanprover-community/mathlib4.git" @ "db584cd6d46c92f209a44c0f1c829460d327499d"
@[default_target]
lean_lib MomentCounterexample where
  roots := #[`Moment]
