import Counting

open Finset

namespace GeometricThrackle

lemma same_sign_of_positive_products {a b d : ℝ} (ha : 0 < a * d) (hb : 0 < b * d) :
    0 < a * b := by
  rcases mul_pos_iff.mp ha with ⟨ha, hd⟩ | ⟨ha, hd⟩ <;>
    rcases mul_pos_iff.mp hb with ⟨hb, hd'⟩ | ⟨hb, hd'⟩
  · exact mul_pos ha hb
  · linarith
  · linarith
  · exact mul_pos_of_neg_of_neg ha hb

theorem nonleaf_neighbors_le_two {V : Type*} [Fintype V]
    (G : SimpleGraph V) [DecidableRel G.Adj]
    (D : V → V → V → ℝ)
    (hskew : ∀ v a b, D v b a = -D v a b)
    (hside : ∀ v a, G.Adj v a → G.degree a ≠ 1 →
      ∃ d : ℝ, ∀ b, G.Adj v b → b ≠ a → 0 < D v a b * d)
    (v : V) : ((G.neighborFinset v).filter fun w => G.degree w ≠ 1).card ≤ 2 := by
  classical
  by_contra hn
  have hn' : 2 < ((G.neighborFinset v).filter fun w => G.degree w ≠ 1).card := by omega
  obtain ⟨a, b, c, ha, hb, hc, hab, hac, hbc⟩ := Finset.two_lt_card_iff.mp hn'
  simp only [Finset.mem_filter, SimpleGraph.mem_neighborFinset] at ha hb hc
  obtain ⟨da, hda⟩ := hside v a ha.1 ha.2
  obtain ⟨db, hdb⟩ := hside v b hb.1 hb.2
  obtain ⟨dc, hdc⟩ := hside v c hc.1 hc.2
  have ha' := same_sign_of_positive_products (hda b hb.1 hab.symm) (hda c hc.1 hac.symm)
  have hb' := same_sign_of_positive_products (hdb a ha.1 hab) (hdb c hc.1 hbc.symm)
  have hc' := same_sign_of_positive_products (hdc a ha.1 hac) (hdc b hb.1 hbc)
  rw [hskew v a b] at hb'
  rw [hskew v a c, hskew v b c] at hc'
  rcases mul_pos_iff.mp ha' with ⟨hab', hac'⟩ | ⟨hab', hac'⟩ <;>
    rcases mul_pos_iff.mp hb' with ⟨hba', hbc'⟩ | ⟨hba', hbc'⟩ <;>
    rcases mul_pos_iff.mp hc' with ⟨hca', hcb'⟩ | ⟨hca', hcb'⟩ <;> linarith

end GeometricThrackle
