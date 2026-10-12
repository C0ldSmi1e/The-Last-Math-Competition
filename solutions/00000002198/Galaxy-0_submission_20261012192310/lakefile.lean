import Lake
open Lake DSL
package tlmc2198 where
  moreLeanArgs := #["-DwarningAsError=true"]
@[default_target]
lean_lib Main where
  roots := #[`Main, `EnumLemma, `Eulerian]
