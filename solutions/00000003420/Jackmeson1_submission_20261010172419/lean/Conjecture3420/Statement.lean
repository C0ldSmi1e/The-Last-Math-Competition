import Mathlib

/-! Formal statement for Conjecture3420: definitions only, ending in `Claim`. Split verbatim from the marked block of `Basic.lean`. -/

-- STATEMENT BEGIN
namespace C3420

open Matrix

variable {V : Type} [Fintype V] [DecidableEq V]

/-- Eigenvalue `λ_k` of the Laplacian `L` (for an arbitrary chosen orthonormal eigenbasis). -/
noncomputable def lam (G : SimpleGraph V) [DecidableRel G.Adj] (k : V) : ℝ :=
  (G.isHermitian_lapMatrix ℝ).eigenvalues k

/-- Orthonormal eigenvector `u_k` of `L` for `λ_k`, as a function on vertices. -/
noncomputable def vec (G : SimpleGraph V) [DecidableRel G.Adj] (k : V) : V → ℝ :=
  (G.isHermitian_lapMatrix ℝ).eigenvectorBasis k

/-- "the pseudoinverse": the Moore-Penrose pseudoinverse `L⁺ = ∑_{λ_k ≠ 0} λ_k⁻¹ u_k u_kᵀ`,
written as `U * diag(λ_k⁻¹ if λ_k ≠ 0 else 0) * Uᵀ` with `U` the matrix of eigenvectors. -/
noncomputable def pinv (G : SimpleGraph V) [DecidableRel G.Adj] : Matrix V V ℝ :=
  (G.isHermitian_lapMatrix ℝ).eigenvectorUnitary *
    diagonal (fun k => if lam G k = 0 then 0 else (lam G k)⁻¹) *
    ((G.isHermitian_lapMatrix ℝ).eigenvectorUnitary : Matrix V V ℝ)ᵀ

/-- The current vector `e_i - e_j`. -/
def current (i j : V) : V → ℝ := Pi.single i 1 - Pi.single j 1

/-- "the electrical network correspondence": `v` is a potential for unit current `i → j`,
i.e. `L v = e_i - e_j` (unit conductances). -/
def IsPotential (G : SimpleGraph V) [DecidableRel G.Adj] (i j : V) (v : V → ℝ) : Prop :=
  G.lapMatrix ℝ *ᵥ v = current i j

/-- The four Moore-Penrose equations for `X` as a pseudoinverse of `L`. -/
def IsMoorePenrose (G : SimpleGraph V) [DecidableRel G.Adj] (X : Matrix V V ℝ) : Prop :=
  G.lapMatrix ℝ * X * G.lapMatrix ℝ = G.lapMatrix ℝ ∧ X * G.lapMatrix ℝ * X = X ∧
    (G.lapMatrix ℝ * X)ᵀ = G.lapMatrix ℝ * X ∧ (X * G.lapMatrix ℝ)ᵀ = X * G.lapMatrix ℝ

/-- The conjecture: for every finite connected simple graph and all vertices `i j`, the
pseudoinverse is the (unique) Moore-Penrose inverse of `L`, a potential exists, and the effective resistance
`v i - v j` (for every potential `v`) equals the quadratic form `(e_i-e_j)ᵀ L⁺ (e_i-e_j)`, which
equals the sum `∑_{λ_k>0} (u_k i - u_k j)^2 / λ_k`. -/
def Conjecture : Prop :=
  ∀ (V : Type) [Fintype V] [DecidableEq V] (G : SimpleGraph V) [DecidableRel G.Adj],
    G.Connected → IsMoorePenrose G (pinv G) ∧ (∀ X, IsMoorePenrose G X → X = pinv G) ∧ ∀ i j : V,
      (∃ v, IsPotential G i j v) ∧
      (∀ v, IsPotential G i j v →
        v i - v j = current i j ⬝ᵥ (pinv G *ᵥ current i j) ∧
        current i j ⬝ᵥ (pinv G *ᵥ current i j) =
          ∑ k ∈ Finset.univ.filter (fun k => 0 < lam G k),
            (vec G k i - vec G k j) ^ 2 / lam G k)

/-- What this package proves. -/
def Claim : Prop := Conjecture

end C3420
-- STATEMENT END
