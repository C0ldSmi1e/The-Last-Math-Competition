import Mathlib.Analysis.Convex.Birkhoff
import Mathlib.Data.Real.Basic

open scoped BigOperators
open Finset Matrix

namespace HoffmanWielandt

theorem exists_perm_cost_le {n : Type*} [Fintype n] [DecidableEq n]
    (W C : Matrix n n ℝ) (hW : W ∈ doublyStochastic ℝ n) :
    ∃ σ : Equiv.Perm n, (∑ i, C i (σ i)) ≤ ∑ i, ∑ j, W i j * C i j := by
  classical
  obtain ⟨w, hw, hw_sum, hw_matrix⟩ := exists_eq_sum_perm_of_mem_doublyStochastic hW
  obtain ⟨σ, _, hσ⟩ := exists_min_image (univ : Finset (Equiv.Perm n))
    (fun τ => ∑ i, C i (τ i)) univ_nonempty
  refine ⟨σ, ?_⟩
  have hcost : (∑ i, ∑ j, W i j * C i j) =
      ∑ τ : Equiv.Perm n, w τ * ∑ i, C i (τ i) := by
    rw [← hw_matrix]
    simp only [Matrix.sum_apply, smul_apply, smul_eq_mul, Finset.sum_mul]
    calc
      _ = ∑ i, ∑ τ : Equiv.Perm n, ∑ j, w τ * τ.permMatrix ℝ i j * C i j := by
        exact Finset.sum_congr rfl fun i _ => Finset.sum_comm
      _ = ∑ τ : Equiv.Perm n, ∑ i, ∑ j, w τ * τ.permMatrix ℝ i j * C i j :=
        Finset.sum_comm
      _ = _ := by simp [Finset.mul_sum, Equiv.toPEquiv_apply, mul_assoc]
  rw [hcost]
  calc
    (∑ i, C i (σ i)) = ∑ τ : Equiv.Perm n, w τ * (∑ i, C i (σ i)) := by
      rw [← Finset.sum_mul, hw_sum, one_mul]
    _ ≤ ∑ τ : Equiv.Perm n, w τ * (∑ i, C i (τ i)) := by
      exact Finset.sum_le_sum fun τ _ => mul_le_mul_of_nonneg_left (hσ τ (mem_univ τ)) (hw τ)

end HoffmanWielandt
