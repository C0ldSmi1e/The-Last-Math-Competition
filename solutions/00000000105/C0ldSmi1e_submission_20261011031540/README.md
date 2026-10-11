# Conjecture 00000000105: genus-one counterexample

The standard torus cannot be homeomorphic to the boundary of any closed convex subset of real three-space. The result covers unbounded closed convex sets as well. A complementary theorem covers all bounded convex sets even without closedness. This includes every convex polyhedron, with or without distinct prime edge lengths or a vertex-count bound. Empty-interior convex sets are handled too; full dimensionality is not assumed.

The proof uses the genuine topological spaces and geometric boundaries. It constructs the circle exponential covering, proves that a circle cannot retract from a contractible space, and uses stereographic projection to distinguish the torus from the sphere. Mathlib's established gauge-rescaling homeomorphism connects a bounded convex body's actual frontier to the sphere. Finite convex-hull compactness is also proved by stock Mathlib and used explicitly.

The final definition of genus one is the standard topological model: a space homeomorphic to `Circle × Circle`. The torus's compactness, Hausdorffness, second countability, path connectedness, real-analytic product manifold structure, and chart dimension two are separately checked. The report explains the precise surface-realization interpretation and the logical reason the prime-edge and vertex-count restrictions are irrelevant to this disproof.

## Files

- `report.tex`: complete mathematical report; the matching `report.pdf` is generated and visually checked separately.
- `Proof.lean`: covering and retraction obstructions, convex-boundary theorem, surface facts, and final counterexample.
- `TorusTopology.lean`: explicit stereographic retraction construction from a hypothetical torus-to-sphere homeomorphism.
- `BoundaryBound.lean`: a proper closed convex set in real dimension greater than one with bounded frontier is bounded, eliminating the unbounded-polyhedron convention issue.
- `AxiomAudit.lean`: transitive axiom checks for the principal theorems.
- `verify.py`: reproducible version, dependency-pin/source, input-hash, Lean build, and axiom checks.
- `lean-toolchain`, `lakefile.lean`, `lake-manifest.json`: Lean 4.19.0 and Mathlib v4.19.0 project configuration.
- `source/`: unchanged original bilingual conjecture, both rules documents, and input hashes.
- `logs/`: actual verification outputs.
- `PROVENANCE.json`: input, stock-library, author-independence, and interpretation provenance.

## Verification

For a fresh checkout, install Lean through a standard toolchain manager such as Elan, then run these commands from this directory. The included `lean-toolchain` selects Lean 4.19.0, and the existing `lake-manifest.json` pins dependency revisions:

```text
lake build
python3 verify.py
```

The first `lake build` materializes the pinned dependency repositories and builds the project. Optionally run `lake exe cache get` before that build to fetch the matching precompiled Mathlib cache. Both setup routes may need network access; neither requires any author-specific `/private/tmp` directory. Do not regenerate or update the dependency manifest to use newer revisions.

With the pinned dependencies already available in `.lake/packages`, an explicit-runtime check is:

```text
python3 verify.py --lake /path/to/lean-4.19.0/bin/lake
```

Alternatively put the pinned Lake on `PATH` and run `python3 verify.py`.

The supplied dependency revisions match the original manifest. Missing stock module objects can be built locally by Lake. No dependency source is modified by this project. Build warnings are failures, and audit warnings are errors. The verifier records the actual Lean build and `#print axioms` outputs; only `propext`, `Classical.choice`, and `Quot.sound` are permitted. These axiom checks supplement Lean source compilation and are not described as an independent kernel implementation.

## Principal declarations

All are in namespace `TLMC105`:

- `no_torus_closed_convex_boundary`
- `no_torus_convex_boundary`
- `no_torus_polytope_boundary`
- `genus_one_not_convex_polyhedral`
- `torus_closed_surface_properties`
- `torus_chart_dimension`
- `conjecture_00000000105_counterexample`

The mathematical result is a complete disproof under the ordinary convex-polyhedral-boundary interpretation of surface realization, including the broader convention admitting unbounded closed convex polyhedra. The conjecture's asymptotic claim at genus zero is never used. The general closed-convex theorem treats arbitrary intersections of closed halfspaces directly, without equating them with finite convex hulls.
