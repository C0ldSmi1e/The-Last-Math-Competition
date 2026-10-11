import Conjecture8538
open Lean Meta in
#eval show MetaM Unit from do
  let env ← getEnv
  let some idx := env.getModuleIdx? `Conjecture8538.Statement
    | throwError "STATEMENT_FAIL: module Conjecture8538.Statement is not imported by Conjecture8538"
  let claims := env.const2ModIdx.fold (init := #[]) fun acc n i =>
    match n with
    | .str _ "Claim" => if i == idx then acc.push n else acc
    | _ => acc
  if claims.size != 1 then
    throwError m!"STATEMENT_FAIL: expected exactly one `Claim` in Conjecture8538.Statement, found {claims}"
  let claim := claims[0]!
  unless (← isDefEq (← inferType (mkConst claim)) (mkSort Level.zero)) do
    throwError m!"STATEMENT_FAIL: {claim} is not a Prop"
  let mut ok := false
  for t in [`C8538.main, `C8538.finite_main] do
    if (← isDefEq (← getConstInfo t).type (mkConst claim)) then
      IO.println s!"CLAIM_OK {t} : {claim}"
      ok := true
  unless ok do throwError m!"STATEMENT_FAIL: no main theorem has type {claim}"
