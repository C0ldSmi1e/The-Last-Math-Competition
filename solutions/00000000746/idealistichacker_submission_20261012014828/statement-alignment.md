# Source-To-Lean Alignment

The original bilingual source is unchanged in source.md. We use the ordinary local analytic-germ
meaning of the named p-adic Koenigs/Schroder function. The source does not state an integral-input,
polynomial-input, global analyticity or fixed unit-disk condition. Adding one would alter the
conjecture. If organizers later require one, reassess rather than claiming a corrected statement
was disproved. Rational coefficients allow the literal necessary bound: no reduced denominator
is divisible by p squared. The stronger reading allowing only denominators1 orp implies this too.

## Complete Actual Premises

K is Mathlib Q_[3], with an audited Fact that3 is prime. U is the actual open norm ball
norm x<1/3 containing0, not an empty or assigned domain. Norm unit theorems prove all denominators
nonzero onU. H,F,J are K-analytic on neighborhoods of every point inU. Actual derivatives are
H'(0)=1 andF'(0)=3;3 is nonzero and has norm1/3. F(0)=H(0)=0.

F mapsU toU and normF(x)=normx/3. Lean induction on Function.iterate proves every orbit stays
inU, its exact norm at eachn is(1/3)^n normx, and its actual points Tendsto0. The functional
identity is H(F(x))=3H(x) for EVERYx inU. J is a genuine analytic inverse with J(Hx)=x and
H(Jx)=x onU, and bothH/J preserveU. ThusH is an analytic local coordinate, not merely a
formal eigenfunction. actual_analytic_conjugacy_on_U packages the stronger inverse evidence.

The actual full geometric HasSum for EVERYx inU gives HasFPowerSeriesAt H P0 where
P=FormalMultilinearSeries.ofScalars of the Q3 embeddings of a0=0,a(n+1)=3^-n.
coeff_P proves the actual coefficient equality. Rat's canonical normal-form denominator theorem
gives a(n+1).den=3^n; a_three_den gives9, so the actual degree-three coefficient violates the bound.
H_rational_coefficients_unique proves any rational coefficient series for the SAMEgermH has
these coefficients. It does not prove uniqueness among all normalized Schroder functions.

## Closed Negation And Trust

NormalizedAnalyticSchroder is a transparent conjunction of the above actual premises, including
both actual series specifications and all-orbit attraction. actual_normalized_Schroder proves
F/H/U/a satisfies it; exists_actual_counterexample gives genuine witnesses and the bound's
negation. necessary_denominator_claim_false negates its corresponding necessary universal
assertion. A universal original claim about all primes and attracting analytic germs implies
this specializedp=3,lambda=3 assertion, so its negation refutes the denominator clause. No
unproved existence premise or arithmetic Boolean assigned to false is left in the theorem.

Local instances use the ordinary inherited K field/self-module/normed-space structures;
self_smul_eq_mul is definitional equality with multiplication, not a changed norm or topology.
The type-checking transparency option introduces no axiom or evaluation bypass. All45 public
theorems and the prime instance are printed inCheck.lean and checked against the standard
foundation allowlist. Exact Python rational samples are auxiliary only. The original analytic
convergence claim is true for this witness and is not refuted.

## Verification Boundaries

No general Koenigs existence theorem, universal linearization algorithm, global nonsingularity,
corrected integral-input assertion, arbitrary p-adic irrational denominator or first-solve status
is advertised. main.tex supplies the complete explicit proof. Final independent review must read
both source languages, full theorem types/proofs, all PDF pages and actually execute the frozen
reproducer. It is correlated AI review, not human certification. Publication still requires fresh
duplicate/source/status/WIP/identity checks and maintainer review remains external.
