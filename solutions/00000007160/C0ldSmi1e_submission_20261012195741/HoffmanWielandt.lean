import Frobenius
import Matching
import Reindexing

noncomputable section
open scoped BigOperators ComplexConjugate
open Matrix

namespace HoffmanWielandt

/-- Complete algebraic eigenvalue list: characteristic polynomial factorization,
with one linear factor for each occurrence, so repeated eigenvalues retain multiplicity. -/
def IsEigenvalueList {n : ℕ} (A : Matrix (Fin n) (Fin n) ℂ) (lam : Fin n → ℂ) : Prop :=
  A.charpoly = ∏ i, (Polynomial.X - Polynomial.C (lam i))

/-- Squared optimal matching estimate in any complete orthonormal eigenbases. -/
theorem eigenbasis_matching_sq {E : Type*} [NormedAddCommGroup E]
    [InnerProductSpace ℂ E] [FiniteDimensional ℂ E]
    {n : Type*} [Fintype n] [DecidableEq n]
    (S T : E →ₗ[ℂ] E) (b c e : OrthonormalBasis n ℂ E) (lam mu : n → ℂ)
    (hb : ∀ i, S (b i) = lam i • b i) (hc : ∀ j, T (c j) = mu j • c j) :
    ∃ σ : Equiv.Perm n,
      (∑ i, ‖lam i - mu (σ i)‖ ^ 2) ≤
        frobeniusSq (LinearMap.toMatrixOrthonormal e (S - T)) := by
  obtain ⟨σ, hσ⟩ := exists_perm_cost_le
    (fun i j => ‖@inner ℂ E _ (b i) (c j)‖ ^ 2)
    (fun i j => ‖lam i - mu j‖ ^ 2) (overlaps_doublyStochastic b c)
  exact ⟨σ, hσ.trans_eq (weighted_cost_eq_frobenius S T b c e lam mu hb hc)⟩

/-- Full Hoffman–Wielandt inequality for arbitrary complex normal matrices.
The dimension may be zero. No commutation between A and B is assumed. -/
theorem normal_matrices_hoffman_wielandt_sq {n : ℕ}
    (A B : Matrix (Fin n) (Fin n) ℂ)
    (hA : Commute (star A) A) (hB : Commute (star B) B) :
    ∃ (lam mu : Fin n → ℂ) (σ : Equiv.Perm (Fin n)),
      IsEigenvalueList A lam ∧ IsEigenvalueList B mu ∧
      (∑ i, ‖lam i - mu (σ i)‖ ^ 2) ≤ frobeniusSq (A - B) := by
  let e := EuclideanSpace.basisFun (Fin n) ℂ
  let Φ := LinearMap.toMatrixOrthonormal e
  let S := Φ.symm A
  let T := Φ.symm B
  have hS : Commute (star S) S := by
    simpa only [S, map_star] using hA.map Φ.symm
  have hT : Commute (star T) T := by
    simpa only [T, map_star] using hB.map Φ.symm
  obtain ⟨b, lam, hb⟩ := normal_exists_eigenbasis S hS (by simp : Module.finrank ℂ (EuclideanSpace ℂ (Fin n)) = n)
  obtain ⟨c, mu, hc⟩ := normal_exists_eigenbasis T hT (by simp : Module.finrank ℂ (EuclideanSpace ℂ (Fin n)) = n)
  obtain ⟨σ, hσ⟩ := eigenbasis_matching_sq S T b c e lam mu hb hc
  refine ⟨lam, mu, σ, ?_, ?_, ?_⟩
  · change A.charpoly = _
    have h := eigenbasis_charpoly S b lam hb
    rw [← LinearMap.charpoly_toMatrix S e.toBasis] at h
    change (Φ S).charpoly = _ at h
    simpa [S] using h
  · change B.charpoly = _
    have h := eigenbasis_charpoly T c mu hc
    rw [← LinearMap.charpoly_toMatrix T e.toBasis] at h
    change (Φ T).charpoly = _ at h
    simpa [T] using h
  · simpa only [S, T, Φ, map_sub, StarAlgEquiv.apply_symm_apply] using hσ

/-- Lipschitz form: the spectral matching distance is bounded by the Frobenius norm. -/
theorem normal_matrices_hoffman_wielandt {n : ℕ}
    (A B : Matrix (Fin n) (Fin n) ℂ)
    (hA : Commute (star A) A) (hB : Commute (star B) B) :
    ∃ (lam mu : Fin n → ℂ) (σ : Equiv.Perm (Fin n)),
      IsEigenvalueList A lam ∧ IsEigenvalueList B mu ∧
      Real.sqrt (∑ i, ‖lam i - mu (σ i)‖ ^ 2) ≤ frobeniusNorm (A - B) := by
  obtain ⟨lam, mu, σ, hAlam, hBmu, h⟩ := normal_matrices_hoffman_wielandt_sq A B hA hB
  exact ⟨lam, mu, σ, hAlam, hBmu, Real.sqrt_le_sqrt h⟩

/-- A complete list equals the characteristic polynomial's root multiset exactly. -/
theorem eigenvalueList_roots {n : ℕ} (A : Matrix (Fin n) (Fin n) ℂ)
    (lam : Fin n → ℂ) (hlam : IsEigenvalueList A lam) :
    A.charpoly.roots = (Finset.univ : Finset (Fin n)).val.map lam := by
  rw [hlam]
  simpa only [Finset.prod_eq_multiset_prod, Multiset.map_map, Function.comp_apply] using
    Polynomial.roots_multiset_prod_X_sub_C ((Finset.univ : Finset (Fin n)).val.map lam)

/-- The squared Hoffman–Wielandt inequality for arbitrary complete eigenvalue lists. -/
theorem hoffman_wielandt_sq {n : ℕ} (A B : Matrix (Fin n) (Fin n) ℂ)
    (hA : Aᴴ * A = A * Aᴴ) (hB : Bᴴ * B = B * Bᴴ)
    (lam mu : Fin n → ℂ) (hlam : IsEigenvalueList A lam) (hmu : IsEigenvalueList B mu) :
    ∃ σ : Equiv.Perm (Fin n),
      (∑ i, ‖lam i - mu (σ i)‖ ^ 2) ≤ ∑ i, ∑ j, ‖A i j - B i j‖ ^ 2 := by
  obtain ⟨lam₀, mu₀, σ₀, hlam₀, hmu₀, hcost⟩ :=
    normal_matrices_hoffman_wielandt_sq A B hA hB
  obtain ⟨e, he⟩ := exists_perm_of_prod_X_sub_C_eq lam lam₀ (hlam.symm.trans hlam₀)
  obtain ⟨f, hf⟩ := exists_perm_of_prod_X_sub_C_eq mu mu₀ (hmu.symm.trans hmu₀)
  refine ⟨(e.trans σ₀).trans f.symm, ?_⟩
  calc
    (∑ i, ‖lam i - mu (((e.trans σ₀).trans f.symm) i)‖ ^ 2) =
        ∑ i, ‖lam₀ (e i) - mu₀ (σ₀ (e i))‖ ^ 2 := by
      simp only [he, hf, Equiv.trans_apply, Equiv.apply_symm_apply]
    _ = ∑ i, ‖lam₀ i - mu₀ (σ₀ i)‖ ^ 2 := Equiv.sum_comp e (fun i => ‖lam₀ i - mu₀ (σ₀ i)‖ ^ 2)
    _ ≤ _ := hcost

/-- Spectral Lipschitz estimate with constant one in the Frobenius norm.
The eigenvalue lists are arbitrary and include algebraic multiplicity. -/
theorem hoffman_wielandt {n : ℕ} (A B : Matrix (Fin n) (Fin n) ℂ)
    (hA : Aᴴ * A = A * Aᴴ) (hB : Bᴴ * B = B * Bᴴ)
    (lam mu : Fin n → ℂ) (hlam : IsEigenvalueList A lam) (hmu : IsEigenvalueList B mu) :
    ∃ σ : Equiv.Perm (Fin n),
      Real.sqrt (∑ i, ‖lam i - mu (σ i)‖ ^ 2) ≤ frobeniusNorm (A - B) := by
  obtain ⟨σ, hσ⟩ := hoffman_wielandt_sq A B hA hB lam mu hlam hmu
  exact ⟨σ, Real.sqrt_le_sqrt hσ⟩

end HoffmanWielandt
