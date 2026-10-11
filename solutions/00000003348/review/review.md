# Solution Review — Conjecture 00000003348 (PR 1000)

**Submission:** C0ldSmi1e — `C0ldSmi1e_submission_20261011035640`  
**Reviewer:** independent competition reviewer  
**Date:** 2026-10-11

## Checklist results

- **Eligibility and scope.** The submission uses the correct personal folder for conjecture 00000003348; the conjecture was open, and the pull request changed no conjecture, README, leaderboard, or metadata file.
- **Report and PDF.** The complete official statement of the conjecture, the LaTeX report, and the submitted PDF were read in full. The LaTeX source was independently recompiled with `pdflatex`, which exited successfully and regenerated the PDF; the rendered report matches the submitted PDF.
- **Lean project.** The submission's Lean project was rebuilt from a clean copy of the frozen sources, keeping its own module names, its own `lakefile`, its pinned Mathlib revision `c44e0c8ee63ca166450922a373c7409c5d26b00b` and its toolchain `leanprover/lean4:v4.19.0`. `lake build` completed successfully: no `sorry`, no `native_decide`, no custom `axiom`/`constant`, no `unsafe`, `opaque`, `extern` or `implemented_by` declaration, and no kernel bypass.
- **Axiom audit.** `#print axioms` was run against every declaration exported by the submission's own modules. The transitive axiom set of each audited theorem is contained in {`Classical.choice`, `Quot.sound`, `propext`}; no other axiom — in particular no `sorryAx` — is reachable.
- **Auxiliary code.** The LaTeX source compiled cleanly with `pdflatex` and regenerated the PDF. The following require the author's own prepared build environment and could not be rerun standalone: `verification/tools/test_hardening.py`, `verification/tools/check_audit_graph.py`, `verification/tools/verify.py`.

## Semantic audit

**Conjecture as filed.** Definition: Expansive maps: uniformly expanding dynamics. Conjecture: The embedding of expansive kernels: the Julia set of an expansive map is of Cantor type, with the dimension of the Cantor set the root of the pressure equation. (expansive Cantor pressure dimension root **Formal objects introduced.** `CantorType`, `UniformlyExpandingOn`, `filledJulia`, `julia`, `square`, `squarePolynomial`. **Decisive results.** `not_mem_filledJulia_of_one_lt_norm` (in `Counterexample.lean`); `mem_julia_square_iff` (in `Counterexample.lean`); `julia_square_not_totallyDisconnected` (in `Counterexample.lean`); `julia_square_not_cantorType` (in `Counterexample.lean`). Read against the filed statement, these definitions formalize precisely the quantities named in the conjecture text, and the decisive theorems are stated over those same definitions with no strengthening, weakening or renaming, so the formalization is a faithful reading of the conjecture. The decisive theorems establish the negation of the filed statement under the same hypotheses, so the conjecture as filed is refuted rather than a mis-reading of it.

## Disposition

APPROVED — merged as PR 1000.
