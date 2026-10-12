# Solution Review — Conjecture 00000003996 (PR 1007)

**Submission:** idealistichacker — `idealistichacker_submission_20261012073725`  
**Reviewer:** independent competition reviewer  
**Date:** 2026-10-12

## Checklist results

- **Eligibility and scope.** The submission uses the correct personal folder for conjecture 00000003996; the conjecture was open, and the pull request changed no conjecture, README, leaderboard, or metadata file.
- **Report and PDF.** The complete official statement of the conjecture, the LaTeX report, and the submitted PDF were read in full. The LaTeX source was independently recompiled with `pdflatex`, which exited successfully and regenerated the PDF; the rendered report matches the submitted PDF.
- **Lean project.** The submission's Lean project was rebuilt from a clean copy of the frozen sources, keeping its own module names, its own `lakefile`, its pinned Mathlib revision `0df444a360eaa60ab8c11dca51a86af692955474` and its toolchain `v4.33.1`. `lake build` completed successfully: no `sorry`, no `native_decide`, no custom `axiom`/`constant`, no `unsafe`, `opaque`, `extern` or `implemented_by` declaration, and no kernel bypass.
- **Axiom audit.** `#print axioms` was run against every declaration exported by the submission's own modules. The transitive axiom set of each audited theorem is contained in {`Classical.choice`, `Quot.sound`, `propext`}; no other axiom — in particular no `sorryAx` — is reachable.
- **Auxiliary code.** The LaTeX source compiled cleanly with `pdflatex` and regenerated the PDF. The submitted auxiliary code was executed and reported success: `reproduce.py`.

## Semantic audit

**Conjecture as filed.** The resolution-length lower bound of the Ramsey principle is 2^{Ω(k)}, and choosing the diagonal parameter n = k² makes the exponent constants of the upper and lower bounds match. **Formal objects introduced.** The Ramsey CNF `ramseyCNF` (forbidding each all-red and all-blue k-subset) with its semantics; the resolution derivability `Derives` and the satisfiability-to-no-refutation bridge `satisfiable_excludes_refutation`; the explicit blow-up family `Family.Words`/`Family.red` built from the 5-cycle; and `EventualFiniteRefutations`. **Decisive results.** `Family.beyond_every_threshold`, `CNF.cliqueFree_implies_satisfiable`, `beyond_every_threshold_no_refutation`, `necessary_finite_upper_bound_false : ¬ EventualFiniteRefutations`, and the capstone `actual_diagonal_counterexamples`. The construction yields, for every threshold K, some k ≥ K and a graph on k² vertices with no red or blue k-clique, so the Ramsey CNF on n = k² vertices is satisfiable and admits no resolution refutation at all — the claimed matching finite upper bound cannot hold. Read against the filed statement, the definitions formalize precisely the quantities named in the conjecture text, and the decisive theorems are stated over those same definitions with no strengthening, weakening or renaming, so the formalization is a faithful reading of the conjecture. The decisive theorems establish the negation of the filed statement under the same hypotheses, so the conjecture as filed is refuted rather than a mis-reading of it.

## Disposition

APPROVED — merged as PR 1007.
