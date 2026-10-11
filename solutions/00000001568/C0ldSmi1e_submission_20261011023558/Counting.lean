import Mathlib.Combinatorics.SimpleGraph.DegreeSum
import Mathlib.Tactic

open Finset

namespace GeometricThrackle

theorem edge_bound_of_nonleaf_neighbors {V : Type*} [Fintype V]
    (G : SimpleGraph V) [DecidableRel G.Adj]
    (h : ∀ v, ((G.neighborFinset v).filter fun w => G.degree w ≠ 1).card ≤ 2) :
    G.edgeFinset.card ≤ Fintype.card V := by
  classical
  let leafCount := fun v => ((G.neighborFinset v).filter fun w => G.degree w = 1).card
  have hpoint (v : V) : G.degree v + (if G.degree v = 1 then 1 else 0) ≤
      2 + leafCount v := by
    by_cases hv : G.degree v = 1
    · simp [hv]
    · have hsplit := Finset.filter_card_add_filter_neg_card_eq_card
        (s := G.neighborFinset v) (p := fun w => G.degree w = 1)
      have hc := h v
      simp only [ne_eq] at hc
      simp only [SimpleGraph.card_neighborFinset_eq_degree] at hsplit
      simp only [hv, ↓reduceIte, add_zero]
      dsimp [leafCount]
      omega
  have hsumLeaves : ∑ v, leafCount v = ∑ v : V, if G.degree v = 1 then 1 else 0 := by
    simp only [leafCount, Finset.card_filter]
    simp_rw [G.neighborFinset_eq_filter, Finset.sum_filter]
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl
    intro w _
    by_cases hw : G.degree w = 1
    · simp only [hw, ↓reduceIte]
      have hsym : ∀ v, G.Adj v w ↔ G.Adj w v := fun v => G.adj_comm v w
      simp_rw [hsym]
      rw [← Finset.card_filter, ← G.neighborFinset_eq_filter,
        SimpleGraph.card_neighborFinset_eq_degree, hw]
    · simp [hw]
  have hsum := Finset.sum_le_sum (s := Finset.univ) (fun v _ => hpoint v)
  simp only [Finset.sum_add_distrib, Finset.sum_const, Finset.card_univ, smul_eq_mul] at hsum
  rw [hsumLeaves, G.sum_degrees_eq_twice_card_edges] at hsum
  omega

end GeometricThrackle
