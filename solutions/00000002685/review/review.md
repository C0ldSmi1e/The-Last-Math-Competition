# Solution Review — Conjecture 00000002685 (PR 1008)

**Submission:** Galaxy-0 — `Galaxy-0_submission_20261012T191900Z`  
**Reviewer:** independent competition reviewer  
**Date:** 2026-10-12

## Checklist results

- **Eligibility and scope.** The submission uses the correct personal folder for conjecture 00000002685; the conjecture was open, and the pull request changed no conjecture, README, leaderboard, or metadata file.
- **Report and PDF.** The complete official statement of the conjecture, the LaTeX report, and the submitted PDF were read in full. The LaTeX source was independently recompiled with `pdflatex`, which exited successfully and regenerated the PDF; the rendered report matches the submitted PDF.
- **Lean project.** The submission's Lean project was rebuilt from a clean copy of the frozen sources, keeping its own module names, its own `lakefile`, its self-contained core-Lean setup (no Mathlib dependency) and its toolchain `v4.31.0`. `lake build` completed successfully: no `sorry`, no `native_decide`, no custom `axiom`/`constant`, no `unsafe`, `opaque`, `extern` or `implemented_by` declaration, and no kernel bypass.
- **Axiom audit.** `#print axioms` was run against every declaration exported by the submission's own modules. The transitive axiom set of each audited theorem is contained in {`Classical.choice`, `Quot.sound`, `propext`}; no other axiom — in particular no `sorryAx` — is reachable.
- **Auxiliary code.** The LaTeX source compiled cleanly with `pdflatex` and regenerated the PDF. The submitted auxiliary code was executed and reported success: `build_pdf.sh`, `reproduce.sh`.

## Semantic audit

**Conjecture as filed.** The orbit closure of a multidimensional endomorphism semigroup is either the preperiodic point set or Zariski dense, and the criterion is emptiness of the multiplicative zero set of the Jacobian determinants (computably verifiable for at most two maps). **Formal objects introduced.** The polynomial-expression type `Poly` over ℚ with `eval`, formal derivatives `dx`/`dy` and `jacobian`; `zariskiClosure` as the intersection of all polynomial zero loci containing a locus, and `Dense`; the affine endomorphism `F(x,y) = (x+1, y)` with `iterate`, `orbit` and `Preperiodic`; and the multiplicative products `determinantProduct` and `jacobianProduct`. **Decisive results.** `iterate_formula`, `iterate_add`, `iterate_injective_time`, `no_preperiodic`, `closure_on_line`, `not_dense`, `closure_not_preperiodic_set`, `closure_not_contained_preperiodic`, `multiplicative_zero_set_empty`, and the capstone `counterexample`. The map F is a genuine endomorphism of the affine plane given by a single generator; every Jacobian determinant equals 1, so the multiplicative zero set is empty, yet the closure of the orbit of the origin is a proper closed line — neither the (empty) preperiodic set nor the whole plane. Both alternatives of the filed dichotomy and its stated computable criterion therefore fail. Read against the filed statement, the definitions formalize precisely the quantities named in the conjecture text, and the decisive theorems are stated over those same definitions with no strengthening, weakening or renaming, so the formalization is a faithful reading of the conjecture. The decisive theorems establish the negation of the filed statement under the same hypotheses, so the conjecture as filed is refuted rather than a mis-reading of it.

## Disposition

APPROVED — merged as PR 1008.
