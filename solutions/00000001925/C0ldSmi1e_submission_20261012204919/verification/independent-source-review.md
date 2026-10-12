# Independent frozen-source semantic review: conjecture 00000001925

## Verdict and scope

**PASS for mathematical correctness and source/report semantic correspondence, with no blocking findings.** The frozen project proves the intended counterexample to the ordinary unqualified bilingual claim: one bounded observable in one invertible probability-preserving system has quadratic averages that do not converge in the genuine L-infinity norm. The report accurately limits this conclusion to the written claim and explicitly excludes any claim about an amended ergodic-only hypothesis.

This is an independent mathematical and source-semantic review. Builds, kernel replay, environment authenticity, axiom/trust auditing, PDF rendering, submission eligibility, and repository operations are separate workstreams. This reviewer did not run or duplicate builds and does not certify those workstreams. The report's validation paragraph is explicitly a working draft and must be replaced with actual recorded results before final submission; the final edited paragraph and module notes must be reviewed and hash-bound.

## Frozen identity and files read

The supplied `frozen-v1.json` has SHA-256 `bf918649c77eaa562ecd36add9416f6a02957bd56813c45fb539691945c96b2e`, as independently recomputed. Every file in `frozen-project-v1` was compared to that manifest and matched. All six Lean modules, configuration files, README, and the complete report were read. Read-only reviewer copies and exact hashes are in `snapshot-final-source-v1/manifest.json`. The report reviewed here has SHA-256 `7a444cd54c4ba8cc5941684abb16dbb3f1d6373262c92c7eda664a355aef76ed`.

The final module hashes are:

| Module | SHA-256 |
| --- | --- |
| Dynamics.lean | d747a1e6cdbeb190569b136086238d42616c621a8dd85646d4072db8e17346bb |
| Measure.lean | 2355091f693ffd313bf6998e0bd9be1adee3ad9f684b64c10b4ffb6a76f391ec |
| Nonconvergence.lean | 1c0d8080bf6e7ab41e94793ebe84331680fb5e33fc3a75770dde4be799712d45 |
| Counterexample.lean | 24a4a7ae9efe504394716b2ec0e076b6098e88eabef812190c9d986322b49c96 |
| Tests.lean | 298bebc46554b2dd3a94bce8b4eb28bc88b83c9434f418dd1dc560b23b4fb566 |
| Conjecture1925.lean | b435f73aff88648460f911e0414bcd9da8a0a05a33562b5b61c174345bd35e07 |

The earlier snapshots were compared by complete diff; all new and changed bytes were reviewed, and all three core final modules were also reread in full. The final source differs from the earlier reviewed drafts only as follows: Dynamics adds the actual quadratic polynomial object, degree theorem, evaluation identity, and average identity; Measure adds component masses and explicit nonergodicity and broadens the official import accordingly; Nonconvergence makes the extended-real-to-real conversion explicit. Counterexample, Tests, and the root module are new to this stage and were read in full.

## Original-claim interpretation

Both original language versions and both rules files were read in full before any author proof. Neither conjecture version requires ergodicity of the transformation or gives a precise rate formula. Polynomial ergodic averages conventionally include averages of arbitrary measure-preserving systems; the name alone does not assert that the system is ergodic. The choice p(k)=k^2 is a conventional nonconstant integer polynomial, and the normalized averages use indices 0 through N−1. Failure of qualitative norm convergence defeats every proposed rate that actually implies convergence, without needing to invent a formula for the unspecified rate.

The report states this adopted interpretation and limitation explicitly. No stronger hypothesis is silently claimed or refuted. A nonergodic example is within the ordinary unqualified reading of the supplied text. This conclusion is a semantic interpretation of an underspecified original statement, not a claim that the original contained fully quantified definitions.

## Complete mathematical audit

### Fixed system, transformation, and polynomial

The space Ω is the countable dependent sum of cyclic groups of lengths q_n=4(n+1)^2+1. The transformation is one fixed equivalence that adds one within each component, with a displayed inverse subtracting one. The observable is one fixed real-valued indicator of canonical residues at or above (n+1)^2 in the n-th component. Its dependence on the component coordinate is legitimate and does not vary the observable with the averaging length.

The proof of actual iterates sends (n,j) to (n,j+k). `squareTime` is k^2, and `squarePolynomial` is the actual Mathlib polynomial X^2 over the naturals, with natDegree exactly two. Its evaluation equals squareTime. Such a polynomial is in particular integer-valued at the nonnegative times being used. The average is directly defined by applying the observable to the actual square-time iterates and dividing the finite real sum by N; `average_eq_polynomial_average` makes the polynomial-object formulation explicit.

At the base point of component n and for k<2(n+1), the square time is strictly below q_n. Its canonical residue is exactly k^2, so there is no modular wrap. The first n+1 samples are zero and the next n+1 samples are one. The two averages at lengths n+1 and 2(n+1) are therefore 0 and 1/2 at that same point. These identities hold for every n symbolically. Pointwise bounds 0≤f≤1 and 0≤A_N f≤1 are proved for all inputs. The convention A_0=0 is harmless and every gap theorem requires N>0.

### One legitimate probability measure

The full power-set sigma algebra is a legitimate measurable structure on this countable Ω. All singletons and all functions out of Ω are measurable. The geometric PMF with parameter 1/2 gives component mass w_n=2^{-(n+1)}. Atom mass is w_n/q_n. Summing the q_n equal masses in each finite component gives w_n; summing over n gives one. The resulting PMF and its `toMeasure` are fixed and independent of N.

Every singleton has strictly positive measure. The forward and inverse rotations are measurable, and the pushforward agrees with the original measure on every singleton because rotation preserves the component index and all atom masses within a component are equal. Countable singleton extensionality gives equality on every set. Thus the precise transformation used in the averages preserves the precise probability measure used for the L-infinity norm.

### Actual L-infinity quotient and universal limit failure

`MemLp` membership of the observable and each average follows from measurability and the bound one. `averageLp` uses standard `MemLp.toLp`, which forms an almost-everywhere equivalence class in Mathlib's actual Lp space with exponent infinity. Relevant official definitions and bridge lemmas were read directly and recorded in the source-read manifests.

Because all singletons have positive measure, an almost-everywhere predicate holds at every point. Applying the official almost-everywhere bound by the essential supremum to the difference of the two averages and evaluating at the appropriate base point gives an essential-supremum lower bound of 1/2. `Lp.edist_toLp_toLp` transfers this bound to the distance between their actual quotient classes; the ordinary metric/norm identities and explicit extended-real conversion give the real norm bound. This is not an unproved identification with a pointwise supremum or a custom surrogate norm.

Every positive N is covered by N=n+1. The witness point may depend on N and its atom mass may decrease, but its mass is positive and all data defining the dynamical system remain fixed. For any supposed Cauchy tail, the indices N+1 and 2(N+1) lie beyond that tail and still have distance at least 1/2. This contradicts the Cauchy condition at epsilon 1/2. The final nonconvergence theorem excludes existence of every possible L-infinity limit by convergence implying the Cauchy property.

### Explicit nonergodicity

The newly added `component n` is the exact set of points whose first coordinate is n. Rotation has this set as its own preimage. The proof of `component_measure` sums the PMF over this component and obtains `cycleMass n`. At n=0 this equals 1/2. Since q_0=5, this is exactly the report's C_0={0}×Z/5Z.

The official Mathlib ergodicity definition includes the zero-one property for measurable invariant sets on a probability space. `rotation_not_ergodic` applies that property to C_0 and contradicts its mass 1/2. Thus the explicit nonergodicity assertion is now supported both mathematically and formally; it is not merely an informal label. This also accurately documents why the example does not resolve a separately imposed ergodicity hypothesis.

## Capstone, tests, and configuration

`Conjecture1925.counterexample` is an unconditioned conjunction over the fixed objects. Its clauses assert probability, bijectivity, measurability of forward and inverse maps, preservation, essential boundedness and pointwise bounds of the observable, genuine degree two, the average formula, all-positive-N quotient norm separation, failure to be Cauchy, absence of every limit, and nonergodicity. It uses the preceding concrete lemmas; it does not move the main conclusion into a premise or quantify a vacuous class of candidate systems.

`Tests.lean` was read entirely. Its examples check total mass, both inverse identities, preservation, membership in L-infinity, polynomial evaluations, zero-length behavior, the first witness, the all-N norm bound using direct toLp expressions, agreement of representatives at every point, positive witness masses, the invariant half-mass component, and universal no-limit quantification. These are formal integration checks and do not substitute finite numerical evidence for the general proof. The #print axioms commands request dependencies but their output must be assessed in the separate engineering audit.

The root module imports Tests, and the chain Tests → Counterexample → Nonconvergence → Measure → Dynamics covers all authored proof modules. `lakefile.lean` has one default library target, warnings as errors, and the stated Mathlib tag, with no custom hook. The frozen `lake-manifest.json` and `lean-toolchain` are byte-identical to the neutral inputs. They pin Lean 4.19.0, Mathlib v4.19.0 at revision c44e0c8ee63ca166450922a373c7409c5d26b00b, and explicit transitive revisions. This source inspection confirms intended configuration; execution and trust verification remain the engineer's responsibility.

## Full-report correspondence

The entire report, including abstract, original-claim discussion, construction, both proofs, nonergodicity paragraph, formal-correspondence section, and draft validation paragraph, was read. The component lengths, weights, indicator threshold, rotation, polynomial, normalization, witness point x_N=(N−1,0), witness mass 2^{-N}/(4N^2+1), gap, quantifiers, and nonergodicity all match the source. The essential-supremum argument correctly uses positive singleton mass even when that mass tends to zero. The Cauchy argument correctly rules out arbitrary limits, and the rate discussion does not invent a quantitative theorem.

The formal-correspondence section accurately describes the three core modules. The parent plans to add notes for the new capstone and tests and replace the explicitly provisional validation paragraph with actual engineering outcomes. Those are the only outstanding report edits known to this reviewer; their final text must be reviewed and hashed before a final report identity is certified. No correction to the mathematical exposition was found necessary.

## Independence and remaining boundary

Only the authorized original input, fresh author/frozen project and report, and official stock Mathlib source were consulted. No prior or competing solution, unrelated problem, external review, network source, or external message was consulted. Only independent-review files were written.

The mathematical/source-semantic review is complete for the frozen source identity above. Full submission validation remains conditional on successful independent engineering/trust results and final report/PDF handling; no maintainer acceptance or publication is implied.
