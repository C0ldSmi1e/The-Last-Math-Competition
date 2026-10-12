# Solution Review — Conjecture 00000002346 (PR 1003)

**Submission:** lizaixi01 — `lizaixi01_submission_20261011231205`  
**Reviewer:** independent competition reviewer  
**Date:** 2026-10-12

## Checklist results

- **Eligibility and scope.** The submission uses the correct personal folder for conjecture 00000002346; the conjecture was open, and the pull request changed no conjecture, README, leaderboard, or metadata file.
- **Report and PDF.** The complete official statement of the conjecture, the LaTeX report, and the submitted PDF were read in full. The LaTeX source was independently recompiled with `pdflatex`, which exited successfully and regenerated the PDF; the rendered report matches the submitted PDF.
- **Lean project.** The submission's Lean project was rebuilt from a clean copy of the frozen sources, keeping its own module names, its own `lakefile`, its pinned Mathlib revision `db584cd6d46c92f209a44c0f1c829460d327499d` and its toolchain `v4.33.0`. `lake build` completed successfully: no `sorry`, no `native_decide`, no custom `axiom`/`constant`, no `unsafe`, `opaque`, `extern` or `implemented_by` declaration, and no kernel bypass.
- **Axiom audit.** `#print axioms` was run against every declaration exported by the submission's own modules. The transitive axiom set of each audited theorem is contained in {`Classical.choice`, `Quot.sound`, `propext`}; no other axiom — in particular no `sorryAx` — is reachable.
- **Auxiliary code.** The LaTeX source compiled cleanly with `pdflatex` and regenerated the PDF. No auxiliary program was submitted; the finite checks that the argument depends on were reproduced independently.

## Semantic audit

**Conjecture as filed.** The minimal order for exactness of moment relaxations is 2d (d the maximal degree of the defining polynomials), and the order is the explicit linear function d·dim_R(X) of the real dimension. **Formal objects introduced.** `constraint` (the defining polynomial 1 − X²) and `originalFeasible` (its nonnegativity set); the order-r `momentMatrix` and `localizingMatrix` with `hierarchyFeasible`; `relaxedObjective`; and `exactAt r`, the equality of the optimal bounds for every objective admissible at order r. **Decisive results.** `order_one_exact : exactAt 1`, `least_exact_order : IsLeast {r | exactAt r} 1`, and `refutes_minimal_order_formula : ¬ minimalOrderFormula`, where `minimalOrderFormula` is `IsLeast {r | exactAt r} (2 * constraint.natDegree)`. On the interval 1 − X² ≥ 0 the defining polynomial has degree 2, so the filed formula predicts minimal exact order 2d = 4; the submission proves the true minimal order is 1, with an explicit atomic representation and an attained minimizer for every quadratic objective. Read against the filed statement, the definitions formalize precisely the quantities named in the conjecture text, and the decisive theorems are stated over those same definitions with no strengthening, weakening or renaming, so the formalization is a faithful reading of the conjecture. The decisive theorems establish the negation of the filed statement under the same hypotheses, so the conjecture as filed is refuted rather than a mis-reading of it.

## Disposition

APPROVED — merged as PR 1003.
