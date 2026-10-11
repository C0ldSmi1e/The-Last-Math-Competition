import Mathlib

/-! Formal statement for Conjecture7175: definitions only, ending in `Claim`. Split verbatim from the marked block of `Basic.lean`. -/

-- STATEMENT BEGIN
namespace C7175

open Matrix Polynomial

/-- "tridiagonal": all entries with `|i - j| >= 2` vanish. -/
def IsTridiagonal {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ) : Prop :=
  ∀ i j : Fin n, ((i : ℕ) + 2 ≤ j ∨ (j : ℕ) + 2 ≤ i) → A i j = 0

/-- "the principal-minor chain": the `k x k` leading principal minor of `A`
(determinant of the top-left `k x k` block), for `k ≤ n`. -/
noncomputable def leadingMinor {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ) (k : ℕ) (h : k ≤ n) : ℝ :=
  (A.submatrix (Fin.castLE h) (Fin.castLE h)).det

/-- "Any real spectrum is realizable by a symmetric tridiagonal": for every `n` and every list
`l` of `n` real numbers (repeats allowed, multiplicities retained) there is a real symmetric
tridiagonal `n x n` matrix whose characteristic polynomial is `∏ (X - l i)`. -/
def Realizable : Prop :=
  ∀ (n : ℕ) (l : Fin n → ℝ), ∃ A : Matrix (Fin n) (Fin n) ℝ,
    A.IsSymm ∧ IsTridiagonal A ∧ A.charpoly = ∏ i, (X - C (l i))

/-- "the positivity of the tridiagonal is the principal-minor chain": a real symmetric
tridiagonal matrix is (strictly) positive definite iff all its leading principal minors
(`k = 1, ..., n`, and the trivial `k = 0`) are positive. -/
def MinorCriterion : Prop :=
  ∀ (n : ℕ) (A : Matrix (Fin n) (Fin n) ℝ), A.IsSymm → IsTridiagonal A →
    (A.PosDef ↔ ∀ (k : ℕ) (h : k ≤ n), 0 < leadingMinor A k h)

/-- The conjecture as written (both clauses). -/
def Conjecture : Prop := Realizable ∧ MinorCriterion

/-- What this package proves. -/
def Claim : Prop := Conjecture

end C7175
-- STATEMENT END
