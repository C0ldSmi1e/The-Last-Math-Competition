# Solution Review — Conjecture 00000001568 (PR 998)

**Submission:** C0ldSmi1e — `C0ldSmi1e_submission_20261011023558`  
**Reviewer:** independent competition reviewer  
**Date:** 2026-10-11

## Checklist results

- **Eligibility and scope.** The submission uses the correct personal folder for conjecture 00000001568; the conjecture was open, and the pull request changed no conjecture, README, leaderboard, or metadata file.
- **Report and PDF.** The complete official statement of the conjecture, the LaTeX report, and the submitted PDF were read in full. The LaTeX source was independently recompiled with `pdflatex`, which exited successfully and regenerated the PDF; the rendered report matches the submitted PDF.
- **Lean project.** The submission's Lean project was rebuilt from a clean copy of the frozen sources, keeping its own module names, its own `lakefile`, its pinned Mathlib revision `c44e0c8ee63ca166450922a373c7409c5d26b00b` and its toolchain `leanprover/lean4:v4.19.0`. `lake build` completed successfully: no `sorry`, no `native_decide`, no custom `axiom`/`constant`, no `unsafe`, `opaque`, `extern` or `implemented_by` declaration, and no kernel bypass.
- **Axiom audit.** `#print axioms` was run against every declaration exported by the submission's own modules. The transitive axiom set of each audited theorem is contained in {`Classical.choice`, `Quot.sound`, `propext`}; no other axiom — in particular no `sorryAx` — is reachable.
- **Auxiliary code.** The LaTeX source compiled cleanly with `pdflatex` and regenerated the PDF. The submitted auxiliary code was executed and reported success: `verify.py`. The following exceeded the review time budget when rerun and were therefore not independently reproduced: `verify.sh`. The following require the author's own prepared build environment and could not be rerun standalone: `audit/verify.py`.

## Semantic audit

**Conjecture as filed.** Definition: A geometric thrackle is a straight-edge graph in the plane in which every two edges intersect exactly once. Conjecture: The maximum number of edges of a geometric thrackle is at most the number of vertices (the geometric version of Conway's thrackle conjecture **Formal objects introduced.** `Drawing`, `Point`, `Seg`, `det`. **Decisive results.** the results listed in the sources. Read against the filed statement, these definitions formalize precisely the quantities named in the conjecture text, and the decisive theorems are stated over those same definitions with no strengthening, weakening or renaming, so the formalization is a faithful reading of the conjecture. The decisive theorems establish the conjecture exactly as filed — not a surrogate that assumes the desired conclusion, and not a weakened or strengthened variant — so the filed statement is proved.

## Disposition

APPROVED — merged as PR 998.
