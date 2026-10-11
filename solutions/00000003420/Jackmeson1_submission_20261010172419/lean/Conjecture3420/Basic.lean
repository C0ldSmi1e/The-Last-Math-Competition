import Mathlib
import Conjecture3420.Statement

/-!
# Conjecture 00000003420: the spectral formula of effective resistance

Conventions: `G` is a finite connected simple graph with unit conductances, `L = G.lapMatrix ℝ`.
Effective resistance between `i` and `j` is the electrical one: `v i - v j` for any potential `v`
with `L v = e_i - e_j`.  "Pseudoinverse" is the Moore-Penrose pseudoinverse, built spectrally
(`U * diag(λ_k⁻¹ or 0) * Uᵀ`) and shown to satisfy the four Penrose equations.  "The harmonic series
of eigenvalues" is read as the weighted reciprocal-eigenvalue expansion
`∑_{λ_k > 0} (u_k i - u_k j)^2 / λ_k`.
-/

-- (formal statement: see Statement.lean)

namespace C3420

open Matrix

variable {V : Type} [Fintype V] [DecidableEq V] (G : SimpleGraph V) [DecidableRel G.Adj]

local notation "hL" => G.isHermitian_lapMatrix ℝ

/-- the eigenvector matrix -/
noncomputable abbrev U : Matrix V V ℝ := (hL).eigenvectorUnitary

lemma U_mul_T : U G * (U G)ᵀ = 1 := by
  have := Unitary.coe_mul_star_self ((hL).eigenvectorUnitary)
  simpa [Matrix.star_eq_conjTranspose, conjTranspose_eq_transpose_of_trivial] using this

lemma T_mul_U : (U G)ᵀ * U G = 1 := by
  have := Unitary.coe_star_mul_self ((hL).eigenvectorUnitary)
  simpa [Matrix.star_eq_conjTranspose, conjTranspose_eq_transpose_of_trivial] using this

lemma U_apply (i k : V) : U G i k = vec G k i := rfl

lemma lam_nonneg (k : V) : 0 ≤ lam G k :=
  (G.posSemidef_lapMatrix ℝ).eigenvalues_nonneg k

lemma lap_eq : G.lapMatrix ℝ = U G * diagonal (lam G) * (U G)ᵀ := by
  have h := (hL).spectral_theorem
  rw [Unitary.conjStarAlgAut_apply] at h
  simp [Matrix.star_eq_conjTranspose, conjTranspose_eq_transpose_of_trivial] at h
  exact h

/-- the reciprocal-or-zero diagonal -/
noncomputable def dinv (k : V) : ℝ := if lam G k = 0 then 0 else (lam G k)⁻¹

lemma pinv_eq : pinv G = U G * diagonal (dinv G) * (U G)ᵀ := rfl

lemma D_Dinv : diagonal (lam G) * diagonal (dinv G) = diagonal (fun k => if lam G k = 0 then 0 else 1) := by
  rw [diagonal_mul_diagonal]; congr 1; ext k; unfold dinv; split_ifs with h <;> simp [h]

lemma Dinv_D : diagonal (dinv G) * diagonal (lam G) = diagonal (fun k => if lam G k = 0 then 0 else 1) := by
  rw [diagonal_mul_diagonal]; congr 1; ext k; unfold dinv; split_ifs with h <;> simp [h]

lemma D_Dinv_D : diagonal (lam G) * diagonal (dinv G) * diagonal (lam G) = diagonal (lam G) := by
  rw [diagonal_mul_diagonal, diagonal_mul_diagonal]; congr 1; ext k; unfold dinv
  split_ifs with h <;> simp [h]

lemma Dinv_D_Dinv : diagonal (dinv G) * diagonal (lam G) * diagonal (dinv G) = diagonal (dinv G) := by
  rw [diagonal_mul_diagonal, diagonal_mul_diagonal]; congr 1; ext k; unfold dinv
  split_ifs with h <;> simp [h]

lemma LP : G.lapMatrix ℝ * pinv G = U G * diagonal (fun k => if lam G k = 0 then (0:ℝ) else 1) * (U G)ᵀ := by
  rw [lap_eq G, pinv_eq]
  calc _ = U G * (diagonal (lam G) * ((U G)ᵀ * U G) * diagonal (dinv G)) * (U G)ᵀ := by
        simp only [Matrix.mul_assoc]
    _ = _ := by rw [T_mul_U, Matrix.mul_one, D_Dinv]

lemma PL : pinv G * G.lapMatrix ℝ = U G * diagonal (fun k => if lam G k = 0 then (0:ℝ) else 1) * (U G)ᵀ := by
  rw [lap_eq G, pinv_eq]
  calc _ = U G * (diagonal (dinv G) * ((U G)ᵀ * U G) * diagonal (lam G)) * (U G)ᵀ := by
        simp only [Matrix.mul_assoc]
    _ = _ := by rw [T_mul_U, Matrix.mul_one, Dinv_D]

lemma moorePenrose : IsMoorePenrose G (pinv G) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · conv_lhs => rw [lap_eq G, pinv_eq]
    calc _ = U G * (diagonal (lam G) * ((U G)ᵀ * U G) * diagonal (dinv G) * ((U G)ᵀ * U G)
          * diagonal (lam G)) * (U G)ᵀ := by simp only [Matrix.mul_assoc]
      _ = _ := by rw [T_mul_U]; simp only [Matrix.mul_one]; rw [D_Dinv_D]; exact (lap_eq G).symm
  · conv_lhs => rw [lap_eq G, pinv_eq]
    calc _ = U G * (diagonal (dinv G) * ((U G)ᵀ * U G) * diagonal (lam G) * ((U G)ᵀ * U G)
          * diagonal (dinv G)) * (U G)ᵀ := by simp only [Matrix.mul_assoc]
      _ = _ := by rw [T_mul_U]; simp only [Matrix.mul_one]; rw [Dinv_D_Dinv]; exact (pinv_eq G).symm
  · rw [LP]; simp [Matrix.transpose_mul, Matrix.mul_assoc]
  · rw [PL]; simp [Matrix.transpose_mul, Matrix.mul_assoc]

/-- entries of `Uᵀ e` -/
lemma UT_current (i j : V) : (U G)ᵀ *ᵥ current i j = fun k => vec G k i - vec G k j := by
  ext k
  simp [current, Matrix.mulVec, dotProduct, U, vec, mul_sub, Finset.sum_sub_distrib,
    Pi.single_apply]

lemma vec_const (hG : G.Connected) (k : V) (hk : lam G k = 0) (i j : V) : vec G k i = vec G k j := by
  have h : G.lapMatrix ℝ *ᵥ vec G k = 0 := by
    have := (hL).mulVec_eigenvectorBasis k
    unfold vec; rw [this]; unfold lam at hk; simp [hk]
  rw [SimpleGraph.lapMatrix_mulVec_eq_zero_iff_forall_reachable] at h
  exact h i j (hG.preconnected i j)

lemma LP_current (hG : G.Connected) (i j : V) : G.lapMatrix ℝ *ᵥ (pinv G *ᵥ current i j) = current i j := by
  rw [mulVec_mulVec, LP, ← Matrix.mulVec_mulVec, ← Matrix.mulVec_mulVec, UT_current]
  have : (diagonal (fun k => if lam G k = 0 then (0:ℝ) else 1)) *ᵥ (fun k => vec G k i - vec G k j)
      = fun k => vec G k i - vec G k j := by
    ext k
    rw [mulVec_diagonal]
    by_cases h : lam G k = 0
    · simp [h, vec_const G hG k h i j]
    · simp [h]
  rw [this, ← UT_current G i j, Matrix.mulVec_mulVec, U_mul_T, one_mulVec]

lemma quad_eq (i j : V) : current i j ⬝ᵥ (pinv G *ᵥ current i j) =
    ∑ k, dinv G k * (vec G k i - vec G k j) ^ 2 := by
  rw [pinv_eq, ← Matrix.mulVec_mulVec, ← Matrix.mulVec_mulVec, UT_current, dotProduct_mulVec]
  have : current i j ᵥ* U G = fun k => vec G k i - vec G k j := by
    rw [← Matrix.mulVec_transpose, UT_current G i j]
  rw [this]
  simp only [dotProduct, mulVec_diagonal]
  refine Finset.sum_congr rfl fun k _ => ?_
  ring

lemma potential_value (i j : V) (hG : G.Connected) (v : V → ℝ) (hv : G.lapMatrix ℝ *ᵥ v = current i j) :
    v i - v j = current i j ⬝ᵥ (pinv G *ᵥ current i j) := by
  have h1 : v i - v j = v ⬝ᵥ current i j := by
    simp [current, dotProduct, Pi.single_apply, mul_sub, Finset.sum_sub_distrib]
  have hs : (G.lapMatrix ℝ)ᵀ = G.lapMatrix ℝ := (G.isSymm_lapMatrix ℝ)
  have h3 : v ᵥ* G.lapMatrix ℝ = G.lapMatrix ℝ *ᵥ v := by
    conv_lhs => rw [← hs]
    exact Matrix.vecMul_transpose _ _
  rw [h1]
  conv_lhs => rw [← LP_current G hG i j]
  rw [dotProduct_mulVec, h3, hv]

/-- positive eigenvalues -/
lemma sum_pos (i j : V) :
    ∑ k, dinv G k * (vec G k i - vec G k j) ^ 2 =
      ∑ k ∈ Finset.univ.filter (fun k => 0 < lam G k), (vec G k i - vec G k j) ^ 2 / lam G k := by
  rw [Finset.sum_filter]
  refine Finset.sum_congr rfl fun k _ => ?_
  have := lam_nonneg G k
  unfold dinv
  by_cases h : lam G k = 0
  · simp [h]
  · have : 0 < lam G k := lt_of_le_of_ne this (Ne.symm h)
    simp [h, this]; ring

lemma mp_unique {A X Y : Matrix V V ℝ}
    (h1 : A * X * A = A) (h2 : X * A * X = X) (h3 : (A * X)ᵀ = A * X) (h4 : (X * A)ᵀ = X * A)
    (g1 : A * Y * A = A) (g2 : Y * A * Y = Y) (g3 : (A * Y)ᵀ = A * Y) (g4 : (Y * A)ᵀ = Y * A) :
    X = Y := by
  have e1 : A * X = A * Y :=
    calc A * X = (A * Y * A) * X := by rw [g1]
      _ = (A * Y) * (A * X) := by simp only [Matrix.mul_assoc]
      _ = (A * Y)ᵀ * (A * X)ᵀ := by rw [g3, h3]
      _ = (A * X * (A * Y))ᵀ := (Matrix.transpose_mul _ _).symm
      _ = (A * Y)ᵀ := by
          rw [show A * X * (A * Y) = (A * X * A) * Y by simp only [Matrix.mul_assoc], h1]
      _ = A * Y := g3
  have e2 : X * A = Y * A :=
    calc X * A = X * (A * Y * A) := by rw [g1]
      _ = (X * A) * (Y * A) := by simp only [Matrix.mul_assoc]
      _ = (X * A)ᵀ * (Y * A)ᵀ := by rw [g4, h4]
      _ = (Y * A * (X * A))ᵀ := (Matrix.transpose_mul _ _).symm
      _ = (Y * A)ᵀ := by
          rw [show Y * A * (X * A) = Y * (A * X * A) by simp only [Matrix.mul_assoc], h1]
      _ = Y * A := g4
  calc X = X * A * X := h2.symm
    _ = Y * A * X := by rw [e2]
    _ = Y * (A * X) := by rw [Matrix.mul_assoc]
    _ = Y * (A * Y) := by rw [e1]
    _ = Y := by rw [← Matrix.mul_assoc, g2]

/-- The four Penrose equations determine `L⁺`: any Moore-Penrose inverse of `L` is `pinv G`. -/
theorem moorePenrose_unique (X : Matrix V V ℝ) (hX : IsMoorePenrose G X) : X = pinv G := by
  obtain ⟨h1, h2, h3, h4⟩ := hX
  obtain ⟨g1, g2, g3, g4⟩ := moorePenrose G
  exact mp_unique h1 h2 h3 h4 g1 g2 g3 g4

theorem main : Claim := by
  intro V _ _ G _ hG
  refine ⟨moorePenrose G, fun X hX => moorePenrose_unique G X hX, fun i j => ⟨?_, fun v hv => ?_⟩⟩
  · exact ⟨_, LP_current G hG i j⟩
  · refine ⟨potential_value G i j hG v hv, ?_⟩
    rw [quad_eq, sum_pos]

end C3420
