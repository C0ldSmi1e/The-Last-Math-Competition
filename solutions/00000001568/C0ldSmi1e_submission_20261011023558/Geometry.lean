import Mathlib.Analysis.Convex.Between
import Mathlib.Tactic

namespace GeometricThrackle

abbrev Point := ℝ × ℝ

def det (a b : Point) : ℝ := a.1 * b.2 - a.2 * b.1

theorem det_swap (a b : Point) : det a b = -det b a := by
  unfold det
  ring

def Seg (a b : Point) : Set Point :=
  {p | ∃ t : ℝ, 0 ≤ t ∧ t ≤ 1 ∧ p = (1 - t) • a + t • b}

theorem seg_eq_segment (a b : Point) : Seg a b = segment ℝ a b := by
  ext p
  constructor
  · rintro ⟨t, ht, ht', rfl⟩
    exact ⟨1 - t, t, by linarith, ht, by ring, rfl⟩
  · rintro ⟨s, t, hs, ht, hst, hp⟩
    refine ⟨t, ht, by linarith, ?_⟩
    have : s = 1 - t := by linarith
    simpa [this] using hp.symm

theorem left_mem_Seg (a b : Point) : a ∈ Seg a b := by
  exact ⟨0, le_rfl, zero_le_one, by simp⟩

theorem right_mem_Seg (a b : Point) : b ∈ Seg a b := by
  exact ⟨1, zero_le_one, le_rfl, by simp⟩

theorem Seg_symm (a b : Point) : Seg a b = Seg b a := by
  simpa only [seg_eq_segment] using segment_symm ℝ a b

theorem Seg_comm (a b : Point) : Seg a b = Seg b a := Seg_symm a b

theorem det_sub_zero_collinear {v a p : Point} (ha : a ≠ v)
    (h : det (a - v) (p - v) = 0) : Collinear ℝ ({v, a, p} : Set Point) := by
  have hcoord : (a.1 - v.1) * (p.2 - v.2) -
      (a.2 - v.2) * (p.1 - v.1) = 0 := h
  have hrep : ∃ c : ℝ, p = c • (a - v) + v := by
    by_cases h1 : a.1 - v.1 = 0
    · have h2 : a.2 - v.2 ≠ 0 := by
        intro h2
        apply ha
        apply Prod.ext <;> linarith
      refine ⟨(p.2 - v.2) / (a.2 - v.2), ?_⟩
      apply Prod.ext
      · simp only [Prod.fst_add, Prod.smul_fst, Prod.fst_sub, smul_eq_mul]
        have : p.1 - v.1 = 0 := by
          rw [h1, zero_mul, zero_sub, neg_eq_zero] at hcoord
          exact (mul_eq_zero.mp hcoord).resolve_left h2
        simp [h1]
        linarith
      · simp only [Prod.snd_add, Prod.smul_snd, Prod.snd_sub, smul_eq_mul]
        field_simp
    · refine ⟨(p.1 - v.1) / (a.1 - v.1), ?_⟩
      apply Prod.ext
      · simp only [Prod.fst_add, Prod.smul_fst, Prod.fst_sub, smul_eq_mul]
        field_simp
      · simp only [Prod.snd_add, Prod.smul_snd, Prod.snd_sub, smul_eq_mul]
        field_simp
        nlinarith
  rw [collinear_iff_of_mem (by simp : v ∈ ({v, a, p} : Set Point))]
  refine ⟨a - v, ?_⟩
  intro q hq
  simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hq
  rcases hq with rfl | rfl | rfl
  · exact ⟨0, by simp⟩
  · exact ⟨1, by simp⟩
  · exact hrep

theorem det_strict_side {v a b x : Point} (ha : a ≠ v) (_hb : b ≠ v)
    (hab : Seg v a ∩ Seg v b = {v})
    (hax : Seg v a ∩ Seg a x = {a})
    (hmeet : (Seg v b ∩ Seg a x).Nonempty) :
    0 < det (a - v) (b - v) * det (a - v) (x - v) := by
  obtain ⟨p, hpb, hpx⟩ := hmeet
  have hpv : p ≠ v := by
    intro h
    have : v ∈ Seg v a ∩ Seg a x := ⟨left_mem_Seg _ _, h ▸ hpx⟩
    rw [hax, Set.mem_singleton_iff] at this
    exact ha this.symm
  have hpa : p ≠ a := by
    intro h
    have : a ∈ Seg v a ∩ Seg v b := ⟨right_mem_Seg _ _, h ▸ hpb⟩
    rw [hab, Set.mem_singleton_iff] at this
    exact ha this
  have hpdet : det (a - v) (p - v) ≠ 0 := by
    intro hzero
    have hcol := det_sub_zero_collinear ha hzero
    have hpb' : p ∈ segment ℝ v b := by simpa only [← seg_eq_segment] using hpb
    have hpx' : p ∈ segment ℝ a x := by simpa only [← seg_eq_segment] using hpx
    rcases hcol.wbtw_or_wbtw_or_wbtw with h | h | h
    · have havb : a ∈ Seg v b := by
        rw [seg_eq_segment]
        exact (convex_segment v b).segment_subset (left_mem_segment ℝ v b) hpb'
          h.mem_segment
      have : a ∈ Seg v a ∩ Seg v b := ⟨right_mem_Seg _ _, havb⟩
      rw [hab, Set.mem_singleton_iff] at this
      exact ha this
    · have hpva : p ∈ Seg v a := by
        rw [seg_eq_segment, segment_symm ℝ v a]
        exact h.mem_segment
      have : p ∈ Seg v a ∩ Seg v b := ⟨hpva, hpb⟩
      rw [hab, Set.mem_singleton_iff] at this
      exact hpv this
    · have hvax : v ∈ Seg a x := by
        rw [seg_eq_segment]
        exact (convex_segment a x).segment_subset hpx' (left_mem_segment ℝ a x)
          h.mem_segment
      have : v ∈ Seg v a ∩ Seg a x := ⟨left_mem_Seg _ _, hvax⟩
      rw [hax, Set.mem_singleton_iff] at this
      exact ha this.symm
  obtain ⟨t, ht, ht1, hpt⟩ := hpb
  obtain ⟨s, hs, hs1, hps⟩ := hpx
  have htpos : 0 < t := by
    by_contra h
    have : t = 0 := by linarith
    exact hpv (by simpa [this] using hpt)
  have hspos : 0 < s := by
    by_contra h
    have : s = 0 := by linarith
    exact hpa (by simpa [this] using hps)
  have hdt : det (a - v) (p - v) = t * det (a - v) (b - v) := by
    rw [hpt]
    simp only [det, Prod.fst_sub, Prod.snd_sub, Prod.fst_add, Prod.snd_add,
      Prod.smul_fst, Prod.smul_snd, smul_eq_mul]
    ring
  have hds : det (a - v) (p - v) = s * det (a - v) (x - v) := by
    rw [hps]
    simp only [det, Prod.fst_sub, Prod.snd_sub, Prod.fst_add, Prod.snd_add,
      Prod.smul_fst, Prod.smul_snd, smul_eq_mul]
    ring
  have hprod : 0 < (t * det (a - v) (b - v)) *
      (s * det (a - v) (x - v)) := by
    rw [← hdt, ← hds]
    exact mul_self_pos.mpr hpdet
  have hts : 0 < t * s := mul_pos htpos hspos
  have heq : (t * det (a - v) (b - v)) * (s * det (a - v) (x - v)) =
      (t * s) * (det (a - v) (b - v) * det (a - v) (x - v)) := by ring
  rw [heq] at hprod
  exact (mul_pos_iff_of_pos_left hts).mp hprod

end GeometricThrackle
