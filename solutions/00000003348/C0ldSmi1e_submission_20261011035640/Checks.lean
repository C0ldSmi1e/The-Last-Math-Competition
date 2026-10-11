import Counterexample

open ExpandingJuliaCounterexample

/- Boundary and scope checks: these deliberately distinguish Julia from filled
Julia, and expansion on the Julia locus from expansion on the whole plane. -/
example : (0 : ℂ) ∈ filledJulia squarePolynomial :=
  mem_filledJulia_of_norm_le_one (by simp)

example : (0 : ℂ) ∉ julia squarePolynomial := by simp

example : deriv square (0 : ℂ) = 0 := by
  have h : square^[1] = square := by simp
  rw [← h, (square_iterate_hasDerivAt 1 0).deriv]
  norm_num

example (z : ℂ) : deriv (square^[0]) z = 1 := by simp

example : square (1 : ℂ) = square (-1 : ℂ) := by simp

example : ¬ Function.Injective square := by
  intro h
  have heq : (1 : ℂ) = -1 := h (by simp)
  norm_num at heq

#print axioms squarePolynomial_degree
#print axioms square_iterate
#print axioms filledJulia_square
#print axioms julia_square
#print axioms square_iterate_hasDerivAt
#print axioms norm_deriv_square_iterate
#print axioms norm_real_fderiv_square_iterate
#print axioms square_local_distance_expansion
#print axioms square_uniformlyExpanding
#print axioms julia_square_connected
#print axioms cantorType_totallyDisconnected
#print axioms julia_square_not_cantorType
#print axioms counterexample
#print axioms not_every_expanding_polynomial_has_cantor_julia
#print axioms not_every_expanding_polynomial_satisfies_conjunction
