# Independent geometric assessment and provenance

This assessment was prepared by the delegated geometric-proof author in the current clean authoring task. The author inspected only the supplied clean problem statement and competition rules, stock Mathlib source needed for elementary segment and collinearity APIs, the newly prepared proof project configuration, and the author's own newly written `Geometry.lean`. No prior solution, repository submission, web source, search engine, or external proof was consulted. The parent supplied the determinant formulation while the author was independently exploring a leaf-deletion argument; the resulting strict-sign lemma was checked mathematically and formalized here.

## Semantic interpretation

The input concerns a finite straight-edge graph in the real plane whose distinct edges intersect in exactly one point. Vertices are represented by distinct plane points, edges have distinct endpoints, and an edge is the full closed straight segment joining its endpoints. The condition permits crossings in edge interiors and permits a vertex of one edge to lie in the interior of another. It does not require general position. In particular, collinear vertices and opposite directions at a vertex are allowed when they are compatible with singleton intersections. The resulting theorem bounds the number of graph edges by the number of vertices.

The geometry formalization uses `Point := ℝ × ℝ` and defines the closed segment by an explicit real parameter in `[0,1]`. It proves this agrees with the stock Mathlib segment definition. Thus neither an open segment convention nor an unmentioned proper-crossing condition is introduced.

## Geometric argument

Fix three edges `va`, `vb`, and `ax`, where `a ≠ v`, `b ≠ v`, the first two meet only at `v`, the first and third meet only at `a`, and the second and third have a point `p` in common. Necessarily `p ≠ v` and `p ≠ a`: either equality would violate one of the two prescribed singleton intersections.

The points `v,a,p` are not collinear. Indeed, if they were collinear, one of the three points would lie on the segment joining the other two. If `a` lies between `v` and `p`, then `a` also belongs to `vb`, contradicting the intersection `va ∩ vb = {v}`. If `p` lies between `v` and `a`, the same intersection contains `p ≠ v`. If `v` lies between `p` and `a`, then `v` also belongs to `ax`, contradicting `va ∩ ax = {a}`. Mathlib's weak-betweenness trichotomy handles these alternatives, including boundary cases.

Write `p=(1−t)v+tb=(1−s)a+sx`, with `0≤t,s≤1`. The inequalities `p≠v,a` imply `t,s>0`. Bilinearity of the planar determinant gives

`det(a−v,p−v) = t det(a−v,b−v) = s det(a−v,x−v)`.

The left-hand determinant is nonzero by the noncollinearity just proved. Squaring it and cancelling the positive factor `ts` proves

`det(a−v,b−v) · det(a−v,x−v) > 0`.

This is `GeometricThrackle.det_strict_side`. The proof assumes only the two stated singleton intersections and existence of the third intersection. It therefore covers every degeneracy permitted by the original definition, without relying on an unformalized drawing.

## Consequence for counting

If a neighbor `a` of a vertex `v` has another incident edge `ax`, the strict-sign lemma says that all other neighbor directions at `v` lie strictly on the same side of the directed line `va`. Three such nonleaf neighbors `a,b,c` are impossible: antisymmetry of the determinant makes the three resulting same-side conditions contradictory. Consequently every vertex has at most two neighbors of degree different from one; a neighbor cannot have degree zero.

One can conclude by deleting leaves and isolated vertices until the remaining graph has maximum degree at most two. Equivalently, the subgraph induced by vertices of degree at least two has at most as many edges as vertices, and every remaining edge can be charged to an incident degree-one vertex. This geometric author supplied the local argument; the parent author owns and verifies the graph-counting formalization.

## Verification scope

`Geometry.lean` was compiled using the provided Lean 4.19.0 runtime and stock Mathlib dependencies. The complete local theorem contains no `sorry`, `admit`, or custom axiom. It uses ordinary classical real arithmetic and stock Mathlib results concerning convex segments, collinearity, and betweenness. Compilation establishes the stated local geometry theorem. The final graph theorem and report consistency remain the parent author's responsibility and should be checked in the assembled project.
