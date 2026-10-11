# Solution Review — Conjecture 00000001043 (PR 945)

**Submission:** Galaxy-0 — `Galaxy-0_submission_20261009192303`  
**Reviewer:** independent competition reviewer  
**Date:** 2026-10-11

## Checklist results

- **Eligibility and scope.** The submission uses the correct personal folder for conjecture 00000001043; the conjecture was open, and the pull request changed no conjecture, README, leaderboard, or metadata file.
- **Report and PDF.** The complete official statement of the conjecture, the LaTeX report, and the submitted PDF were read in full. The LaTeX source was independently recompiled with `pdflatex`, which exited successfully and regenerated the PDF; the rendered report matches the submitted PDF.
- **Lean project.** The submission's Lean project was rebuilt from a clean copy of the frozen sources, keeping its own module names, its own `lakefile`, its pinned Mathlib revision `None` and its toolchain `leanprover/lean4:v4.31.0`. `lake build` completed successfully: no `sorry`, no `native_decide`, no custom `axiom`/`constant`, no `unsafe`, `opaque`, `extern` or `implemented_by` declaration, and no kernel bypass.
- **Axiom audit.** `#print axioms` was run against every declaration exported by the submission's own modules. The transitive axiom set of each audited theorem is contained in {`Quot.sound`, `propext`}; no other axiom — in particular no `sorryAx` — is reachable.
- **Auxiliary code.** The LaTeX source compiled cleanly with `pdflatex` and regenerated the PDF. The submitted auxiliary code was executed and reported success: `build_pdf.sh`, `reproduce.py`. The following exceeded the review time budget when rerun and were therefore not independently reproduced: `verify.sh`.

## Semantic audit

**Conjecture as filed.** Definition: The Carlitz rank is the number of AB-expression layers. Conjecture: The permutation rank over prime fields is at most four; and the combination of four is the norm-basis decomposition. (Carlitz rank four norm-basis decomposition) **Formal objects introduced.** `F`, `NotAffine`, `PrimeNat`, `RankAtMost`, `Represents`, `inv`. **Decisive results.** `standard_carlitz_bound_false` (in `lean4/Final.lean`); `affine_not_NotAffine` (in `lean4/Base.lean`); `no_three` (in `lean4/Final.lean`); `no_four` (in `lean4/Final.lean`). Read against the filed statement, these definitions formalize precisely the quantities named in the conjecture text, and the decisive theorems are stated over those same definitions with no strengthening, weakening or renaming, so the formalization is a faithful reading of the conjecture. The decisive theorems establish the negation of the filed statement under the same hypotheses, so the conjecture as filed is refuted rather than a mis-reading of it.

## Disposition

APPROVED — merged as PR 945.
