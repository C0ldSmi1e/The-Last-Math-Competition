import Conjecture1925.Counterexample

/-!
Kernel-checked integration tests of the concrete system, conventional polynomial formula,
essential-supremum interpretation and universal exclusion of possible limits.
There is no numerical computation on which the disproof depends.
-/

open scoped ENNReal Topology
open MeasureTheory Filter

namespace Conjecture1925.Tests

example : μ Set.univ = 1 := measure_univ

example (x : Ω) : rotation.symm (rotation x) = x := rotation.symm_apply_apply x

example (x : Ω) : rotation (rotation.symm x) = x := rotation.apply_symm_apply x

example : MeasurePreserving (rotation : Ω → Ω) μ μ := rotation_measurePreserving

example (N : ℕ) : MemLp (average N) ∞ μ := average_memLp N

example : squarePolynomial.eval 0 = 0 ∧ squarePolynomial.eval 1 = 1 ∧
    squarePolynomial.eval 2 = 4 := by norm_num [squarePolynomial]

example (x : Ω) : average 0 x = 0 := by simp [average]

example : observable (base 0) = 0 := by
  norm_num [observable, base]
  rfl

example : average 1 (base 0) = 0 := average_at_base 0

example : average 2 (base 0) = 1 / 2 := double_average_at_base 0

example (N : ℕ) (hN : 0 < N) :
    (1 / 2 : ℝ) ≤ ‖(average_memLp (2 * N)).toLp (average (2 * N)) -
      (average_memLp N).toLp (average N)‖ := lp_norm_gap_all hN

example (N : ℕ) (x : Ω) :
    ((average_memLp N).toLp (average N) : Ω → ℝ) x = average N x :=
  ae_iff_forall.mp (average_memLp N).coeFn_toLp x

example (N : ℕ) : 0 < μ {base N} := singleton_pos (base N)

example : (rotation : Ω → Ω) ⁻¹' component 0 = component 0 ∧
    μ (component 0) = (1 / 2 : ℝ≥0∞) :=
  ⟨component_invariant 0, component_zero_measure⟩

example : ¬ ∃ g : Lp ℝ ∞ μ,
    Tendsto (fun N => (average_memLp N).toLp (average N)) atTop (𝓝 g) :=
  no_Linfinity_limit

#print axioms Conjecture1925.counterexample
#print axioms Conjecture1925.no_Linfinity_limit
#print axioms Conjecture1925.lp_norm_gap_all
#print axioms Conjecture1925.rotation_measurePreserving
#print axioms Conjecture1925.rotation_not_ergodic

end Conjecture1925.Tests
