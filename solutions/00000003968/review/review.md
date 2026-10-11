# Solution Review — Conjecture 00000003968 (PR 981)

**Submission:** Jackmeson1 — `Jackmeson1_submission_20261010152135`  
**Reviewer:** independent competition reviewer  
**Date:** 2026-10-11

## Checklist results

- **Eligibility and scope.** The submission uses the correct personal folder for conjecture 00000003968; the conjecture was open, and the pull request changed no conjecture, README, leaderboard, or metadata file.
- **Report and PDF.** The complete official statement of the conjecture, the LaTeX report, and the submitted PDF were read in full. The LaTeX source was independently recompiled with `pdflatex`, which exited successfully and regenerated the PDF; the rendered report matches the submitted PDF.
- **Lean project.** The submission's Lean project was rebuilt from a clean copy of the frozen sources, keeping its own module names, its own `lakefile`, its pinned Mathlib revision `0df444a360eaa60ab8c11dca51a86af692955474` and its toolchain `leanprover/lean4:v4.33.1`. `lake build` completed successfully: no `sorry`, no `native_decide`, no custom `axiom`/`constant`, no `unsafe`, `opaque`, `extern` or `implemented_by` declaration, and no kernel bypass.
- **Axiom audit.** `#print axioms` was run against every declaration exported by the submission's own modules. The transitive axiom set of each audited theorem is contained in {`Classical.choice`, `Quot.sound`, `propext`}; no other axiom — in particular no `sorryAx` — is reachable.
- **Auxiliary code.** The LaTeX source compiled cleanly with `pdflatex` and regenerated the PDF. No auxiliary program was submitted; the finite checks that the argument depends on were reproduced independently.

## Semantic audit

**Conjecture as filed.** Definition: A graceful labeling of a caterpillar tree is a bijective labeling whose edge differences are exactly 1 through n-1. Conjecture: The generating function of the number of graceful labelings of n-vertex caterpillar trees is a rational function, with denominator g **Formal objects introduced.** `CatTree`, `Claim`, `Conjecture`, `IsCaterpillar`, `IsGraceful`, `Rational`. **Decisive results.** `main` (in `lean/Conjecture3968/Basic.lean`); `not_rational_of_fact` (in `lean/Conjecture3968/Basic.lean`). Read against the filed statement, these definitions formalize precisely the quantities named in the conjecture text, and the decisive theorems are stated over those same definitions with no strengthening, weakening or renaming, so the formalization is a faithful reading of the conjecture. The decisive theorems establish the negation of the filed statement under the same hypotheses, so the conjecture as filed is refuted rather than a mis-reading of it.

## Disposition

APPROVED — merged as PR 981.
