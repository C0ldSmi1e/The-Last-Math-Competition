import Mathlib.Data.ZMod.Basic
import Mathlib.Tactic

/-!
The explicitly defined dynamical system and its quadratic ergodic averages.
All indices of averages start at zero; A_0 is defined as zero by field division.
-/

noncomputable section

open scoped BigOperators

namespace Conjecture1925

/-- The n-th cycle is longer than all square times k² with k < 2(n+1). -/
def cycleLength (n : ℕ) : ℕ := 4 * (n + 1) ^ 2 + 1

instance (n : ℕ) : NeZero (cycleLength n) := ⟨by unfold cycleLength; omega⟩

/-- A countable disjoint union of finite cyclic groups. -/
def Ω := (n : ℕ) × ZMod (cycleLength n)

/-- Rotation by one in each component, explicitly as a bijection. -/
def rotation : Ω ≃ Ω where
  toFun x := ⟨x.1, x.2 + 1⟩
  invFun x := ⟨x.1, x.2 - 1⟩
  left_inv x := by cases x; simp
  right_inv x := by cases x; simp

/-- The fixed observable has values zero and one. -/
def observable (x : Ω) : ℝ := if (x.1 + 1) ^ 2 ≤ x.2.val then 1 else 0

/-- The integer-valued polynomial used in the counterexample is p(k) = k². -/
def squareTime (k : ℕ) : ℕ := k ^ 2

/-- A polynomial object certifying that the times are genuinely quadratic. -/
def squarePolynomial : Polynomial ℕ := Polynomial.X ^ 2

lemma squarePolynomial_degree : squarePolynomial.natDegree = 2 :=
  Polynomial.natDegree_X_pow 2

lemma squareTime_eq_eval (k : ℕ) : squareTime k = squarePolynomial.eval k := by
  simp [squareTime, squarePolynomial]

/-- The actual polynomial ergodic average, using iterates of the fixed transformation. -/
def average (N : ℕ) (x : Ω) : ℝ :=
  (∑ k ∈ Finset.range N, observable ((rotation : Ω → Ω)^[squareTime k] x)) / N

lemma average_eq_polynomial_average (N : ℕ) (x : Ω) :
    average N x = (∑ k ∈ Finset.range N,
      observable ((rotation : Ω → Ω)^[squarePolynomial.eval k] x)) / N := by
  simp only [average, squareTime_eq_eval]

/-- Base point in a cycle of the indicated size parameter. -/
def base (n : ℕ) : Ω := ⟨n, 0⟩

lemma rotation_iterate (k n : ℕ) (j : ZMod (cycleLength n)) :
    (rotation : Ω → Ω)^[k] ⟨n, j⟩ = ⟨n, j + k⟩ := by
  induction k with
  | zero => simp
  | succ k ih =>
    rw [Function.iterate_succ_apply', ih]
    simp [rotation, Nat.cast_add, add_assoc]

lemma square_lt_cycle {n k : ℕ} (hk : k < 2 * (n + 1)) :
    k ^ 2 < cycleLength n := by
  unfold cycleLength
  nlinarith

lemma sample_before {n k : ℕ} (hk : k < n + 1) :
    observable ((rotation : Ω → Ω)^[squareTime k] (base n)) = 0 := by
  have hk' : k < 2 * (n + 1) := by omega
  rw [base, rotation_iterate]
  simp only [zero_add, observable, squareTime, ZMod.val_natCast_of_lt (square_lt_cycle hk')]
  split_ifs with h
  · nlinarith
  · rfl

lemma sample_after {n k : ℕ} (hk₁ : n + 1 ≤ k) (hk₂ : k < 2 * (n + 1)) :
    observable ((rotation : Ω → Ω)^[squareTime k] (base n)) = 1 := by
  rw [base, rotation_iterate]
  simp only [zero_add, observable, squareTime, ZMod.val_natCast_of_lt (square_lt_cycle hk₂)]
  split_ifs with h
  · rfl
  · exfalso
    apply h
    nlinarith

lemma average_at_base (n : ℕ) : average (n + 1) (base n) = 0 := by
  unfold average
  have h : (∑ k ∈ Finset.range (n + 1),
      observable ((rotation : Ω → Ω)^[squareTime k] (base n))) = 0 := by
    apply Finset.sum_eq_zero
    intro k hk
    exact sample_before (Finset.mem_range.mp hk)
  rw [h, zero_div]

lemma double_average_at_base (n : ℕ) : average (2 * (n + 1)) (base n) = 1 / 2 := by
  unfold average
  have hsum : (∑ k ∈ Finset.range (2 * (n + 1)),
      observable ((rotation : Ω → Ω)^[squareTime k] (base n))) = (n + 1 : ℝ) := by
    rw [two_mul, Finset.sum_range_add]
    have h₁ : (∑ k ∈ Finset.range (n + 1),
        observable ((rotation : Ω → Ω)^[squareTime k] (base n))) = 0 := by
      apply Finset.sum_eq_zero
      intro k hk
      exact sample_before (Finset.mem_range.mp hk)
    have h₂ : (∑ k ∈ Finset.range (n + 1),
        observable ((rotation : Ω → Ω)^[squareTime (n + 1 + k)] (base n))) = (n + 1 : ℝ) := by
      have heq : ∀ k ∈ Finset.range (n + 1),
          observable ((rotation : Ω → Ω)^[squareTime (n + 1 + k)] (base n)) = 1 := by
        intro k hk
        have hk' := Finset.mem_range.mp hk
        apply sample_after <;> omega
      rw [Finset.sum_congr rfl heq]
      simp
    rw [h₁, h₂, zero_add]
  rw [hsum]
  push_cast
  have hn : (n : ℝ) + 1 ≠ 0 := by positivity
  field_simp
  ring

lemma observable_bounds (x : Ω) : 0 ≤ observable x ∧ observable x ≤ 1 := by
  unfold observable
  split_ifs <;> norm_num

lemma average_bounds (N : ℕ) (x : Ω) : 0 ≤ average N x ∧ average N x ≤ 1 := by
  constructor
  · apply div_nonneg
    · exact Finset.sum_nonneg (fun k _ => (observable_bounds _).1)
    · positivity
  · by_cases hN : N = 0
    · simp [hN, average]
    · have hp : (0 : ℝ) < N := Nat.cast_pos.mpr (Nat.pos_of_ne_zero hN)
      apply (div_le_iff₀ hp).mpr
      calc
        (∑ k ∈ Finset.range N, observable ((rotation : Ω → Ω)^[squareTime k] x))
          ≤ ∑ _k ∈ Finset.range N, (1 : ℝ) := Finset.sum_le_sum (fun k _ => (observable_bounds _).2)
        _ = 1 * N := by simp

end Conjecture1925
