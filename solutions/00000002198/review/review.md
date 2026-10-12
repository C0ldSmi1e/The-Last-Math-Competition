# Solution Review — Conjecture 00000002198 (PR 1009)

**Submission:** Galaxy-0 — `Galaxy-0_submission_20261012192310`  
**Reviewer:** independent competition reviewer  
**Date:** 2026-10-12

## Checklist results

- **Eligibility and scope.** The submission uses the correct personal folder for conjecture 00000002198; the conjecture was open, and the pull request changed no conjecture, README, leaderboard, or metadata file.
- **Report and PDF.** The complete official statement of the conjecture, the LaTeX report, and the submitted PDF were read in full. The LaTeX source was independently recompiled with `pdflatex`, which exited successfully and regenerated the PDF; the rendered report matches the submitted PDF.
- **Lean project.** The submission's Lean project was rebuilt from a clean copy of the frozen sources, keeping its own module names, its own `lakefile`, its self-contained core-Lean setup (no Mathlib dependency) and its toolchain `v4.31.0`. `lake build` completed successfully: no `sorry`, no `native_decide`, no custom `axiom`/`constant`, no `unsafe`, `opaque`, `extern` or `implemented_by` declaration, and no kernel bypass.
- **Axiom audit.** `#print axioms` was run against every declaration exported by the submission's own modules. The transitive axiom set of each audited theorem is contained in {`Classical.choice`, `Quot.sound`, `propext`}; no other axiom — in particular no `sorryAx` — is reachable.
- **Auxiliary code.** The LaTeX source compiled cleanly with `pdflatex` and regenerated the PDF. The submitted auxiliary code was executed and reported success: `build_pdf.sh`, `reproduce.py`, `check2198.py`, `verification/independent-check.py`.

## Semantic audit

**Conjecture as filed.** The number of maximal antichains of the weak-order lattice is given by an explicit bijection with Eulerian numbers; the antichain count equals the second-order Eulerian numbers. **Formal objects introduced.** The second-order Eulerian triangle `euler2` with its standard recurrence and the row sum `euler2RowSum`; the weak-order relation `weakLE` on one-line encodings of S₄ with its characterisation `weakLE_iff`; the permutation enumeration `permList` and antichain enumeration `antichains` built on `AntichainEnumeration.enumerate`; and `maximalAntichains` / `maximumAntichains`. **Decisive results.** `weakLE_iff`, `every_permutation_encoded`, `antichain_complete`, `maximal_iff`, `maximum_iff`, the counts `all_antichain_count = 856`, `maximal_antichain_count = 190`, `maximum_antichain_count = 4`, and the capstones `all_counts_not_eulerian` and `all_counts_not_row_sum`, supported by `euler2_exclusions` and `euler2_row_sum_exclusions`, which prove that 4, 190 and 856 occur nowhere in the second-order Eulerian triangle and equal no row sum. The actual maximal-antichain count of the S₄ weak order is 190, so the filed identification with second-order Eulerian numbers fails under either reading. Read against the filed statement, the definitions formalize precisely the quantities named in the conjecture text, and the decisive theorems are stated over those same definitions with no strengthening, weakening or renaming, so the formalization is a faithful reading of the conjecture. The decisive theorems establish the negation of the filed statement under the same hypotheses, so the conjecture as filed is refuted rather than a mis-reading of it.

## Disposition

APPROVED — merged as PR 1009.
