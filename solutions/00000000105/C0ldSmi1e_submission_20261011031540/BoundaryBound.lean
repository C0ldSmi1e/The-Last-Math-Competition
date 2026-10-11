import Mathlib.Analysis.NormedSpace.Connected
import Mathlib.Analysis.Normed.Affine.AddTorsor
import Mathlib.Analysis.InnerProductSpace.PiL2

noncomputable section

open Set Metric

namespace TLMC105

/-- A closed proper convex set in dimension greater than one is bounded whenever
its frontier is bounded. -/
theorem bounded_of_convex_frontier_bounded
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (hdim : 1 < Module.rank ℝ E) {s : Set E}
    (hc : IsClosed s) (hv : Convex ℝ s) (hs : s ≠ univ)
    (hf : Bornology.IsBounded (frontier s)) : Bornology.IsBounded s := by
  obtain ⟨p, hp⟩ := (Set.ne_univ_iff_exists_not_mem s).mp hs
  obtain ⟨R, hR⟩ := hf.subset_closedBall p
  apply (isBounded_iff_subset_closedBall p).mpr
  refine ⟨R, ?_⟩
  intro x hx
  by_contra hdist
  have hfar : R < dist x p := lt_of_not_ge hdist
  have havoid (y : E) (hy : y ∈ sphere p (dist x p)) : y ∉ frontier s := by
    intro hyf
    have hbound := hR hyf
    rw [mem_closedBall, mem_sphere.mp hy] at hbound
    exact (not_le.mpr hfar) hbound
  have hcover : sphere p (dist x p) ⊆ interior s ∪ sᶜ := by
    intro y hy
    by_cases hys : y ∈ s
    · left
      by_contra hni
      exact havoid y hy (by rw [hc.frontier_eq]; exact ⟨hys, hni⟩)
    · exact Or.inr hys
  have hdisjoint : Disjoint (interior s) sᶜ :=
    disjoint_compl_right.mono_left interior_subset
  rcases (isPreconnected_sphere hdim p (dist x p)).subset_or_subset
      isOpen_interior hc.isOpen_compl hdisjoint hcover with hin | hout
  · have hreflect : Equiv.pointReflection p x ∈ sphere p (dist x p) := by
      change dist (Equiv.pointReflection p x) p = dist x p
      rw [dist_pointReflection_left, dist_comm]
    have hreflects : Equiv.pointReflection p x ∈ s := interior_subset (hin hreflect)
    exact hp (by simpa using hv.midpoint_mem hx hreflects)
  · exact hout (show x ∈ sphere p (dist x p) from rfl) hx

/-- In three-dimensional Euclidean space, a proper closed convex set with compact
frontier is bounded. -/
theorem bounded_of_convex_compact_frontier
    {s : Set (EuclideanSpace ℝ (Fin 3))}
    (hc : IsClosed s) (hv : Convex ℝ s) (hs : s ≠ univ)
    (hf : IsCompact (frontier s)) : Bornology.IsBounded s := by
  apply bounded_of_convex_frontier_bounded (E := EuclideanSpace ℝ (Fin 3))
      ?_ hc hv hs hf.isBounded
  rw [← Module.finrank_eq_rank, finrank_euclideanSpace_fin]
  norm_num

end TLMC105
