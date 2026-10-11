# Independent assessment of the proposed topological reduction

## Scope and disposition

This assesses only the reduction described by the coordinating reviewer. I reread my source assessment and relevant files in the authorized stock mathlib tree. I have not inspected author files or executed a Lean build. All library observations below are source inspection, not compilation verification.

**The reduction is mathematically sound in outline under the ordinary R^3/boundary interpretation.** It uses actual topological spaces and an actual convex hull, and it can establish a stronger obstruction than the prime-edge/vertex-count assertion requires. The punctured-torus retract step is valid. The remaining obligations are substantial, concrete proof steps rather than a detected contradiction in the strategy.

## Verification of the two cases

Write T = Circle × Circle, V for a finite subset of Euclidean 3-space, and K = convexHull ℝ V. Suppose h : T ≃ₜ frontier K.

**Nonempty interior.** Finiteness gives compactness and hence boundedness of K, and the convex hull is convex. The stock theorem `exists_homeomorph_image_interior_closure_frontier_eq_unitBall` in `Analysis/Convex/GaugeRescale.lean` genuinely supplies an ambient homeomorphism carrying frontier K onto the unit sphere. Restricting that homeomorphism gives the required boundary-to-sphere homeomorphism; this restriction must actually be constructed, not inferred merely from the ambient map's type.

Choose a point q on the sphere and let p be its preimage in T. The resulting homeomorphism must restrict to a homeomorphism T \ {p} ≃ₜ sphere \ {q}. Stock `stereographic` in `Geometry/Manifold/Instances/Sphere.lean` is a **partial** homeomorphism: its source is the complement of its pole and its target is the entire orthogonal complement of that pole. After the correct restriction, this is a homeomorphism onto a real vector space W. Using that orthogonal-complement space directly is sufficient; identifying it with R^2 or proving a finrank calculation is unnecessary for the contradiction.

For p = (a,b), choose b₀ ≠ b. The maps

- i : Circle → T \ {p}, i(z) = (z,b₀),
- r : T \ {p} → Circle, r(z,w) = z

are continuous and r ∘ i = id. The fact b₀ ≠ b is exactly what makes the entire slice avoid the removed point. Conjugating these maps through the punctured-sphere homeomorphism gives a continuous section/retraction pair Circle ⇄ W. Thus the proposed puncture construction is correct; one does not need the punctured torus itself to be contractible, and one must not claim that it is.

**Empty interior.** Since K is compact and Euclidean space is Hausdorff, K is closed. Therefore frontier K = closure K \ interior K = K. Under the hypothesized h, K is nonempty. Stock `Convex.contractibleSpace` proves that this actual subtype K is contractible. The torus has the ordinary circle slice and first-coordinate retraction; transport along h gives Circle ⇄ K. The empty hull cannot be overlooked, but h already rules it out, so no extra geometric assumption is needed.

## Covering-space contradiction and exact hypotheses

A sufficient reusable lemma is: if X is simply connected and locally path connected and there are continuous i : Circle → X and r : X → Circle with r ∘ i = id, then a covering map exp : R → Circle would give a continuous section of exp. Choose the base point x₀ = i(1) and its lift 0; then exp(0) = 1 = r(x₀). Lift r to R, then compose its lift with i. The section identity follows from the lift identity and r ∘ i = id.

The stock theorem `IsCoveringMap.existsUnique_continuousMap_lifts` in `Topology/Homotopy/Lifting.lean` explicitly requires both `SimplyConnectedSpace X` and `LocPathConnectedSpace X`, together with the base point and lift equation. **Contractibility by itself does not supply the local-path-connectedness hypothesis in arbitrary spaces.** In this proposal it is available: real vector spaces are locally convex, and stock `Convex.locPathConnectedSpace` in `Topology/Algebra/Module/LocallyConvex.lean` gives local path connectedness for the convex subtype K. Stock `SimplyConnectedSpace.ofContractible` is in `AlgebraicTopology/FundamentalGroupoid/SimplyConnected.lean`. Thus both cases can satisfy the lifting theorem honestly.

The exponential covering and its lack of continuous section still require genuine proofs. Stock `Analysis/SpecialFunctions/Complex/Circle.lean` supplies `isLocalHomeomorph_circleExp`, accompanied by the comment “todo: upgrade this to `IsCoveringMap Circle.exp`.” A local homeomorphism is not, in general, automatically a covering map, even if surjective. The author must construct or derive the evenly covered neighborhoods with all sheets; the stock local-homeomorphism result alone does not finish this step.

For the no-section result, a valid route is to assume a continuous section σ, consider t ↦ σ(exp t) − t, prove it takes values in the discrete subgroup 2πZ, and use connectedness of R to prove it is constant. Periodicity of exp then changes that same difference by −2π, a contradiction. All continuity, kernel/period, discreteness, and nonzero-period facts must be supplied. This is an example of adequate mathematical evidence, not a claim that the author's implementation already does it.

## Semantic bridge to the original conjecture

1. **Genuine polyhedra:** A bounded convex polyhedron in ordinary Euclidean 3-space is the convex hull of its finitely many vertices. The proposed theorem quantifies over every finite generating set, so it even covers redundant generators and lower-dimensional hulls. This is faithful under the common finite-convex-hull definition of convex polytope, with realization by the entire ambient frontier. If the submission instead defines polyhedron as a bounded finite intersection of halfspaces, it needs the representation theorem connecting that definition to a finite convex hull. Merely naming finite sets “polyhedra” does not prove an equivalence with a different formal definition. The report should state the adopted standard convention explicitly.
2. **Genuine torus:** Stock Circle is the unit circle, so its product is the genuine topological torus. To state the entire conjecture's negation formally, the submission must connect this witness to its definition of a closed surface of genus one. Compactness, connectedness, boundaryless two-dimensional manifold structure and the genus convention cannot be supplied by an unsupported proposition field. A standard genus-one model defined to be the torus is legitimate; an arbitrary formal “genus 1” tag is not. The stock sphere-manifold file does provide actual Circle charted-space/manifold instances, but this inspection has not established the full surface/genus packaging or its execution.
3. **Weaker necessary consequence:** The final geometric theorem should unconditionally exclude a homeomorphism T ≃ₜ frontier(convexHull ℝ V) for every finite V in Euclidean 3-space. It must not retain a hidden assumption such as “all convex boundaries are spheres” or “Circle has no retract.” With the torus and polyhedron bridges in place, the original universal conjecture would imply precisely such a forbidden realization. Any prime-edge and O(g) conditions only further restrict the set of available realizations; impossibility before imposing them suffices. No prime-length construction, edge enumeration, O(g) estimate, or g = 0 convention is needed for this disproof.

## Concrete items to inspect when code is authorized

- The exact final theorem and all remaining parameters/assumptions.
- Actual finite-convex-hull compactness/boundedness and both interior cases, including hull nonemptiness derived from h.
- Correct frontier subtype homeomorphisms and correct puncture/pole in every restriction.
- A distinct second coordinate for the avoiding slice; continuity and the precise retraction identity.
- Genuine covering proof for Circle.exp; no substitution of a local-homeomorphism claim.
- Genuine no-continuous-section proof; no custom axioms or assumed topological obstruction.
- Both lifting instances and the base-point lift equation for W and K.
- The semantic torus/genus and polyhedron/realization bridge in theorem statements and report.
- A clean executed build and final axiom/dependency audit, still outstanding.
