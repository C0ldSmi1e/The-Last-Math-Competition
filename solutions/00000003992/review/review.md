# Solution Review — Conjecture 00000003992 (PR 1006)

**Submission:** idealistichacker — `idealistichacker_submission_20261012031320`  
**Reviewer:** independent competition reviewer  
**Date:** 2026-10-12

## Checklist results

- **Eligibility and scope.** The submission uses the correct personal folder for conjecture 00000003992; the conjecture was open, and the pull request changed no conjecture, README, leaderboard, or metadata file.
- **Report and PDF.** The complete official statement of the conjecture, the LaTeX report, and the submitted PDF were read in full. The LaTeX source was independently recompiled with `pdflatex`, which exited successfully and regenerated the PDF; the rendered report matches the submitted PDF.
- **Lean project.** The submission's Lean project was rebuilt from a clean copy of the frozen sources, keeping its own module names, its own `lakefile`, its pinned Mathlib revision `0df444a360eaa60ab8c11dca51a86af692955474` and its toolchain `v4.33.1`. `lake build` completed successfully: no `sorry`, no `native_decide`, no custom `axiom`/`constant`, no `unsafe`, `opaque`, `extern` or `implemented_by` declaration, and no kernel bypass.
- **Axiom audit.** `#print axioms` was run against every declaration exported by the submission's own modules. The transitive axiom set of each audited theorem is contained in {`Classical.choice`, `Quot.sound`, `propext`}; no other axiom — in particular no `sorryAx` — is reachable.
- **Auxiliary code.** The LaTeX source compiled cleanly with `pdflatex` and regenerated the PDF. The submitted auxiliary code was executed and reported success: `reproduce.py`.

## Semantic audit

**Conjecture as filed.** The resolution width of the Tseitin formula of a connected graph with odd charges equals exactly the number of vertices of the smallest odd-charge subgraph, with no additive constant. **Formal objects introduced.** The triangle graph `triangle` with unit `charge`; the parity CNF `parityCNF` with its semantics `parityAt`; the resolution derivability `DerivesWithin`/`RefutesWithin` and `IsResolutionWidth`; and `oddChargeSubgraph` on actual subgraphs. **Decisive results.** `actual_Tseitin_unsatisfiable`, `actual_resolution_width_two : IsResolutionWidth parityCNF 2`, `no_odd_charge_subgraph_with_two_vertices`, `necessary_width_charge_clause_false : ¬ NecessaryWidthChargeClause`, and the capstone `actual_graph_counterexample`. On the 3-vertex triangle every charge is 1, so every odd-charge subgraph has an odd vertex count and no 2-vertex odd-charge subgraph exists; the smallest odd-charge subgraph therefore has 1 vertex, whereas the true resolution width is 2, so the exact equality of the filed statement fails. Read against the filed statement, the definitions formalize precisely the quantities named in the conjecture text, and the decisive theorems are stated over those same definitions with no strengthening, weakening or renaming, so the formalization is a faithful reading of the conjecture. The decisive theorems establish the negation of the filed statement under the same hypotheses, so the conjecture as filed is refuted rather than a mis-reading of it.

## Disposition

APPROVED — merged as PR 1006.
