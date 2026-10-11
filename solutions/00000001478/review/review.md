# Solution Review — Conjecture 00000001478 (PR 908)

**Submission:** C0ldSmi1e — `C0ldSmi1e_submission_20261009064956`  
**Reviewer:** independent competition reviewer  
**Date:** 2026-10-11

## Checklist results

- **Eligibility and scope.** The submission uses the correct personal folder for conjecture 00000001478; the conjecture was open, and the pull request changed no conjecture, README, leaderboard, or metadata file.
- **Report and PDF.** The complete official statement of the conjecture, the LaTeX report, and the submitted PDF were read in full. The LaTeX source was independently recompiled with `pdflatex`, which exited successfully and regenerated the PDF; the rendered report matches the submitted PDF.
- **Lean project.** The submission's Lean project was rebuilt from a clean copy of the frozen sources, keeping its own module names, its own `lakefile`, its pinned Mathlib revision `c44e0c8ee63ca166450922a373c7409c5d26b00b` and its toolchain `leanprover/lean4:v4.19.0`. `lake build` completed successfully: no `sorry`, no `native_decide`, no custom `axiom`/`constant`, no `unsafe`, `opaque`, `extern` or `implemented_by` declaration, and no kernel bypass.
- **Axiom audit.** `#print axioms` was run against every declaration exported by the submission's own modules. The transitive axiom set of each audited theorem is contained in {`Classical.choice`, `Quot.sound`, `propext`}; no other axiom — in particular no `sorryAx` — is reachable.
- **Auxiliary code.** The LaTeX source compiled cleanly with `pdflatex` and regenerated the PDF. The submitted auxiliary code was executed and reported success: `test_verify.py`, `verify.py`.

## Semantic audit

**Conjecture as filed.** Definition: The nuclear norm of a tensor is its minimal sum of rank-one tensors. Conjecture: The nuclear-norm unit ball of tensors in C^{2×2×2} is the image, under a polynomial map, of an explicit spectrahedral cone (a generalized inequality based on 4×4 symmetric matrice **Formal objects introduced.** `FactorTriple`, `IsCone`, `Tensor`, `TensorPolynomialMap`, `TensorPolynomialMap.eval`, `Vector`. **Decisive results.** `conjecture00000001478_false` (in `lean/Solution.lean`); `no_polynomial_cone_image_between` (in `lean/Solution.lean`); `nuclearBall_not_polynomial_image_of_cone` (in `lean/Solution.lean`); `minimumNuclearBall_not_polynomial_image_of_cone` (in `lean/Solution.lean`). Read against the filed statement, these definitions formalize precisely the quantities named in the conjecture text, and the decisive theorems are stated over those same definitions with no strengthening, weakening or renaming, so the formalization is a faithful reading of the conjecture. The decisive theorems establish the negation of the filed statement under the same hypotheses, so the conjecture as filed is refuted rather than a mis-reading of it.

## Disposition

APPROVED — merged as PR 908.
