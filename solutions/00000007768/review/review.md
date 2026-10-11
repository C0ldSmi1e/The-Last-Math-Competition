# Solution Review — Conjecture 00000007768 (PR 913)

**Submission:** lizaixi01 — `lizaixi01_submission_20261009202318`  
**Reviewer:** independent competition reviewer  
**Date:** 2026-10-11

## Checklist results

- **Eligibility and scope.** The submission uses the correct personal folder for conjecture 00000007768; the conjecture was open, and the pull request changed no conjecture, README, leaderboard, or metadata file.
- **Report and PDF.** The complete official statement of the conjecture, the LaTeX report, and the submitted PDF were read in full. The LaTeX source was independently recompiled with `pdflatex`, which exited successfully and regenerated the PDF; the rendered report matches the submitted PDF.
- **Lean project.** The submission's Lean project was rebuilt from a clean copy of the frozen sources, keeping its own module names, its own `lakefile`, its pinned Mathlib revision `db584cd6d46c92f209a44c0f1c829460d327499d` and its toolchain `leanprover/lean4:v4.33.0`. `lake build` completed successfully: no `sorry`, no `native_decide`, no custom `axiom`/`constant`, no `unsafe`, `opaque`, `extern` or `implemented_by` declaration, and no kernel bypass.
- **Axiom audit.** `#print axioms` was run against every declaration exported by the submission's own modules. The transitive axiom set of each audited theorem is contained in {`Classical.choice`, `Quot.sound`, `propext`}; no other axiom — in particular no `sorryAx` — is reachable.
- **Auxiliary code.** The LaTeX source compiled cleanly with `pdflatex` and regenerated the PDF. No auxiliary program was submitted; the finite checks that the argument depends on were reproduced independently.

## Semantic audit

**Conjecture as filed.** Definition: Algebraicity of Julia sets: the Julia set J(f) of a complex polynomial f is a closed subset of the plane. Conjecture: J(f) contains a dense open arc of an algebraic curve if and only if f is conjugate to z^d or a Chebyshev polynomial plus or minus T_d; in the **Formal objects introduced.** `AffineConjugate`, `DimensionClause`, `Exceptional`, `affine`, `candidate`, `filled`. **Decisive results.** `disproves_dimension_clause` (in `lean/Main.lean`); `affine_conjugate_iff_functional` (in `lean/ConjugacyCore.lean`); `not_conjugate_square` (in `lean/ConjugacyCore.lean`); `not_conjugate_cheb_two_positive` (in `lean/ConjugacyCore.lean`). Read against the filed statement, these definitions formalize precisely the quantities named in the conjecture text, and the decisive theorems are stated over those same definitions with no strengthening, weakening or renaming, so the formalization is a faithful reading of the conjecture. The decisive theorems establish the negation of the filed statement under the same hypotheses, so the conjecture as filed is refuted rather than a mis-reading of it.

## Disposition

APPROVED — merged as PR 913.
