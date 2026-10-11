# Source and formalization

The exact bilingual source is preserved in `original.md`. Both versions require uniform expansion and claim Cantor type together with a dimension/pressure conclusion.

The source leaves the ambient category and several conventions unspecified. This submission declares the standard complex-polynomial setting, with Julia set the boundary of the bounded-forward-orbit set, and uniform expansion on that Julia set in the Euclidean metric. It does not silently add disconnectedness or inverse-branch separation. The phrase about expansive kernels has no separately supplied mathematical definition. An intended different category or whole-plane expansion hypothesis would be a different statement.

| Mathematical content | Formal declaration in `ExpandingJuliaCounterexample` |
|---|---|
| Actual complex polynomial of degree two | `squarePolynomial`, `squarePolynomial_degree` |
| Its evaluation and actual iterates | `square`, `square_iterate` |
| A single norm bound for all forward iterates | `filledJulia` |
| Genuine topological frontier | `julia` |
| Orbit-defined filled Julia is the closed disk | `filledJulia_square` |
| Its Julia frontier is the unit circle | `julia_square` |
| Compactness and forward invariance | `julia_square_compact`, `square_mapsTo_julia` |
| Actual complex derivative of each iterate | `square_iterate_hasDerivAt` |
| Uniform complex/real tangent expansion for every vector | `norm_fderiv_square_iterate`, `norm_real_fderiv_square_iterate` |
| Local metric expansion, radius 1/2 and factor 3/2 | `square_local_distance_expansion` |
| Common expansion constants C=1, L=2 | `square_uniformlyExpanding` |
| Homeomorphism with the standard product Cantor space | `CantorType` |
| Cantor homeomorphism implies total disconnectedness | `cantorType_totallyDisconnected` |
| Genuine circle connectedness and distinct points | `julia_square_connected`, `julia_square_not_totallyDisconnected` |
| Failure of Cantor topology | `julia_square_not_cantorType` |
| Concrete polynomial satisfying hypotheses and failing conclusion | `counterexample` |
| Negation of necessary universal topological clause | `not_every_expanding_polynomial_has_cantor_julia` |
| Same obstruction with any additional conclusion | `not_every_expanding_polynomial_satisfies_conjunction` |

`UniformlyExpandingOn` additionally requires global complex differentiability of all iterates, a property satisfied by this polynomial. It uses a scalar derivative norm; the real Frechet derivative theorem explicitly connects it to all tangent vectors. No Julia set, derivative, dimension, or pressure is replaced by an assigned numerical value. Pressure and dimension are uncomputed because the first conjunct already fails. The arbitrary second-conclusion predicate expresses only that logical implication.

`Checks.lean` distinguishes the filled Julia set from Julia at the origin, checks the vanishing derivative there, checks the identity iterate's derivative, and checks noninjectivity at the two distinct circle points. These guard against extending the expansion claim beyond its intended locus or from local to global pairwise expansion.

The conventional boundary Julia definition is supported by Cheraghi, Lecture4, p22, Lemma4.1. The normal-family equivalence is not newly formalized. Milnor, Section14, p14-1 supplies the standard all-vector expansion convention. Full references, proof and interpretation limits are in `report.tex` and the matching PDF.
