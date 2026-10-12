import Conjecture1925.Measure
import Mathlib.MeasureTheory.Function.LpSpace.Basic

noncomputable section

open scoped ENNReal NNReal Topology
open MeasureTheory Filter

namespace Conjecture1925

lemma observable_memLp : MemLp observable ∞ μ := by
  apply memLp_top_of_bound (measurable_of_countable _).aestronglyMeasurable 1
  apply ae_of_all
  intro x
  rw [Real.norm_eq_abs, abs_of_nonneg (observable_bounds x).1]
  exact (observable_bounds x).2

lemma average_memLp (N : ℕ) : MemLp (average N) ∞ μ := by
  apply memLp_top_of_bound (measurable_of_countable _).aestronglyMeasurable 1
  apply ae_of_all
  intro x
  rw [Real.norm_eq_abs, abs_of_nonneg (average_bounds N x).1]
  exact (average_bounds N x).2

/-- The actual equivalence class of the polynomial average in Mathlib's L∞ space. -/
def averageLp (N : ℕ) : Lp ℝ ∞ μ := (average_memLp N).toLp (average N)

/-- The essential supremum is bounded below by the gap at a positive-mass atom. -/
lemma essential_gap (n : ℕ) :
    (1 / 2 : ℝ≥0∞) ≤ eLpNorm (average (2 * (n + 1)) - average (n + 1)) ∞ μ := by
  have h := ae_iff_forall.mp
    (enorm_ae_le_eLpNormEssSup (average (2 * (n + 1)) - average (n + 1)) μ) (base n)
  simpa [eLpNorm_exponent_top, Pi.sub_apply, average_at_base,
    double_average_at_base, enorm, Real.nnnorm_of_nonneg] using h

/-- Separation takes place in the true quotient norm, not a pointwise surrogate. -/
lemma lp_edist_gap (n : ℕ) :
    (1 / 2 : ℝ≥0∞) ≤ edist (averageLp (2 * (n + 1))) (averageLp (n + 1)) := by
  rw [averageLp, averageLp, Lp.edist_toLp_toLp]
  exact essential_gap n

lemma lp_norm_gap (n : ℕ) :
    (1 / 2 : ℝ) ≤ ‖averageLp (2 * (n + 1)) - averageLp (n + 1)‖ := by
  have h := lp_edist_gap n
  rw [edist_dist, dist_eq_norm] at h
  apply (ENNReal.ofReal_le_ofReal_iff (by positivity)).mp
  convert h using 1
  norm_num [ENNReal.ofReal_div_of_pos (by norm_num : (0 : ℝ) < 2)]

/-- All positive averaging lengths exhibit a fixed norm gap from their doubled length. -/
lemma lp_norm_gap_all {N : ℕ} (hN : 0 < N) :
    (1 / 2 : ℝ) ≤ ‖averageLp (2 * N) - averageLp N‖ := by
  obtain ⟨n, rfl⟩ := Nat.exists_eq_succ_of_ne_zero hN.ne'
  exact lp_norm_gap n

/-- Failure of the Cauchy condition rules out every possible L∞ limit. -/
theorem averages_not_cauchy : ¬ CauchySeq averageLp := by
  intro h
  obtain ⟨N, hN⟩ := EMetric.cauchySeq_iff.mp h (1 / 2) (by norm_num)
  have hclose := hN (2 * (N + 1)) (by omega) (N + 1) (by omega)
  exact not_lt_of_ge (lp_edist_gap N) hclose

/-- Qualitative norm convergence already fails, independently of any proposed rate. -/
theorem no_Linfinity_limit : ¬ ∃ g : Lp ℝ ∞ μ, Tendsto averageLp atTop (𝓝 g) := by
  rintro ⟨g, hg⟩
  exact averages_not_cauchy hg.cauchySeq

end Conjecture1925
