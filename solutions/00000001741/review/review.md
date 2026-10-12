# Solution Review — Conjecture 00000001741 (PR 1012)

**Submission:** C0ldSmi1e — `C0ldSmi1e_submission_20261012213418`  
**Reviewer:** independent competition reviewer  
**Date:** 2026-10-12

## Checklist results

- **Eligibility and scope.** The submission uses the correct personal folder for conjecture 00000001741; the conjecture was open, and the pull request changed no conjecture, README, leaderboard, or metadata file.
- **Report and PDF.** The complete official statement of the conjecture, the LaTeX report, and the submitted PDF were read in full. The LaTeX source was independently recompiled with `pdflatex`, which exited successfully and regenerated the PDF; the rendered report matches the submitted PDF.
- **Lean project.** The submission's Lean project was rebuilt from a clean copy of the frozen sources, keeping its own module names, its own `lakefile`, its pinned Mathlib revision `c44e0c8ee63ca166450922a373c7409c5d26b00b` and its toolchain `v4.19.0`. `lake build` completed successfully: no `sorry`, no `native_decide`, no custom `axiom`/`constant`, no `unsafe`, `opaque`, `extern` or `implemented_by` declaration, and no kernel bypass.
- **Axiom audit.** `#print axioms` was run against every declaration exported by the submission's own modules. The transitive axiom set of each audited theorem is contained in {`Classical.choice`, `Quot.sound`, `propext`}; no other axiom — in particular no `sorryAx` — is reachable.
- **Auxiliary code.** The LaTeX source compiled cleanly with `pdflatex` and regenerated the PDF. The submitted auxiliary code was executed and reported success: `lean/verify.py`, `verification/tools/test_hardening.py`, `verification/tools/check_audit_graph.py`. The offline-review driver `verification/tools/verify.py` passed its preparation step, but its full run needs the author's prepared stock import cache (it stops on a missing generated ProofWidgets bundle); the same properties were independently reproduced by the clean build and axiom audit recorded above.

## Semantic audit

**Conjecture as filed.** Hall's reverse conjecture: there exist infinitely many pairs (x, y) of positive integers with 0 < |x³ − y²| < √x·(log x)^{1/4}, and the logarithmic correction is optimal (the exponent 1/4 cannot be increased). **Formal objects introduced.** The cube-square gap `gap x y = |x³ − y²|` over ℝ; the logarithmic upper bound `upperBound a x = √x·(log x)^a`; `admissible a p` (positive coordinates with 0 < gap p < upperBound a p.1); `infinitelyMany a` (the admissible set is infinite); `cannotIncrease` (∀ b, 1/4 < b → ¬ infinitelyMany b); and `conjecture` as their conjunction. **Decisive results.** `finite_fiber` and `finite_below` (only finitely many admissible pairs below a fixed cutoff), `infinite_tail`, `upperBound_mono` (the bound is monotone in the exponent once log x ≥ 1), `infinitelyMany_mono` (infinitude at exponent a implies infinitude at every larger exponent b), `quarter_infinitude_refutes_optimality`, and the capstone `conjecture_false : ¬ conjecture`. The two clauses of the filed statement are mutually inconsistent: if infinitely many pairs lie below the 1/4-exponent bound, those same pairs also lie below the bound at exponent 1 > 1/4, so the exponent can be increased and the optimality clause fails. The refutation is purely logical and assumes neither Hall's conjecture nor the isolated infinitude clause. Read against the filed statement, the definitions formalize precisely the quantities named in the conjecture text, and the decisive theorems are stated over those same definitions with no strengthening, weakening or renaming, so the formalization is a faithful reading of the conjecture. The decisive theorems establish the negation of the filed statement under the same hypotheses, so the conjecture as filed is refuted rather than a mis-reading of it.

## Disposition

APPROVED — merged as PR 1012.
