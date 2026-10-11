import Conjecture4125
set_option autoImplicit false
set_option warningAsError true

namespace Conjecture4125.Verification
open Conjecture4125 MeasureTheory

-- The ambient measurable-space instance is precisely the Borel sigma-algebra.
example : (inferInstance : MeasurableSpace ℝ) = borel ℝ := rfl

-- The example has all arbitrary suprema and complements, rather than only finite operations.
example : CompleteBooleanAlgebra Four := inferInstance
example : Nat.card Four = 4 := four_card
example : CCC Four := four_ccc
example : IsSimpleGroup (Aut Four) := aut_simple
example : Nat.card (Aut Four) = 2 := aut_card

-- The identity and the atom swap are distinct, and the swap has order two.
example : swapAtoms ≠ (1 : Aut Four) := swapAtoms_ne_one
example : swapAtoms * swapAtoms = (1 : Aut Four) := by
  apply OrderIso.ext
  funext s
  ext b
  cases b <;> rfl

-- Carrier permutations that move zero cannot be automorphisms.
example (f : Aut Four) : f ∅ ≠ {false} := by
  have hf : f ∅ = ∅ := map_bot f
  rw [hf]
  exact (Set.singleton_ne_empty false).symm

-- The two nonzero atoms really are disjoint.
example : ({false} : Four) ≠ ⊥ ∧ ({true} : Four) ≠ ⊥ ∧
    Disjoint ({false} : Four) {true} := by
  simp

-- The null interval is identified with zero by the quotient.
example : randomFive 0 = randomZero := by
  apply (randomClass_eq_zero_iff (randomInterval 0)).mpr
  have h := randomFive_mass 0
  simpa [randomFive, randomClass, randomMass] using h

-- The other endpoint is the full-measure class, and is positive.
example : randomMass (randomFive 4) = 1 := by
  rw [randomFive_mass]
  change ENNReal.ofReal ((4 : ℝ) / 4) = 1
  norm_num
example : randomFive 4 ≠ randomZero := by
  intro h
  have hm := congrArg randomMass h
  rw [randomFive_mass, randomZero_mass] at hm
  change ENNReal.ofReal ((4 : ℝ) / 4) = 0 at hm
  norm_num at hm

-- Different positive interval classes remain distinct.
example : randomFive 1 ≠ randomFive 2 := by
  intro h
  have hi := randomFive_injective h
  have hv := congrArg Fin.val hi
  change (1 : ℕ) = 2 at hv
  omega

-- Support outside [0,1] vanishes on passage to a canonical representative.
example : randomClass ⟨Set.Icc (2 : ℝ) 3, measurableSet_Icc⟩ = randomZero := by
  rw [randomClass_unitRepresentative]
  congr 1
  apply Subtype.ext
  ext x
  change x ∈ Set.Icc (2 : ℝ) 3 ∩ Set.Icc 0 1 ↔ False
  constructor
  · rintro ⟨⟨hx, _⟩, ⟨_, hx'⟩⟩
    linarith
  · exact False.elim

-- The regular-open coordinate cylinders are different actual subsets.
example : cohenCylinder 0 ≠ cohenCylinder 1 := by
  intro h
  have hi := cohenCylinder_injective h
  omega

-- Both named carriers are too large, and the quantified consequence is refuted.
example : ¬ Nonempty (Four ≃ RandomAlgebraCarrier) := four_not_random
example : ¬ Nonempty (Four ≃ CohenAlgebraCarrier) := four_not_cohen
example : ¬ ClassificationCarrierConsequence := classification_carrier_consequence_false

#print axioms aut_simple
#print axioms randomClass_eq_iff_null_symmDiff
#print axioms randomClass_unitRepresentative
#print axioms randomClass_positive_iff
#print axioms cohenFive_injective
#print axioms randomFive_injective
#print axioms four_counterexample
#print axioms classification_carrier_consequence_false
#print axioms conjunction_with_classification_false

end Conjecture4125.Verification
