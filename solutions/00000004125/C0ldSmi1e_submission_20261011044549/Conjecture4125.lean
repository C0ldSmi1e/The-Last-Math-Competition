import Mathlib.GroupTheory.SpecificGroups.Cyclic
import Mathlib.Order.Atoms
import Mathlib.Order.Hom.CompleteLattice
import Mathlib.Order.Hom.BoundedLattice
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
import Mathlib.Topology.Instances.Discrete
import Mathlib.Topology.Constructions
import Mathlib.Tactic

set_option autoImplicit false
set_option warningAsError true

namespace Conjecture4125

noncomputable section

/-- The full group of order automorphisms; in a Boolean algebra order determines all
Boolean operations, and in a complete lattice it also determines arbitrary joins. -/
abbrev Aut (B : Type*) [PartialOrder B] := B ≃o B

instance autGroup (B : Type*) [PartialOrder B] : Group (Aut B) where
  mul f g := g.trans f
  one := OrderIso.refl B
  inv f := f.symm
  mul_assoc _ _ _ := rfl
  one_mul _ := rfl
  mul_one _ := rfl
  inv_mul_cancel f := by ext x; exact f.symm_apply_apply x

@[simp] theorem aut_one_apply {B : Type*} [PartialOrder B] (x : B) : (1 : Aut B) x = x := rfl

/-- The actual powerset Boolean algebra on a two-element set. -/
abbrev Four := Set Bool

/-- Every pairwise-disjoint family of nonzero elements is countable. -/
def CCC (B : Type*) [PartialOrder B] [OrderBot B] : Prop :=
  ∀ A : Set B, (∀ a ∈ A, a ≠ ⊥) → A.Pairwise Disjoint → A.Countable

theorem four_complete : Nonempty (CompleteBooleanAlgebra Four) := ⟨inferInstance⟩

theorem four_ccc : CCC Four := by
  intro A _ _
  exact Set.to_countable A

theorem four_card : Nat.card Four = 4 := by
  classical
  simp [Nat.card_eq_fintype_card, Fintype.card_set, Four]

/-- Exhaustion of all four actual sets, used to control the full automorphism group. -/
theorem four_cases (s : Four) :
    s = ∅ ∨ s = {false} ∨ s = {true} ∨ s = Set.univ := by
  classical
  by_cases hf : false ∈ s <;> by_cases ht : true ∈ s
  · right; right; right; ext b; cases b <;> simp [hf, ht]
  · right; left; ext b; cases b <;> simp [hf, ht]
  · right; right; left; ext b; cases b <;> simp [hf, ht]
  · left; ext b; cases b <;> simp [hf, ht]

/-- Swapping the two atoms, as an order automorphism of their entire powerset. -/
def swapAtoms : Aut Four where
  toFun s := Bool.not ⁻¹' s
  invFun s := Bool.not ⁻¹' s
  left_inv s := by ext b; cases b <;> rfl
  right_inv s := by ext b; cases b <;> rfl
  map_rel_iff' := by
    intro s t
    constructor
    · intro h b hb
      have h' : (!b) ∈ Bool.not ⁻¹' s := by simpa using hb
      have := h h'
      simpa using this
    · intro h b hb
      exact h hb

theorem aut_determined_by_false {f g : Aut Four} (h : f {false} = g {false}) : f = g := by
  have hc : ({false} : Four)ᶜ = {true} := by ext b; cases b <;> simp
  have ht : f {true} = g {true} := by
    rw [← hc, map_compl', map_compl', h]
  apply OrderIso.ext
  funext s
  rcases four_cases s with rfl | rfl | rfl | rfl
  · exact (map_bot f).trans (map_bot g).symm
  · exact h
  · exact ht
  · exact (map_top f).trans (map_top g).symm

theorem aut_cases (f : Aut Four) : f = 1 ∨ f = swapAtoms := by
  obtain ⟨b, hb⟩ := Set.isAtom_iff.mp ((f.isAtom_iff {false}).mpr (Set.isAtom_singleton false))
  cases b
  · left
    apply aut_determined_by_false
    exact hb
  · right
    apply aut_determined_by_false
    rw [hb]
    ext b; cases b <;> simp [swapAtoms]

theorem swapAtoms_ne_one : swapAtoms ≠ (1 : Aut Four) := by
  intro h
  have he := congrArg (fun f : Aut Four => f {false}) h
  have ht := congrArg (fun s : Four => true ∈ s) he
  simp [swapAtoms] at ht

/-- An explicit bijection enumerates the full automorphism group, not all permutations
of the four-element carrier. -/
noncomputable def autEquivBool : Aut Four ≃ Bool := by
  classical
  exact {
  toFun f := if f = 1 then false else true
  invFun b := if b then swapAtoms else 1
  left_inv f := by
    rcases aut_cases f with rfl | rfl <;> simp [swapAtoms_ne_one]
  right_inv b := by
    cases b <;> simp [swapAtoms_ne_one] }

theorem aut_card : Nat.card (Aut Four) = 2 := by
  rw [Nat.card_congr autEquivBool]
  simp

theorem aut_simple : IsSimpleGroup (Aut Four) :=
  isSimpleGroup_of_prime_card aut_card

/-- The example is atomic, as permitted by the text of both language versions. -/
theorem four_has_atom : ∃ a : Four, IsAtom a := ⟨{false}, Set.isAtom_singleton false⟩

/-- Five distinct elements preclude any bijection with the four-element example. -/
theorem no_equiv_of_five {A : Type*} (f : Fin 5 → A) (hf : Function.Injective f) :
    ¬ Nonempty (Four ≃ A) := by
  rintro ⟨e⟩
  have h := Nat.card_le_card_of_injective (e.symm ∘ f) (e.symm.injective.comp hf)
  rw [four_card] at h
  norm_num at h

/-- Binary Cantor space with the product of discrete two-point topologies. -/
abbrev CantorSpace := ℕ → Bool

/-- The standard regular-open presentation of the Cohen algebra (including zero). -/
def CohenAlgebraCarrier := {U : Set CantorSpace // interior (closure U) = U}

/-- The coordinate cylinder is clopen, hence regular open. -/
def cohenCylinder (n : ℕ) : CohenAlgebraCarrier :=
  ⟨{x | x n = true}, by
    have hc : IsClopen {x : CantorSpace | x n = true} :=
      (isClopen_discrete ({true} : Set Bool)).preimage (continuous_apply n)
    rw [hc.1.closure_eq, hc.2.interior_eq]⟩

theorem cohenCylinder_injective : Function.Injective cohenCylinder := by
  intro n m h
  by_contra hn
  have he := congrArg (fun U : CohenAlgebraCarrier =>
    (fun k => decide (k = n)) ∈ U.val) h
  simp [cohenCylinder, hn, Ne.symm hn] at he

def cohenFive (i : Fin 5) : CohenAlgebraCarrier := cohenCylinder i.val

theorem cohenFive_injective : Function.Injective cohenFive :=
  cohenCylinder_injective.comp Fin.val_injective

theorem four_not_cohen : ¬ Nonempty (Four ≃ CohenAlgebraCarrier) :=
  no_equiv_of_five cohenFive cohenFive_injective

open MeasureTheory
open scoped ENNReal symmDiff

/-- Lebesgue probability measure on the unit interval, represented on the real line. -/
def unitMeasure : Measure ℝ := volume.restrict (Set.Icc (0 : ℝ) 1)

/-- Borel sets: the standard measurable-space instance on the real line is Borel. -/
abbrev BorelSet := {s : Set ℝ // MeasurableSet s}

/-- Equality modulo null sets, on actual Borel sets. -/
def randomSetoid : Setoid BorelSet where
  r s t := s.val =ᵐ[unitMeasure] t.val
  iseqv := ⟨fun _ => Filter.EventuallyEq.refl _ _,
    fun h => h.symm, fun h₁ h₂ => h₁.trans h₂⟩

/-- Restricting a representative to the unit interval keeps it Borel. -/
def unitRepresentative (s : BorelSet) : BorelSet :=
  ⟨s.val ∩ Set.Icc (0 : ℝ) 1, s.property.inter measurableSet_Icc⟩

/-- The standard random measure-algebra carrier, including the null/zero class.
Its positive elements are the positive-measure Borel forcing in the problem. -/
def RandomAlgebraCarrier := Quotient randomSetoid

def randomClass (s : BorelSet) : RandomAlgebraCarrier := Quotient.mk randomSetoid s

theorem randomClass_eq_iff_null_symmDiff (s t : BorelSet) :
    randomClass s = randomClass t ↔ unitMeasure (s.val ∆ t.val) = 0 := by
  constructor
  · intro h
    exact measure_symmDiff_eq_zero_iff.mpr (Quotient.exact h)
  · intro h
    exact Quotient.sound (measure_symmDiff_eq_zero_iff.mp h)

/-- Our real-line presentation has canonical representatives inside the unit interval. -/
theorem randomClass_unitRepresentative (s : BorelSet) :
    randomClass s = randomClass (unitRepresentative s) := by
  apply Quotient.sound
  change s.val =ᵐ[volume.restrict (Set.Icc (0 : ℝ) 1)] (unitRepresentative s).val
  filter_upwards [ae_restrict_mem (μ := (volume : Measure ℝ)) measurableSet_Icc] with x hx
  apply propext
  exact ⟨fun h => ⟨h, hx⟩, And.left⟩

/-- The measure descends to the quotient. -/
def randomMass : RandomAlgebraCarrier → ℝ≥0∞ :=
  Quotient.lift (fun s : BorelSet => unitMeasure s.val)
    (fun _ _ h => measure_congr h)

def randomInterval (i : Fin 5) : BorelSet :=
  ⟨Set.Icc 0 ((i.val : ℝ) / 4), measurableSet_Icc⟩

def randomFive (i : Fin 5) : RandomAlgebraCarrier := randomClass (randomInterval i)

theorem randomFive_mass (i : Fin 5) :
    randomMass (randomFive i) = ENNReal.ofReal ((i.val : ℝ) / 4) := by
  change unitMeasure (Set.Icc 0 ((i.val : ℝ) / 4)) = _
  rw [unitMeasure, Measure.restrict_apply measurableSet_Icc]
  have hi : (i.val : ℝ) / 4 ≤ 1 := by
    have hn : i.val ≤ 4 := by omega
    have hr : (i.val : ℝ) ≤ 4 := by exact_mod_cast hn
    linarith
  rw [Set.inter_eq_left.mpr (Set.Icc_subset_Icc le_rfl hi), Real.volume_Icc]
  simp

theorem randomFive_injective : Function.Injective randomFive := by
  intro i j h
  have hm := congrArg (fun a => (randomMass a).toReal) h
  dsimp only at hm
  rw [randomFive_mass, randomFive_mass,
    ENNReal.toReal_ofReal (by positivity), ENNReal.toReal_ofReal (by positivity)] at hm
  apply Fin.ext
  have hv : (i.val : ℝ) = j.val := by linarith
  exact_mod_cast hv

theorem four_not_random : ¬ Nonempty (Four ≃ RandomAlgebraCarrier) :=
  no_equiv_of_five randomFive randomFive_injective

/-- The null class, corresponding to Boolean zero (omitted from the positive forcing). -/
def randomZero : RandomAlgebraCarrier := randomClass ⟨∅, MeasurableSet.empty⟩

@[simp] theorem randomZero_mass : randomMass randomZero = 0 := by
  change unitMeasure ∅ = 0
  exact measure_empty

theorem randomClass_eq_zero_iff (s : BorelSet) :
    randomClass s = randomZero ↔ unitMeasure s.val = 0 := by
  rw [randomZero, randomClass_eq_iff_null_symmDiff]
  simp

/-- The quotient's nonzero classes are exactly the positive-measure Borel conditions. -/
theorem randomClass_positive_iff (s : BorelSet) :
    0 < randomMass (randomClass s) ↔ randomClass s ≠ randomZero := by
  change 0 < unitMeasure s.val ↔ _
  simp only [pos_iff_ne_zero, ne_eq, randomClass_eq_zero_iff]

/-- Our use of order automorphisms preserves all Boolean operations and all joins. -/
theorem aut_preserves_boolean_and_joins {B : Type*} [CompleteBooleanAlgebra B]
    (f : Aut B) (x y : B) (S : Set B) :
    f ⊥ = ⊥ ∧ f ⊤ = ⊤ ∧ f (x ⊓ y) = f x ⊓ f y ∧
    f (x ⊔ y) = f x ⊔ f y ∧ f xᶜ = (f x)ᶜ ∧
    f (sSup S) = ⨆ a ∈ S, f a :=
  ⟨map_bot f, map_top f, f.map_inf x y, f.map_sup x y, map_compl' f x, f.map_sSup S⟩

/-- Conversely, a bijection preserving binary joins is an order automorphism.
In particular every Boolean-algebra automorphism belongs to our `Aut` group. -/
def booleanEquivToOrderIso {B : Type*} [BooleanAlgebra B] (e : B ≃ B)
    (hjoin : ∀ x y, e (x ⊔ y) = e x ⊔ e y) : Aut B where
  toEquiv := e
  map_rel_iff' := by
    intro x y
    constructor
    · intro h
      apply sup_eq_right.mp
      apply e.injective
      rw [hjoin, sup_eq_right.mpr h]
    · intro h
      apply sup_eq_right.mp
      rw [← hjoin, sup_eq_right.mpr h]

/-- Every order isomorphism in particular gives an equivalence of its carrier types. -/
theorem order_isomorphic_implies_equivalent {A B : Type*} [PartialOrder A] [PartialOrder B] :
    Nonempty (A ≃o B) → Nonempty (A ≃ B) := fun ⟨e⟩ => ⟨e.toEquiv⟩

/-- A necessary consequence of the stated classification, obtained by forgetting
Boolean operations on the two named target algebras. This is intentionally weaker
than the original classification, so disproving it also disproves that classification. -/
def ClassificationCarrierConsequence : Prop :=
  ∀ (B : Type) [CompleteBooleanAlgebra B], CCC B → IsSimpleGroup (Aut B) →
    Nonempty (B ≃ RandomAlgebraCarrier) ∨ Nonempty (B ≃ CohenAlgebraCarrier)

/-- An explicit counterexample to the unrestricted classification in both language versions. -/
theorem four_counterexample :
    CCC Four ∧ IsSimpleGroup (Aut Four) ∧
    ¬ Nonempty (Four ≃ RandomAlgebraCarrier) ∧ ¬ Nonempty (Four ≃ CohenAlgebraCarrier) :=
  ⟨four_ccc, aut_simple, four_not_random, four_not_cohen⟩

/-- The actual universally quantified necessary consequence is false. -/
theorem classification_carrier_consequence_false : ¬ ClassificationCarrierConsequence := by
  intro h
  rcases h Four four_ccc aut_simple with hr | hc
  · exact four_not_random hr
  · exact four_not_cohen hc

/-- Whichever truth values the two other conjuncts have, they cannot repair the false
classification conjunct. No assertion about either other conjunct is needed. -/
theorem conjunction_with_classification_false (P Q : Prop) :
    ¬ (P ∧ Q ∧ ClassificationCarrierConsequence) := by
  rintro ⟨_, _, h⟩
  exact classification_carrier_consequence_false h

end

end Conjecture4125
