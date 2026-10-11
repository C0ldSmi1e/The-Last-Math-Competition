# Independent source review: conjecture 00000000105

## Scope, evidence, and verdict

I read every line of `/private/tmp/tlmc105-proof/Proof.lean` (206 lines) and `/private/tmp/tlmc105-proof/TorusTopology.lean` (40 lines), against the exact English/Chinese conjecture and rules previously inspected. I also inspected the relevant definitions and theorem implementations in the authorized stock mathlib tree at `/private/tmp/tlmc4607-restored-stock/mathlib`. I did not modify the author files, inspect other candidates, or use external mathematical solutions. The author's report has not yet been reviewed.

**Source-level verdict: no substantive mathematical gap or semantic evasion found.** The files give a genuine geometric/topological obstruction sufficient to disprove the ordinary reading of the conjecture. The earlier concern about upgrading a local homeomorphism to a covering is discharged by an explicit all-sheet trivialization. The earlier local-path-connectedness concern does not apply to the implemented homotopy-lifting argument.

This is **not** a compilation-verification verdict. I executed file/hash and lexical source checks, but did not execute Lean or audit compiled theorem axioms. Clean compilation, theorem axiom/dependency checks, and full LaTeX/PDF review remain necessary for an unconditional competition-rules acceptance.

## Exact reviewed sources

| File | SHA-256 |
| --- | --- |
| `Proof.lean` | `ad9e063589e482167ffc35250872e0454cbdda4a5e5907067a24484502161047` |
| `TorusTopology.lean` | `47285ebd3038294d260dcd988fed9cf9b99a19a05a0d7f78c7a7ddf0e9654150` |

The entire custom import chain consists of these two files; their remaining imports name stock mathlib modules. A lexical scan of both files found no `sorry`, `admit`, `axiom`, `unsafe`, `native_decide`, `implemented_by`, `extern`, `opaque`, `set_option`, `run_tac`, `elab`, or `eval`. This scan is supplementary evidence, not a substitute for the compiled dependency/axiom audit.

## Covering construction and circle obstruction

**Genuine discrete kernel (`Proof.lean:13–21`).** `ExpKernel` is the actual subtype of real numbers satisfying `Circle.exp t = 1`, with the inherited topology. Local injectivity of the stock exponential local homeomorphism restricts to local injectivity of the constant map on this subtype. The stock theorem `discreteTopology_iff_locallyInjective` then proves the existing topology is discrete. The code does not replace the topology or assume kernel discreteness.

**All-sheet trivialization (`Proof.lean:23–82`).** Given a genuine local chart e whose forward map is exponential, q uses the chart inverse on e.target and an argument value elsewhere. The proof requires q continuous only on e.target, where it is the chart inverse; its possible discontinuities outside this target are harmless. Its global right-inverse identity is established in both branches.

The trivialization sends t to `(exp t, t − q(exp t))`, and its inverse sends `(z,k)` to `q(z)+k`. The kernel equation, both inverse identities, source/target conditions, and both continuity statements are explicitly proved. Critically, the source is the **entire** exponential preimage of e.target and the fiber is the **entire** actual kernel, so this genuinely covers all sheets. Choosing a chart at `arg z` puts each z in some base set. `IsEvenlyCovered.to_isEvenlyCovered_preimage` is a stock change-of-fiber construction, not an assumption of the required covering property. Inspection of the stock `IsLocalHomeomorph` definition also confirms that the supplied equality between its partial-homeomorphism forward function and exponential is genuine.

**No section (`Proof.lean:84–94`).** If f were a continuous section, the maps `t ↦ f(exp t)` and `t ↦ t+f(1)` would be two continuous lifts of exponential on the connected real line and agree at zero. Stock covering-map lift uniqueness makes them equal. At `2π`, periodicity gives `f(1)=2π+f(1)`, contradicting π>0. The argument is not circular and leaves no unexplained degree, fundamental-group, or Euler-characteristic assumption.

**No circle retract (`Proof.lean:96–117`).** A genuine contraction H of V is reversed, then composed with i and r to produce a homotopy G from a constant circle map to the identity. The initial constant map has the explicit constant real lift `arg(r(v))`. Stock `liftHomotopy` lifts the entire homotopy; its time-one slice is a continuous section of exponential, impossible by the preceding theorem.

I inspected stock `Topology/Homotopy/Lifting.lean`: this homotopy-lifting construction allows an arbitrary parameter space and does **not** require that V or Circle be locally path connected. The earlier source-outline concern concerned the different `existsUnique_continuousMap_lifts` theorem and is fully resolved by this implementation. `ContractibleSpace` is stock homotopy equivalence with a one-point space, and `id_nullhomotopic` yields the actual contraction used here.

## Torus, stereographic projection, and convex geometry

**Torus-to-sphere obstruction (all of `TorusTopology.lean`, then `Proof.lean:119–123`).** Circle is the stock unit circle, and its product is the genuine topological torus. The stereographic pole is e(1,1). The entire slice z↦(z,−1) avoids that pole because −1≠1 and e is injective. This membership in the actual stereographic source is explicitly proved. The proposed inclusion and retraction use actual stereographic projection and its inverse, with proved continuity and the exact retraction identity.

Stock `stereographic` has source the sphere minus its pole and target all of the pole's orthogonal-complement vector space. Consequently its inverse is continuous on the whole target, as used on lines 31–32. The code need not package a separate punctured-space homeomorphism: restricting the forward composite to the avoiding slice and using the globally defined inverse on the entire target is sufficient. No claim is made that the punctured torus is contractible. The target is a genuine real vector space; stock `RealTopologicalVectorSpace.contractibleSpace` supplies contractibility.

**All bounded convex boundaries (`Proof.lean:135–150`).** This is the strongest geometric theorem in the submission. It assumes actual convexity and boundedness in actual Euclidean 3-space, plus a homeomorphism from the torus to the actual frontier. For nonempty interior, stock gauge rescaling supplies an ambient homeomorphism whose image of the frontier is the unit sphere. `Homeomorph.image` and `Homeomorph.setCongr` genuinely restrict/reidentify the boundary subtype, allowing the torus-to-sphere contradiction.

For empty interior, the frontier equals the closure, whether or not K was closed. Its nonemptiness is obtained from the hypothesized homeomorphism. The closure remains convex, so stock `Convex.contractibleSpace` gives actual contractibility of the closure subtype. The circle slice and coordinate projection transported through the torus homeomorphism give the contradiction. Thus there is no hidden nonempty-interior, full-dimensionality, nonemptiness, or closedness assumption.

**Finite hull corollary (`Proof.lean:152–179`).** Stock finite-hull compactness supplies boundedness; convexity is inherent in `convexHull`. The theorem excludes every finite generating set, including redundant generators and degenerate hulls. Calling the generating finset “vertices” causes no logical weakness, since all genuine finite vertex sets are included. `HasConvexPolyhedralRealization` is an actual existential homeomorphism to the frontier of an actual finite convex hull, with no encoded Euler relation or pre-assumed obstruction.

## Surface/genus semantics and final capstone

`HasGenusOne S` (`Proof.lean:160–163`) is the standard topological-model definition that S is homeomorphic to the torus. It does not add arbitrary genus labels to arbitrary spaces and does not incorporate a nonrealizability claim. `torus_has_genus_one` is appropriately immediate under that definition: the substantive obstruction is proved separately.

`torus_closed_surface_properties` (`Proof.lean:182–193`) supplies compactness, Hausdorffness, second countability, path connectedness, and the actual analytic manifold structure on the product of circle manifolds. Path connectedness is obtained from actual continuous surjectivity of exponential and product paths. The chart model is the product of two **full one-dimensional real Euclidean spaces**, rather than a half-space model. `torus_chart_dimension` (`Proof.lean:195–198`) proves that model has real dimension two. Inspection of stock model-with-corners definitions confirms that the Euclidean self model is boundaryless and its product is boundaryless. Consequently these facts exhibit an actual compact, connected, boundaryless two-manifold. No Euler/genus classification theorem has been postulated. The files use the conventional orientable genus-one model, rather than formalizing an independent general integer-valued genus invariant.

The capstone (`Proof.lean:200–204`) states that this concrete genus-one model has no convex-polyhedral realization. It has no residual hypotheses such as “convex boundaries are spheres,” “Circle cannot retract,” or any unproved topological bridge. The closed-surface facts are established in separate theorems rather than repeated in the capstone conjunction; the report should explicitly connect them, but this is not a mathematical gap.

Under the ordinary convention that a convex polyhedral realization of a closed surface is a homeomorphism to the boundary of a bounded convex polyhedron in R^3, this disproves the source claim. The finite-convex-hull realization definition is a standard polytope convention. Moreover, `no_torus_convex_boundary` independently covers **every bounded convex set**, so applying the obstruction to a bounded convex polyhedron defined by halfspaces does not require a finite-hull representation theorem at all. The report should state the convention explicitly and should not claim the code quantifies over arbitrary unbounded polyhedra or arbitrary ambient dimensions.

The original prime-edge and O(g) conditions are intentionally absent from the obstruction. This is legitimate: a purported realization with those additional properties would first have to be a convex-polyhedral realization, which is already excluded at genus one. The proof does not exploit g=0, a chosen Big-O convention, arithmetic surrogates for edge length, or replacement of convexity by an Euler predicate. It therefore establishes a stronger counterexample than required under the stated conventional interpretation.

## Outstanding acceptance checks

1. Execute the clean pinned-stock build and check the final theorem types/axioms, together with the strongest geometric theorem and the covering/retract lemmas. No such execution is claimed by this reviewer.
2. Review the full LaTeX and PDF for mathematical agreement, explicit R^3/bounded-convex-boundary and genus-one-model conventions, and accurate descriptions of what was actually formalized.
3. Confirm the final submitted files match the hashes above, or review any later differences.

There is presently no source-level correction request. Any final acceptance must include the outstanding execution and report evidence, rather than treating this source-only verdict as completion of all competition review obligations.
