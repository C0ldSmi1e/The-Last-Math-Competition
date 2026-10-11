# Independent review of proposed BoundaryBound extension

## Source, scope, and verdict

Reviewed every line of `/private/tmp/tlmc105-proof/BoundaryBound.lean` (59 lines), without editing it. Current SHA-256:

`b35015d5a835d0aa60b710cc5837441c50cd15ea43566def8801fede40b901c2`

This is a proposed, not necessarily frozen, extension. I checked the relevant stock sphere-connectedness, connected-set partition, reflection-distance, and reflection-midpoint lemmas by reading their definitions/proofs in the authorized stock mathlib tree. I did not execute Lean. A lexical scan found no `sorry`, `admit`, `axiom`, `unsafe`, `native_decide`, `implemented_by`, `extern`, `opaque`, `set_option`, `run_tac`, `elab`, or `eval`.

**Source-level verdict: mathematically sound.** The final theorem genuinely states that a proper closed convex subset of Euclidean 3-space with compact frontier is bounded, with no concealed geometric hypothesis. Its stronger first theorem only needs bounded frontier and real vector-space dimension greater than one. Both closedness and properness are used appropriately. No source-level correction is requested, subject to clean compilation and a compiled axiom audit.

## Argument checked in detail

1. Properness `s ≠ univ` supplies an actual point p outside s. Boundedness of the actual frontier supplies R with `frontier s ⊆ closedBall p R`.
2. Suppose an actual point x of s lies farther than R from p. On the sphere centered at p of radius `dist x p`, no point can lie on the frontier, because its distance would simultaneously exceed and be at most R.
3. Closedness gives `frontier s = s \ interior s`. Therefore every point on that sphere belongs either to `interior s` or to `sᶜ`. These are disjoint open sets; openness of the complement is exactly where closedness is needed.
4. Stock `isPreconnected_sphere` proves preconnectedness for every sphere in a real normed vector space whose rank exceeds one. The theorem has the exact rank hypothesis used in the source. Stock `IsPreconnected.subset_or_subset` then implies that the whole sphere lies in one of the two open sets. There is no unjustified jump from local information to a global sphere statement.
5. The complement alternative is impossible because x lies on the sphere and in s.
6. In the interior alternative, the reflection of x about p lies on the same sphere, hence in s. Convexity places its midpoint with x in s. The stock midpoint/reflection identity identifies that midpoint with p, contradicting the original choice of p outside s.
7. Thus s is contained in the selected closed ball and is bounded. The proof does not require R>0 or a separate nonempty-set assumption: it handles s=∅ vacuously, and the contradictory far point supplies sphere membership when needed.
8. In Euclidean 3-space, the stock finrank-to-rank identity and `finrank_euclideanSpace_fin` give rank 3>1. Compact frontier implies bounded frontier, so the second theorem is exactly the advertised result.

The extension uses actual convexity, actual frontier, actual compactness/boundedness, actual Euclidean dimension, and actual topological connectedness. It does not encode the desired conclusion into a new definition or assume a classification theorem.

## Integration into the original disproof

The source as reviewed proves boundedness; it does not yet itself state the integrated torus-boundary contradiction. To use it correctly for a closed convex K and a purported homeomorphism `e : Circle × Circle ≃ₜ frontier K`, the integration should:

- Obtain compactness of the frontier from compactness of the actual torus and the homeomorphism, or directly from the compact continuous image of the torus under the composite of e with subtype inclusion.
- Prove K is proper. If K=univ, its frontier is empty, contradicting the actual point e(1,1).
- Apply `bounded_of_convex_compact_frontier` to obtain boundedness.
- Apply the already reviewed `no_torus_convex_boundary` to the same convex set and homeomorphism.

This would remove the boundedness restriction for **closed convex sets in R³**. It therefore covers the standard definition of a possibly unbounded convex polyhedron as a finite intersection of closed halfspaces: such a set is closed and convex. No finite-hull representation theorem or prior assumption that the alleged realization is bounded is then needed.

The extension does not by itself quantify over nonclosed convex sets, other ambient dimensions, or a realization relation weaker than a homeomorphism to the whole frontier. These are not defects for the standard polyhedron-boundary reading. The existing bounded theorem already treats nonclosed bounded convex sets; the new intended theorem can simply state its honest closed-convex scope.

## Remaining verification

A clean executed Lean build and compiled axiom/dependency audit are outstanding for this reviewer. The integration must be inspected when it is frozen, and any change to this file requires a hash comparison and delta review. The author report must accurately explain the use of properness, compact frontier, and closedness rather than asserting all convex sets with bounded boundary are bounded (the whole space is the excluded counterexample).
