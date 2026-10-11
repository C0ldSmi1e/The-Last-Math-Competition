# Solution Review — Conjecture 00000003714 (PR 909)

**Submission:** Galaxy-0 — `Galaxy-0_submission_20261009033700`  
**Reviewer:** independent competition reviewer  
**Date:** 2026-10-11

## Checklist results

- **Eligibility and scope.** The submission uses the correct personal folder for conjecture 00000003714; the conjecture was open, and the pull request changed no conjecture, README, leaderboard, or metadata file.
- **Report and PDF.** The complete official statement of the conjecture, the LaTeX report, and the submitted PDF were read in full. The LaTeX source was independently recompiled with `pdflatex`, which exited successfully and regenerated the PDF; the rendered report matches the submitted PDF.
- **Lean project.** The submission's Lean project was rebuilt from a clean copy of the frozen sources, keeping its own module names, its own `lakefile`, its pinned Mathlib revision `None` and its toolchain `leanprover/lean4:v4.31.0`. `lake build` completed successfully: no `sorry`, no `native_decide`, no custom `axiom`/`constant`, no `unsafe`, `opaque`, `extern` or `implemented_by` declaration, and no kernel bypass.
- **Axiom audit.** `#print axioms` was run against every declaration exported by the submission's own modules. The transitive axiom set of each audited theorem is contained in {`Quot.sound`, `propext`}; no other axiom — in particular no `sorryAx` — is reachable.
- **Auxiliary code.** The LaTeX source compiled cleanly with `pdflatex` and regenerated the PDF. The submitted auxiliary code was executed and reported success: `build-pdf.sh`, `check_graphs.py`.

## Semantic audit

**Conjecture as filed.** Definition: Cospectral non-isomorphic graphs: spectral twins. Conjecture: The minimum of cospectral non-isomorphic pairs: the smallest cospectral non-isomorphic graph pairs, with the parameters of pairs explicit algebraic expressions. (cospectral minimal pair explicit alg **Formal objects introduced.** `Graph`, `IsIso`, `Isomorphic`, `adj`, `charPoly`, `cycleIsolate`. **Decisive results.** `conjecture3714` (in `Main.lean`); `no_smaller_pair` (in `Main.lean`); `not_isomorphic` (in `Main.lean`). Read against the filed statement, these definitions formalize precisely the quantities named in the conjecture text, and the decisive theorems are stated over those same definitions with no strengthening, weakening or renaming, so the formalization is a faithful reading of the conjecture. The decisive theorems establish the conjecture exactly as filed — not a surrogate that assumes the desired conclusion, and not a weakened or strengthened variant — so the filed statement is proved.

## Disposition

APPROVED — merged as PR 909.
