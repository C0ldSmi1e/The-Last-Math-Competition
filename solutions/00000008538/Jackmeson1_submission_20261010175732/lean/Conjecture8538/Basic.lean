import Mathlib
import Conjecture8538.Statement

/-!
# Conjecture 00000008538: radical and quotient of the incidence algebra of a lattice (disproof)

Conjecture: "A lattice algebra is the incidence algebra of a lattice.  The Jacobson radical of an
incidence algebra is its strictly lower triangular part; and its quotient is the Mobius algebra,
of dimension equal to the number of lattice elements."

Reading: `L` is a locally finite lattice with a top element, with no finiteness assumption (the
statement has none), and `K` is a field.  `Conjecture` quantifies over all such `K` and `L`; `main`
refutes it with `K = ℚ`, `L = ℕᵒᵈ`.  `FiniteConjecture` adds `[Fintype L]`, and `finite_main` proves
it: the statement holds exactly in the finite case.  The incidence algebra is Mathlib's `IncidenceAlgebra K L` (functions `f a b`, supported on `a ≤ b`,
multiplied by `(f*g) a b = ∑ x ∈ Icc a b, f a x * g x b`).  In the matrix picture with entry
`(a,b)` this is the upper-triangular convention; the "strictly lower triangular" wording is the
transposed (dual) convention for the same set of functions: the elements supported strictly off the
diagonal, `f a b ≠ 0 → a < b`.  The radical is `Ring.jacobson`.  The Mobius algebra is the
semigroup algebra of `(L, ⊓)`.
-/

-- (formal statement: see Statement.lean)

namespace C8538

open IncidenceAlgebra Module Finset

variable {K L : Type} [Field K] [Lattice L] [DecidableEq L] [LocallyFiniteOrder L]

/-- The diagonal evaluation `f ↦ f a a` as a ring homomorphism. -/
def ev (K : Type) [Field K] (a : L) : IncidenceAlgebra K L →+* K where
  toFun f := f a a
  map_one' := by simp
  map_mul' f g := by simp
  map_zero' := rfl
  map_add' _ _ := rfl

lemma ev_surj (a : L) : Function.Surjective (ev K a) := fun c =>
  ⟨algebraMap K (IncidenceAlgebra K L) c, by simp [ev, Algebra.algebraMap_eq_smul_one]⟩

lemma strict_iff (f : IncidenceAlgebra K L) :
    f ∈ StrictlyTriangular K L ↔ ∀ x, f x x = 0 := by
  constructor
  · intro h x
    by_contra hx
    exact lt_irrefl _ (h x x hx)
  · intro h x y hne
    exact lt_of_le_of_ne (le_of_ne_zero hne) fun e => hne (e ▸ h x)

/-- The diagonal algebra map `I(L,K) → K^L`. -/
def diag (K : Type) [Field K] (L : Type) [Lattice L] [DecidableEq L]
    [LocallyFiniteOrder L] : IncidenceAlgebra K L →ₐ[K] (L → K) :=
  AlgHom.mk' (RingHom.pi fun a => ev K a) (fun c f => by
    ext a; show (c • f) a a = c * f a a; simp)

lemma diag_apply (f : IncidenceAlgebra K L) (a : L) : diag K L f a = f a a := rfl

lemma diag_surj : Function.Surjective (diag K L) := fun g =>
  ⟨⟨fun a b => if a = b then g a else 0, fun a b h => by
    rw [if_neg]; rintro rfl; exact h le_rfl⟩, by ext a; simp [diag_apply]⟩

/-! ### The disproof: `L = ℕᵒᵈ`, `K = ℚ` -/

/-- If the radical is the strictly triangular part, then the quotient is `K`-linearly `K^L`
(via the diagonal map). -/
noncomputable def quotLinEquiv
    (h : (↑(Ring.jacobson (IncidenceAlgebra K L)) : Set (IncidenceAlgebra K L)) =
      StrictlyTriangular K L) :
    (IncidenceAlgebra K L ⧸ Ring.jacobson (IncidenceAlgebra K L)) ≃ₗ[K] (L → K) := by
  have hker : LinearMap.ker (diag K L).toLinearMap =
      (Ring.jacobson (IncidenceAlgebra K L)).restrictScalars K := by
    ext f
    have hf : f ∈ Ring.jacobson (IncidenceAlgebra K L) ↔ ∀ x, f x x = 0 := by
      rw [← strict_iff, ← SetLike.mem_coe, h]
    rw [LinearMap.mem_ker, Submodule.restrictScalars_mem, hf]
    exact ⟨fun h x => congrFun h x, fun h => funext h⟩
  exact (Submodule.Quotient.restrictScalarsEquiv K (Ring.jacobson (IncidenceAlgebra K L))).symm
    ≪≫ₗ (Submodule.quotEquivOfEq _ _ hker.symm)
    ≪≫ₗ LinearMap.quotKerEquivOfSurjective _ (diag_surj (K := K) (L := L))

theorem rank_ne (K : Type) [Field K] (L : Type) [Lattice L] [DecidableEq L]
    [LocallyFiniteOrder L] [Infinite L]
    (h : (↑(Ring.jacobson (IncidenceAlgebra K L)) : Set (IncidenceAlgebra K L)) =
      StrictlyTriangular K L) :
    Module.rank K (IncidenceAlgebra K L ⧸ Ring.jacobson (IncidenceAlgebra K L)) =
      Cardinal.mk (L → K) := by
  rw [(quotLinEquiv h).rank_eq]
  exact rank_fun_infinite

theorem main : Claim := by
  intro hC
  obtain ⟨h1, -, h3⟩ := hC ℚ ℕᵒᵈ
  have h4 := rank_ne ℚ ℕᵒᵈ h1
  rw [h3] at h4
  have hq : Cardinal.mk (ℕᵒᵈ → ℚ) = Cardinal.continuum := by
    rw [← Cardinal.power_def, Cardinal.mkRat, ← Cardinal.aleph0_power_aleph0]
    have : Cardinal.mk ℕᵒᵈ = Cardinal.aleph0 := Cardinal.mk_eq_aleph0 ℕᵒᵈ
    rw [this]
  rw [hq, Cardinal.mk_eq_aleph0 ℕᵒᵈ] at h4
  exact absurd h4 (Cardinal.aleph0_lt_continuum.ne)

open scoped Classical

variable [Fintype L]
lemma jac_diag {f : IncidenceAlgebra K L} (hf : f ∈ Ring.jacobson (IncidenceAlgebra K L))
    (a : L) : f a a = 0 := by
  haveI : RingHomSurjective (ev K a) := ⟨ev_surj a⟩
  have h := Ring.map_jacobson_le (ev K a) (Submodule.mem_map_of_mem hf)
  haveI := Ideal.bot_isMaximal (K := K)
  have : Ring.jacobson K ≤ (⊥ : Ideal K) := Ring.jacobson_le_of_isMaximal (⊥ : Ideal K)
  have h2 : f a a ∈ Ring.jacobson K := h
  exact Ideal.mem_bot.1 (this h2)

lemma pow_zero_aux {f : IncidenceAlgebra K L} (hf : ∀ x, f x x = 0) :
    ∀ (k : ℕ) (a b : L), (Icc a b).card ≤ k → (f ^ k) a b = 0 := by
  intro k
  induction k with
  | zero =>
    intro a b h
    by_cases hab : a ≤ b
    · exact absurd h (by have := Finset.card_pos.2 ⟨a, mem_Icc.2 ⟨le_rfl, hab⟩⟩; omega)
    · exact apply_eq_zero_of_not_le hab _
  | succ k ih =>
    intro a b h
    rw [pow_succ', mul_apply]
    refine Finset.sum_eq_zero fun x hx => ?_
    obtain ⟨hax, hxb⟩ := mem_Icc.1 hx
    by_cases hxa : x = a
    · subst hxa; simp [hf]
    · have hlt : (Icc x b).card < (Icc a b).card := by
        apply Finset.card_lt_card
        refine ⟨Icc_subset_Icc_left hax, fun hsub => ?_⟩
        have := hsub (mem_Icc.2 ⟨le_rfl, hax.trans hxb⟩)
        exact hxa (le_antisymm (mem_Icc.1 this).1 hax)
      rw [ih x b (by omega), mul_zero]

lemma zeroDiag_mul {r f : IncidenceAlgebra K L} (hf : ∀ x, f x x = 0) :
    ∀ x, (r * f) x x = 0 := fun x => by simp [hf]

lemma diag_le_jac {f : IncidenceAlgebra K L} (hf : ∀ x, f x x = 0) :
    f ∈ Ring.jacobson (IncidenceAlgebra K L) := by
  rw [Ring.jacobson_eq_sInf_isMaximal, Submodule.mem_sInf]
  intro m hm
  by_contra hfm
  have hlt : m < m ⊔ Ideal.span {f} := lt_of_le_of_ne le_sup_left fun h =>
    hfm (h ▸ Submodule.mem_sup_right (Submodule.subset_span rfl))
  have hmax : Ideal.IsMaximal m := hm
  have htop := hmax.out.2 _ hlt
  have h1 : (1 : IncidenceAlgebra K L) ∈ m ⊔ Ideal.span {f} := by rw [htop]; trivial
  obtain ⟨a, ha, b, hb, hab⟩ := Submodule.mem_sup.1 h1
  obtain ⟨r, rfl⟩ := Submodule.mem_span_singleton.1 hb
  rw [smul_eq_mul] at hab
  have hnil : IsNilpotent (r * f) :=
    ⟨Fintype.card L, by
      ext x y hxy
      exact pow_zero_aux (zeroDiag_mul hf) _ x y (Finset.card_le_univ _)⟩
  have hu : IsUnit (1 - r * f) := hnil.isUnit_one_sub
  have : a = 1 - r * f := by rw [← hab]; abel
  rw [this] at ha
  exact hmax.out.1 (Ideal.eq_top_of_isUnit_mem _ ha hu)

lemma jac_iff (f : IncidenceAlgebra K L) :
    f ∈ Ring.jacobson (IncidenceAlgebra K L) ↔ ∀ x, f x x = 0 :=
  ⟨fun h => jac_diag h, diag_le_jac⟩


lemma ker_diag : RingHom.ker (diag K L).toRingHom = Ring.jacobson (IncidenceAlgebra K L) := by
  ext f
  rw [RingHom.mem_ker, jac_iff]
  constructor
  · intro h x; exact congrFun h x
  · intro h; ext x; exact h x

/-- `I(L,K) / J ≃ K^L` as `K`-algebras. -/
noncomputable def quotEquiv (K : Type) [Field K] (L : Type) [Lattice L] [Fintype L] [DecidableEq L]
    [LocallyFiniteOrder L] :
    (IncidenceAlgebra K L ⧸ Ring.jacobson (IncidenceAlgebra K L)) ≃ₐ[K] (L → K) :=
  AlgEquiv.ofBijective
    (Ideal.Quotient.liftₐ _ (diag K L) fun f hf => by
      have : f ∈ RingHom.ker (diag K L).toRingHom := by rw [ker_diag]; exact hf
      exact this)
    ⟨by
      intro x y
      induction x using Submodule.Quotient.induction_on with | _ x => ?_
      induction y using Submodule.Quotient.induction_on with | _ y => ?_
      intro h
      change diag K L x = diag K L y at h
      rw [Submodule.Quotient.eq]
      have : x - y ∈ RingHom.ker (diag K L).toRingHom := by simp [RingHom.mem_ker, h]
      rwa [ker_diag] at this
    , fun g => by
      obtain ⟨f, rfl⟩ := diag_surj g
      exact ⟨Ideal.Quotient.mk _ f, rfl⟩⟩

/-! ### The Mobius algebra and Solomon's idempotents -/

variable [BoundedOrder L]

/-- The meet-indicator monoid hom `x ↦ (z ↦ [z ≤ x])`. -/
noncomputable def indHom (K : Type) [Field K] (L : Type) [Lattice L] [BoundedOrder L] [DecidableEq L]
    [Fintype L] : MeetMonoid L →* (L → K) where
  toFun x z := if z ≤ x.val then 1 else 0
  map_one' := by funext z; simp [show (1 : MeetMonoid L) = ⟨⊤⟩ from rfl]
  map_mul' x y := by
    funext z
    change (if z ≤ x.val ⊓ y.val then (1 : K) else 0) = _
    by_cases h1 : z ≤ x.val <;> by_cases h2 : z ≤ y.val <;> simp [h1, h2, le_inf_iff]

/-- The algebra map from the Mobius algebra to `K^L`. -/
noncomputable def mobPhi (K : Type) [Field K] (L : Type) [Lattice L] [BoundedOrder L]
    [DecidableEq L] [Fintype L] : MobiusAlgebra K L →ₐ[K] (L → K) :=
  MonoidAlgebra.lift K (L → K) (MeetMonoid L) (indHom K L)

lemma mobPhi_single (x : MeetMonoid L) (z : L) :
    mobPhi K L (MonoidAlgebra.single x 1) z = if z ≤ x.val then 1 else 0 := by
  simp [mobPhi, indHom]

lemma mobPhi_surj : Function.Surjective (mobPhi K L) := by
  intro g
  refine ⟨∑ a : L, ∑ y : L, (if y ≤ a then g a * mu K y a else 0) •
    (MonoidAlgebra.single ⟨y⟩ (1 : K)), ?_⟩
  funext z
  simp only [map_sum, map_smul, Finset.sum_apply, Pi.smul_apply, mobPhi_single, smul_eq_mul]
  have key : ∀ a : L, ∑ y : L, (if y ≤ a then g a * mu K y a else 0) *
      (if z ≤ y then (1 : K) else 0) = if z = a then g a else 0 := by
    intro a
    have h1 : ∑ y : L, (if y ≤ a then g a * mu K y a else 0) *
        (if z ≤ y then (1 : K) else 0) = g a * ∑ y ∈ Icc z a, mu K y a := by
      have : Icc z a = Finset.univ.filter (fun y => z ≤ y ∧ y ≤ a) := by ext; simp
      rw [this, Finset.sum_filter, Finset.mul_sum]
      refine Finset.sum_congr rfl fun y _ => ?_
      by_cases h1 : y ≤ a <;> by_cases h2 : z ≤ y <;> simp [h1, h2]
    rw [h1, sum_Icc_mu_left]
    by_cases h : z = a <;> simp [h]
  simp only [key]
  simp

/-- `L` and `MeetMonoid L` are in bijection. -/
def meetEquiv : L ≃ MeetMonoid L := ⟨MeetMonoid.mk, MeetMonoid.val, fun _ => rfl, fun _ => rfl⟩

lemma mob_finrank : finrank K (MobiusAlgebra K L) = Fintype.card L := by
  letI : Fintype (MeetMonoid L) := Fintype.ofEquiv L meetEquiv
  rw [Module.finrank_eq_card_basis (MonoidAlgebra.basis (MeetMonoid L) K)]
  exact (Fintype.card_congr meetEquiv).symm

noncomputable def mobEquiv (K : Type) [Field K] (L : Type) [Lattice L] [Fintype L] [DecidableEq L]
    [LocallyFiniteOrder L] [BoundedOrder L] : MobiusAlgebra K L ≃ₐ[K] (L → K) :=
  AlgEquiv.ofBijective (mobPhi K L) (by
    refine ⟨?_, mobPhi_surj⟩
    haveI : Finite (MeetMonoid L) := Finite.of_equiv L meetEquiv
    haveI : Module.Finite K (MobiusAlgebra K L) := Module.Finite.of_basis (MonoidAlgebra.basis (MeetMonoid L) K)
    have h : finrank K (MobiusAlgebra K L) = finrank K (L → K) := by
      rw [mob_finrank, Module.finrank_pi]
    exact (LinearMap.injective_iff_surjective_of_finrank_eq_finrank (f := (mobPhi K L).toLinearMap) h).2
      mobPhi_surj)

theorem finite_main : FiniteConjecture := by
  intro K _ L _ _ _ _ _
  refine ⟨?_, ⟨(quotEquiv K L).trans (mobEquiv K L).symm⟩, ?_⟩
  · ext f
    rw [SetLike.mem_coe, jac_iff, ← strict_iff]
  · rw [LinearEquiv.finrank_eq (quotEquiv K L).toLinearEquiv, Module.finrank_pi]

end C8538

