# Solution Review — Conjecture 00000000161 (PR 930)

**Submission:** C0ldSmi1e — `C0ldSmi1e_submission_20261009232445`  
**Reviewer:** independent competition reviewer  
**Date:** 2026-10-11

## Checklist results

- **Eligibility and scope.** The submission uses the correct personal folder for conjecture 00000000161; the conjecture was open, and the pull request changed no conjecture, README, leaderboard, or metadata file.
- **Report and PDF.** The complete official statement of the conjecture, the LaTeX report, and the submitted PDF were read in full. The LaTeX source was independently recompiled with `pdflatex`, which exited successfully and regenerated the PDF; the rendered report matches the submitted PDF.
- **Lean project.** The submission's Lean project was rebuilt from a clean copy of the frozen sources, keeping its own module names, its own `lakefile`, its pinned Mathlib revision `c44e0c8ee63ca166450922a373c7409c5d26b00b` and its toolchain `leanprover/lean4:v4.19.0`. `lake build` completed successfully: no `sorry`, no `native_decide`, no custom `axiom`/`constant`, no `unsafe`, `opaque`, `extern` or `implemented_by` declaration, and no kernel bypass.
- **Axiom audit.** `#print axioms` was run against every declaration exported by the submission's own modules. The transitive axiom set of each audited theorem is contained in {`Classical.choice`, `Quot.sound`, `propext`}; no other axiom — in particular no `sorryAx` — is reachable.
- **Auxiliary code.** The LaTeX source compiled cleanly with `pdflatex` and regenerated the PDF. The following require the author's own prepared build environment and could not be rerun standalone: `lean/verify.py`, `verification/engineering/replay_extended.py`.

## Semantic audit

**Conjecture as filed.** Conjecture: The order of a random element of GL_n(F_p): with probability tending to 1 (as p → ∞ with fixed n ≥ 2), a random A ∈ GL_n(F_p) has order divisible by a prime factor exceeding p^{n−1}/poly(n). **Formal objects introduced.** `GeneralLinear`, `LargePrimeFactor`, `OriginalClaim`, `PrimeIndex`, `successProbability`. **Decisive results.** `conjecture_false` (in `lean/Conjecture161.lean`); `no_largePrimeFactor_four` (in `lean/Conjecture161.lean`); `successProbability_four_not_tendsto_one` (in `lean/Conjecture161.lean`); `no_positive_denominator_function` (in `lean/Conjecture161.lean`). Read against the filed statement, these definitions formalize precisely the quantities named in the conjecture text, and the decisive theorems are stated over those same definitions with no strengthening, weakening or renaming, so the formalization is a faithful reading of the conjecture. The decisive theorems establish the negation of the filed statement under the same hypotheses, so the conjecture as filed is refuted rather than a mis-reading of it.

## Disposition

APPROVED — merged as PR 930.
