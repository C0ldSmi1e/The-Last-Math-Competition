import HallReverse

/-!
Verification checks for the exact definitions, boundary cases, and theorem scope.
All checks are kernel-checked proofs, not numerical approximations to logarithms.
-/

namespace HallReverse.Verification

-- Opposite signs verify that subtraction occurs in ℝ before absolute value.
example : gap 2 3 = 1 := by norm_num [gap]
example : gap 3 5 = 2 := by norm_num [gap]

-- Zero coordinates are excluded by the positive-integer guards.
example (a : ℝ) (y : ℕ) : ¬ admissible a (0, y) := by simp [admissible]
example (a : ℝ) (x : ℕ) : ¬ admissible a (x, 0) := by simp [admissible]

-- The nonzero-gap guard excludes all exact cube-square coincidences.
example (a : ℝ) (n : ℕ) : ¬ admissible a (n ^ 2, n ^ 3) := by
  simp [admissible, gap, ← pow_mul, Nat.mul_comm]

-- x = 1 has logarithmic bound zero at the exact exponent in the original.
example : upperBound ((1 : ℝ) / 4) 1 = 0 := by norm_num [upperBound]
example (y : ℕ) : ¬ admissible ((1 : ℝ) / 4) (1, y) := by
  intro h
  have hupper : gap 1 y < 0 := by simpa [upperBound] using h.2.2.2
  exact (lt_trans h.2.2.1 hupper).false

-- This definition check exposes every guard and the exact analytic expression.
example (a : ℝ) (x y : ℕ) :
    admissible a (x, y) ↔
      0 < x ∧ 0 < y ∧
        0 < |(x : ℝ) ^ 3 - (y : ℝ) ^ 2| ∧
        |(x : ℝ) ^ 3 - (y : ℝ) ^ 2| <
          Real.sqrt (x : ℝ) * (Real.log (x : ℝ)) ^ a := Iff.rfl

-- Removing ANY bounded-x strip preserves actual set infinitude.
example (N : ℕ) (h : infinitelyMany ((1 : ℝ) / 4)) :
    Set.Infinite {p : ℕ × ℕ | admissible ((1 : ℝ) / 4) p ∧ N ≤ p.1} :=
  infinite_tail h N

-- Explicit larger exponents, and the general exponent-order property.
example (h : infinitelyMany ((1 : ℝ) / 4)) : infinitelyMany 1 :=
  infinitelyMany_mono (by norm_num) h
example (h : infinitelyMany ((1 : ℝ) / 4)) : infinitelyMany ((5 : ℝ) / 4) :=
  infinitelyMany_mono (by norm_num) h
example : Monotone infinitelyMany := fun _ _ hab h => infinitelyMany_mono hab h

-- The final theorem with both clauses fully exposed, including real exponents.
example : ¬ (
    Set.Infinite {p : ℕ × ℕ |
      0 < p.1 ∧ 0 < p.2 ∧
      0 < |(p.1 : ℝ) ^ 3 - (p.2 : ℝ) ^ 2| ∧
      |(p.1 : ℝ) ^ 3 - (p.2 : ℝ) ^ 2| <
        Real.sqrt (p.1 : ℝ) * (Real.log (p.1 : ℝ)) ^ ((1 : ℝ) / 4)} ∧
    ∀ b : ℝ, (1 : ℝ) / 4 < b →
      ¬ Set.Infinite {p : ℕ × ℕ |
        0 < p.1 ∧ 0 < p.2 ∧
        0 < |(p.1 : ℝ) ^ 3 - (p.2 : ℝ) ^ 2| ∧
        |(p.1 : ℝ) ^ 3 - (p.2 : ℝ) ^ 2| <
          Real.sqrt (p.1 : ℝ) * (Real.log (p.1 : ℝ)) ^ b}) :=
  conjecture_false

end HallReverse.Verification
