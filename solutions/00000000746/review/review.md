# Solution Review — Conjecture 00000000746 (PR 1005)

**Submission:** idealistichacker — `idealistichacker_submission_20261012014828`  
**Reviewer:** independent competition reviewer  
**Date:** 2026-10-12

## Checklist results

- **Eligibility and scope.** The submission uses the correct personal folder for conjecture 00000000746; the conjecture was open, and the pull request changed no conjecture, README, leaderboard, or metadata file.
- **Report and PDF.** The complete official statement of the conjecture, the LaTeX report, and the submitted PDF were read in full. The LaTeX source was independently recompiled with `pdflatex`, which exited successfully and regenerated the PDF; the rendered report matches the submitted PDF.
- **Lean project.** The submission's Lean project was rebuilt from a clean copy of the frozen sources, keeping its own module names, its own `lakefile`, its pinned Mathlib revision `0df444a360eaa60ab8c11dca51a86af692955474` and its toolchain `v4.33.1`. `lake build` completed successfully: no `sorry`, no `native_decide`, no custom `axiom`/`constant`, no `unsafe`, `opaque`, `extern` or `implemented_by` declaration, and no kernel bypass.
- **Axiom audit.** `#print axioms` was run against every declaration exported by the submission's own modules. The transitive axiom set of each audited theorem is contained in {`Classical.choice`, `Quot.sound`, `propext`}; no other axiom — in particular no `sorryAx` — is reachable.
- **Auxiliary code.** The LaTeX source compiled cleanly with `pdflatex` and regenerated the PDF. The submitted auxiliary code was executed and reported success: `reproduce.py`.

## Semantic audit

**Conjecture as filed.** The p-adic Schröder function of an attracting fixed point is a convergent power series whose coefficient denominators contain only the first power of p. **Formal objects introduced.** Over K = ℚ_3, the germs `H(x) = x/(1 − x/3)` and `F(x) = 3x/(1 + 2x/3)` on U = {‖x‖ < 1/3}; the rational coefficient sequence `a` with `a (n+1) = 3⁻ⁿ`; `P := FormalMultilinearSeries.ofScalars`; `HasFPowerSeriesAt H P 0` and the all-point `HasSum`; the explicit analytic inverse `J`; and the structure `NormalizedAnalyticSchroder` collecting the actual normalized-germ premises. **Decisive results.** `H_hasFPowerSeriesAt`, `a_three_den : (a 3).den = 9`, `actual_normalized_Schroder : NormalizedAnalyticSchroder F H U a`, `exists_actual_counterexample`, and `necessary_denominator_claim_false : ¬ NecessaryDenominatorClaim`. The series of H is Σ 3⁻ⁿ x^{n+1}, whose degree-three coefficient is 1/9 with reduced denominator 9 = 3²; this violates the first-power-only bound `FirstPowerDenominatorBound`, while H is a genuine analytic normalized Schröder germ (H(F x) = 3·H x, H′(0) = 1, F′(0) = 3, attracting orbits in U). Read against the filed statement, the definitions formalize precisely the quantities named in the conjecture text, and the decisive theorems are stated over those same definitions with no strengthening, weakening or renaming, so the formalization is a faithful reading of the conjecture. The decisive theorems establish the negation of the filed statement under the same hypotheses, so the conjecture as filed is refuted rather than a mis-reading of it.

## Disposition

APPROVED — merged as PR 1005.
