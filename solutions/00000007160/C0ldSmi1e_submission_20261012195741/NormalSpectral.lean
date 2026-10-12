import Mathlib.Analysis.InnerProductSpace.JointEigenspace
import Mathlib.Analysis.InnerProductSpace.Adjoint
import Mathlib.Data.Complex.Module
import Mathlib.LinearAlgebra.Charpoly.ToMatrix
import Mathlib.Tactic

noncomputable section
open scoped ComplexConjugate BigOperators
open Module.End

namespace HoffmanWielandt

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℂ E]
  [FiniteDimensional ℂ E]

/-- Normality yields a full orthonormal eigenbasis, including dimension zero. -/
theorem normal_exists_eigenbasis (T : E →ₗ[ℂ] E) (hT : Commute (star T) T)
    {n : ℕ} (hn : Module.finrank ℂ E = n) :
    ∃ (b : OrthonormalBasis (Fin n) ℂ E) (lam : Fin n → ℂ),
      ∀ i, T (b i) = lam i • b i := by
  classical
  let H : E →ₗ[ℂ] E := realPart T
  let K : E →ₗ[ℂ] E := imaginaryPart T
  have hH : H.IsSymmetric := (LinearMap.isSymmetric_iff_isSelfAdjoint H).2
    (realPart T).property
  have hK : K.IsSymmetric := (LinearMap.isSymmetric_iff_isSelfAdjoint K).2
    (imaginaryPart T).property
  have hHK : Commute H K := by
    dsimp [H, K]
    rw [realPart_apply_coe, imaginaryPart_apply_coe]
    apply Commute.smul_left
    apply Commute.smul_right
    apply Commute.smul_right
    exact ((Commute.refl T).add_left hT).sub_right
      (hT.symm.add_left (Commute.refl (star T)))
  let V : ℂ × ℂ → Submodule ℂ E := fun p => eigenspace H p.2 ⊓ eigenspace K p.1
  have hV : DirectSum.IsInternal V := hH.directSum_isInternal_of_commute hK hHK
  have hVo : OrthogonalFamily ℂ (fun p => V p) (fun p => (V p).subtypeₗᵢ) :=
    hH.orthogonalFamily_eigenspace_inf_eigenspace hK
  have hfin : {p | V p ≠ ⊥}.Finite :=
    WellFoundedGT.finite_ne_bot_of_iSupIndep hV.submodule_iSupIndep
  letI : Fintype {p // V p ≠ ⊥} := hfin.fintype
  have hV' : DirectSum.IsInternal (fun p : {p // V p ≠ ⊥} => V p) :=
    DirectSum.isInternal_ne_bot_iff.mpr hV
  have hVo' := hVo.comp (f := fun p : {p // V p ≠ ⊥} => p.val) Subtype.val_injective
  let b := hV'.subordinateOrthonormalBasis hn hVo'
  let p := fun i => (hV'.subordinateOrthonormalBasisIndex hn i hVo').val
  refine ⟨b, fun i => (p i).2 + Complex.I * (p i).1, ?_⟩
  intro i
  have hb : b i ∈ V (p i) := hV'.subordinateOrthonormalBasis_subordinate hn i hVo'
  have hbiH : H (b i) = (p i).2 • b i := mem_eigenspace_iff.mp hb.1
  have hbiK : K (b i) = (p i).1 • b i := mem_eigenspace_iff.mp hb.2
  calc
    T (b i) = (H + Complex.I • K) (b i) := by
      rw [show H + Complex.I • K = T from realPart_add_I_smul_imaginaryPart T]
    _ = ((p i).2 + Complex.I * (p i).1) • b i := by
      simp only [LinearMap.add_apply, LinearMap.smul_apply, hbiH, hbiK, smul_smul,
        add_smul]

omit [FiniteDimensional ℂ E] in
/-- Matrix coordinates in a complete eigenbasis are diagonal. -/
theorem eigenbasis_toMatrix {n : Type*} [Fintype n] [DecidableEq n]
    (T : E →ₗ[ℂ] E) (b : OrthonormalBasis n ℂ E) (lam : n → ℂ)
    (hb : ∀ i, T (b i) = lam i • b i) :
    LinearMap.toMatrix b.toBasis b.toBasis T = Matrix.diagonal lam := by
  ext i j
  by_cases h : i = j <;> simp [LinearMap.toMatrix_apply, hb, Matrix.diagonal_apply, h, eq_comm]

/-- The eigenbasis lists every root with its algebraic multiplicity. -/
theorem eigenbasis_charpoly {n : Type*} [Fintype n] [DecidableEq n]
    (T : E →ₗ[ℂ] E) (b : OrthonormalBasis n ℂ E) (lam : n → ℂ)
    (hb : ∀ i, T (b i) = lam i • b i) :
    T.charpoly = ∏ i, (Polynomial.X - Polynomial.C (lam i)) := by
  rw [← LinearMap.charpoly_toMatrix T b.toBasis, eigenbasis_toMatrix T b lam hb]
  simp only [Matrix.charpoly, Matrix.charmatrix, Matrix.scalar_apply, RingHom.mapMatrix_apply, Matrix.diagonal_map (map_zero Polynomial.C)]
  rw [Matrix.diagonal_sub]
  simp [Matrix.det_diagonal]

omit [FiniteDimensional ℂ E] in
/-- In an orthonormal eigenbasis, each coordinate functional is a left eigenvector. -/
theorem inner_eigenbasis_apply {n : Type*} [Fintype n]
    (T : E →ₗ[ℂ] E) (b : OrthonormalBasis n ℂ E) (lam : n → ℂ)
    (hb : ∀ i, T (b i) = lam i • b i) (i : n) (x : E) :
    @inner ℂ E _ (b i) (T x) = lam i * @inner ℂ E _ (b i) x := by
  classical
  conv_lhs => rw [← b.sum_repr x]
  simp only [map_sum, map_smul, hb, inner_sum, inner_smul_right,
    orthonormal_iff_ite.mp b.orthonormal]
  simp [OrthonormalBasis.repr_apply_apply, mul_comm]

end HoffmanWielandt
