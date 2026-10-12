# Independent source review: conjecture 00000001741

Review date: 2026-10-12. Reviewer: independent AI agent assigned to semantic and source review. This is not competition-maintainer acceptance.

**Disposition: source-level clearance for the literal disproof. No correctness issue found in either reviewed Lean source.** The formal theorem refutes the conjunction printed in the bilingual original. It does not prove the infinitude clause false, and it does not resolve a conjecture with “increased” replaced by “decreased.”

No independent compilation or runtime axiom audit was performed in this review. The coordinating agent is conducting the separate fresh build and runtime checks. Configuration, the source manifest, report, and PDF are outside this source review; the mathematical source hashes below identify precisely what was inspected.

## Sources and integrity

All paths below are relative to:

`/Users/daniel/.codex/visualizations/2026/10/04/01a10508-f155-7f33-b06c-d34f02168fbf/competition-work`

| Inspected source | SHA-256 |
| --- | --- |
| `1741/author/HallReverse.lean` | `cd4886721c5149d8ab3497feee968ec58df1ad5cfefc820b10a9074071710633` |
| `1741/author/Verification.lean` | `0a8f742c33f543b54e13f1b6f2d10458b7fe267ce042b60ac4a5fc674669f6c9` |
| `clean-conjecture-corpus/00000001741.md` | `c703aa91d423fbc1e16edad2b866bb0e66324fbdb5ff0532e32b20d748a04179` |
| `selection-after1925/RULES.en.md` | `200d9a783c08a5edfd1b508e6942b3b851a63c726506291f6de6a59773f1163a` |
| `selection-after1925/RULES.zh-CN.md` | `7c5b49bb84403feea1eb14d23d48491400c7749d58db345cd317231949a9e82b` |

The original and rules were read during this agent's preceding independent semantic screening. The two Lean modules were read in full for this review. No competing submission, previous candidate proof, or network proof was consulted. No author source was edited.

## Mapping to the literal conjecture

The English original asserts infinitely many pairs satisfying

\[
0<|x^3-y^2|<\sqrt{x}(\log x)^{1/4},
\]

and adds “the exponent 1/4 cannot be increased.” The Chinese independently says “指数 1/4 不可再增大.” Both therefore specify the same direction of optimality.

`gap`, `upperBound`, and `admissible` in `HallReverse.lean:19–28` retain the exact displayed bound and all required restrictions. In particular:

- The coordinates belong to `ℕ × ℕ`, and both must be strictly positive. This represents the original positive-integer domain without an off-by-one convention.
- Both powers are taken after coercing to `ℝ`; subtraction therefore retains its sign before absolute value. It is not truncated natural subtraction.
- The lower and upper bounds are both strict. The nonzero-gap condition is not dropped.
- `Real.sqrt` is the nonnegative real square root and `Real.log` is the natural logarithm. The exponent argument has type `ℝ`, so the last power is the real power operation rather than a natural power or integer division.
- `(1 : ℝ) / 4` is the real number one quarter.

`infinitelyMany` at line 31 is actual `Set.Infinite` for the set of distinct ordered pairs satisfying those predicates. It is not an infinite list that may repeat a solution, a large finite sample, or an unproved claim of unboundedness.

`cannotIncrease` at lines 34–35 makes the parenthetical precise as

\[
\forall b\in\mathbb R,\quad b>1/4\Longrightarrow\neg I(b),
\]

where \(I(b)\) is this actual infinitude predicate. This is equivalent to saying there is no strictly larger exponent for which the same infinitude assertion holds. `conjecture` at line 38 takes its conjunction with \(I(1/4)\), exactly the literal combination being refuted.

Real exponents are a natural interpretation of the original unrestricted exponent language. The contradiction uses the concrete exponent 1, so it would also refute the same non-increase claim restricted to rational exponents. It does not depend on adding an exotic class of exponents.

The phrase “optimal” is treated as explicated by the immediately following parenthetical, rather than silently corrected to the opposite direction. Both languages support that reading. The theorem's scope and the source's opening comment make the limitation explicit.

## Proof review

### Finite fibers and bounded strips

`finite_fiber` at lines 42–56 proves finiteness for each fixed first coordinate, for every real exponent. It chooses a natural number \(M>x^3+B\), where \(B\) is the real upper bound. For an admissible pair, positivity of the integer \(y\) yields \(1\le y\) and hence \(y\le y^2\). The lower half of `abs_lt` yields

\[
-B<x^3-y^2,
\]

and therefore \(y^2<x^3+B<M\). Combining the inequalities gives \(y<M\). Thus the fiber is a subset of the finite image of \(\{y\in\mathbb N:y<M\}\) under \(y\mapsto(x,y)\).

The argument bounds the actual integer coordinate, not merely its real image. Both uses of `exact_mod_cast` have the intended natural/real comparison meanings. It does not need an assumed nonnegativity of \(B\): existence of an admissible pair supplies the needed inequalities. Consequently the generality over all real exponents causes no gap.

`finite_below` at lines 59–65 takes a finite union of these finite fibers over \(x<N\). This discharges the essential point that finitely many possible first coordinates alone would not imply finitely many pairs.

`infinite_tail` at lines 68–75 removes that finite strip from an infinite set and maps the remaining set into the tail \(N\le x\). Its only assumption is the actual infinitude predicate at the same exponent. The proof of the tail condition uses the natural-order complement of \(x<N\), with no extra growth assumption.

### Eventual comparison of real powers

`upperBound_mono` at lines 79–84 requires \(\exp(1)\le x\). Positivity of \(\exp(1)\), monotonicity of the logarithm, and \(\log(\exp(1))=1\) give \(1\le\log x\). The real-power theorem is then applied to a base at least one, precisely the domain where increasing an exponent increases or preserves the value. Multiplication by the nonnegative square root preserves the comparison.

The proof does not claim this comparison for the small positive integers with \(\log x<1\). Those exceptional coordinates are dealt with through finiteness, not ignored. The weak cutoff \(\exp(1)\le x\), rather than a strict cutoff, is sufficient since base one also permits the desired non-strict comparison.

`infinitelyMany_mono` at lines 88–96 chooses a natural cutoff above or equal to \(\exp(1)\), invokes the infinite-tail theorem, preserves both positive-coordinate guards and the nonzero-gap guard, and combines the original strict upper inequality with the non-strict comparison. The resulting upper inequality is still strict. This proves

\[
a\le b\quad\Longrightarrow\quad I(a)\Longrightarrow I(b).
\]

Real-power totalizations at zero or negative bases do not affect the target assertion. The target uses positive coordinates and positive exponents; its only zero logarithm occurs at \(x=1\), which contributes no solution at exponent one quarter. The eventual comparison uses \(\log x\ge1\). The more general monotonicity theorem remains justified by its finite-exception argument even at arbitrary real exponents.

### Negation of the complete conjunction

`quarter_infinitude_refutes_optimality` at lines 100–103 assumes \(I(1/4)\) and obtains \(I(1)\) by monotonicity. Since \(1/4<1\), the asserted `cannotIncrease` would give \(\neg I(1)\). The contradiction therefore refutes exactly that optimality clause conditional on the infinitude clause.

`conjecture_false` at lines 106–108 introduces both clauses of the defined conjunction and applies that conditional result. Its theorem type is unconditional `¬ conjecture`: it has no hidden Hall hypothesis, no imported infinitude theorem, and no arithmetic existence assertion stronger than what was proved.

The Hall-definition preamble is not assumed or exploited. In particular, the source does not derive a vacuous result from the preamble's omission of a nonzero-gap restriction. It addresses the reverse conjecture's own explicit nonzero-gap condition.

## Verification coverage and source trust

`Verification.lean` contains 13 examples. Their combined coverage is appropriate for the small formal development:

| Verification lines | Property checked |
| --- | --- |
| 11–12 | Absolute value after signed real subtraction, with both signs of the cube-square difference |
| 15–16 | Exclusion of each zero coordinate |
| 19–20 | Exclusion of every exact cube-square coincidence \((n^2,n^3)\) |
| 23–27 | The zero logarithmic bound at \(x=1\), and consequent absence of solutions there |
| 30–35 | Full definition expansion, including the domain, both strict inequalities, and exact analytic expression |
| 38–40 | Actual infinitude after deleting an arbitrary bounded-first-coordinate strip |
| 43–47 | Explicit larger exponents 1 and 5/4, and general monotonicity of the infinitude predicate |
| 50–62 | The final negation with both clauses fully expanded, including all guards and real exponent quantification |

The expanded final example is particularly useful for auditing the statement independently of the names `cannotIncrease` and `conjecture`. It rules out the possibility that the final theorem only negates an unrelated shorthand proposition.

No `sorry`, `admit`, user-added axiom, opaque proof replacement, unsafe declaration, or numerical logarithm approximation is present in the reviewed modules. The author included `#print axioms` commands for all seven named theorems in `HallReverse.lean:112–118`. Their runtime output must still be checked by the separate build audit; source presence alone does not establish a successful build or the output of those commands. Standard logical axioms used by Mathlib are not an illicit Hall assumption.

These examples support definition and boundary auditing. The general fiber, tail, and monotonicity theorems themselves establish the infinite-family reasoning; it does not rest on example counts or sampled numerical data. No missing source-level regression check was found that would block this proof's semantic clearance.

## Findings and review limits

There are no actionable source findings. The implementation is faithful to a complete disproof of the literal conjunction, and the proof logic handles the finite exceptional strip correctly.

The source-level clearance remains limited to the exact hashes recorded above. This review does not certify the Lake configuration, reproducibility, successful compilation, printed axiom list, report-to-source consistency, PDF rendering, absence of a prior accepted solution, or maintainer acceptance. Those are separate requirements under the supplied rules and require the coordinated build and report review.

Any final report should retain the source's explicit restriction: the contradiction concerns the stated upward optimality. It must not describe `conjecture_false` as \(\neg I(1/4)\), as a resolution of standard Hall's conjecture, or as a solution of a corrected downward-optimality conjecture. With that scope retained, no semantic hold is warranted.
