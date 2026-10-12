import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.SpecialFunctions.Sqrt
import Mathlib.Data.Set.Finite.Lattice
import Mathlib.Tactic

/-!
# A literal disproof of conjecture 00000001741

The final sentence asserts that the exponent in an *upper* bound cannot be
increased. We formalize both clauses and refute their conjunction by proving
that infinitude is preserved by increasing this exponent. We make no assumption
of Hall's conjecture and do not settle the isolated infinitude clause.
-/

namespace HallReverse

/-- The integer cube-square gap, evaluated after coercion to the reals so that
subtraction is not truncated natural-number subtraction. -/
def gap (x y : ℕ) : ℝ := |(x : ℝ) ^ 3 - (y : ℝ) ^ 2|

/-- The exact logarithmically corrected upper bound at exponent `a`. -/
noncomputable def upperBound (a : ℝ) (x : ℕ) : ℝ :=
  Real.sqrt (x : ℝ) * (Real.log (x : ℝ)) ^ a

/-- Both integers are positive and the gap is strictly between zero and the
stated upper bound. -/
def admissible (a : ℝ) (p : ℕ × ℕ) : Prop :=
  0 < p.1 ∧ 0 < p.2 ∧ 0 < gap p.1 p.2 ∧ gap p.1 p.2 < upperBound a p.1

/-- Infinitely many distinct pairs, rather than a repeated enumeration. -/
def infinitelyMany (a : ℝ) : Prop := Set.Infinite {p : ℕ × ℕ | admissible a p}

/-- The literal meaning of “the exponent 1/4 cannot be increased.” -/
def cannotIncrease : Prop :=
  ∀ b : ℝ, (1 : ℝ) / 4 < b → ¬ infinitelyMany b

/-- The two assertions in the original conjecture, as one conjunction. -/
def conjecture : Prop := infinitelyMany ((1 : ℝ) / 4) ∧ cannotIncrease

/-- Fixing `x` leaves only finitely many admissible `y`, because the upper gap
bound forces an upper bound on `y²` and hence on the positive integer `y`. -/
theorem finite_fiber (a : ℝ) (x : ℕ) :
    Set.Finite {p : ℕ × ℕ | admissible a p ∧ p.1 = x} := by
  obtain ⟨M, hM⟩ := exists_nat_gt ((x : ℝ) ^ 3 + upperBound a x)
  apply ((Set.finite_lt_nat M).image (fun y : ℕ => (x, y))).subset
  rintro ⟨u, y⟩ ⟨hp, hux⟩
  dsimp at hux
  subst u
  refine ⟨y, ?_, rfl⟩
  have hy : (1 : ℝ) ≤ (y : ℝ) := by exact_mod_cast hp.2.1
  have hy_sq : (y : ℝ) ≤ (y : ℝ) ^ 2 := by
    nlinarith [mul_nonneg (show 0 ≤ (y : ℝ) by positivity) (sub_nonneg.mpr hy)]
  have hgap : -(upperBound a x) < (x : ℝ) ^ 3 - (y : ℝ) ^ 2 :=
    (abs_lt.mp hp.2.2.2).1
  have hyM : (y : ℝ) < (M : ℝ) := by linarith
  exact_mod_cast hyM

/-- A bounded set of first coordinates contributes only finitely many pairs. -/
theorem finite_below (a : ℝ) (N : ℕ) :
    Set.Finite {p : ℕ × ℕ | admissible a p ∧ p.1 < N} := by
  have hfinite := (Set.finite_lt_nat N).biUnion
    (fun x _ => finite_fiber a x)
  apply hfinite.subset
  intro p hp
  exact Set.mem_iUnion.mpr ⟨p.1, Set.mem_iUnion.mpr ⟨hp.2, hp.1, rfl⟩⟩

/-- Beyond any fixed cutoff, an infinite admissible set is still infinite. -/
theorem infinite_tail {a : ℝ} (h : infinitelyMany a) (N : ℕ) :
    Set.Infinite {p : ℕ × ℕ | admissible a p ∧ N ≤ p.1} := by
  have hd := h.diff (finite_below a N)
  apply hd.mono
  intro p hp
  refine ⟨hp.1, ?_⟩
  by_contra hn
  exact hp.2 ⟨hp.1, by omega⟩

/-- For logarithmic base at least one, increasing its exponent increases the
right-hand side of the exact inequality. -/
theorem upperBound_mono {a b : ℝ} (hab : a ≤ b) {x : ℕ}
    (hx : Real.exp 1 ≤ (x : ℝ)) : upperBound a x ≤ upperBound b x := by
  have hlog : (1 : ℝ) ≤ Real.log (x : ℝ) := by
    simpa only [Real.log_exp] using Real.log_le_log (Real.exp_pos 1) hx
  exact mul_le_mul_of_nonneg_left (Real.rpow_le_rpow_of_exponent_le hlog hab)
    (Real.sqrt_nonneg _)

/-- The key unconditional implication: infinitude at an exponent persists at
every larger exponent. The finitely many small values of `x` are removed first. -/
theorem infinitelyMany_mono {a b : ℝ} (hab : a ≤ b)
    (h : infinitelyMany a) : infinitelyMany b := by
  obtain ⟨N, hN⟩ := exists_nat_ge (Real.exp 1)
  apply (infinite_tail h N).mono
  intro p hp
  refine ⟨hp.1.1, hp.1.2.1, hp.1.2.2.1, ?_⟩
  apply lt_of_lt_of_le hp.1.2.2.2
  apply upperBound_mono hab
  exact hN.trans (by exact_mod_cast hp.2)

/-- The written optimality assertion fails whenever its infinitude assertion
holds; exponent `1` is one explicit strictly larger exponent. -/
theorem quarter_infinitude_refutes_optimality
    (h : infinitelyMany ((1 : ℝ) / 4)) : ¬ cannotIncrease := by
  intro hc
  exact hc 1 (by norm_num) (infinitelyMany_mono (by norm_num) h)

/-- The complete literal conjecture is false. -/
theorem conjecture_false : ¬ conjecture := by
  rintro ⟨hi, hc⟩
  exact quarter_infinitude_refutes_optimality hi hc

end HallReverse

#print axioms HallReverse.finite_fiber
#print axioms HallReverse.finite_below
#print axioms HallReverse.infinite_tail
#print axioms HallReverse.upperBound_mono
#print axioms HallReverse.infinitelyMany_mono
#print axioms HallReverse.quarter_infinitude_refutes_optimality
#print axioms HallReverse.conjecture_false
