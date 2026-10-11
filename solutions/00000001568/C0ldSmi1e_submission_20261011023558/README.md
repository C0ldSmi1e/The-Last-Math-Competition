# Geometric thrackle bound — conjecture 00000001568

This project proves that every finite geometric thrackle has at most as many edges as vertices.

The formal model is a finite undirected simple graph, an injective position map into the real plane, and exactly one intersection point for every pair of distinct unordered edges, drawn as closed straight segments. It does not require general position, proper crossings, or avoidance of nonincident vertices by edges. Isolated vertices and empty/disconnected graphs are included.

The final result is `GeometricThrackle.geometric_thrackle_bound` in `Main.lean`.

## Files

- `report.tex`: complete mathematical argument and exact formalization correspondence.
- `report.pdf`: exported report, generated and visually verified by the parent workflow before submission.
- `Geometry.lean`: strict determinant sign lemma, including collinearity and endpoint cases.
- `Angular.lean`: no vertex has three nonleaf neighbors.
- `Counting.lean`: degree/leaf finite-sum counting argument.
- `Main.lean`: drawing definition and the complete original bound.
- `verify.sh`, `verify.py`: reproducible build and source/dependency/axiom checks.
- `source/`: unchanged bilingual original statement, both repository rules, original stock package manifest, and original input checksums.
- `PROVENANCE.md`, `child-semantic-assessment.md`: derivation and source-access record.

## Reproduce

Install the toolchain specified by `lean-toolchain` (Lean 4.19.0). The project manifest pins Mathlib at `c44e0c8ee63ca166450922a373c7409c5d26b00b` and all of its stock dependencies. With the dependencies available, run:

```sh
./verify.sh
```

An alternate Lake executable can be selected with `LAKE_BIN=/absolute/path/to/lake ./verify.sh`. The script uses Python 3 for manifest and source checks. It removes only the four authored modules' generated `.olean` files to force their rebuild. Dependency packages are not modified. If dependencies are not yet cached, provision the pinned packages and Mathlib's ordinary cache before running the script.

The expected theorem axiom list is exactly `propext`, `Classical.choice`, and `Quot.sound`. The proof uses no admitted goals, extra axioms, `native_decide`, or unsafe definitions. The auxiliary verification scripts validate the build; they are not premises of the mathematical proof.

The LaTeX report is a standalone document and can be exported by a TeX engine supporting the listed standard packages, for example `tectonic report.tex`. No numerical experiment or external mathematical result beyond stock Mathlib is needed.

Eligibility checks, final PDF export and visual review, and any repository publication are owned by the parent workflow. The author's Lean proof and report do not make a historical novelty claim.
