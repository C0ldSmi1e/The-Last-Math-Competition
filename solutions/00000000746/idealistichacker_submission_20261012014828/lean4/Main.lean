import Mathlib.NumberTheory.Padics.PadicNumbers
import Mathlib.Analysis.Analytic.OfScalars
import Mathlib.Analysis.Analytic.Basic
import Mathlib.Analysis.Analytic.Uniqueness
import Mathlib.Analysis.Analytic.Constructions
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Analysis.Calculus.Deriv.Inv
import Mathlib.Analysis.Calculus.Deriv.Add
import Mathlib.Data.Rat.Lemmas
import Mathlib.Data.Rat.Cast.CharZero
import Mathlib.Logic.Function.Iterate
import Mathlib.Tactic

/-!
Explicit analytic germs over Q_3 for conjecture 746,
with their actual rational coefficient series. Including an explicit analytic local inverse.
-/
noncomputable section

-- Use ordinary definitional reduction across inherited field/module instances.
set_option backward.isDefEq.respectTransparency false
open Set Filter
open scoped Topology BigOperators

namespace Conjecture746

instance prime_three : Fact (Nat.Prime 3) := ⟨by norm_num⟩

abbrev K := ℚ_[3]

-- Choose the same inherited self-module used by the generic quotient APIs.
-- These are the ordinary field structures, not additional mathematical assumptions.
local instance (priority := 2000) : AddCommGroup K :=
  (inferInstance : NontriviallyNormedField K).toDivisionRing.toAddCommGroup
local instance (priority := 2000) : NormedSpace K K := NormedAlgebra.toNormedSpace K
local instance (priority := 2000) : Module K K := (NormedAlgebra.toNormedSpace K).toModule

/-- The chosen self-module has exactly the usual field scalar multiplication. -/
theorem self_smul_eq_mul (x y : K) : x • y = x * y := rfl

def H (x : K) : K := x / (1 - x / 3)
def F (x : K) : K := 3 * x / (1 + 2 * x / 3)
def U : Set K := {x | ‖x‖ < (1 / 3 : ℝ)}

/-- Coefficient index is the actual power of x, starting at the constant coefficient. -/
def a : ℕ → ℚ
  | 0 => 0
  | n + 1 => (3 ^ n : ℚ)⁻¹

def P : FormalMultilinearSeries K K K :=
  FormalMultilinearSeries.ofScalars K (fun n => (a n : K))

@[simp] theorem coeff_P (n : ℕ) : P.coeff n = (a n : K) := by
  exact FormalMultilinearSeries.coeff_ofScalars

theorem norm_three : ‖(3 : K)‖ = (1 / 3 : ℝ) := by
  simpa [one_div] using (Padic.norm_p (p := 3))

theorem norm_div_three_lt_one {x : K} (hx : x ∈ U) : ‖x / 3‖ < 1 := by
  rw [norm_div, norm_three]
  exact (div_lt_one (by norm_num : (0 : ℝ) < 1 / 3)).mpr hx

/-- The complete coefficient sequence genuinely sums to the rational function on U. -/
theorem H_hasSum {x : K} (hx : x ∈ U) :
    HasSum (fun n : ℕ => (a n : K) * x ^ n) (H x) := by
  have hgeom := hasSum_geometric_of_norm_lt_one (norm_div_three_lt_one hx)
  have htail : HasSum (fun n : ℕ => (a (n + 1) : K) * x ^ (n + 1)) (H x) := by
    have heq : (fun n : ℕ => (a (n + 1) : K) * x ^ (n + 1)) =
        (fun n : ℕ => x * (x / 3) ^ n) := by
      funext n
      simp only [a, Rat.cast_inv, Rat.cast_pow, Rat.cast_ofNat, pow_succ,
        div_eq_mul_inv]
      ring_nf
      simp only [one_div]
      ac_rfl
    rw [heq]
    simpa only [H, div_eq_mul_inv] using hgeom.mul_left x
  apply (hasSum_nat_add_iff' 1).mp
  simpa [a] using htail

/-- P is an actual convergent power series of H, not merely assigned coefficient data. -/
theorem H_hasFPowerSeriesAt : HasFPowerSeriesAt H P 0 := by
  apply hasFPowerSeriesAt_iff.mpr
  filter_upwards [Metric.ball_mem_nhds (0 : K) (by norm_num : (0 : ℝ) < 1 / 3)] with x hx
  have hxU : x ∈ U := by
    simpa only [U, Set.mem_ofPred_eq, Metric.mem_ball, dist_zero_right] using hx
  simpa [smul_eq_mul, mul_comm] using H_hasSum hxU

/-- Canonical reduced rational denominator of every nonconstant coefficient. -/
theorem a_succ_den (n : ℕ) : (a (n + 1)).den = 3 ^ n := by
  change ((3 ^ n : ℚ)⁻¹).den = 3 ^ n
  have hd := Rat.inv_natCast_den_of_pos (a := 3 ^ n) (pow_pos (by norm_num) n)
  simpa only [Nat.cast_pow, Nat.cast_ofNat] using hd

theorem a_three_den : (a 3).den = 9 := by
  simpa using a_succ_den 2

theorem actual_third_coefficient :
    P.coeff 3 = ((1 / 9 : ℚ) : K) ∧ (a 3).den = 9 := by
  constructor
  · rw [coeff_P]
    norm_num [a]
  · exact a_three_den


@[simp] theorem H_zero : H 0 = 0 := by simp [H]
@[simp] theorem F_zero : F 0 = 0 := by simp [F]

theorem zero_mem_U : (0 : K) ∈ U := by norm_num [U]
theorem U_nonempty : U.Nonempty := ⟨0, zero_mem_U⟩
theorem U_isOpen : IsOpen U := isOpen_lt continuous_norm continuous_const

theorem norm_two_mul_div_three_lt_one {x : K} (hx : x ∈ U) :
    ‖2 * x / 3‖ < 1 := by
  have h2 : ‖(2 : K)‖ ≤ 1 := by
    simpa using (Padic.norm_int_le_one (p := 3) 2)
  have hnorm : ‖2 * x / 3‖ = ‖(2 : K)‖ * ‖x / 3‖ := by
    rw [mul_div_assoc, norm_mul]
  rw [hnorm]
  exact (mul_le_of_le_one_left (norm_nonneg _) h2).trans_lt (norm_div_three_lt_one hx)

theorem H_den_norm {x : K} (hx : x ∈ U) : ‖1 - x / 3‖ = 1 := by
  have hlt := norm_div_three_lt_one hx
  have hne : ‖(1 : K)‖ ≠ ‖-(x / 3)‖ := by
    simpa only [norm_one, norm_neg] using ne_of_gt hlt
  have h := Padic.add_eq_max_of_ne hne
  simpa only [sub_eq_add_neg, norm_one, norm_neg, max_eq_left (le_of_lt hlt)] using h

theorem F_den_norm {x : K} (hx : x ∈ U) : ‖1 + 2 * x / 3‖ = 1 := by
  have hlt := norm_two_mul_div_three_lt_one hx
  have hne : ‖(1 : K)‖ ≠ ‖2 * x / 3‖ := by
    simpa only [norm_one] using ne_of_gt hlt
  have h := Padic.add_eq_max_of_ne hne
  simpa only [norm_one, max_eq_left (le_of_lt hlt)] using h

theorem H_den_ne_zero {x : K} (hx : x ∈ U) : 1 - x / 3 ≠ 0 := by
  intro h
  have hn := H_den_norm hx
  rw [h, norm_zero] at hn
  norm_num at hn

theorem F_den_ne_zero {x : K} (hx : x ∈ U) : 1 + 2 * x / 3 ≠ 0 := by
  intro h
  have hn := F_den_norm hx
  rw [h, norm_zero] at hn
  norm_num at hn

theorem norm_H {x : K} (hx : x ∈ U) : ‖H x‖ = ‖x‖ := by
  rw [H, norm_div, H_den_norm hx, div_one]

theorem norm_F {x : K} (hx : x ∈ U) : ‖F x‖ = ‖x‖ / 3 := by
  rw [F, norm_div, norm_mul, F_den_norm hx, div_one, norm_three]
  ring

theorem F_mem_U {x : K} (hx : x ∈ U) : F x ∈ U := by
  change ‖F x‖ < (1 / 3 : ℝ)
  rw [norm_F hx]
  have hx' : ‖x‖ < (1 / 3 : ℝ) := hx
  linarith [norm_nonneg x]

theorem F_mapsTo_U : Set.MapsTo F U U := fun _ hx => F_mem_U hx

theorem H_derivative_at_zero : HasDerivAt H (1 : K) 0 := by
  have hid : HasDerivAt (fun x : K => x) 1 0 := hasDerivAt_id' 0
  have hd := (hid.div_const (3 : K)).const_sub 1
  convert! hid.fun_div hd (by norm_num) using 1
  norm_num

theorem F_derivative_at_zero : HasDerivAt F (3 : K) 0 := by
  have hid : HasDerivAt (fun x : K => x) 1 0 := hasDerivAt_id' 0
  have hn := hid.const_mul (3 : K)
  have hd := ((hid.const_mul (2 : K)).div_const (3 : K)).const_add 1
  convert! hn.fun_div hd (by norm_num) using 1
  norm_num

theorem H_analyticOnNhd : AnalyticOnNhd K H U := by
  intro x hx
  have hid : AnalyticAt K (fun y : K => y) x := analyticAt_id
  have hd : AnalyticAt K (fun y : K => 1 - y / 3) x :=
    analyticAt_const.sub (hid.div analyticAt_const (by norm_num))
  convert! hid.div hd (H_den_ne_zero hx) using 1

theorem F_analyticOnNhd : AnalyticOnNhd K F U := by
  intro x hx
  have hid : AnalyticAt K (fun y : K => y) x := analyticAt_id
  have hn : AnalyticAt K (fun y : K => 3 * y) x := analyticAt_const.mul hid
  have hd : AnalyticAt K (fun y : K => 1 + 2 * y / 3) x :=
    analyticAt_const.add ((analyticAt_const.mul hid).div analyticAt_const (by norm_num))
  convert! hn.div hd (F_den_ne_zero hx) using 1

theorem Schroder_on_U {x : K} (hx : x ∈ U) : H (F x) = 3 * H x := by
  have hdF := F_den_ne_zero hx
  have hdH := H_den_ne_zero hx
  have hdF' : 3 + 2 * x ≠ 0 := by
    intro hz
    apply hdF
    calc
      1 + 2 * x / 3 = (3 + 2 * x) / 3 := by ring
      _ = 0 := by rw [hz, zero_div]
  have hdH' : 3 - x ≠ 0 := by
    intro hz
    apply hdH
    calc
      1 - x / 3 = (3 - x) / 3 := by ring
      _ = 0 := by rw [hz, zero_div]
  have hdF'' : 3 + x * 2 ≠ 0 := by simpa only [mul_comm] using hdF'
  unfold H F
  field_simp
  field_simp [hdF'', hdH']
  ring_nf
  field_simp [hdH']

theorem iterate_mem_U {x : K} (hx : x ∈ U) (n : ℕ) : F^[n] x ∈ U := by
  induction n with
  | zero => exact hx
  | succ n hn =>
    rw [Function.iterate_succ_apply']
    exact F_mem_U hn

theorem iterate_norm {x : K} (hx : x ∈ U) (n : ℕ) :
    ‖F^[n] x‖ = (1 / 3 : ℝ) ^ n * ‖x‖ := by
  induction n with
  | zero => simp
  | succ n hn =>
    rw [Function.iterate_succ_apply', norm_F (iterate_mem_U hx n), hn, pow_succ]
    ring

theorem iterate_tendsto_zero {x : K} (hx : x ∈ U) :
    Tendsto (fun n : ℕ => F^[n] x) atTop (𝓝 0) := by
  apply tendsto_zero_iff_norm_tendsto_zero.mpr
  have hg : Tendsto (fun n : ℕ => (1 / 3 : ℝ) ^ n * ‖x‖) atTop (𝓝 0) := by
    simpa only [zero_mul] using
      (tendsto_pow_atTop_nhds_zero_of_norm_lt_one
        (R := ℝ) (x := 1 / 3) (by norm_num)).mul_const ‖x‖
  simpa only [iterate_norm hx] using hg

/-- Any rational-coefficient analytic series of this same germ has these actual coefficients. -/
theorem H_rational_coefficients_unique (b : ℕ → ℚ)
    (hb : HasFPowerSeriesAt H
      (FormalMultilinearSeries.ofScalars K (fun n => (b n : K))) 0) : b = a := by
  have hp := H_hasFPowerSeriesAt.eq_formalMultilinearSeries hb
  funext n
  apply Rat.cast_injective (α := K)
  have hcoeff := congrArg (fun q : FormalMultilinearSeries K K K => q.coeff n) hp
  simpa only [coeff_P, FormalMultilinearSeries.coeff_ofScalars] using hcoeff.symm

/-- Denominators are the canonical reduced rational denominators, not opaque numerical labels. -/
def FirstPowerDenominatorBound (b : ℕ → ℚ) : Prop :=
  ∀ n, ¬ (3 ^ 2 : ℕ) ∣ (b n).den

theorem a_violates_denominator_bound : ¬ FirstPowerDenominatorBound a := by
  intro hb
  apply hb 3
  rw [a_three_den]
  norm_num

/-- Transparent sufficient premises for the actual normalized p-adic Schroder germ instance. -/
structure NormalizedAnalyticSchroder (f h : K → K) (s : Set K) (b : ℕ → ℚ) : Prop where
  neighborhood_open : IsOpen s
  neighborhood_nonempty : s.Nonempty
  neighborhood_contains_zero : (0 : K) ∈ s
  analytic_f : AnalyticOnNhd K f s
  analytic_h : AnalyticOnNhd K h s
  fixed_point : f 0 = 0
  normalized_zero : h 0 = 0
  multiplier_derivative : HasDerivAt f (3 : K) 0
  multiplier_nonzero : (3 : K) ≠ 0
  multiplier_attracting : ‖(3 : K)‖ < 1
  normalized_derivative : HasDerivAt h (1 : K) 0
  invariant : Set.MapsTo f s s
  norm_contraction : ∀ x ∈ s, ‖f x‖ = ‖x‖ / 3
  attracting_orbits : ∀ x ∈ s, Tendsto (fun n : ℕ => f^[n] x) atTop (𝓝 0)
  functional_identity : ∀ x ∈ s, h (f x) = 3 * h x
  actual_series_at_zero : HasFPowerSeriesAt h
    (FormalMultilinearSeries.ofScalars K (fun n => (b n : K))) 0
  actual_series_on_neighborhood : ∀ x ∈ s,
    HasSum (fun n : ℕ => (b n : K) * x ^ n) (h x)

theorem actual_normalized_Schroder : NormalizedAnalyticSchroder F H U a where
  neighborhood_open := U_isOpen
  neighborhood_nonempty := U_nonempty
  neighborhood_contains_zero := zero_mem_U
  analytic_f := F_analyticOnNhd
  analytic_h := H_analyticOnNhd
  fixed_point := F_zero
  normalized_zero := H_zero
  multiplier_derivative := F_derivative_at_zero
  multiplier_nonzero := by norm_num
  multiplier_attracting := Padic.norm_p_lt_one
  normalized_derivative := H_derivative_at_zero
  invariant := F_mapsTo_U
  norm_contraction := fun _ hx => norm_F hx
  attracting_orbits := fun _ hx => iterate_tendsto_zero hx
  functional_identity := fun _ hx => Schroder_on_U hx
  actual_series_at_zero := H_hasFPowerSeriesAt
  actual_series_on_neighborhood := fun _ hx => H_hasSum hx

/-- Necessary denominator consequence of the universal assertion, specialized to p=3. -/
def NecessaryDenominatorClaim : Prop :=
  ∀ (f h : K → K) (s : Set K) (b : ℕ → ℚ),
    NormalizedAnalyticSchroder f h s b → FirstPowerDenominatorBound b

theorem exists_actual_counterexample :
    ∃ (f h : K → K) (s : Set K) (b : ℕ → ℚ),
      NormalizedAnalyticSchroder f h s b ∧ ¬ FirstPowerDenominatorBound b :=
  ⟨F, H, U, a, actual_normalized_Schroder, a_violates_denominator_bound⟩

theorem necessary_denominator_claim_false : ¬ NecessaryDenominatorClaim := by
  intro hclaim
  exact a_violates_denominator_bound (hclaim F H U a actual_normalized_Schroder)

/-- Explicit analytic inverse of the normalized linearizing germ on U. -/
def J (x : K) : K := x / (1 + x / 3)

theorem J_den_norm {x : K} (hx : x ∈ U) : ‖1 + x / 3‖ = 1 := by
  have hlt := norm_div_three_lt_one hx
  have hne : ‖(1 : K)‖ ≠ ‖x / 3‖ := by
    simpa only [norm_one] using ne_of_gt hlt
  have h := Padic.add_eq_max_of_ne hne
  simpa only [norm_one, max_eq_left (le_of_lt hlt)] using h

theorem J_den_ne_zero {x : K} (hx : x ∈ U) : 1 + x / 3 ≠ 0 := by
  intro h
  have hn := J_den_norm hx
  rw [h, norm_zero] at hn
  norm_num at hn

theorem norm_J {x : K} (hx : x ∈ U) : ‖J x‖ = ‖x‖ := by
  rw [J, norm_div, J_den_norm hx, div_one]

theorem J_mem_U {x : K} (hx : x ∈ U) : J x ∈ U := by
  change ‖J x‖ < (1 / 3 : ℝ)
  rw [norm_J hx]
  exact hx

theorem H_mem_U {x : K} (hx : x ∈ U) : H x ∈ U := by
  change ‖H x‖ < (1 / 3 : ℝ)
  rw [norm_H hx]
  exact hx

theorem H_J {x : K} (hx : x ∈ U) : H (J x) = x := by
  have hd := J_den_ne_zero hx
  have he : 1 - (x / (1 + x / 3)) / 3 = 1 / (1 + x / 3) := by
    apply (eq_div_iff hd).mpr
    calc
      (1 - (x / (1 + x / 3)) / 3) * (1 + x / 3) =
          (1 + x / 3) - ((x / (1 + x / 3)) * (1 + x / 3)) / 3 := by ring
      _ = 1 := by rw [div_mul_cancel₀ x hd]; ring
  unfold H J
  rw [he, div_div_div_cancel_right₀ hd, div_one]

theorem J_H {x : K} (hx : x ∈ U) : J (H x) = x := by
  have hd := H_den_ne_zero hx
  have he : 1 + (x / (1 - x / 3)) / 3 = 1 / (1 - x / 3) := by
    apply (eq_div_iff hd).mpr
    calc
      (1 + (x / (1 - x / 3)) / 3) * (1 - x / 3) =
          (1 - x / 3) + ((x / (1 - x / 3)) * (1 - x / 3)) / 3 := by ring
      _ = 1 := by rw [div_mul_cancel₀ x hd]; ring
  unfold J H
  rw [he, div_div_div_cancel_right₀ hd, div_one]

theorem J_analyticOnNhd : AnalyticOnNhd K J U := by
  intro x hx
  have hid : AnalyticAt K (fun y : K => y) x := analyticAt_id
  have hd : AnalyticAt K (fun y : K => 1 + y / 3) x :=
    analyticAt_const.add (hid.div analyticAt_const (by norm_num))
  convert! hid.div hd (J_den_ne_zero hx) using 1

theorem actual_analytic_conjugacy_on_U :
    AnalyticOnNhd K H U ∧ AnalyticOnNhd K J U ∧
      Set.MapsTo H U U ∧ Set.MapsTo J U U ∧
      (∀ x ∈ U, J (H x) = x) ∧ (∀ x ∈ U, H (J x) = x) ∧
      (∀ x ∈ U, H (F x) = 3 * H x) := by
  exact ⟨H_analyticOnNhd, J_analyticOnNhd, (fun _ hx => H_mem_U hx),
    (fun _ hx => J_mem_U hx), (fun _ hx => J_H hx), (fun _ hx => H_J hx),
    (fun _ hx => Schroder_on_U hx)⟩

end Conjecture746
