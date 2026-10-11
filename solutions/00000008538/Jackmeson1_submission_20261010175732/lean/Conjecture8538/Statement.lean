import Mathlib

/-! Formal statement for Conjecture8538: definitions only, ending in `Claim`. Split verbatim from the marked block of `Basic.lean`. -/

-- STATEMENT BEGIN
namespace C8538

open IncidenceAlgebra Module

/-- The monoid `(L, ⊓, ⊤)`: a copy of `L` whose multiplication is the meet. -/
structure MeetMonoid (L : Type*) where
  /-- the underlying lattice element -/
  val : L

instance (L : Type*) [SemilatticeInf L] [OrderTop L] : CommMonoid (MeetMonoid L) where
  mul x y := ⟨x.val ⊓ y.val⟩
  one := ⟨⊤⟩
  mul_assoc x y z := congrArg MeetMonoid.mk (inf_assoc x.val y.val z.val)
  one_mul x := congrArg MeetMonoid.mk (top_inf_eq x.val)
  mul_one x := congrArg MeetMonoid.mk (inf_top_eq x.val)
  mul_comm x y := congrArg MeetMonoid.mk (inf_comm x.val y.val)

/-- "the Mobius algebra": the algebra `K[L]` with basis the elements of the lattice `L` and
product `x * y = x ⊓ y` (the monoid algebra of the meet monoid). -/
abbrev MobiusAlgebra (K L : Type*) [CommSemiring K] [SemilatticeInf L] [OrderTop L] :=
  MonoidAlgebra K (MeetMonoid L)

/-- "its strictly lower triangular part": the elements of the incidence algebra that vanish on
every pair `(x, y)` with `x = y` (equivalently, are supported on pairs `x < y`); this is the
strictly triangular part, the upper or lower form depending on the matrix convention. -/
def StrictlyTriangular (K L : Type*) [Zero K] [Preorder L] : Set (IncidenceAlgebra K L) :=
  {f | ∀ x y, f x y ≠ 0 → x < y}

/-- The conjecture exactly as written, for every lattice `L` (with a top element, so that the
Mobius algebra is unital) and every field `K`, with NO finiteness hypothesis on `L`; the incidence
algebra is Mathlib's `IncidenceAlgebra K L` (which needs `L` locally finite), the radical is
`Ring.jacobson`, and "of dimension equal to the number of lattice elements" is
`Module.rank K (quotient) = Cardinal.mk L`. -/
def Conjecture : Prop :=
  ∀ (K : Type) [Field K] (L : Type) [Lattice L] [DecidableEq L]
    [LocallyFiniteOrder L] [OrderTop L],
    (↑(Ring.jacobson (IncidenceAlgebra K L)) : Set (IncidenceAlgebra K L)) = StrictlyTriangular K L ∧
    Nonempty ((IncidenceAlgebra K L ⧸ Ring.jacobson (IncidenceAlgebra K L)) ≃ₐ[K]
      MobiusAlgebra K L) ∧
    Module.rank K (IncidenceAlgebra K L ⧸ Ring.jacobson (IncidenceAlgebra K L)) = Cardinal.mk L

/-- The boundary result: the same statement restricted to finite lattices (with `finrank` and
`Fintype.card`). It is TRUE (theorem `finite_main`). -/
def FiniteConjecture : Prop :=
  ∀ (K : Type) [Field K] (L : Type) [Lattice L] [Fintype L] [DecidableEq L]
    [LocallyFiniteOrder L] [BoundedOrder L],
    (↑(Ring.jacobson (IncidenceAlgebra K L)) : Set (IncidenceAlgebra K L)) = StrictlyTriangular K L ∧
    Nonempty ((IncidenceAlgebra K L ⧸ Ring.jacobson (IncidenceAlgebra K L)) ≃ₐ[K]
      MobiusAlgebra K L) ∧
    finrank K (IncidenceAlgebra K L ⧸ Ring.jacobson (IncidenceAlgebra K L)) = Fintype.card L

/-- What this package proves: the conjecture as written (no finiteness hypothesis) is false. -/
def Claim : Prop := ¬ Conjecture

end C8538
-- STATEMENT END
