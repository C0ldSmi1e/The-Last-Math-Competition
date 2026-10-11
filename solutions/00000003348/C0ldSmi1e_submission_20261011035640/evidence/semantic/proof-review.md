# Frozen proof semantic review: 00000003348

Date: 2026-10-10. Reviewer role: independent semantic reviewer. Scope: the exact original bilingual statement and the frozen clean-author Lean project identified below. This is an internal review, not a submission report.

## Verdict

**PASS for proof correctness and semantic fidelity under the explicitly declared standard complex-polynomial interpretation. No proof defect or required source change found.** The development establishes an actual polynomial of degree two, its Julia set derived from bounded forward orbits, genuine uniform derivative expansion, and failure of the full Cantor-homeomorphism conclusion. The generic conjunction corollary is logically sufficient to refute the conjecture's conjunctive conclusion without assigning artificial meanings to dimension or pressure.

This verdict does not pretend that the brief original uniquely specifies all conventions. The report must retain the interpretation disclosures below. The full LaTeX/PDF report has not yet been supplied and is **not reviewed** by this document. A separately prepared dependency rebuild remains the engineering reviewer's scope.

## Materials and exact hashes

Initially, before any proposed proof was supplied, I assessed only the original and the two rules files, then permitted standard definitions and stock Mathlib. I later assessed a strategy supplied by the root, without author-code access. For this review I read all 216 lines of the current `Counterexample.lean`, all 40 lines of `Checks.lean`, the complete `lakefile.toml`, `AUTHOR_NOTES.txt`, and `AUTHOR_FREEZE_SHA256.json`; reread the original; and checked the toolchain, lock manifest, and frozen author build log as verification metadata. I did not read a discarded author's proof, repository solutions, selection/eligibility material, or another agent's history. I did not contact the author or edit the author's source. Provenance statements in `AUTHOR_NOTES.txt` are the author's/root's account, not independently established facts about every past access.

All entries recorded in the author freeze matched the files at review time:

| File | SHA-256 |
| --- | --- |
| `Counterexample.lean` | `f25d2eb1ae1a64c456645c739c88fc58f0c87c6675f4c70dda28eaf96069bfce` |
| `Checks.lean` | `f37cbe068bb8e58ebe8132c1ee13a8382105555be5bc6de82b6a2a4d76f1cca4` |
| `lakefile.toml` | `ac117c896288419873ec81469eb46ade148a5a8c1f0c6dbc95ae9c859411db44` |
| `lean-toolchain` | `55e97be96000b5e9e290c9e74482e5e317861499a5540353ce845471bded8cea` |
| `lake-manifest.json` | `56f7aa9722d120b38ffe868179164054411be9398660939609cb8a0c55e48637` |
| `build.log` | `9319ee2c143c86fe3086c3ebb81a8633e6b1963735936e6c0e34cf0bc908dbdd` |
| `AUTHOR_NOTES.txt` | `45e98ea27e67f89c9023c7b593eee9da75b114b88ac15b33a1a0102bc8f6126d` |

The freeze JSON itself has SHA-256 `ec8ae59929cfd0c55ddb1e42e1a42695b9c943d87b42261b2a47ada8eb21d3f9`. Source location: `/private/tmp/tlmc3348-clean-proof`. The two Lean-source hashes were rechecked after proof replay and were unchanged.

## Definitions and source fidelity

1. **Polynomial and degree, lines 27–37.** `squarePolynomial` is the genuine `Polynomial.X ^ 2` over `ℂ`; `square` is its actual evaluation map. The evaluation identity and natural degree are proved from library polynomial definitions. The final theorem requires degree at least two and supplies this concrete witness. No arbitrary self-map is relabelled as a polynomial.

2. **Filled Julia set, lines 39–41.** Membership is existence of one real norm bound valid for every natural iterate of the actual polynomial evaluation. This is genuine boundedness of the forward orbit. The bound is permitted to depend on the initial point, as it should. An explicit `R ≥ 0` condition is unnecessary: the zeroth iterate and nonnegativity of the norm already force any valid bound to be nonnegative.

3. **Julia set, lines 43–44.** `julia p` is Mathlib's topological frontier of that bounded-orbit set in `ℂ`. The definition can syntactically be applied to low-degree polynomials, but the counterexample/universal statements correctly restrict to degree at least two. This is the accepted standard polynomial boundary convention, supported by the primary-definition checks in the initial source assessment. The normal-family equivalence is not formalized and is not needed to adopt this definition. The notes accurately disclose that boundary convention.

4. **Cantor type, lines 46–47.** The predicate is actual existence of a homeomorphism from the entire Julia subtype to `ℕ → Bool`. The subtype has its inherited topology; the codomain has its standard product topology with discrete `Bool`. This is a genuine Cantor space, not merely an arbitrary disconnected set, finite Boolean set, symbolic label, or embedded Cantor subset. No homeomorphism is assumed for the counterexample.

5. **Uniform expansion, lines 49–54.** The definition requires compactness, forward invariance, genuine complex differentiability of every iterate, and constants `C > 0`, `L > 1` common to all points and all iteration times. It uses the standard derivative rather than an assigned multiplier. Including the zeroth iterate and requiring global complex differentiability are stronger regularity/normalization features than some standard formulations, not weakenings that could admit a spurious counterexample. Polynomials satisfy the extra differentiability requirement. The explicit real-tangent and local-distance lemmas further confirm the intended meaning.

These definitions satisfy the semantic bridges identified before author-code access. The original does not expressly impose whole-plane expansion, disjoint branches, a totally disconnected repeller, or an embedding problem with specified domain/codomain. The code does not silently introduce those conditions. The report should state that it interprets expanding polynomial conventionally as expanding **on its Julia set**. Squaring is not expanding on all of `ℂ`.

## Complete inference audit

| Source lines / declarations | Checked inference and outcome |
| --- | --- |
| 56–64: `square_iterate`, `norm_square_iterate` | Function extensionality connects actual polynomial evaluation to squaring. Stock `pow_iterate` gives exponent `2^n`; multiplicativity of the complex norm gives the orbit norm identity. This is computed iteration, not stipulated data. Correct, including `n = 0`. |
| 66–72: bounded orbit inside disk | `R = 1` bounds all powers of a norm in `[0,1]`. The proof covers the origin, boundary, and zeroth iterate. Correct. |
| 74–84: unbounded orbit outside disk | For a putative arbitrary bound `R`, Archimedean power unboundedness gives `R < ‖z‖^n`; `n ≤ 2^n` and monotonicity for a base greater than one imply `R < ‖z‖^(2^n)`, contradicting the actual orbit bound at time `n`. Correct; no unjustified inference from mere monotonicity to divergence. |
| 86–94: `filledJulia_square` | Both inclusions are proved with the preceding two lemmas and the exact closed-ball norm characterization. No set identity is assumed. |
| 96–103: Julia identity and membership | Stock frontier-of-closed-ball theorem at nonzero radius yields the sphere in the normed real plane underlying `ℂ`. This is the boundary of the **filled** Julia set, not a confusion of disk and circle. |
| 105–112: compactness and invariance | Properness of finite-dimensional `ℂ` gives compact sphere; norm multiplicativity shows squaring maps the unit circle into itself. These are properties of the identified Julia set. |
| 114–127: derivatives | Stock power differentiation proves `HasDerivAt` for each actual iterate; differentiability follows. On the Julia set, norm one reduces the coefficient norm to `2^n`. Natural subtraction in the exponent is harmless because `2^n ≥ 1`, and `n = 0` yields derivative one. |
| 129–140: complex/real tangent vectors | `fderiv_eq_deriv_mul` identifies the complex derivative as multiplication. Multiplicativity of the norm gives equality for every vector. Restriction of scalars for a genuinely complex-differentiable map identifies the real Fréchet derivative, yielding the same equality on the underlying real tangent plane. This closes the scalar-to-tangent semantic bridge. |
| 142–156: local metric expansion | Triangle inequality applied to `(z+w)+(z-w)=2z`, norm one for `z`, and `‖z-w‖≤1/2` give `‖z+w‖≥3/2`. Factoring the difference of squares and multiplying by the nonnegative distance give the asserted expansion. `w` may be any nearby complex point. The estimate is explicitly local and does not imply global injectivity. Correct. |
| 158–163: uniform-expansion witness | Combines already-proved compactness, invariance and differentiability with `C=1`, `L=2`; the exact derivative equality implies the common lower bound. No expansion premise is assumed. |
| 165–168: connectedness | Stock sphere connectedness requires real rank greater than one; `Complex.rank_real_complex = 2` discharges it. Radius one is nonnegative. Thus the proof is about a circle in the actual complex plane, not a two-point real sphere. |
| 170–176: failure of total disconnectedness | Applies the defining subsingleton condition to the whole connected Julia set. Both `1` and `−1` are proved members and are distinct in `ℂ`. The contradiction is valid and non-vacuous. |
| 178–186: Cantor bridge and obstruction | A hypothesized homeomorphism transports total disconnectedness from the product Cantor space back to the Julia subtype. The standard subtype equivalence returns total disconnectedness of the ambient subset, contradicted above. Thus the full `CantorType` predicate is actually negated. |
| 188–201: witness and universal negation | Packages the same polynomial, true degree bound, genuine expansion, and failed Cantor conclusion. Eliminating that witness contradicts the asserted universal statement. No existential or implication scope error. |
| 203–214: arbitrary conjunction | A proof of `CantorType ∧ additionalConclusion` would yield `CantorType` by first projection. This contradicts the previous universal negation for every possible second predicate. The explicit comments correctly deny that the arbitrary predicate itself defines pressure. |

The comments and theorem statements accurately describe the mathematics. I found no hidden hypothesis forcing the result, shadow definition changing a standard primitive, axiom supplied for the example, unproved equality replacing Julia, or numerical surrogate replacing differentiation.

## Supporting library checks

I inspected the relevant stock source at `/private/tmp/tlmc4607-restored-stock/mathlib`, including:

- `Algebra/Group/Basic.lean`: `pow_iterate` and its induction.
- `Algebra/Order/Archimedean/Basic.lean`: genuine power-unboundedness theorem.
- `Analysis/NormedSpace/Real.lean`: frontier of a nonzero-radius closed ball, proved from closure/interior facts.
- `Analysis/NormedSpace/Connected.lean`: sphere path-connectedness in real rank greater than one and consequent connectedness.
- `Data/Complex/FiniteDimensional.lean`: real dimension/rank of `ℂ` is two.
- `Topology/MetricSpace/ProperSpace.lean`: compactness of spheres in proper spaces.
- `Analysis/Calculus/Deriv/Pow.lean`: power derivative theorem from actual strict derivatives.
- `Analysis/Calculus/Deriv/Basic.lean`: scalar derivative/Fréchet derivative relation.
- `Analysis/Calculus/FDeriv/RestrictScalars.lean`: real derivative is the restriction of the complex derivative under differentiability.
- `Topology/Order.lean`: `Bool` has the discrete topology.
- `Topology/Connected/TotallyDisconnected.lean`: actual subset definition, discrete-to-totally-separated-to-totally-disconnected instances, product preservation, and subtype equivalence.
- `Topology/Homeomorph/Lemmas.lean`: transport of total disconnectedness by a homeomorphism.

The inspection establishes the meaning of the imported facts. It is not a claim to have manually audited every transitive Mathlib theorem or its entire trusted code base.

## Checks, configuration, and independent replay

`Checks.lean` has six boundary/scope examples: origin in the filled Julia set, origin outside the Julia set, derivative zero at the origin, derivative one for the zeroth iterate, equality of the images of `1` and `−1`, and noninjectivity of squaring. These examples compile and accurately distinguish the relevant notions. They supplement the proof rather than replace any universal argument.

The project configuration declares both `Counterexample` and `Checks` as default targets, enables `warningAsError`, and requests Mathlib `v4.19.0`. The lock pins Mathlib commit `c44e0c8ee63ca166450922a373c7409c5d26b00b`; the toolchain is Lean 4.19.0. The configuration has no custom build script, unusual evaluator, or proof-disabling option.

For fresh proof replay I copied the two exact source files into `/private/tmp/tlmc3348-independent-review/replay`, checked their SHA-256 equality, and invoked the supplied Lean binary directly with `-DwarningAsError=true`. I freshly generated the reviewer's `Counterexample.olean`, then checked `Checks.lean` with the reviewer's directory first in `LEAN_PATH`, so the checks imported that newly generated proof artifact. The package-library search paths pointed to the existing package artifacts in the clean project; I did not rebuild those dependencies in this semantic review or alter the author project.

- Compiler identity: `Lean (version 4.19.0, arm64-apple-darwin23.6.0, commit 6caaee842e94, Release)`.
- Fresh `Counterexample.lean` check: exit 0, empty diagnostic log.
- Fresh `Checks.lean` check: exit 0.
- All 15 printed axiom dependencies: only `propext`, `Classical.choice`, `Quot.sound`.
- Source search found no `sorry`, `admit`, custom `axiom`, `unsafe`, external implementation, `native_decide`, or altered proof options. The word `axioms` appears solely in the audit commands.

Replay logs are `replay/Counterexample.replay.log` and `replay/Checks.replay.log` under this review directory. This is an independent **source replay**, not an independent reconstruction of all dependency artifacts. The engineering review must supply that separate environment/dependency verification if required. The author freeze and original source hashes remained unchanged after replay.

## Issues and outstanding document review

**Blocking proof/source issues: none.** The standard interpretation does not weaken an explicit original hypothesis. Instead it supplies missing conventional context and proves an example satisfying a substantive uniform-expansion condition.

The later report must faithfully state:

1. The ambient interpretation is degree-at-least-two complex polynomials, and expansion is on the Julia set in the Euclidean derivative sense. A whole-plane or fully general dynamical claim is not established.
2. The Julia set is formalized by bounded orbits and frontier; equivalence with the normal-family convention is a standard cited fact, not a newly formalized theorem here.
3. The entire Julia set fails to be homeomorphic to Cantor space. The result does not deny that it contains an embedded Cantor subset.
4. The vague phrase about embedding expansive kernels has no supplied mathematical definition; it supplies no hidden separation hypothesis.
5. The first conjunct is false. Neither Hausdorff dimension nor pressure is computed, and the pressure-dimension relation in isolation is not claimed false.
6. The generic second predicate expresses only the logic of conjunction; it is not a formal pressure definition.

The LaTeX argument, citations, proof inventory, PDF rendering, and complete report/Lean match remain to be reviewed when those artifacts are frozen and provided. Those pending artifacts do not affect the present positive verdict on the frozen Lean proof.
