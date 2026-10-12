# Independent auxiliary source review — 00000007160

Scope: the entire `auxiliary/check_examples.py`, read independently before any author Lean or report source. This is implementation verification of finite sanity checks, not proof of Hoffman–Wielandt. No previous submissions, competing proofs, sessions, root/selector notes, or neighboring problems were read.

Reviewed source SHA-256:

    37d2866b5ef589820a73c48d91b8df95d0ad17a50ee1ebd955669181fb4dc136

## Finding

No mathematical or implementation defect was found in the script for its stated internal inputs and finite-check purpose. The full script replay exited 0 with empty stderr and the source hash was unchanged. The reviewer also ran 71 explicit-oracle probes, all successful. Those probes exercise the implementation; they are not a second general proof.

The script imports only Python standard-library facilities, performs no file/network/process operations, and prints one JSON result. The review replay and probes were run with `-B` and `PYTHONDONTWRITEBYTECODE=1`; review-created files are restricted to `independent-review`.

## Source inspection

`QComplex` stores both coordinates as `Fraction`. Addition, subtraction, multiplication, conjugation, and squared modulus have the exact complex arithmetic formulas. The frozen dataclass is immutable and hashable, so repeated constants in polynomial lists cannot be mutated through aliasing and `set` correctly detects equal eigenvalues. The script never converts its matrix arithmetic to floating point.

`adj` transposes and conjugates. `mul`, `diag`, and `ident` use the ordinary square-matrix formulas. `normal` compares A A* and A* A exactly; it is not merely a Hermitian or diagonal check. `frobenius_difference_sq` sums squared complex moduli of every entry of A − B. It uses the unnormalized Frobenius square intended by the conjecture.

`characteristic_polynomial` independently computes det(xI − A) by the Leibniz formula. The permutation sign counts inversions, each factor is −a_(i,p(i)) + δ_(i,p(i))x, and polynomial coefficients are accumulated in ascending degree. Thus the comparison with the product of (x − λ) checks the whole characteristic polynomial, including multiplicity, instead of merely checking selected eigenvectors. Polynomial multiplication is the usual exact coefficient convolution. At dimension zero, the unique empty permutation contributes the constant 1, so the empty determinant is handled correctly.

`matching_costs` enumerates every permutation of the eigenvalue index set. For the equal-length lists passed by this script, each candidate is a bijection using every eigenvalue exactly once. The empty list has the single empty permutation with cost zero, so `min` is well-defined at n = 0.

`unitary` composes diagonal phases in {1, −1, i, −i} and rational plane rotations whose entries satisfy c² + s² = 1. Both U U* = I and U* U = I are explicitly checked for generated nonempty matrices. For n = 0 it directly returns the unique empty identity, which has these properties. Separate unitaries for A and B generate pairs that need not commute. `check_pair` additionally checks normality, full characteristic-polynomial factorization, and the exact minimum matching inequality, so the replay does not accept the generator's spectral labels solely because it constructed them.

These routines are internal finite-test helpers, not general-purpose validated matrix APIs. For example, `check_pair` validates outer dimensions but not individual row lengths, and `matching_costs` itself does not validate equal input lengths. Every actual call constructs square matrices and equal-length lists by inspection. These omissions do not invalidate the reported checks and need no change for the stated purpose.

## Coverage verified

The deterministic replay checks 361 generated normal pairs: one in dimension 0 and 120 each in dimensions 1, 2, and 3. The reported categories overlap: 194 pairs do not commute, 335 have at least one non-Hermitian member, 127 have repeated eigenvalues in at least one spectrum, and 188 have a strict matching inequality. The script requires all four nontrivial categories to occur. Complex phases and nonreal diagonal values exercise complex normal matrices, not just real symmetric examples.

Four additional controls are correct:

1. A = B = diag(0, 1), with opposite spectrum enumerations, has optimal cost and Frobenius bound zero but cost 2 under the fixed enumeration. This demonstrates why the theorem needs permutation matching.
2. diag(0, 0, 1) and diag(0, 1, 1) have the same set of distinct eigenvalues but different multiplicities; both the optimal matching cost and Frobenius square are 1. This demonstrates loss of information from a set-only representation. It is a semantic control, not a counterexample to a set-valued upper-bound inequality, which would be weaker.
3. Zero and I₃ have matching cost and Frobenius square 3, while the ordinary Euclidean operator norm of their difference has square 1. This refutes replacement of the Frobenius bound by the unscaled operator norm in the same ℓ² matching statement. The script hard-codes 1 rather than implementing an operator-norm routine; the analytical identity ‖I₃‖₂ = 1 makes that valid for this exact example.
4. The nonnormal matrices [[0,1],[0,0]] and [[0,1],[1/4,0]] have characteristic polynomials x² and x² − 1/4. Their optimal squared matching cost is 1/2 while the squared Frobenius difference is 1/16. The source verifies nonnormality, the characteristic polynomials, and these costs exactly. Thus it supplies a genuine counterexample to dropping normality entirely.

The positive-control calls are additional to the 361 generated normal pairs; the `normal_pairs` counter is not a total count of every `check_pair` invocation. The labels printed by the source make no conflicting claim. Reports should describe the four examples as “semantic controls”; calling all four “invalid-strengthening counterexamples” would overstate the multiplicity example.

## Independent implementation probes

The reviewer-created `independent_auxiliary_probes.py` imports definitions without invoking the source's `main`. It checks 60 rational-pair scalar arithmetic cases and 11 explicit matrix/polynomial/permutation cases. Independent expected formulas include det(xI − C) = x³ − 1 for the off-diagonal cyclic permutation matrix, det(xI − iI₃) = x³ − 3ix² − 3x + i, and det(xI − H) = x² − 1 for H = [[0,i],[−i,0]]. It also checks the empty determinant and empty matching, scalar characteristic polynomial, conjugate transpose, normal and nonnormal examples, both two-point matching costs, and a direct entrywise Frobenius-square calculation. All 71 checks passed.

## Durable evidence and limits

`AUXILIARY_REPLAY_MANIFEST.json` records the reviewed source hash before and after replay, Python runtime, exact command, exit status, stdout/stderr hashes, and reviewer probe source/output hashes. Raw outputs are preserved as `auxiliary-replay.stdout.json`, `auxiliary-replay.stderr.txt`, `independent-probes.stdout.json`, and `independent-probes.stderr.txt`.

These examples neither cover all matrices nor establish a universal implication. In particular, finite dimensions 0–3 and a finite rational input family cannot substitute for a theorem quantifying arbitrary finite complex normal matrices. The script explicitly states this limitation. Its proper role in the final package is reproducible semantic sanity checking alongside the general Lean proof and mathematical report. The full conjecture review remains pending frozen Lean and report sources.
