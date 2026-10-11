# Prove conjecture 00000003420: effective resistance equals the pseudoinverse quadratic form and the reciprocal-eigenvalue sum

Lean 4 / Mathlib proof (no axioms beyond propext, Classical.choice, Quot.sound) for every finite connected simple graph G
(unit conductances) and every pair of vertices i, j, with L = G.lapMatrix R.

* `pinv G = U * diag(1/lambda_k or 0) * U^T` is built from Mathlib's spectral decomposition of L (U = eigenvectorUnitary).
* `moorePenrose`: pinv G satisfies the four Penrose equations; `moorePenrose_unique`: it is the only matrix that does.
* Electrical definition: a potential is v with L v = e_i - e_j. One exists, and every such v has v i - v j = (e_i-e_j)^T L^+ (e_i-e_j).
* That quadratic form equals the sum over lambda_k > 0 of (u_k i - u_k j)^2 / lambda_k (the "harmonic series of eigenvalues", read as the weighted reciprocal-eigenvalue expansion).
* Connectedness is used exactly to show that eigenvectors for eigenvalue 0 are constant.

Main theorem: `C3420.main : C3420.Claim` (Claim := Conjecture, quantified over all V and G).

## Contents

| path | content |
|---|---|
| `proof.tex`, `proof.pdf` | full report |
| `lean/` | Lean 4 project (Lean (version 4.33.1; Mathlib v4.33.1); proof in `lean/Conjecture3420/Basic.lean` |
| `lean/Conjecture3420/Statement.lean` | the formal statement alone: Mathlib imports and definitions only, ending in `Claim : Prop` (read this file to check faithfulness) |
| `lean/StatementCheck.lean` | machine check that a main theorem has type exactly `Claim` (`verification/statement.txt`) |
| `lean/Axioms.lean` | axiom audit |
| `conjecture.md` | the conjecture exactly as in `conjectures/00000003420.md` |
| `SEMANTIC_REVIEW.md` | independent pre-submission semantic review |
| `verification/` | fresh-build log, axiom output, SHA-256 checksums |

## Lean

Main theorems: `C3420.main`.

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

Checked before opening the pull request (2026-10-10): no solution folder for 00000003420 on `main`, no open pull request for it by anyone else, and `metadata.csv` lists it as unsolved. The pull request only adds this submission folder.
