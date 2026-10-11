# Solution Review — Conjecture 00000001569 (PR 907)

**Submission:** C0ldSmi1e — `C0ldSmi1e_submission_20261009054921`  
**Reviewer:** independent competition reviewer  
**Date:** 2026-10-11

## Checklist results

- **Eligibility and scope.** The submission uses the correct personal folder for conjecture 00000001569; the conjecture was open, and the pull request changed no conjecture, README, leaderboard, or metadata file.
- **Report and PDF.** The complete official statement of the conjecture, the LaTeX report, and the submitted PDF were read in full. The LaTeX source was independently recompiled with `pdflatex`, which exited successfully and regenerated the PDF; the rendered report matches the submitted PDF.
- **Lean project.** The submission's Lean project was rebuilt from a clean copy of the frozen sources, keeping its own module names, its own `lakefile`, its pinned Mathlib revision `c44e0c8ee63ca166450922a373c7409c5d26b00b` and its toolchain `leanprover/lean4:v4.19.0`. `lake build` completed successfully: no `sorry`, no `native_decide`, no custom `axiom`/`constant`, no `unsafe`, `opaque`, `extern` or `implemented_by` declaration, and no kernel bypass.
- **Axiom audit.** `#print axioms` was run against every declaration exported by the submission's own modules. The transitive axiom set of each audited theorem is contained in {`Classical.choice`, `Quot.sound`, `propext`}; no other axiom — in particular no `sorryAx` — is reachable.
- **Auxiliary code.** The LaTeX source compiled cleanly with `pdflatex` and regenerated the PDF. The submitted auxiliary code was executed and reported success: `test_verify.py`, `verify.py`.

## Semantic audit

**Conjecture as filed.** Definition: The angle set of a point set is the set of all angles it determines. Conjecture: An n-point set determines at least n² − O(n) distinct angles; and the lower bound is attained by the equidistribution of arguments of lattice families. (angle set n-squared lower **Formal objects introduced.** `Plane`, `UniformQuadraticLowerBound`, `angleSet`, `axisPoint`, `configuration`. **Decisive results.** `original_conjunction_false` (in `lean/Solution.lean`); `mem_angleSet_iff` (in `lean/Solution.lean`); `arbitrarily_large_counterexamples` (in `lean/Solution.lean`); `not_uniformQuadraticLowerBound` (in `lean/Solution.lean`). Read against the filed statement, these definitions formalize precisely the quantities named in the conjecture text, and the decisive theorems are stated over those same definitions with no strengthening, weakening or renaming, so the formalization is a faithful reading of the conjecture. The decisive theorems establish the negation of the filed statement under the same hypotheses, so the conjecture as filed is refuted rather than a mis-reading of it.

## Disposition

APPROVED — merged as PR 907.
