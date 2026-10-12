import HoffmanWielandt

noncomputable section
open scoped BigOperators ComplexConjugate
open HoffmanWielandt Matrix

namespace HoffmanWielandtVerification

/-- The public result specializes to the full entrywise formula, not an operator norm. -/
theorem full_statement {n : ℕ} (A B : Matrix (Fin n) (Fin n) ℂ)
    (hA : Aᴴ * A = A * Aᴴ) (hB : Bᴴ * B = B * Bᴴ) :
    ∃ (lam mu : Fin n → ℂ) (σ : Equiv.Perm (Fin n)),
      A.charpoly = ∏ i, (Polynomial.X - Polynomial.C (lam i)) ∧
      B.charpoly = ∏ i, (Polynomial.X - Polynomial.C (mu i)) ∧
      Real.sqrt (∑ i, ‖lam i - mu (σ i)‖ ^ 2) ≤
        Real.sqrt (∑ i, ∑ j, ‖A i j - B i j‖ ^ 2) :=
  normal_matrices_hoffman_wielandt A B hA hB

/-- Dimension zero is covered without a nonempty assumption. -/
example (A B : Matrix (Fin 0) (Fin 0) ℂ) :
    ∃ (lam mu : Fin 0 → ℂ) (σ : Equiv.Perm (Fin 0)),
      IsEigenvalueList A lam ∧ IsEigenvalueList B mu ∧
      Real.sqrt (∑ i, ‖lam i - mu (σ i)‖ ^ 2) ≤ frobeniusNorm (A - B) := by
  apply normal_matrices_hoffman_wielandt A B <;> exact Subsingleton.elim _ _

/-- The matching lemma permits signed costs and the empty index type. -/
example (W C : Matrix (Fin 0) (Fin 0) ℝ) :
    ∃ σ : Equiv.Perm (Fin 0), (∑ i, -C i (σ i)) ≤ ∑ i, ∑ j, W i j * (-C i j) := by
  apply exists_perm_cost_le W (fun i j => -C i j)
  simp [mem_doublyStochastic_iff_sum]

/-- Repeated eigenvalues are repeated linear factors. -/
example : IsEigenvalueList (diagonal (fun _ : Fin 2 => Complex.I))
    (fun _ : Fin 2 => Complex.I) := by
  simp [IsEigenvalueList, Matrix.charpoly, Matrix.charmatrix]

/-- One-dimensional scalar perturbations attain constant one exactly. -/
example : Real.sqrt (∑ _i : Fin 1, ‖(0 : ℂ) - 1‖ ^ 2) =
    frobeniusNorm ((0 : Matrix (Fin 1) (Fin 1) ℂ) - 1) := by
  simp [frobeniusNorm, frobeniusSq]

def A : Matrix (Fin 2) (Fin 2) ℂ := !![Complex.I, 0; 0, 0]
def B : Matrix (Fin 2) (Fin 2) ℂ := !![0, Complex.I; Complex.I, 0]

theorem A_normal : Commute (star A) A := by
  unfold Commute SemiconjBy
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [A, Matrix.mul_apply, Fin.sum_univ_two]

theorem B_normal : Commute (star B) B := by
  unfold Commute SemiconjBy
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [B, Matrix.mul_apply, Fin.sum_univ_two]

theorem A_not_hermitian : star A ≠ A := by
  intro h
  have h00 := congrArg (fun M : Matrix (Fin 2) (Fin 2) ℂ => (M 0 0).im) h
  norm_num [A] at h00

theorem B_not_hermitian : star B ≠ B := by
  intro h
  have h01 := congrArg (fun M : Matrix (Fin 2) (Fin 2) ℂ => (M 0 1).im) h
  norm_num [B] at h01

theorem matrices_do_not_commute : ¬ Commute A B := by
  intro h
  have h01 := congrArg (fun M : Matrix (Fin 2) (Fin 2) ℂ => (M 0 1).re) h.eq
  norm_num [A, B, Matrix.mul_apply, Fin.sum_univ_two] at h01

/-- Both matrices are non-Hermitian and they do not commute, yet the theorem applies. -/
example : ∃ (lam mu : Fin 2 → ℂ) (σ : Equiv.Perm (Fin 2)),
    IsEigenvalueList A lam ∧ IsEigenvalueList B mu ∧
    Real.sqrt (∑ i, ‖lam i - mu (σ i)‖ ^ 2) ≤ frobeniusNorm (A - B) :=
  normal_matrices_hoffman_wielandt A B A_normal B_normal

/-- Arbitrary enumerations of the two characteristic-polynomial root multisets are allowed. -/
example {n : ℕ} (M N : Matrix (Fin n) (Fin n) ℂ)
    (hM : Mᴴ * M = M * Mᴴ) (hN : Nᴴ * N = N * Nᴴ)
    (lam mu : Fin n → ℂ) (hlam : IsEigenvalueList M lam) (hmu : IsEigenvalueList N mu) :
    ∃ σ : Equiv.Perm (Fin n),
      Real.sqrt (∑ i, ‖lam i - mu (σ i)‖ ^ 2) ≤
        Real.sqrt (∑ i, ∑ j, ‖M i j - N i j‖ ^ 2) :=
  hoffman_wielandt M N hM hN lam mu hlam hmu

/-- Nonempty signed costs require no extra sign hypothesis. -/
example (W : Matrix (Fin 2) (Fin 2) ℝ) (hW : W ∈ doublyStochastic ℝ (Fin 2)) :
    ∃ σ : Equiv.Perm (Fin 2), (∑ i, if i = σ i then (-7 : ℝ) else 3) ≤
      ∑ i, ∑ j, W i j * (if i = j then (-7 : ℝ) else 3) :=
  exists_perm_cost_le W (fun i j => if i = j then -7 else 3) hW

/-- Reversing the order of arbitrary roots is handled by the multiplicity bridge. -/
example (z w : ℂ) :
    ∃ e : Equiv.Perm (Fin 2),
      ∀ i, (if i = 0 then z else w) = (if e i = 0 then w else z) := by
  apply exists_perm_of_prod_X_sub_C_eq
    (fun i : Fin 2 => if i = 0 then z else w)
    (fun i : Fin 2 => if i = 0 then w else z)
  simp [Fin.prod_univ_two, mul_comm]

example (z : ℂ) :
    ∃ e : Equiv.Perm (Fin 3), ∀ i, (fun _ : Fin 3 => z) i = (fun _ : Fin 3 => z) (e i) :=
  exists_perm_of_prod_X_sub_C_eq (fun _ => z) (fun _ => z) rfl

#print axioms HoffmanWielandt.eigenvalueList_roots
#print axioms HoffmanWielandt.exists_perm_of_prod_X_sub_C_eq
#print axioms HoffmanWielandt.hoffman_wielandt_sq
#print axioms HoffmanWielandt.hoffman_wielandt

#print axioms HoffmanWielandt.normal_exists_eigenbasis
#print axioms HoffmanWielandt.eigenbasis_charpoly
#print axioms HoffmanWielandt.weighted_cost_eq_frobenius
#print axioms HoffmanWielandt.exists_perm_cost_le
#print axioms HoffmanWielandt.normal_matrices_hoffman_wielandt_sq
#print axioms HoffmanWielandt.normal_matrices_hoffman_wielandt
#print axioms full_statement

end HoffmanWielandtVerification
