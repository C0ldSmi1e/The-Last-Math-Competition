# Conjecture 00000002346: disproof package

The standard normalized univariate moment relaxation for the real interval defined by 1-X² ≥ 0 is exact at matrix order one for every quadratic objective, with explicit probability representations and attained minimizers. The defining polynomial has degree two. This contradicts the asserted universal minimum 2d=4 and therefore refutes the original conjunction. The real-dimension formula standing alone is not independently adjudicated.

The original bilingual statement is unchanged in original.md. Read the complete three-page report.pdf or its source report.tex; project/Moment.lean contains every mathematical definition and proof. theorem-contracts.json lists all 13 audited declaration types.

## Reproduction

Use the pinned Lean 4.33.0 toolchain and Mathlib revision in project/lakefile.lean and project/lake-manifest.json. From project, run `lake build`; then the pinned official `leanchecker --fresh --verbose Moment` can replay all declarations in the module and its imports. The mathematical Lean source and PDF are byte-identical to the independently reviewed, mechanically verified frozen package. Publication rehashes existing evidence and does not claim a new compilation.

AI assistance was used. A separate original-first reviewer checked the complete source, all three PDF pages and correspondence to both clauses of the original. Local validation, a PR submission, organizer acceptance and first-solve status are distinct. No mathematical novelty or organizer acceptance is claimed.
