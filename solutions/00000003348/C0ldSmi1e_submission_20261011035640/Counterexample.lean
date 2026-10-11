import Mathlib.Analysis.NormedSpace.Connected
import Mathlib.Analysis.Calculus.Deriv.Pow
import Mathlib.Analysis.Calculus.FDeriv.RestrictScalars
import Mathlib.Analysis.Complex.Basic
import Mathlib.Data.Complex.FiniteDimensional
import Mathlib.Topology.Homeomorph.Lemmas
import Mathlib.Algebra.Polynomial.Degree.Operations
import Mathlib.Algebra.Order.Archimedean.Basic
import Mathlib.Tactic

/-!
# Conjecture 00000003348: an expanding polynomial with a non-Cantor Julia set

We use the standard polynomial convention: the filled Julia set consists of the
points with bounded forward orbit; the Julia set is its topological boundary.
Expansion is uniform exponential growth of the complex derivative of every
iterate on that compact invariant set. Cantor type means homeomorphic to the
usual Cantor space `ℕ → Bool`, with its product topology.
-/

noncomputable section

open Set Metric

namespace ExpandingJuliaCounterexample

/-- The degree-two complex polynomial used throughout. -/
def squarePolynomial : Polynomial ℂ := Polynomial.X ^ 2

/-- Its genuine evaluation map. -/
def square : ℂ → ℂ := squarePolynomial.eval

@[simp] theorem square_apply (z : ℂ) : square z = z ^ 2 := by
  simp [square, squarePolynomial]

theorem squarePolynomial_degree : squarePolynomial.natDegree = 2 := by
  simp [squarePolynomial]

/-- Boundedness is a single uniform bound over all forward iterates. -/
def filledJulia (p : Polynomial ℂ) : Set ℂ :=
  {z | ∃ R : ℝ, ∀ n : ℕ, ‖(p.eval)^[n] z‖ ≤ R}

/-- The standard boundary definition for complex polynomials of degree at least two. -/
def julia (p : Polynomial ℂ) : Set ℂ := frontier (filledJulia p)

/-- The full topological meaning of Cantor type. -/
def CantorType (S : Set ℂ) : Prop := Nonempty (S ≃ₜ (ℕ → Bool))

/-- Uniform exponential derivative expansion on a compact invariant set. -/
def UniformlyExpandingOn (f : ℂ → ℂ) (S : Set ℂ) : Prop :=
  IsCompact S ∧ MapsTo f S S ∧
    (∀ n : ℕ, Differentiable ℂ (f^[n])) ∧
    ∃ C L : ℝ, 0 < C ∧ 1 < L ∧
      ∀ n : ℕ, ∀ z ∈ S, C * L ^ n ≤ ‖deriv (f^[n]) z‖

/-- Iteration is computed from the evaluation map, not stipulated separately. -/
theorem square_iterate (n : ℕ) : square^[n] = fun z : ℂ => z ^ (2 ^ n) := by
  have h : square = (fun z : ℂ => z ^ 2) := funext square_apply
  rw [h]
  exact pow_iterate 2 n

theorem norm_square_iterate (n : ℕ) (z : ℂ) :
    ‖square^[n] z‖ = ‖z‖ ^ (2 ^ n) := by
  rw [square_iterate, norm_pow]

/-- Every point in the closed unit disk has bounded orbit. -/
theorem mem_filledJulia_of_norm_le_one {z : ℂ} (hz : ‖z‖ ≤ 1) :
    z ∈ filledJulia squarePolynomial := by
  refine ⟨1, fun n => ?_⟩
  change ‖square^[n] z‖ ≤ 1
  rw [norm_square_iterate]
  exact pow_le_one₀ (norm_nonneg z) hz

/-- Every point outside the closed unit disk has unbounded orbit. -/
theorem not_mem_filledJulia_of_one_lt_norm {z : ℂ} (hz : 1 < ‖z‖) :
    z ∉ filledJulia squarePolynomial := by
  rintro ⟨R, hR⟩
  obtain ⟨n, hn⟩ := pow_unbounded_of_one_lt R hz
  have hpow : n ≤ 2 ^ n := Nat.le_of_lt (show n < 2 ^ n from Nat.lt_two_pow_self)
  have hmono : ‖z‖ ^ n ≤ ‖z‖ ^ (2 ^ n) := pow_le_pow_right₀ hz.le hpow
  have hb := hR n
  change ‖square^[n] z‖ ≤ R at hb
  rw [norm_square_iterate] at hb
  exact (not_lt_of_ge hb) (hn.trans_le hmono)

/-- The filled Julia set is derived exactly from bounded forward orbits. -/
theorem filledJulia_square : filledJulia squarePolynomial = closedBall (0 : ℂ) 1 := by
  ext z
  simp only [mem_closedBall, dist_zero_right]
  constructor
  · intro hz
    by_contra h
    exact not_mem_filledJulia_of_one_lt_norm (lt_of_not_ge h) hz
  · exact mem_filledJulia_of_norm_le_one

/-- The Julia set is exactly the unit circle. -/
theorem julia_square : julia squarePolynomial = sphere (0 : ℂ) 1 := by
  rw [julia, filledJulia_square, frontier_closedBall _ one_ne_zero]

@[simp] theorem mem_julia_square_iff (z : ℂ) :
    z ∈ julia squarePolynomial ↔ ‖z‖ = 1 := by
  rw [julia_square]
  simp

theorem julia_square_compact : IsCompact (julia squarePolynomial) := by
  rw [julia_square]
  exact isCompact_sphere _ _

theorem square_mapsTo_julia : MapsTo square (julia squarePolynomial) (julia squarePolynomial) := by
  intro z hz
  rw [mem_julia_square_iff] at hz ⊢
  simp [hz, norm_pow]

/-- Derivative of every actual iterate, including the zeroth iterate. -/
theorem square_iterate_hasDerivAt (n : ℕ) (z : ℂ) :
    HasDerivAt (square^[n]) ((2 ^ n : ℕ) * z ^ (2 ^ n - 1)) z := by
  rw [square_iterate]
  exact hasDerivAt_pow (2 ^ n) z

theorem square_iterate_differentiable (n : ℕ) : Differentiable ℂ (square^[n]) :=
  fun z => (square_iterate_hasDerivAt n z).differentiableAt

theorem norm_deriv_square_iterate (n : ℕ) {z : ℂ} (hz : z ∈ julia squarePolynomial) :
    ‖deriv (square^[n]) z‖ = (2 : ℝ) ^ n := by
  rw [(square_iterate_hasDerivAt n z).deriv, norm_mul, norm_pow,
    (mem_julia_square_iff z).mp hz, one_pow, mul_one]
  simp

/-- The complex Frechet derivative expands every tangent vector by exactly `2^n`. -/
theorem norm_fderiv_square_iterate (n : ℕ) {z : ℂ}
    (hz : z ∈ julia squarePolynomial) (v : ℂ) :
    ‖fderiv ℂ (square^[n]) z v‖ = (2 : ℝ) ^ n * ‖v‖ := by
  rw [fderiv_eq_deriv_mul, norm_mul, norm_deriv_square_iterate n hz]

/-- The same estimate for the real derivative on the underlying real tangent plane. -/
theorem norm_real_fderiv_square_iterate (n : ℕ) {z : ℂ}
    (hz : z ∈ julia squarePolynomial) (v : ℂ) :
    ‖fderiv ℝ (square^[n]) z v‖ = (2 : ℝ) ^ n * ‖v‖ := by
  rw [(square_iterate_differentiable n z).fderiv_restrictScalars ℝ]
  exact norm_fderiv_square_iterate n hz v

/-- A uniform local distance-expansion estimate, with radius 1/2 and factor 3/2. -/
theorem square_local_distance_expansion {z w : ℂ}
    (hz : z ∈ julia squarePolynomial) (hzw : dist z w ≤ 1 / 2) :
    (3 / 2 : ℝ) * dist z w ≤ dist (square z) (square w) := by
  have hnz : ‖z‖ = 1 := (mem_julia_square_iff z).mp hz
  have htri := norm_add_le (z + w) (z - w)
  have hid : z + w + (z - w) = (2 : ℂ) * z := by ring
  rw [hid, norm_mul, hnz] at htri
  norm_num at htri
  have hsum : (3 / 2 : ℝ) ≤ ‖z + w‖ := by
    rw [dist_eq_norm] at hzw
    linarith
  rw [dist_eq_norm, dist_eq_norm, square_apply, square_apply,
    show z ^ 2 - w ^ 2 = (z - w) * (z + w) by ring, norm_mul]
  nlinarith [norm_nonneg (z - w)]

/-- Explicit witnesses are C = 1 and L = 2, uniformly in n and z. -/
theorem square_uniformlyExpanding : UniformlyExpandingOn square (julia squarePolynomial) := by
  refine ⟨julia_square_compact, square_mapsTo_julia, square_iterate_differentiable,
    1, 2, by norm_num, by norm_num, ?_⟩
  intro n z hz
  rw [norm_deriv_square_iterate n hz, one_mul]

/-- Connectedness is a theorem about the genuine sphere in the complex plane. -/
theorem julia_square_connected : IsConnected (julia squarePolynomial) := by
  rw [julia_square]
  exact isConnected_sphere (by rw [Complex.rank_real_complex]; norm_num) _ (by norm_num)

theorem julia_square_not_totallyDisconnected : ¬ IsTotallyDisconnected (julia squarePolynomial) := by
  intro h
  have hsub := h _ (Subset.refl _) julia_square_connected.isPreconnected
  have h1 : (1 : ℂ) ∈ julia squarePolynomial := by simp
  have hm1 : (-1 : ℂ) ∈ julia squarePolynomial := by simp
  have heq := hsub h1 hm1
  norm_num at heq

/-- A formal bridge from the full Cantor homeomorphism requirement to a necessary property. -/
theorem cantorType_totallyDisconnected {S : Set ℂ} (h : CantorType S) :
    IsTotallyDisconnected S := by
  obtain ⟨e⟩ := h
  letI : TotallyDisconnectedSpace S := e.symm.totallyDisconnectedSpace
  exact totallyDisconnectedSpace_subtype_iff.mp inferInstance

theorem julia_square_not_cantorType : ¬ CantorType (julia squarePolynomial) :=
  fun h => julia_square_not_totallyDisconnected (cantorType_totallyDisconnected h)

/-- Counterexample with the actual polynomial, its degree, uniform expansion, and failed conclusion. -/
theorem counterexample :
    ∃ p : Polynomial ℂ, 2 ≤ p.natDegree ∧
      UniformlyExpandingOn p.eval (julia p) ∧ ¬ CantorType (julia p) := by
  exact ⟨squarePolynomial, by rw [squarePolynomial_degree],
    square_uniformlyExpanding, julia_square_not_cantorType⟩

/-- Thus even the necessary topological clause of the proposed universal statement fails. -/
theorem not_every_expanding_polynomial_has_cantor_julia :
    ¬ ∀ p : Polynomial ℂ, 2 ≤ p.natDegree →
      UniformlyExpandingOn p.eval (julia p) → CantorType (julia p) := by
  intro h
  obtain ⟨p, hp, he, hn⟩ := counterexample
  exact hn (h p hp he)

/-- Adding a pressure/dimension requirement cannot repair the false Cantor conjunct.
No mathematical meaning is assigned to `additionalConclusion` here; the theorem
records the elementary logical implication for every possible second conjunct. -/
theorem not_every_expanding_polynomial_satisfies_conjunction
    (additionalConclusion : Polynomial ℂ → Prop) :
    ¬ ∀ p : Polynomial ℂ, 2 ≤ p.natDegree →
      UniformlyExpandingOn p.eval (julia p) →
        CantorType (julia p) ∧ additionalConclusion p := by
  intro h
  apply not_every_expanding_polynomial_has_cantor_julia
  intro p hp he
  exact (h p hp he).1

end ExpandingJuliaCounterexample
