# Prove conjecture 00000007175: every real spectrum is realized by a symmetric tridiagonal matrix, and tridiagonal positive definiteness is the leading-minor chain

Lean 4 / Mathlib proof (no extra axioms) of both clauses of the conjecture.

- `C7175.realizable`: for every n and every `l : Fin n -> R` there is a real symmetric tridiagonal matrix with characteristic polynomial `prod (X - C (l i))` (multiplicities retained). Witness: `diagonal l`.
- `C7175.minorCriterion`: for every n and every real symmetric tridiagonal `A`, `A.PosDef` iff all leading principal minors (k <= n) are positive. Sylvester's criterion is proved from scratch by induction on n via a Schur complement; it is proved for all symmetric matrices, so the tridiagonal hypothesis is only used to match the statement.
- Main theorem: `C7175.main : Claim` (`Claim := Realizable /\ MinorCriterion`).
- Axioms: propext, Classical.choice, Quot.sound only.

Reading: "real spectrum" is a finite list of reals with multiplicity; "positivity ... is the principal-minor chain" is read as the Sylvester equivalence.

## Contents

| path | content |
|---|---|
| `proof.tex`, `proof.pdf` | full report |
| `lean/` | Lean 4 project (Lean (version 4.33.1; Mathlib v4.33.1); proof in `lean/Conjecture7175/Basic.lean` |
| `lean/Conjecture7175/Statement.lean` | the formal statement alone: Mathlib imports and definitions only, ending in `Claim : Prop` (read this file to check faithfulness) |
| `lean/StatementCheck.lean` | machine check that a main theorem has type exactly `Claim` (`verification/statement.txt`) |
| `lean/Axioms.lean` | axiom audit |
| `conjecture.md` | the conjecture exactly as in `conjectures/00000007175.md` |
| `SEMANTIC_REVIEW.md` | independent pre-submission semantic review |
| `verification/` | fresh-build log, axiom output, SHA-256 checksums |

## Lean

Main theorems: `C7175.main`.

No `sorry`, `admit`, `native_decide` or `axiom`; every theorem above depends only on `propext`, `Classical.choice` and `Quot.sound` (`verification/axioms.txt`).

Reproduce:

```
cd lean
lake exe cache get
lake build
lake env lean Axioms.lean
lake env lean StatementCheck.lean
```

## Eligibility

Checked before opening the pull request (2026-10-10): no solution folder for 00000007175 on `main`, no open pull request for it by anyone else, and `metadata.csv` lists it as unsolved. The pull request only adds this submission folder.
