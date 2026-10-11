import Mathlib
import Conjecture7175.Statement

/-! # Conjecture 00000007175: realizability of real spectra by symmetric tridiagonal matrices,
and positivity of a tridiagonal matrix via its chain of leading principal minors. -/

-- (formal statement: see Statement.lean)

namespace C7175

open Matrix Polynomial

theorem realizable : Realizable := by
  intro n l
  refine ⟨diagonal l, ?_, ?_, ?_⟩
  · exact (diagonal_transpose l)
  · intro i j hij
    have : i ≠ j := by
      rintro rfl; omega
    simp [diagonal_apply_ne _ this]
  · rw [charpoly_diagonal]

theorem posDef_minors {n : ℕ} {A : Matrix (Fin n) (Fin n) ℝ} (hA : A.PosDef) (k : ℕ)
    (h : k ≤ n) : 0 < leadingMinor A k h :=
  (hA.submatrix (Fin.castLE_injective h)).det_pos

theorem minors_posDef : ∀ (n : ℕ) (A : Matrix (Fin n) (Fin n) ℝ), A.IsSymm →
    (∀ (k : ℕ) (h : k ≤ n), 0 < leadingMinor A k h) → A.PosDef := by
  intro n
  induction n with
  | zero =>
    intro A hA _
    refine PosDef.of_dotProduct_mulVec_pos ?_ ?_
    · exact hA
    · intro x hx
      exact absurd (Subsingleton.elim x 0) hx
  | succ n ih =>
    intro A hA hmin
    set B : Matrix (Fin n) (Fin n) ℝ := A.submatrix Fin.castSucc Fin.castSucc with hBdef
    have hBsymm : B.IsSymm := by
      ext i j; simpa [hBdef] using (congrFun (congrFun hA (Fin.castSucc j)) (Fin.castSucc i)).symm
    have hBpos : B.PosDef := by
      refine ih B hBsymm fun k hk => ?_
      have := hmin k (hk.trans n.le_succ)
      have e : B.submatrix (Fin.castLE hk) (Fin.castLE hk)
          = A.submatrix (Fin.castLE (hk.trans n.le_succ)) (Fin.castLE (hk.trans n.le_succ)) := by
        ext i j; simp [hBdef]
      simpa [leadingMinor, e] using this
    have hdetA : 0 < A.det := by
      have := hmin (n + 1) le_rfl
      have e : A.submatrix (Fin.castLE (le_refl (n + 1))) (Fin.castLE (le_refl (n + 1))) = A := by
        ext i j; simp
      simpa [leadingMinor, e] using this
    -- reindex as a block matrix
    let e : Fin n ⊕ Fin 1 ≃ Fin (n + 1) := finSumFinEquiv
    set M : Matrix (Fin n ⊕ Fin 1) (Fin n ⊕ Fin 1) ℝ := A.submatrix e e with hM
    have hMsymm : M.IsSymm := by
      ext i j; simpa [hM] using (congrFun (congrFun hA (e j)) (e i)).symm
    have hB11 : M.toBlocks₁₁ = B := by
      ext i j; simp [hM, hBdef, e, Matrix.toBlocks₁₁]; rfl
    have hblocks : M = fromBlocks B M.toBlocks₁₂ M.toBlocks₁₂ᴴ M.toBlocks₂₂ := by
      conv_lhs => rw [← fromBlocks_toBlocks M]
      have h21 : M.toBlocks₂₁ = M.toBlocks₁₂ᴴ := by
        ext i j
        have := congrFun (congrFun hMsymm (Sum.inl j)) (Sum.inr i)
        simpa [Matrix.toBlocks₂₁, Matrix.toBlocks₁₂, Matrix.conjTranspose_apply] using this
      rw [h21, hB11]
    have hdetM : 0 < M.det := by
      rw [hM, det_submatrix_equiv_self]; exact hdetA
    have : Invertible B := hBpos.isUnit.invertible
    have hdetB := hBpos.det_pos
    set S : Matrix (Fin 1) (Fin 1) ℝ := M.toBlocks₂₂ - M.toBlocks₁₂ᴴ * B⁻¹ * M.toBlocks₁₂ with hS
    have hdetfac : M.det = B.det * S.det := by
      conv_lhs => rw [hblocks]
      rw [det_fromBlocks₁₁, invOf_eq_nonsing_inv]
    have hSpos : 0 < S.det := by
      rw [hdetfac] at hdetM
      exact pos_of_mul_pos_right hdetM hdetB.le |> fun h => by
        by_contra hc
        push Not at hc
        nlinarith
    have hS00 : 0 < S 0 0 := by simpa [det_unique] using hSpos
    have hSsemi : S.PosSemidef := by
      refine PosSemidef.of_dotProduct_mulVec_nonneg ?_ ?_
      · ext i j
        have hi : i = 0 := Subsingleton.elim _ _
        have hj : j = 0 := Subsingleton.elim _ _
        subst hi; subst hj; simp
      · intro x
        simp [dotProduct, Matrix.mulVec]
        nlinarith [mul_self_nonneg (x 0), hS00]
    have hMsemi : M.PosSemidef := by
      rw [hblocks]
      exact (PosDef.fromBlocks₁₁ _ _ hBpos).mpr hSsemi
    have hMpos : M.PosDef := (hMsemi.posDef_iff_det_ne_zero).mpr hdetM.ne'
    have := hMpos.submatrix (e := e.symm) e.symm.injective
    simpa [hM, Matrix.submatrix_submatrix] using this

theorem minorCriterion : MinorCriterion := by
  intro n A hA _
  exact ⟨fun h k hk => posDef_minors h k hk, minors_posDef n A hA⟩

theorem main : Claim := ⟨realizable, minorCriterion⟩

end C7175
