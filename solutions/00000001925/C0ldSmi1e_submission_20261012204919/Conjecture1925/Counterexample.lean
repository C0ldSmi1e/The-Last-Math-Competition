import Conjecture1925.Nonconvergence

noncomputable section

open scoped ENNReal Topology
open MeasureTheory Filter

namespace Conjecture1925

/-- Complete specification of the single fixed counterexample to qualitative L∞ convergence.
The explicit nonergodicity clause records the scope limitation of the construction.
-/
theorem counterexample :
    IsProbabilityMeasure μ ∧
    Function.Bijective (rotation : Ω → Ω) ∧
    Measurable (rotation : Ω → Ω) ∧
    Measurable (rotation.symm : Ω → Ω) ∧
    MeasurePreserving (rotation : Ω → Ω) μ μ ∧
    MemLp observable ∞ μ ∧
    (∀ x, 0 ≤ observable x ∧ observable x ≤ 1) ∧
    squarePolynomial.natDegree = 2 ∧
    (∀ N x, average N x = (∑ k ∈ Finset.range N,
      observable ((rotation : Ω → Ω)^[squarePolynomial.eval k] x)) / N) ∧
    (∀ N : ℕ, 0 < N → (1 / 2 : ℝ) ≤
      ‖averageLp (2 * N) - averageLp N‖) ∧
    (¬ CauchySeq averageLp) ∧
    (¬ ∃ g : Lp ℝ ∞ μ, Tendsto averageLp atTop (𝓝 g)) ∧
    ¬ Ergodic (rotation : Ω → Ω) μ := by
  exact ⟨inferInstance, rotation.bijective, rotation_measurable, inverse_measurable,
    rotation_measurePreserving, observable_memLp, observable_bounds, squarePolynomial_degree,
    average_eq_polynomial_average, fun _ hN => lp_norm_gap_all hN,
    averages_not_cauchy, no_Linfinity_limit, rotation_not_ergodic⟩

end Conjecture1925
