# Solution Review — Conjecture 00000000302 (PR 939)

**Submission:** C0ldSmi1e — `C0ldSmi1e_submission_20261010000034`  
**Reviewer:** independent competition reviewer  
**Date:** 2026-10-11

## Checklist results

- **Eligibility and scope.** The submission uses the correct personal folder for conjecture 00000000302; the conjecture was open, and the pull request changed no conjecture, README, leaderboard, or metadata file.
- **Report and PDF.** The complete official statement of the conjecture, the LaTeX report, and the submitted PDF were read in full. The LaTeX source was independently recompiled with `pdflatex`, which exited successfully and regenerated the PDF; the rendered report matches the submitted PDF.
- **Lean project.** The submission's Lean project was rebuilt from a clean copy of the frozen sources, keeping its own module names, its own `lakefile`, its pinned Mathlib revision `c44e0c8ee63ca166450922a373c7409c5d26b00b` and its toolchain `leanprover/lean4:v4.19.0`. `lake build` completed successfully: no `sorry`, no `native_decide`, no custom `axiom`/`constant`, no `unsafe`, `opaque`, `extern` or `implemented_by` declaration, and no kernel bypass.
- **Axiom audit.** `#print axioms` was run against every declaration exported by the submission's own modules. The transitive axiom set of each audited theorem is contained in {`Classical.choice`, `Quot.sound`, `propext`}; no other axiom — in particular no `sorryAx` — is reachable.
- **Auxiliary code.** The LaTeX source compiled cleanly with `pdflatex` and regenerated the PDF. The submitted auxiliary code was executed and reported success: `lean/verify.py`.

## Semantic audit

**Conjecture as filed.** Definition: II_α = {ξ : ∃c > 0, |ξ − p/q| > c/q^{2+α}} (the exponent-badly-approximable set). Conjecture: dim_H(II_{1/3} ∩ II_{1/2}) = dim_H(II_{1/2}). **Formal objects introduced.** `II`. **Decisive results.** `conjecture` (in `lean/Conjecture302.lean`); `mem_II_of_not_liouvilleWith` (in `lean/Conjecture302.lean`). Read against the filed statement, these definitions formalize precisely the quantities named in the conjecture text, and the decisive theorems are stated over those same definitions with no strengthening, weakening or renaming, so the formalization is a faithful reading of the conjecture. The decisive theorems establish the conjecture exactly as filed — not a surrogate that assumes the desired conclusion, and not a weakened or strengthened variant — so the filed statement is proved.

## Disposition

APPROVED — merged as PR 939.
