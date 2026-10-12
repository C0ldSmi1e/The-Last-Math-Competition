# Independent frozen-project v1 semantic review — 00000007160

## Scope and verdict

The reviewer accounted for all nine files in the frozen author manifest, totaling 609 lines. The three previously reviewed building blocks were confirmed byte-identical to the exact snapshots independently compiled and audited during the preceding stage. Every line of the new reindexing module, final theorem module, verification module, Lake configuration, toolchain declaration, and dependency manifest was read in full. No source was modified. No previous competition submission, competing proof, session, root/selector note, or neighboring problem was read.

**No mathematical or semantic defect was found in the frozen v1 source.** In particular, the final theorem proves the proposed inequality for arbitrary finite complex normal matrices and arbitrary complete eigenvalue lists with algebraic multiplicity. Its hypotheses contain no omitted positive-dimension, simple-spectrum, Hermitian, invertibility, or pairwise-commutation constraint. The formal conclusion is the exact permutation inequality identified in the independent preliminary reading of both original languages.

This is the final mathematical-source review of frozen v1, not a declaration that the entire submission package is ready to publish. A separate engineer is performing the final project rebuild and trust audit. The report's pending-verification paragraphs and final PDF require a later delta check. The findings below must be combined with those records before any completed-verification claim.

## Frozen evidence

The original author manifest was `author/frozen-project-v1.json`; its exact bytes are preserved as `frozen-project-v1-manifest-reviewed.json`. `FROZEN_PROJECT_V1_READ_MANIFEST.json` records its hash, the source directory, every exact source hash, and the independent snapshot directory. All nine source files are retained in `frozen-project-v1-reviewed`.

| File | Lines | SHA-256 |
| --- | ---: | --- |
| `NormalSpectral.lean` | 91 | `79d5085f54cd810184c7ae56613827b63c967311ec6c5629c1b8c2af3473c0f3` |
| `Frobenius.lean` | 97 | `98fc2aff33e116d5c7389529c5df114d0e9291c9ea6c6d13eacaa528ae0e5dc7` |
| `Matching.lean` | 34 | `63635da80b55553c5f50417b55d19949383d127512fbed76507ebe7955b9e651` |
| `Reindexing.lean` | 28 | `de07f7222dd64e8c11595086326881d2fdaadd2147eb2b8b6733630481fd73b3` |
| `HoffmanWielandt.lean` | 108 | `84596cabafe24fe2e6447be0dba455e386cffd2dfdb85ada3a1f0ce1db2665a1` |
| `Verification.lean` | 119 | `f6e68eb59ad1f1409c0879f3751f2340c3f099ffb7991fd0847d9384f6f42ace` |
| `lakefile.lean` | 15 | `143c70050de6b91d35986d211511e78cb905b9b7ba84ff472a2d9e656d7c15f4` |
| `lean-toolchain` | 1 | `55e97be96000b5e9e290c9e74482e5e317861499a5540353ce845471bded8cea` |
| `lake-manifest.json` | 116 | `17619b39e0d5ee7e914c197a1acdde917adbff3381c99c66cd4e220901b57d6c` |

## Previously reviewed modules: exact-byte confirmation

The declaration-by-declaration analysis in `BUILDING_BLOCK_DRAFT_SEMANTIC_REVIEW.md` is incorporated into this review because all three files are byte-identical. It covers all four theorems of `NormalSpectral.lean`, both definitions and all six theorems of `Frobenius.lean`, and the theorem in `Matching.lean`.

That stage independently compiled the exact sources with warnings as errors using only private review outputs and read-only generic caches. All 13 declarations were audited with `#print axioms`, reporting only `propext`, `Classical.choice`, and `Quot.sound`. There was no `sorryAx` or additional supplied axiom. The normality-to-complete-eigenbasis construction, characteristic-polynomial product identity, correctly conjugated coordinate identity, exact entrywise Frobenius sum, both doubly stochastic sum conditions, and correct Birkhoff permutation orientation were all inspected. None depends on nonzero dimension.

## `Reindexing.lean`: full review

`exists_perm_of_prod_X_sub_C_eq` takes arbitrary functions f and g on the same finite index type and equality of their products of complex linear factors. It concludes an actual bijective permutation e with f(i) = g(e(i)).

The proof first applies the standard polynomial-root theorem to identify the roots of each product with the multiset obtained by mapping its entire index multiset. This theorem records multiplicity, including repeated and nonreal values. Equal products therefore have equal root multisets. Taking the count of each complex value gives equal cardinalities for the corresponding fibers. `Fintype.equivOfCardEq` gives a bijection on each fiber, and `Equiv.ofFiberEquiv` combines these into a domain equivalence. The library identity is g(e(i)) = f(i), so its symmetric form gives exactly the stated orientation. Empty fibers and an empty index type require no special assumption. No element is matched more than once, and repeated values are retained rather than deduplicated.

Selected primary Mathlib source was inspected to confirm `roots_multiset_prod_X_sub_C`, `Equiv.ofFiberEquiv`, and `Equiv.ofFiberEquiv_map`. The code uses these declarations in their actual mathematical meanings, not a weaker set-of-roots substitute.

## `HoffmanWielandt.lean`: every declaration and proof

1. `IsEigenvalueList`: The definition is exactly A.charpoly = ∏ᵢ(X − C(λᵢ)), with the index type `Fin n` matching the matrix dimension. This is a complete list with algebraic multiplicities. It is not an assumption of the desired perturbation bound or an arbitrary list of individually verified eigenvectors.

2. `eigenbasis_matching_sq`: The theorem is a correct intermediate result for two supplied complete orthonormal eigenbases. It instantiates `exists_perm_cost_le` with squared overlaps and squared complex eigenvalue differences. The proved doubly stochastic property supplies its hypothesis, and `weighted_cost_eq_frobenius` replaces the weighted cost by the exact Frobenius square in the requested coordinate basis. The resulting witness is a permutation of the complete common index type.

3. `normal_matrices_hoffman_wielandt_sq`: This theorem supplies all missing data from arbitrary complex normal matrices A and B. It uses the standard orthonormal basis of `EuclideanSpace ℂ (Fin n)` and the genuine star-algebra equivalence between linear endomorphisms and their matrices. The primary source confirms that this equivalence preserves multiplication and sends adjoints to conjugate transposes. Thus mapping `Commute (star A) A` and the analogous hypothesis for B through its inverse proves normality of the two associated operators, without imposing that A and B commute with each other.

   The normal spectral theorem produces a complete orthonormal eigenbasis for each operator because the Euclidean-space dimension equals n, including n = 0. The previous matching lemma gives the cost bound. The operator characteristic-polynomial theorem is transferred back through the standard coordinate basis, establishing `IsEigenvalueList` for the actual original matrices A and B. Finally the equivalence's preservation of subtraction and its inverse identities identify the coordinate matrix of the operator difference with exactly A − B. This discharges the concrete-matrix/operator, normality, multiplicity, and norm bridges explicitly.

4. `normal_matrices_hoffman_wielandt`: It obtains the complete lists and permutation from the squared theorem and applies the real square-root monotonicity theorem. `frobeniusNorm` is definitionally the square root of the same explicit `frobeniusSq`; there is no mismatch with an operator norm. The square-root inputs are sums of squares. This version is existential in the two lists; the later public theorem removes that enumeration restriction.

5. `eigenvalueList_roots`: The definition of a complete list and the exact root-product identity prove that the matrix characteristic polynomial's root multiset equals the mapped full index multiset. This explicitly certifies the intended algebraic multiplicity semantics, including repeated roots and the empty characteristic polynomial 1.

6. `hoffman_wielandt_sq`: This is the full arbitrary-list capstone. Its inputs are arbitrary n : ℕ, A and B : Matrix (Fin n) (Fin n) ℂ, their two normality equations Aᴴ A = A Aᴴ and Bᴴ B = B Bᴴ, arbitrary functions λ and μ on `Fin n`, and only the two complete characteristic-polynomial factorization conditions. Its conclusion is an actual σ : Equiv.Perm (Fin n) with

       Σᵢ ‖λᵢ − μ_(σ(i))‖² ≤ ΣᵢΣⱼ ‖Aᵢⱼ − Bᵢⱼ‖².

   There are no other assumptions. It first obtains spectral-theorem lists λ₀, μ₀ and matching σ₀ from the existential theorem. Equal characteristic-polynomial products produce e and f satisfying λ = λ₀ ∘ e and μ = μ₀ ∘ f. The chosen permutation `(e.trans σ₀).trans f.symm` is f⁻¹ ∘ σ₀ ∘ e. Therefore μ at the new matched index is μ₀ at σ₀(e(i)). Reindexing the finite sum by e gives the previously proved cost. The source implements exactly this composition and equality; no inverse-permutation error or fixed-enumeration assumption remains. The final entrywise expression unfolds `frobeniusSq (A − B)` with ordinary pointwise matrix subtraction.

7. `hoffman_wielandt`: This arbitrary-list square-root theorem directly applies `hoffman_wielandt_sq` and square-root monotonicity. It concludes existence of a matching with Euclidean cost at most the explicit Frobenius norm. Hence the minimum over all permutations satisfies the same bound.

The project does not define a separate Lean metric-space structure or a named `d₂` minimum function. That is not a gap in the chosen formulation: the original statement was explicitly interpreted as the pairwise permutation inequality, and the report defines d₂ as the finite minimum. Existence of one permutation with the proved bound immediately implies the stated minimum-distance corollary. The project should continue to describe what it proves through these concrete estimates, without claiming an additional formal `LipschitzWith` or metric-instance declaration.

## `Verification.lean`: every check

The module imports the main theorem and does not replace or weaken it. Its `full_statement` theorem unfolds the existential capstone into characteristic-polynomial products and an explicit double entrywise sum under a square root, confirming the norm and multiplicity semantics in the public interface.

The zero-dimensional matrix example supplies normality by subsingleton equality and instantiates the full theorem. The empty-index signed-cost example instantiates the Birkhoff matching lemma with negated arbitrary costs; the doubly stochastic condition is correctly vacuous. The repeated-eigenvalue example checks the characteristic polynomial of i I₂, retaining both factors. The scalar zero-to-one example shows equality in the norm expression at dimension one, consistent with the report's sharp uniform constant.

The concrete matrices A = diag(i,0) and B = [[0,i],[i,0]] are correctly verified normal. Their conjugate transposes change i to −i, so the two non-Hermitian proofs are correct. Their products have different real (0,1) entries, so the noncommutation proof is correct. Applying the full theorem to this pair meaningfully checks that the theorem is not restricted to Hermitian matrices or commuting pairs.

The arbitrary-enumeration example restates the main arbitrary-list square-root theorem with its explicit entrywise bound. The signed nonempty 2-by-2 cost example checks the general matching lemma without a nonnegative-cost hypothesis. The two-value reversed-order example obtains a permutation from equality of the two factor products. The constant three-value example handles repeated roots through the same multiplicity bridge. These examples are compile-time formal specializations, not empirical substitutes for the general proof.

The eleven `#print axioms` commands target the list/root bridge, reindexing lemma, both arbitrary-list capstones, the spectral/Frobenius/matching core, both existential capstones, and the expanded `full_statement`. Their final outputs belong to the separate frozen-project engineering audit; this semantic review does not treat the author manifest's claimed axiom list as independent engineering evidence.

## Configuration and dependency lock

`lakefile.lean` is a conventional Lake package with `warningAsError = true`. It requires Mathlib v4.19.0, makes all five proof modules roots of the default theorem library, and adds `Verification` as a separate default target. The configuration does not omit the capstone or verification checks, add custom proof axioms, disable kernel checking, or install a build hook that rewrites the proof.

`lean-toolchain` selects `leanprover/lean4:v4.19.0`. The complete 116-line lock file is ordinary Lake JSON with nine git dependencies and fixed revision identifiers. Mathlib is pinned to `c44e0c8ee63ca166450922a373c7409c5d26b00b` with input revision v4.19.0. The remaining packages are plausible, LeanSearchClient, importGraph, proofwidgets, aesop, Qq, batteries, and Cli, each with a fixed revision. Dependency retrieval/trust and exact installed-source validation remain the engineer's job; no additional proof assumption is encoded in the configuration.

## Correspondence with the report and original scope

The report remained byte-identical to the fully reviewed draft during this source review: SHA-256 `32bcf04ac091a3fbdeb5e410012bb421c2fbb441c030432b2ece92d0797ed04b`.

| Report mathematical step | Frozen source support |
| --- | --- |
| Complete list through characteristic-polynomial factorization | `IsEigenvalueList`, `eigenbasis_charpoly`, `eigenvalueList_roots` |
| Full eigenbasis from normality, including zero dimension | `normal_exists_eigenbasis`, concrete transfer in `normal_matrices_hoffman_wielandt_sq` |
| Doubly stochastic squared overlaps | `overlaps_doublyStochastic` |
| Exact weighted Frobenius identity | `inner_eigenbasis_apply`, `sum_image_sq_eq_adjoint`, `sum_image_sq_basis_independent`, `frobeniusSq_toMatrix`, `weighted_cost_eq_frobenius` |
| A permutation no worse than the weighted average | `exists_perm_cost_le`, `eigenbasis_matching_sq` |
| Arbitrary enumeration of complete spectra | `exists_perm_of_prod_X_sub_C_eq`, `hoffman_wielandt_sq` |
| Square-root/Frobenius Lipschitz bound with constant 1 | `hoffman_wielandt`, with `frobeniusNorm` explicit and `frobeniusNorm_eq_mathlib` available |
| Optimal finite matching distance corollary | Mathematical finite-minimum consequence of the existential permutation estimate, as stated in the report |

The two terse original languages are accurately covered under the disclosed standard interpretation. Real normal matrices are included by viewing their entries over ℂ. The definition counts multiplicity, has no dimension-dependent factor, and does not claim a global eigenvalue labeling. Empty, scalar, repeated, zero, and nonreal spectra all lie in the theorem's domain. No numerical checks are used as premises in any general proof.

## Remaining package-level steps

No source-level mathematical correction is requested. The source verdict is bound to the exact hashes above; any change requires a delta review. Before reporting the package fully verified, incorporate the independent strict Lake build, final axiom and trust audit, final auxiliary execution evidence, and the report's final verification-text/PDF review. The current report deliberately still says those steps are pending and must not be published with contradictory validation claims.
