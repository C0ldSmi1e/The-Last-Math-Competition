# Provenance and scope

The author received a clean input directory `/private/tmp/tlmc1568-clean-author-input` containing only the exact bilingual `original.md`, English and Chinese repository rules, Lean toolchain string, pinned stock Lake manifest, and checksums. The author did not inspect the repository's solutions, previous submissions, private selector analyses, other task histories, or online mathematical solutions. All new work was written under `/private/tmp/tlmc1568-proof`.

The parent provisioned copied stock dependencies in `.lake/packages` and authorized their use. The allowed stock Mathlib source was `/private/tmp/tlmc4607-restored-stock/mathlib`; the runtime was `/private/tmp/tlmc310-runtime/lean-4.19.0-darwin_aarch64/bin`. Mathlib source/API searches were confined to that stock source or the copied stock packages.

The author independently found the determinant-side restriction for each nonleaf neighbor and the finite-sum cancellation argument. A child agent independently checked the geometric reasoning, supplied the complete collinear betweenness case analysis, and formalized `Geometry.lean`. The author formalized `Counting.lean`, `Angular.lean`, and `Main.lean`. The child's assessment and precise access record appear in `child-semantic-assessment.md`. No solution strategy from another candidate was supplied or used.

A mathematical checkpoint was sent to the parent before report/PDF production: the exact drawing definition, strict sign lemma with all degeneracies, exclusion of three nonleaf neighbors, and cancellation of leaf counts. All four Lean modules compiled successfully, and the final theorem printed only `propext`, `Classical.choice`, and `Quot.sound` as axioms.

The supplied wording uses the conventional meaning of a straight-edge graph: finite graph, distinct geometric vertices, and nondegenerate straight edges between distinct vertices. The formal graph is simple. Multiple nondegenerate straight edges with the same endpoints are already incompatible with the singleton-intersection hypothesis. The proof deliberately permits collinear vertices, shared crossing points, and nonincident vertices on edges. It imposes no additional geometric position conditions.

The parent handles eligibility and repository state separately. These authoring materials neither assert that the theorem is historically new nor assert that submission eligibility has been checked. The parent also owns final PDF export, full-page visual inspection, independent source/build verification, and any publication.
