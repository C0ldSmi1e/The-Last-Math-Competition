# Disprove conjecture 00000008538: radical and quotient of an incidence algebra fail for infinite locally finite lattices

The conjecture as written has no finiteness hypothesis. For K = Q and the infinite locally finite lattice L = N^op (with top), it fails.
- Objects are Mathlib's: `IncidenceAlgebra K L`, radical `Ring.jacobson`, strictly triangular part `{f | f x y != 0 -> x < y}` (= zero diagonal), Mobius algebra = monoid algebra of (L, meet, top).
- Orientation: Mathlib's convention is upper triangular; "lower" is the transposed (L^op) convention. The counterexample is unaffected, since the part is defined by f x x = 0.
- If the radical equals the strictly triangular part, the diagonal map I -> K^L is surjective with that kernel, so I/J is K-linearly K^L (`quotLinEquiv`).
- By Erdos-Kaplansky (`rank_fun_infinite`), rank K^L = |K^L| = |Q^N| = 2^aleph0, but |L| = aleph0, so the dimension clause fails (`rank_ne`, `main`).
- Boundary: for finite lattices all three clauses hold (`finite_main`, same file): radical = zero diagonal, quotient = K^L = Mobius algebra, dimension |L|.
- Dimension is `Module.rank` against `Cardinal.mk L`. A reader who takes "the number of lattice elements" to presuppose finiteness is reading the finite theorem, which is true.
Main theorems: `C8538.main : C8538.Claim` (Claim := not Conjecture) and `C8538.finite_main : C8538.FiniteConjecture`. Lean: `lean/Conjecture8538/Basic.lean` (318 lines, Mathlib only, axioms propext/Classical.choice/Quot.sound).

## Contents

| path | content |
|---|---|
| `proof.tex`, `proof.pdf` | full report |
| `lean/` | Lean 4 project (Lean (version 4.33.1; Mathlib v4.33.1); proof in `lean/Conjecture8538/Basic.lean` |
| `lean/Conjecture8538/Statement.lean` | the formal statement alone: Mathlib imports and definitions only, ending in `Claim : Prop` (read this file to check faithfulness) |
| `lean/StatementCheck.lean` | machine check that a main theorem has type exactly `Claim` (`verification/statement.txt`) |
| `lean/Axioms.lean` | axiom audit |
| `conjecture.md` | the conjecture exactly as in `conjectures/00000008538.md` |
| `SEMANTIC_REVIEW.md` | independent pre-submission semantic review |
| `verification/` | fresh-build log, axiom output, SHA-256 checksums |

## Lean

Main theorems: `C8538.main`, `C8538.finite_main`.

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

Checked before opening the pull request (2026-10-10): no solution folder for 00000008538 on `main`, no open pull request for it by anyone else, and `metadata.csv` lists it as unsolved. The pull request only adds this submission folder.
