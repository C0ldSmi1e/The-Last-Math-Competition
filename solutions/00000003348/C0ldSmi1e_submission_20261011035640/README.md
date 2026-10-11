# Conjecture 00000003348: an expanding Julia circle

For the standard complex-polynomial interpretation, the conjecture is false: the polynomial z² expands uniformly on its genuine Julia set, the unit circle, which is connected and is not homeomorphic to Cantor space. This refutes the necessary Cantor conclusion; it makes no claim that the separate dimension/pressure formula is false.

Read `report.pdf` or `report.tex`, then `SOURCE-MAPPING.md`. The exact bilingual conjecture is in `original.md`. The report explicitly discloses the polynomial, Julia-boundary and Julia-locus expansion conventions left unspecified by the source.

## Reproduce the formal proof

Use Lean 4.19.0 as specified by `lean-toolchain`. From this submission directory:

```sh
lake exe cache get
lake build
lake env lean -DwarningAsError=true Counterexample.lean
lake env lean -DwarningAsError=true Checks.lean
```

The project builds both mathematical modules with warnings treated as errors. The lock file pins Mathlib and all transitive Git dependencies; do not update it to a newer library version when reproducing this submission. Cache retrieval requires network access. `Checks.lean` includes 15 named axiom inspections as well as semantic boundary checks. The final conjunction theorem is `ExpandingJuliaCounterexample.not_every_expanding_polynomial_satisfies_conjunction`.

## Verification and trust boundary

`VERIFICATION.md` records the separately prepared build, exact-source replay, full dependency-policy inspection, runtime/dependency fingerprints, regression controls and independent AI semantic review. Its commands reproduce the stronger engineering checks. Library caches are identified and reused; no full Mathlib rebuild or compiler bootstrap is claimed. The dependency-policy inspector is not an independent Lean kernel. Local validation is separate from hosted checks and maintainer acceptance.

There is no numerical auxiliary computation required by the mathematical argument. Every submitted executable verification tool is accompanied by its source and test evidence. The complete standalone LaTeX report uses ordinary LaTeX packages; the matching PDF is rendered and visually reviewed. OpenAI Codex assisted authoring and review. The classical example is not claimed as a new discovery.
