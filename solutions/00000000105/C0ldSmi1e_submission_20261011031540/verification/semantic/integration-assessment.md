# Independent delta review: closed-convex-boundary integration

## Snapshot and exact delta

Reviewed `/private/tmp/tlmc105-proof/Proof.lean`, currently 222 lines, with SHA-256:

`9a990ec7f184e69033a96aa7305d58034a305def12ed21a3cfb14022462c3bbf`

The dependent custom files retain the previously reviewed hashes:

- `TorusTopology.lean`: `47285ebd3038294d260dcd988fed9cf9b99a19a05a0d7f78c7a7ddf0e9654150`
- `BoundaryBound.lean`: `b35015d5a835d0aa60b710cc5837441c50cd15ea43566def8801fede40b901c2`

I reread the current Proof source and performed an exact byte-content comparison by removing only its new `import BoundaryBound` line 2 and new wrapper lines 153–167. The resulting SHA-256 is `ad9e063589e482167ffc35250872e0454cbdda4a5e5907067a24484502161047`, exactly the previously reviewed core. Thus the only changes to the reviewed core are that import and wrapper.

This is not a final freeze assertion; later changes require comparison and appropriate delta review. No author files were edited.

## Wrapper review and verdict

**Source-level verdict: valid integration; no mathematical or semantic gap found.** The actual new statement is:

> For any closed convex set K in Euclidean 3-space, a homeomorphism from Circle × Circle to frontier K implies False.

It has no boundedness, properness, nonempty-interior, or full-dimensionality assumption.

The proof supplies the extension's previously outstanding hypotheses correctly:

1. **Properness:** If K were the entire space, `e (1,1)` would still be an actual point of its frontier, but `frontier univ` is empty. Lines 159–162 derive that contradiction explicitly.
2. **Compactness of frontier:** The torus has its genuine stock compact-space instance. The stock `Homeomorph.compactSpace` theorem transfers compactness to the frontier subtype via e. Stock `isCompact_iff_compactSpace` converts it to compactness of the actual subset. I inspected those stock theorem declarations; their hypotheses match this use.
3. **Boundedness and obstruction:** Lines 165–166 apply the independently reviewed compact-frontier boundedness theorem to the same K with its proved properness, then apply the previously reviewed bounded-convex-boundary obstruction to the original e.

Consequently the new theorem covers the usual possibly unbounded closed-halfspace definition of a convex polyhedron, because any such polyhedron is a closed convex subset of R³. The proof derives boundedness from the alleged compact toroidal frontier, so there is no circular assumption that a purported unbounded realization was bounded. The whole-space exception to the standalone boundedness lemma is correctly eliminated by the purported realization.

The finite-hull definition and original capstone remain unchanged and narrower in wording. That is harmless: they still provide the required explicit genus-one counterexample, while `no_torus_closed_convex_boundary` separately establishes that enlarging the polyhedron convention to possibly unbounded closed convex sets cannot rescue the claim. The report should identify this stronger theorem accurately.

## Execution/report status

No Lean execution or compiled axiom audit is claimed in this delta review. Those checks remain with the coordinating review process. Full report/README review is deliberately deferred until the author freeze notice, as requested. This delta review adds no source-level correction request.
