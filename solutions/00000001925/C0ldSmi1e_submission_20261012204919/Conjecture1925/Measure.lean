import Conjecture1925.Dynamics
import Mathlib.Probability.Distributions.Geometric
import Mathlib.Dynamics.Ergodic.Ergodic

noncomputable section

open scoped ENNReal NNReal BigOperators
open MeasureTheory ProbabilityTheory

namespace Conjecture1925

instance : Countable Ω := by unfold Ω; infer_instance
instance : MeasurableSpace Ω := ⊤
instance : MeasurableSingletonClass Ω := ⟨fun _ => trivial⟩

/-- The n-th cycle receives geometric mass 2^(-(n+1)). -/
def cycleMass : PMF ℕ := geometricPMF (p := 1 / 2) (by norm_num) (by norm_num)

/-- Equal positive mass at every point within a component. -/
def atomMass (x : Ω) : ℝ≥0∞ := cycleMass x.1 / cycleLength x.1

lemma finite_cycle_sum (m : ℕ) [NeZero m] (w : ℝ≥0∞) :
    (∑' _j : ZMod m, w / (m : ℝ≥0∞)) = w := by
  rw [tsum_fintype]
  simp only [Finset.sum_const, Finset.card_univ, ZMod.card, nsmul_eq_mul]
  apply ENNReal.mul_div_cancel
  · simpa only [Nat.cast_ne_zero] using (NeZero.ne m)
  · simp

lemma atomMass_sum : ∑' x : Ω, atomMass x = 1 := by
  change (∑' x : (n : ℕ) × ZMod (cycleLength n),
    cycleMass x.1 / (cycleLength x.1 : ℝ≥0∞)) = 1
  rw [ENNReal.tsum_sigma (fun n (_j : ZMod (cycleLength n)) =>
    cycleMass n / (cycleLength n : ℝ≥0∞))]
  simp_rw [finite_cycle_sum]
  exact cycleMass.tsum_coe

/-- A probability mass function on the whole, fixed countable space. -/
def distribution : PMF Ω := ⟨atomMass, ENNReal.summable.hasSum_iff.mpr atomMass_sum⟩

/-- The fixed probability measure used throughout the counterexample. -/
def μ : Measure Ω := distribution.toMeasure

instance : IsProbabilityMeasure μ := PMF.toMeasure.isProbabilityMeasure distribution

lemma measure_singleton (x : Ω) : μ {x} = atomMass x :=
  distribution.toMeasure_apply_singleton x (measurableSet_singleton x)

lemma atomMass_pos (x : Ω) : 0 < atomMass x := by
  unfold atomMass
  apply ENNReal.div_pos
  · apply ne_of_gt
    change 0 < ENNReal.ofReal (geometricPMFReal (1 / 2) x.1)
    apply ENNReal.ofReal_pos.mpr
    apply geometricPMFReal_pos <;> norm_num
  · simp

/-- Crucial bridge: witness points cannot be discarded by the essential supremum. -/
lemma singleton_pos (x : Ω) : 0 < μ {x} := by
  rw [measure_singleton]
  exact atomMass_pos x

lemma ae_iff_forall {P : Ω → Prop} : (∀ᵐ x ∂μ, P x) ↔ ∀ x, P x := by
  rw [ae_iff_of_countable]
  exact ⟨fun h x => h x (singleton_pos x).ne', fun h x _ => h x⟩

lemma rotation_measurable : Measurable (rotation : Ω → Ω) := measurable_of_countable _
lemma inverse_measurable : Measurable (rotation.symm : Ω → Ω) := measurable_of_countable _

/-- Rotation preserves every singleton mass, hence the measure on every set. -/
lemma rotation_measurePreserving : MeasurePreserving (rotation : Ω → Ω) μ μ := by
  refine ⟨rotation_measurable, Measure.ext_of_singleton (fun x => ?_)⟩
  rw [Measure.map_apply rotation_measurable (measurableSet_singleton x)]
  have hpre : (rotation : Ω → Ω) ⁻¹' {x} = {rotation.symm x} := by
    ext y
    change rotation y = x ↔ y = rotation.symm x
    exact rotation.apply_eq_iff_eq_symm_apply
  rw [hpre, measure_singleton, measure_singleton]
  rfl

/-- The invariant n-th component. -/
def component (n : ℕ) : Set Ω := {x | x.1 = n}

lemma component_invariant (n : ℕ) :
    (rotation : Ω → Ω) ⁻¹' component n = component n := rfl

lemma component_measure (n : ℕ) : μ (component n) = cycleMass n := by
  classical
  rw [μ, PMF.toMeasure_apply _ _ (show MeasurableSet (component n) from trivial)]
  simp only [Set.indicator_apply, component, Set.mem_setOf_eq]
  change (∑' x : (i : ℕ) × ZMod (cycleLength i),
    if x.1 = n then cycleMass x.1 / (cycleLength x.1 : ℝ≥0∞) else 0) = cycleMass n
  rw [ENNReal.tsum_sigma (fun i (_j : ZMod (cycleLength i)) =>
    if i = n then cycleMass i / (cycleLength i : ℝ≥0∞) else 0)]
  rw [tsum_eq_single n]
  · simp only [ite_true, finite_cycle_sum]
  · intro b hb
    simp only [hb, ite_false, tsum_zero]

lemma component_zero_measure : μ (component 0) = (1 / 2 : ℝ≥0∞) := by
  rw [component_measure]
  change ENNReal.ofReal ((1 - (1 / 2 : ℝ)) ^ 0 * (1 / 2)) = _
  norm_num [ENNReal.ofReal_div_of_pos (by norm_num : (0 : ℝ) < 2)]

/-- Scope check: the counterexample is deliberately nonergodic. -/
lemma rotation_not_ergodic : ¬ Ergodic (rotation : Ω → Ω) μ := by
  intro h
  have h01 := h.toPreErgodic.prob_eq_zero_or_one
    (show MeasurableSet (component 0) from trivial) (component_invariant 0)
  rw [component_zero_measure] at h01
  norm_num at h01

end Conjecture1925
