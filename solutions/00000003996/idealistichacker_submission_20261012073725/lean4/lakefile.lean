import Lake
open Lake DSL
package tlmc3996
require mathlib from git "https://github.com/leanprover-community/mathlib4.git" @ "0df444a360eaa60ab8c11dca51a86af692955474"
lean_lib Conjecture3996 where
  moreLeanArgs := #["-DwarningAsError=true"]
@[default_target]
lean_lib Main where
  moreLeanArgs := #["-DwarningAsError=true"]
