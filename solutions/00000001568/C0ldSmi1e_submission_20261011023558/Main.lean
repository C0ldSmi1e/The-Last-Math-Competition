import Angular
import Geometry

open Finset

namespace GeometricThrackle

/-- A straight-edge drawing with distinct vertices and exactly one intersection
point for every pair of distinct (unordered) graph edges. No general-position
or proper-crossing assumption is made. -/
structure Drawing {V : Type*} (G : SimpleGraph V) where
  position : V → Point
  injective : Function.Injective position
  intersects_once : ∀ a b c d, G.Adj a b → G.Adj c d → s(a, b) ≠ s(c, d) →
    ∃! q, q ∈ Seg (position a) (position b) ∩ Seg (position c) (position d)

theorem Drawing.incident_intersection {V : Type*} {G : SimpleGraph V} (T : Drawing G)
    {v a b : V} (ha : G.Adj v a) (hb : G.Adj v b) (hab : a ≠ b) :
    Seg (T.position v) (T.position a) ∩ Seg (T.position v) (T.position b) =
      {T.position v} := by
  have he : s(v, a) ≠ s(v, b) := by
    intro he
    rcases Sym2.eq_iff.mp he with ⟨_, hab'⟩ | ⟨hvb, _⟩
    · exact hab hab'
    · exact hb.ne hvb
  obtain ⟨q, hq, hu⟩ := T.intersects_once v a v b ha hb he
  have hv : T.position v ∈ Seg (T.position v) (T.position a) ∩
      Seg (T.position v) (T.position b) := ⟨left_mem_Seg _ _, left_mem_Seg _ _⟩
  ext z
  constructor
  · intro hz
    exact Set.mem_singleton_iff.mpr ((hu z hz).trans (hu _ hv).symm)
  · intro hz
    simpa only [Set.mem_singleton_iff.mp hz] using hv

theorem Drawing.side_property {V : Type*} [Fintype V] {G : SimpleGraph V}
    [DecidableRel G.Adj] (T : Drawing G) (v a : V) (ha : G.Adj v a)
    (hna : G.degree a ≠ 1) :
    ∃ d : ℝ, ∀ b, G.Adj v b → b ≠ a →
      0 < det (T.position a - T.position v) (T.position b - T.position v) * d := by
  classical
  have hpos : 0 < G.degree a := (G.degree_pos_iff_exists_adj a).mpr ⟨v, ha.symm⟩
  have htwo : 1 < (G.neighborFinset a).card := by
    rw [SimpleGraph.card_neighborFinset_eq_degree]
    omega
  obtain ⟨x, hx, hxv⟩ := Finset.exists_mem_ne htwo v
  have hax : G.Adj a x := (G.mem_neighborFinset a x).mp hx
  refine ⟨det (T.position a - T.position v) (T.position x - T.position v), ?_⟩
  intro b hb hba
  have hav : T.position a ≠ T.position v := fun h => ha.ne (T.injective h).symm
  have hbv : T.position b ≠ T.position v := fun h => hb.ne (T.injective h).symm
  have hi := T.incident_intersection ha hb hba.symm
  have hj := T.incident_intersection ha.symm hax hxv.symm
  rw [Seg_symm (T.position a) (T.position v)] at hj
  have he : s(v, b) ≠ s(a, x) := by
    intro he
    rcases Sym2.eq_iff.mp he with ⟨hva, _⟩ | ⟨hvx, _⟩
    · exact ha.ne hva
    · exact hxv hvx.symm
  obtain ⟨q, hq, _⟩ := T.intersects_once v b a x hb hax he
  exact det_strict_side hav hbv hi hj ⟨q, hq⟩

/-- The original geometric thrackle bound: every finite straight-edge graph in
the real plane with one intersection per distinct edge pair has at most as
many edges as vertices. -/
theorem geometric_thrackle_bound {V : Type*} [Fintype V] (G : SimpleGraph V)
    [DecidableRel G.Adj] (T : Drawing G) : G.edgeFinset.card ≤ Fintype.card V := by
  apply edge_bound_of_nonleaf_neighbors G
  apply nonleaf_neighbors_le_two G
    (fun v a b => det (T.position a - T.position v) (T.position b - T.position v))
  · intro v a b
    simp only [det]
    ring
  · exact T.side_property

end GeometricThrackle

#print axioms GeometricThrackle.geometric_thrackle_bound
