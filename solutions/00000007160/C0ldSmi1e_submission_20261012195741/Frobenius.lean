import NormalSpectral
import Mathlib.Data.Matrix.DoublyStochastic
import Mathlib.Analysis.Matrix

noncomputable section
open scoped BigOperators ComplexConjugate

namespace HoffmanWielandt

/-- Squared Frobenius norm, explicitly summing all matrix entries. -/
def frobeniusSq {n : Type*} [Fintype n] (A : Matrix n n ℂ) : ℝ :=
  ∑ i, ∑ j, ‖A i j‖ ^ 2

/-- Frobenius norm with no reliance on the default norm instance for matrices. -/
def frobeniusNorm {n : Type*} [Fintype n] (A : Matrix n n ℂ) : ℝ :=
  Real.sqrt (frobeniusSq A)

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℂ E]
  [FiniteDimensional ℂ E]
variable {n : Type*} [Fintype n] [DecidableEq n]

omit [DecidableEq n] in
/-- The sum of squared image norms is independent of the orthonormal basis. -/
theorem sum_image_sq_eq_adjoint (T : E →ₗ[ℂ] E)
    (b c : OrthonormalBasis n ℂ E) :
    (∑ i, ‖T (b i)‖ ^ 2) = ∑ j, ‖(LinearMap.adjoint T) (c j)‖ ^ 2 := by
  calc
    (∑ i, ‖T (b i)‖ ^ 2) = ∑ i, ∑ j, ‖@inner ℂ E _ (c j) (T (b i))‖ ^ 2 := by
      simp only [c.sum_sq_norm_inner]
    _ = ∑ j, ∑ i, ‖@inner ℂ E _ (b i) ((LinearMap.adjoint T) (c j))‖ ^ 2 := by
      rw [Finset.sum_comm]
      apply Finset.sum_congr rfl
      intro j hj
      apply Finset.sum_congr rfl
      intro i hi
      rw [← LinearMap.adjoint_inner_left]
      rw [norm_inner_symm]
    _ = ∑ j, ‖(LinearMap.adjoint T) (c j)‖ ^ 2 := by
      simp only [b.sum_sq_norm_inner]

omit [DecidableEq n] in
theorem sum_image_sq_basis_independent (T : E →ₗ[ℂ] E)
    (b c : OrthonormalBasis n ℂ E) :
    (∑ i, ‖T (b i)‖ ^ 2) = ∑ i, ‖T (c i)‖ ^ 2 :=
  (sum_image_sq_eq_adjoint T b c).trans (sum_image_sq_eq_adjoint T c c).symm

theorem frobeniusSq_toMatrix (T : E →ₗ[ℂ] E) (b : OrthonormalBasis n ℂ E) :
    frobeniusSq (LinearMap.toMatrixOrthonormal b T) = ∑ i, ‖T (b i)‖ ^ 2 := by
  unfold frobeniusSq
  simp only [LinearMap.toMatrixOrthonormal_apply_apply]
  rw [Finset.sum_comm]
  simp only [b.sum_sq_norm_inner]

omit [FiniteDimensional ℂ E] in
/-- Squared overlaps of any two orthonormal bases are doubly stochastic. -/
theorem overlaps_doublyStochastic (b c : OrthonormalBasis n ℂ E) :
    (fun i j => ‖@inner ℂ E _ (b i) (c j)‖ ^ 2) ∈ doublyStochastic ℝ n := by
  rw [mem_doublyStochastic_iff_sum]
  refine ⟨fun i j => sq_nonneg _, ?_, ?_⟩
  · intro i
    simp_rw [norm_inner_symm (b i)]
    rw [c.sum_sq_norm_inner, b.norm_eq_one, one_pow]
  · intro j
    rw [b.sum_sq_norm_inner, c.norm_eq_one, one_pow]

/-- The doubly stochastic weighted matching cost is exactly the Frobenius difference. -/
theorem weighted_cost_eq_frobenius
    (S T : E →ₗ[ℂ] E) (b c e : OrthonormalBasis n ℂ E) (lam mu : n → ℂ)
    (hb : ∀ i, S (b i) = lam i • b i) (hc : ∀ j, T (c j) = mu j • c j) :
    (∑ i, ∑ j, ‖@inner ℂ E _ (b i) (c j)‖ ^ 2 * ‖lam i - mu j‖ ^ 2) =
      frobeniusSq (LinearMap.toMatrixOrthonormal e (S - T)) := by
  have hcoord (i j : n) :
      @inner ℂ E _ (b i) ((S - T) (c j)) =
        (lam i - mu j) * @inner ℂ E _ (b i) (c j) := by
    simp only [LinearMap.sub_apply, inner_sub_right,
      inner_eigenbasis_apply S b lam hb, hc, inner_smul_right, sub_mul]
  calc
    _ = ∑ i, ∑ j, ‖@inner ℂ E _ (b i) ((S - T) (c j))‖ ^ 2 := by
      simp only [hcoord, norm_mul, mul_pow, mul_comm]
    _ = ∑ j, ‖(S - T) (c j)‖ ^ 2 := by
      rw [Finset.sum_comm]
      simp only [b.sum_sq_norm_inner]
    _ = ∑ j, ‖(S - T) (e j)‖ ^ 2 := sum_image_sq_basis_independent _ c e
    _ = _ := (frobeniusSq_toMatrix _ e).symm

section FrobeniusNormInstance
attribute [local instance] Matrix.frobeniusNormedAddCommGroup

/-- The explicit entrywise norm agrees with Mathlib's Frobenius norm instance. -/
theorem frobeniusNorm_eq_mathlib {m : Type*} [Fintype m] (A : Matrix m m ℂ) :
    frobeniusNorm A = ‖A‖ := by
  rw [Matrix.frobenius_norm_def]
  simp only [frobeniusNorm, frobeniusSq, Real.rpow_two, Real.sqrt_eq_rpow]

end FrobeniusNormInstance

end HoffmanWielandt
