import Mathlib.LinearAlgebra.Matrix.Defs
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Data.Real.Basic
import Mathlib.Algebra.Polynomial.Degree.Operations
import Mathlib.Algebra.Polynomial.Eval.Defs
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum

set_option autoImplicit false

/-! The order-r univariate moment relaxation for 1 - X^2 >= 0.
Order r uses moments of degree at most 2r. Normalization is y(0)=1.
The localizing matrix has rows indexed by monomials of degree at most r-1.
Moments above degree 2r are unused; allowing a total sequence is just a
convenient encoding of a finite truncated moment vector.
-/

namespace MomentCounterexample

noncomputable section

open Matrix Polynomial
open scoped BigOperators

/-- The defining condition for a positive-semidefinite real symmetric matrix.
All real vectors are tested, not just finitely many sample vectors. -/
def positiveSemidefinite {n : ℕ} (M : Matrix (Fin n) (Fin n) ℝ) : Prop :=
  (∀ i j, M i j = M j i) ∧
  ∀ v : Fin n → ℝ, 0 ≤ ∑ i : Fin n, ∑ j : Fin n, v i * M i j * v j

def constraint : ℝ[X] := 1 - X ^ 2

def originalFeasible (x : ℝ) : Prop := 0 ≤ constraint.eval x

def objective (a b c x : ℝ) : ℝ := a * x ^ 2 + b * x + c

def objectivePolynomial (a b c : ℝ) : ℝ[X] := C a * X ^ 2 + C b * X + C c

def momentMatrix (r : ℕ) (y : ℕ → ℝ) : Matrix (Fin (r + 1)) (Fin (r + 1)) ℝ :=
  fun i j => y (i.val + j.val)

def localizingMatrix (r : ℕ) (y : ℕ → ℝ) : Matrix (Fin r) (Fin r) ℝ :=
  fun i j => y (i.val + j.val) - y (i.val + j.val + 2)

def hierarchyFeasible (r : ℕ) (y : ℕ → ℝ) : Prop :=
  1 ≤ r ∧ y 0 = 1 ∧ positiveSemidefinite (momentMatrix r y) ∧
    positiveSemidefinite (localizingMatrix r y)

def relaxedObjective (a b c : ℝ) (y : ℕ → ℝ) : ℝ := a * y 2 + b * y 1 + c

def diracMoments (x : ℝ) : ℕ → ℝ := fun n => x ^ n

/-- A genuine probability law on at most three points of the original set,
whose moments of degrees zero, one, and two are precisely the truncated data. -/
def atomicRepresentation (y : ℕ → ℝ) : Prop :=
  ∃ x₀ x₁ x₂ w₀ w₁ w₂ : ℝ,
    originalFeasible x₀ ∧ originalFeasible x₁ ∧ originalFeasible x₂ ∧
    0 ≤ w₀ ∧ 0 ≤ w₁ ∧ 0 ≤ w₂ ∧ w₀ + w₁ + w₂ = 1 ∧ y 0 = 1 ∧
    w₀ * x₀ + w₁ * x₁ + w₂ * x₂ = y 1 ∧
    w₀ * x₀ ^ 2 + w₁ * x₁ ^ 2 + w₂ * x₂ ^ 2 = y 2

/-- Exactness is equality of all lower bounds, for every objective admissible
at order one. This is stronger than one isolated objective having no gap. -/
def exactAt (r : ℕ) : Prop :=
  1 ≤ r ∧ ∀ a b c L : ℝ,
    (∀ x : ℝ, originalFeasible x → L ≤ objective a b c x) ↔
    (∀ y : ℕ → ℝ, hierarchyFeasible r y → L ≤ relaxedObjective a b c y)

/-- The necessary minimal-order clause of the source, on this concrete set. -/
def minimalOrderFormula : Prop := IsLeast {r : ℕ | exactAt r} (2 * constraint.natDegree)

theorem constraint_degree : constraint.natDegree = 2 := by
  simp [constraint, Polynomial.natDegree_sub_eq_right_of_natDegree_lt]

theorem objectivePolynomial_eval (a b c x : ℝ) :
    (objectivePolynomial a b c).eval x = objective a b c x := by
  simp [objectivePolynomial, objective]

theorem originalFeasible_iff (x : ℝ) : originalFeasible x ↔ -1 ≤ x ∧ x ≤ 1 := by
  simp only [originalFeasible, constraint, eval_sub, eval_one, eval_pow, eval_X]
  constructor
  · intro h
    constructor <;> nlinarith [sq_nonneg (x + 1), sq_nonneg (x - 1)]
  · rintro ⟨hl, hu⟩
    nlinarith [mul_nonneg (sub_nonneg.mpr hu) (by linarith : 0 ≤ x + 1)]

theorem moment_bounds {y : ℕ → ℝ} (h : hierarchyFeasible 1 y) :
    y 1 ^ 2 ≤ y 2 ∧ y 2 ≤ 1 ∧ -1 ≤ y 1 ∧ y 1 ≤ 1 := by
  have hq := h.2.2.1.2 (fun i : Fin 2 => if i = 0 then -y 1 else 1)
  have hloc := h.2.2.2.2 (fun _ : Fin 1 => 1)
  simp [momentMatrix, Fin.sum_univ_two, h.2.1] at hq
  simp [localizingMatrix, h.2.1] at hloc
  have hmq : y 1 ^ 2 ≤ y 2 := by nlinarith [hq]
  have hqu : y 2 ≤ 1 := by linarith
  refine ⟨hmq, hqu, ?_, ?_⟩ <;>
    nlinarith [sq_nonneg (y 1 + 1), sq_nonneg (y 1 - 1)]

theorem dirac_feasible (x : ℝ) (hx : originalFeasible x) :
    hierarchyFeasible 1 (diracMoments x) := by
  have hinterval := (originalFeasible_iff x).mp hx
  have hsq : 0 ≤ 1 - x ^ 2 := by
    nlinarith [mul_nonneg (sub_nonneg.mpr hinterval.2)
      (by linarith [hinterval.1] : 0 ≤ x + 1)]
  have hm : positiveSemidefinite (momentMatrix 1 (diracMoments x)) := by
    constructor
    · intro i j
      simp [momentMatrix, diracMoments, Nat.add_comm]
    · intro v
      have hv := sq_nonneg (v 0 + x * v 1)
      simp [momentMatrix, diracMoments, Fin.sum_univ_two]
      nlinarith [hv]
  have hl : positiveSemidefinite (localizingMatrix 1 (diracMoments x)) := by
    constructor
    · intro i j
      simp [localizingMatrix, diracMoments]
    · intro v
      have hv := mul_nonneg hsq (sq_nonneg (v 0))
      simp [localizingMatrix, diracMoments]
      nlinarith [hv]
  exact ⟨by decide, by simp [diracMoments], hm, hl⟩

theorem feasible_has_atomic_representation {y : ℕ → ℝ} (h : hierarchyFeasible 1 y) :
    atomicRepresentation y := by
  rcases moment_bounds h with ⟨hmq, hqu, hml, hmu⟩
  have hm : originalFeasible (y 1) := (originalFeasible_iff _).mpr ⟨hml, hmu⟩
  have hminus : originalFeasible (-1) := (originalFeasible_iff _).mpr (by norm_num)
  have hplus : originalFeasible 1 := (originalFeasible_iff _).mpr (by norm_num)
  by_cases hboundary : y 1 ^ 2 = 1
  · refine ⟨y 1, -1, 1, 1, 0, 0, hm, hminus, hplus, by norm_num,
      by norm_num, by norm_num, by norm_num, h.2.1, ?_, ?_⟩
    · ring
    · simp only [one_mul, zero_mul, add_zero]
      linarith
  · have hden : 0 < 1 - y 1 ^ 2 := by
      have hs : y 1 ^ 2 ≤ 1 := le_trans hmq hqu
      exact sub_pos.mpr (lt_of_le_of_ne hs hboundary)
    let t : ℝ := (y 2 - y 1 ^ 2) / (1 - y 1 ^ 2)
    have ht0 : 0 ≤ t := div_nonneg (sub_nonneg.mpr hmq) (le_of_lt hden)
    have ht1 : t ≤ 1 := by
      dsimp [t]
      apply (div_le_iff₀ hden).mpr
      linarith
    have hw0 : 0 ≤ 1 - t := sub_nonneg.mpr ht1
    have hw1 : 0 ≤ t * (1 - y 1) / 2 :=
      div_nonneg (mul_nonneg ht0 (sub_nonneg.mpr hmu)) (by norm_num)
    have hw2 : 0 ≤ t * (1 + y 1) / 2 :=
      div_nonneg (mul_nonneg ht0 (by linarith)) (by norm_num)
    have hid : t * (1 - y 1 ^ 2) = y 2 - y 1 ^ 2 := by
      dsimp [t]
      exact div_mul_cancel₀ _ (ne_of_gt hden)
    refine ⟨y 1, -1, 1, 1 - t, t * (1 - y 1) / 2, t * (1 + y 1) / 2,
      hm, hminus, hplus, hw0, hw1, hw2, ?_, h.2.1, ?_, ?_⟩
    · ring
    · ring
    · calc
        _ = y 1 ^ 2 + t * (1 - y 1 ^ 2) := by ring
        _ = y 2 := by rw [hid]; ring

/-- Every relaxed vector can be rounded without increasing any quadratic
objective. Convex quadratics round to the mean; concave ones to an endpoint. -/
theorem round_feasible {y : ℕ → ℝ} (h : hierarchyFeasible 1 y) (a b c : ℝ) :
    ∃ x : ℝ, originalFeasible x ∧ objective a b c x ≤ relaxedObjective a b c y := by
  rcases moment_bounds h with ⟨hmq, hqu, hml, hmu⟩
  by_cases ha : 0 ≤ a
  · refine ⟨y 1, (originalFeasible_iff _).mpr ⟨hml, hmu⟩, ?_⟩
    have hp := mul_nonneg ha (sub_nonneg.mpr hmq)
    dsimp [objective, relaxedObjective]
    nlinarith [hp]
  · have han : a ≤ 0 := le_of_lt (lt_of_not_ge ha)
    have hqa := mul_nonneg_of_nonpos_of_nonpos han (sub_nonpos.mpr hqu)
    by_cases hb : 0 ≤ b
    · refine ⟨-1, (originalFeasible_iff _).mpr (by norm_num), ?_⟩
      have hbm := mul_nonneg hb (by linarith : 0 ≤ y 1 + 1)
      dsimp [objective, relaxedObjective]
      nlinarith [hqa, hbm]
    · refine ⟨1, (originalFeasible_iff _).mpr (by norm_num), ?_⟩
      have hbn : b ≤ 0 := le_of_lt (lt_of_not_ge hb)
      have hbm := mul_nonneg_of_nonpos_of_nonpos hbn (sub_nonpos.mpr hmu)
      dsimp [objective, relaxedObjective]
      nlinarith [hqa, hbm]

theorem order_one_exact : exactAt 1 := by
  refine ⟨by decide, ?_⟩
  intro a b c L
  constructor
  · intro h y hy
    rcases round_feasible hy a b c with ⟨x, hx, hround⟩
    exact le_trans (h x hx) hround
  · intro h x hx
    simpa [relaxedObjective, diracMoments, objective] using h (diracMoments x) (dirac_feasible x hx)

theorem exists_original_minimizer (a b c : ℝ) :
    ∃ x₀ : ℝ, originalFeasible x₀ ∧
      ∀ x : ℝ, originalFeasible x → objective a b c x₀ ≤ objective a b c x := by
  have hminus : originalFeasible (-1) := (originalFeasible_iff _).mpr (by norm_num)
  have hplus : originalFeasible 1 := (originalFeasible_iff _).mpr (by norm_num)
  by_cases ha : a ≤ 0
  · by_cases hb : 0 ≤ b
    · refine ⟨-1, hminus, ?_⟩
      intro x hx
      have hi := (originalFeasible_iff x).mp hx
      have hs : x ^ 2 ≤ 1 := by
        nlinarith [mul_nonneg (sub_nonneg.mpr hi.2) (by linarith : 0 ≤ x + 1)]
      have hp := mul_nonneg_of_nonpos_of_nonpos ha (sub_nonpos.mpr hs)
      have hq := mul_nonneg hb (by linarith : 0 ≤ x + 1)
      dsimp [objective]
      nlinarith [hp, hq]
    · refine ⟨1, hplus, ?_⟩
      intro x hx
      have hi := (originalFeasible_iff x).mp hx
      have hs : x ^ 2 ≤ 1 := by
        nlinarith [mul_nonneg (sub_nonneg.mpr hi.2) (by linarith : 0 ≤ x + 1)]
      have hp := mul_nonneg_of_nonpos_of_nonpos ha (sub_nonpos.mpr hs)
      have hq := mul_nonneg_of_nonpos_of_nonpos (le_of_lt (lt_of_not_ge hb))
        (sub_nonpos.mpr hi.2)
      dsimp [objective]
      nlinarith [hp, hq]
  · have hap : 0 < a := lt_of_not_ge ha
    by_cases hleft : 2 * a ≤ b
    · refine ⟨-1, hminus, ?_⟩
      intro x hx
      have hi := (originalFeasible_iff x).mp hx
      have hxp : 0 ≤ x + 1 := by linarith
      have hmul := mul_nonneg (le_of_lt hap) hxp
      have hcoef : 0 ≤ a * (x - 1) + b := by nlinarith [hmul]
      have hp := mul_nonneg hxp hcoef
      dsimp [objective]
      nlinarith [hp]
    · by_cases hright : b ≤ -(2 * a)
      · refine ⟨1, hplus, ?_⟩
        intro x hx
        have hi := (originalFeasible_iff x).mp hx
        have hxn : x - 1 ≤ 0 := sub_nonpos.mpr hi.2
        have hmul := mul_nonpos_of_nonneg_of_nonpos (le_of_lt hap) hxn
        have hcoef : a * (x + 1) + b ≤ 0 := by nlinarith [hmul]
        have hp := mul_nonneg_of_nonpos_of_nonpos hxn hcoef
        dsimp [objective]
        nlinarith [hp]
      · let v : ℝ := -b / (2 * a)
        have hden : 0 < 2 * a := mul_pos (by norm_num) hap
        have hvl : -1 ≤ v := by
          dsimp [v]
          apply (le_div_iff₀ hden).mpr
          linarith [lt_of_not_ge hleft]
        have hvu : v ≤ 1 := by
          dsimp [v]
          apply (div_le_iff₀ hden).mpr
          linarith [lt_of_not_ge hright]
        have hstat : 2 * a * v + b = 0 := by
          have hd : v * (2 * a) = -b := div_mul_cancel₀ _ (ne_of_gt hden)
          nlinarith [hd]
        refine ⟨v, (originalFeasible_iff _).mpr ⟨hvl, hvu⟩, ?_⟩
        intro x _
        have hstationary : (2 * a * v + b) * (x - v) = 0 := by rw [hstat]; ring
        have hp := mul_nonneg (le_of_lt hap) (sq_nonneg (x - v))
        dsimp [objective]
        nlinarith [hstationary, hp]

theorem attained_exactness (a b c : ℝ) :
    ∃ x₀ : ℝ, ∃ y₀ : ℕ → ℝ,
      originalFeasible x₀ ∧ hierarchyFeasible 1 y₀ ∧
      objective a b c x₀ = relaxedObjective a b c y₀ ∧
      (∀ x : ℝ, originalFeasible x → objective a b c x₀ ≤ objective a b c x) ∧
      (∀ y : ℕ → ℝ, hierarchyFeasible 1 y → relaxedObjective a b c y₀ ≤ relaxedObjective a b c y) := by
  rcases exists_original_minimizer a b c with ⟨x₀, hx₀, hmin⟩
  refine ⟨x₀, diracMoments x₀, hx₀, dirac_feasible x₀ hx₀, ?_, hmin, ?_⟩
  · simp [objective, relaxedObjective, diracMoments]
  · intro y hy
    rcases round_feasible hy a b c with ⟨x, hx, hr⟩
    have hh := le_trans (hmin x hx) hr
    simpa [objective, relaxedObjective, diracMoments] using hh

theorem least_exact_order : IsLeast {r : ℕ | exactAt r} 1 := by
  exact ⟨order_one_exact, fun _ hr => hr.1⟩

theorem refutes_minimal_order_formula : ¬minimalOrderFormula := by
  intro h
  have hle := h.2 order_one_exact
  rw [constraint_degree] at hle
  norm_num at hle

theorem complete_counterexample :
    constraint.natDegree = 2 ∧
    (∀ x : ℝ, originalFeasible x ↔ -1 ≤ x ∧ x ≤ 1) ∧
    IsLeast {r : ℕ | exactAt r} 1 ∧ ¬minimalOrderFormula :=
  ⟨constraint_degree, originalFeasible_iff, least_exact_order, refutes_minimal_order_formula⟩

end

end MomentCounterexample
