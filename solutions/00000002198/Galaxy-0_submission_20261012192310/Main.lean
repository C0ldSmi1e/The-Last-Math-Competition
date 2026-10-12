import EnumLemma
import Eulerian
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace TLMC2198
abbrev P := Fin 4 × Fin 4 × Fin 4 × Fin 4
def entry (p : P) (i : Fin 4) : Fin 4 :=
 if i=0 then p.1 else if i=1 then p.2.1 else if i=2 then p.2.2.1 else p.2.2.2
def ofFunction (f : Fin 4 → Fin 4) : P := (f 0,f 1,f 2,f 3)
theorem entry_ofFunction (f : Fin 4 → Fin 4) (i : Fin 4) : entry (ofFunction f) i = f i := by
 have hi : i=0 ∨ i=1 ∨ i=2 ∨ i=3 := by omega
 rcases hi with h|h|h|h <;> subst i <;> rfl

def inv (p : P) : List Bool :=
  [p.1 > p.2.1, p.1 > p.2.2.1, p.1 > p.2.2.2,
   p.2.1 > p.2.2.1, p.2.1 > p.2.2.2, p.2.2.1 > p.2.2.2]
def weakLE (p q : P) : Bool :=
  ((inv p).zip (inv q)).all fun x => !x.1 || x.2
 theorem weakLE_iff (p q : P) : weakLE p q = true ↔
    ∀ i j : Fin 4, i<j → entry p i > entry p j → entry q i > entry q j := by
  simp only [weakLE, inv, List.zip_cons_cons, List.zip_nil_left, List.all_cons,
    List.all_nil, Bool.and_eq_true, Bool.or_eq_true, Bool.not_eq_true',
    decide_eq_false_iff_not, decide_eq_true_eq]
  constructor
  · intro h i j hij hp
    have hi : i=0 ∨ i=1 ∨ i=2 ∨ i=3 := by omega
    have hj : j=0 ∨ j=1 ∨ j=2 ∨ j=3 := by omega
    rcases hi with h|h|h|h <;> subst i <;>
      rcases hj with h|h|h|h <;> subst j <;> simp [entry] at * <;> grind
  · intro h
    have h01 := h 0 1 (by decide)
    have h02 := h 0 2 (by decide)
    have h03 := h 0 3 (by decide)
    have h12 := h 1 2 (by decide)
    have h13 := h 1 3 (by decide)
    have h23 := h 2 3 (by decide)
    simp [entry] at *
    grind

/-- The one-line notation of a permutation. -/
def entries (p : P) : List (Fin 4) := [p.1,p.2.1,p.2.2.1,p.2.2.2]
def valid (p : P) : Bool := decide (entries p).Nodup
def allTuples : List P := (List.finRange 4).flatMap fun a =>
  (List.finRange 4).flatMap fun b => (List.finRange 4).flatMap fun c =>
  (List.finRange 4).map fun d => (a,b,c,d)
def permList : List P := allTuples.filter valid

theorem valid_iff_injective : ∀ a b c d : Fin 4,
    valid (a,b,c,d) = true ↔ ∀ i j : Fin 4,
      entry (a,b,c,d) i = entry (a,b,c,d) j → i=j := by decide

theorem valid_surjective : ∀ a b c d : Fin 4,
    valid (a,b,c,d) = true → ∀ v : Fin 4, ∃ i : Fin 4,
      entry (a,b,c,d) i = v := by decide

theorem permutation_enumeration_complete : ∀ a b c d : Fin 4,
    valid (a,b,c,d) = true ↔ (a,b,c,d) ∈ permList := by decide

theorem permutation_mem_iff (p : P) : p ∈ permList ↔ valid p = true := by
  rcases p with ⟨a,b,c,d⟩
  exact (permutation_enumeration_complete a b c d).symm

theorem every_permutation_encoded (f : Fin 4 → Fin 4)
    (hf : ∀i j, f i = f j → i=j) :
    ∃p, p∈permList ∧ ∀i, entry p i = f i := by
  refine ⟨ofFunction f,?_,entry_ofFunction f⟩
  apply (permutation_mem_iff _).mpr
  apply (valid_iff_injective (f 0) (f 1) (f 2) (f 3)).mpr
  intro i j hij
  apply hf i j
  change entry (ofFunction f) i = entry (ofFunction f) j at hij
  simpa only [entry_ofFunction] using hij

theorem permutation_enumeration_nodup : permList.Nodup := by decide
 theorem permutation_count : permList.length = 24 := by decide

def compatible (p q : P) : Bool := !(weakLE p q) && !(weakLE q p)
 theorem compatible_symm (p q : P) : compatible p q = compatible q p := by
  simp [compatible, Bool.and_comm]
 theorem compatible_irrefl (p : P) : compatible p p = false := by
  have h : weakLE p p = true := (weakLE_iff p p).mpr (by intro i j h h'; exact h')
  simp [compatible,h]

/-- Lists are canonical subset encodings in the fixed, duplicate-free permutation list. -/
def CanonicalAntichain (a : List P) : Prop :=
  a.Sublist permList ∧ a.Pairwise (fun p q => compatible p q = true)
def antichains : List (List P) := AntichainEnumeration.enumerate compatible permList
 theorem antichain_complete (a : List P) : a ∈ antichains ↔ CanonicalAntichain a :=
  AntichainEnumeration.mem_enumerate_iff compatible permList a
 theorem antichain_enumeration_nodup : antichains.Nodup :=
  AntichainEnumeration.nodup_enumerate compatible permList permutation_enumeration_nodup
 theorem canonical_unique (a b : List P) (ha : CanonicalAntichain a)
    (hb : CanonicalAntichain b) (h : ∀p,p∈a ↔ p∈b) : a=b :=
  AntichainEnumeration.sublist_eq_of_same_members permList a b
    permutation_enumeration_nodup ha.1 hb.1 h

/-- Every actual subset of S4 has a canonical antichain encoding exactly when it is pairwise incomparable. -/
theorem actual_subset_bridge (S : P → Prop) [DecidablePred S] :
    AntichainEnumeration.selected S permList ∈ antichains ↔
      ∀x∈permList, ∀y∈permList, S x → S y → x≠y → compatible x y = true :=
  AntichainEnumeration.selected_mem_enumerate_iff compatible compatible_symm S permList
    permutation_enumeration_nodup

/-- A maximal antichain cannot be extended by any new permutation. -/
def maximal (a : List P) : Bool := permList.all fun p =>
  (a.contains p) || !(a.all (compatible p))
def maximalAntichains := antichains.filter maximal
def maximumAntichains := antichains.filter (fun a=>a.length==6)

theorem maximal_criterion (a : List P) : maximal a = true ↔
    ∀ p, p ∈ permList → p ∈ a ∨ ∃q, q∈a ∧ compatible p q = false := by
  simp [maximal, List.all_eq_true]

def IsInclusionMaximal (a : List P) : Prop := CanonicalAntichain a ∧
    ∀ b, CanonicalAntichain b → (∀ p,p∈a → p∈b) → ∀p,p∈b → p∈a
 theorem maximal_iff (a : List P) : a ∈ maximalAntichains ↔ IsInclusionMaximal a := by
  simp only [maximalAntichains,List.mem_filter]
  constructor
  · rintro ⟨ha,hm⟩
    refine ⟨(antichain_complete a).mp ha,?_⟩
    have h := (AntichainEnumeration.maximal_iff_no_extension compatible compatible_symm
      permList a permutation_enumeration_nodup ha).mp ((maximal_criterion a).mp hm)
    intro b hb hab
    exact h b ((antichain_complete b).mpr hb) hab
  · rintro ⟨ha,hm⟩
    have hea := (antichain_complete a).mpr ha
    refine ⟨hea,(maximal_criterion a).mpr ?_⟩
    apply (AntichainEnumeration.maximal_iff_no_extension compatible compatible_symm
      permList a permutation_enumeration_nodup hea).mpr
    intro b hb hab
    exact hm b ((antichain_complete b).mp hb) hab

def IsMaximum (a : List P) : Prop := CanonicalAntichain a ∧
    ∀ b, CanonicalAntichain b → b.length ≤ a.length

def middle : List P := permList.filter fun p => ((inv p).filter id).length == 3
 theorem middle_antichain : middle ∈ antichains := by decide
 theorem middle_length : middle.length = 6 := by decide
 theorem antichain_length_bound : antichains.all (fun a=>a.length≤6) = true := by decide
 theorem maximum_iff (a : List P) : a ∈ maximumAntichains ↔ IsMaximum a := by
  simp only [maximumAntichains,List.mem_filter,beq_iff_eq,antichain_complete]
  constructor
  · rintro ⟨ha,hlen⟩
    refine ⟨ha,fun b hb=>?_⟩
    have h := List.all_eq_true.mp antichain_length_bound b ((antichain_complete b).mpr hb)
    simpa [hlen] using h
  · rintro ⟨ha,hmax⟩
    refine ⟨ha,?_⟩
    have hlo := hmax middle ((antichain_complete middle).mp middle_antichain)
    have hhi := List.all_eq_true.mp antichain_length_bound a ((antichain_complete a).mpr ha)
    simp only [decide_eq_true_eq] at hhi
    rw [middle_length] at hlo
    omega

 theorem all_antichain_count : antichains.length = 856 := by decide
 theorem maximal_antichain_count : maximalAntichains.length = 190 := by decide
 theorem maximum_antichain_count : maximumAntichains.length = 4 := by decide

 theorem all_counts_not_eulerian (n k : Nat) :
    maximalAntichains.length ≠ euler2 n k ∧
    maximumAntichains.length ≠ euler2 n k ∧
    antichains.length ≠ euler2 n k := by
  rw [maximal_antichain_count,maximum_antichain_count,all_antichain_count]
  have h := euler2_exclusions n k
  exact ⟨Ne.symm h.1,Ne.symm h.2.1,Ne.symm h.2.2⟩

 theorem all_counts_not_row_sum (n : Nat) :
    maximalAntichains.length ≠ euler2RowSum n ∧
    maximumAntichains.length ≠ euler2RowSum n ∧
    antichains.length ≠ euler2RowSum n := by
  rw [maximal_antichain_count,maximum_antichain_count,all_antichain_count]
  have h := euler2_row_sum_exclusions n
  exact ⟨Ne.symm h.1,Ne.symm h.2.1,Ne.symm h.2.2⟩

#print axioms every_permutation_encoded
#print axioms actual_subset_bridge
#print axioms permutation_enumeration_complete
#print axioms valid_iff_injective
#print axioms valid_surjective
#print axioms weakLE_iff
#print axioms antichain_complete
#print axioms antichain_enumeration_nodup
#print axioms canonical_unique
#print axioms maximal_iff
#print axioms maximum_iff
#print axioms all_counts_not_eulerian
#print axioms all_counts_not_row_sum
end TLMC2198
