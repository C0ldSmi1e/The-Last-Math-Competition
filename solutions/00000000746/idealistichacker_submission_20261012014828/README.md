# Disproof of 00000000746: an actual attracting 3-adic Schroder germ

On Q3, set H(x)=x/(1-x/3), F(x)=3x/(1+2x/3) and U={x : norm x<1/3}.
The analytic maps have H(0)=F(0)=0, H'(0)=1 and F'(0)=3 with norm3=1/3.
Every orbit in the invariant open neighborhood U converges to0, and H(F(x))=3H(x).
The analytic inverse J(x)=x/(1+x/3) preserves U and both inverse identities hold.

The ACTUAL convergent power series of H is sum_(n>=0)3^(-n)x^(n+1).
Its degree-three coefficient is1/9 with canonical reduced denominator9.
This contradicts the source's first-power-only p-denominator claim, while convergence itself remains true.

## Formal Scope

Lean uses actual Q_[3], K-analytic maps and derivatives, all-point HasSum and HasFPowerSeriesAt,
actual multilinear-series coefficients and rational denominators, actual Function.iterate/Tendsto,
and the explicit local analytic inverse. It constructs a witness satisfying every premise and
proves the necessary denominator assertion's negation. Check.lean audits all45 public theorems
and the prime instance. No unsupported Boolean-only formalization or new assumptions are used.

Both exact source languages are preserved in source.md; the full Git commit, blob and raw SHA-256
are recorded in submission.json. statement-alignment.md records each bridge and its limitations.

## Reproduction

Use Python3.11+, Git and the exactly pinned Lean4.33.1:

```text
python -X utf8 reproduce.py --repo /path/to/The-Last-Math-Competition --lake /path/to/lean4.33.1/bin/lake
```

The default updates the portable pinned Git dependencies, then verifies every HEAD/origin and
clean tracked source, clean-builds this project's own code with warnings as errors and checks
every printed transitive axiom. Existing exact physical dependency checkouts can use explicit
--skip-update after the same verification. Dependency caches, external path substitutions and
tool binaries are not submitted. To build the actual PDF, use Tectonic0.15.0 with SOURCE_DATE_EPOCH=0.

## Interpretation And Limits

This uses the ordinary LOCAL analytic-germ meaning of p-adic Koenigs/Schroder. Neither original
language restricts inputs to integral coefficients, polynomials, globally analytic maps or a
fixed unit disk. Such corrected statements are not refuted here. All division identities and
analytic assertions are restricted to U where denominators are proved nonzero. Rational
coefficients make the canonical denominator assertion unambiguous. Only the denominator clause,
not convergence or local linearization, fails. Coefficient uniqueness for this H is proved;
no general uniqueness theorem for all Schroder germs is advertised.

AI-assisted implementation and a different independent Agent review for idealistichacker.
No human expert approval, institutional affiliation, first-solve credit or acceptance is claimed.
