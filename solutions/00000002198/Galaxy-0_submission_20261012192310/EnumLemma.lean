import Std

namespace AntichainEnumeration

variable {α : Type u}

def enumerate (compatible : α → α → Bool) : List α → List (List α)
  | [] => [[]]
  | x :: xs =>
    let e := enumerate compatible xs
    e ++ (e.filter (fun a => a.all (compatible x))).map (x :: ·)

theorem mem_enumerate_iff (compatible : α → α → Bool)
    (univ candidate : List α) :
    candidate ∈ enumerate compatible univ ↔
      candidate.Sublist univ ∧ candidate.Pairwise (fun x y => compatible x y = true) := by
  induction univ generalizing candidate with
  | nil => cases candidate <;> simp [enumerate]
  | cons x xs ih =>
    simp only [enumerate, List.mem_append, List.mem_map, List.mem_filter,
      List.all_eq_true]
    constructor
    · rintro (h | ⟨a, ⟨ha, hc⟩, rfl⟩)
      · exact ⟨((ih _).mp h).1.cons x, ((ih _).mp h).2⟩
      · exact ⟨((ih _).mp ha).1.cons_cons x, List.pairwise_cons.mpr ⟨hc, ((ih _).mp ha).2⟩⟩
    · rintro ⟨hs, hp⟩
      rcases List.sublist_cons_iff.mp hs with hs | ⟨a, rfl, ha⟩
      · exact Or.inl ((ih _).mpr ⟨hs, hp⟩)
      · exact Or.inr ⟨a, ⟨(ih _).mpr ⟨ha, (List.pairwise_cons.mp hp).2⟩,
          (List.pairwise_cons.mp hp).1⟩, rfl⟩

theorem nodup_enumerate (compatible : α → α → Bool)
    (univ : List α) (h : univ.Nodup) : (enumerate compatible univ).Nodup := by
  induction univ with
  | nil => simp [enumerate]
  | cons x xs ih =>
    obtain ⟨hx, hxs⟩ := List.nodup_cons.mp h
    have he := ih hxs
    rw [enumerate, List.nodup_append]
    refine ⟨he, ?_, ?_⟩
    · exact (he.filter _).map (x :: ·) (by
        intro a b hab heq
        exact hab (List.cons.inj heq).2)
    · intro a ha b hb hab
      obtain ⟨c, hc, rfl⟩ := List.mem_map.mp hb
      have hs := ((mem_enumerate_iff compatible xs a).mp ha).1
      have hmem : x ∈ a := by rw [hab]; simp
      exact hx (hs.subset hmem)

/-- A nodup ambient list fixes a unique ordering for every subset. -/
theorem sublist_eq_of_same_members (univ a b : List α) (hu : univ.Nodup)
    (ha : a.Sublist univ) (hb : b.Sublist univ)
    (hm : ∀ x, x ∈ a ↔ x ∈ b) : a = b := by
  induction univ generalizing a b with
  | nil =>
    have := List.eq_nil_of_sublist_nil ha
    have := List.eq_nil_of_sublist_nil hb
    grind
  | cons x xs ih =>
    obtain ⟨hx, hxs⟩ := List.nodup_cons.mp hu
    rcases List.sublist_cons_iff.mp ha with hta | ⟨a', rfl, hta⟩
    · rcases List.sublist_cons_iff.mp hb with htb | ⟨b', rfl, htb⟩
      · exact ih a b hxs hta htb hm
      · exact False.elim (hx (hta.subset ((hm x).mpr (by simp))))
    · rcases List.sublist_cons_iff.mp hb with htb | ⟨b', rfl, htb⟩
      · exact False.elim (hx (htb.subset ((hm x).mp (by simp))))
      · congr 1
        apply ih a' b' hxs hta htb
        intro y
        have hax : x ∉ a' := fun h => hx (hta.subset h)
        have hbx : x ∉ b' := fun h => hx (htb.subset h)
        have := hm y
        simp only [List.mem_cons] at this
        by_cases hy : y = x
        · subst y; simp [hax, hbx]
        · simpa [hy] using this

/-- No two enumerated lists encode the same subset when the universe is nodup. -/
theorem enumerated_eq_of_same_members (compatible : α → α → Bool)
    (univ a b : List α) (hu : univ.Nodup)
    (ha : a ∈ enumerate compatible univ) (hb : b ∈ enumerate compatible univ)
    (hm : ∀ x, x ∈ a ↔ x ∈ b) : a = b :=
  sublist_eq_of_same_members univ a b hu
    ((mem_enumerate_iff compatible univ a).mp ha).1
    ((mem_enumerate_iff compatible univ b).mp hb).1 hm

/-- The canonical list representing a predicate-selected subset. -/
def selected (S : α → Prop) [DecidablePred S] (univ : List α) : List α :=
  univ.filter (fun x => decide (S x))

@[simp] theorem mem_selected (S : α → Prop) [DecidablePred S]
    (univ : List α) (x : α) : x ∈ selected S univ ↔ x ∈ univ ∧ S x := by
  simp [selected]

/-- Every compatible selected subset is produced by the enumeration. -/
theorem selected_mem_enumerate (compatible : α → α → Bool)
    (S : α → Prop) [DecidablePred S] (univ : List α) (hu : univ.Nodup)
    (hc : ∀ x ∈ univ, ∀ y ∈ univ, S x → S y → x ≠ y → compatible x y = true) :
    selected S univ ∈ enumerate compatible univ := by
  apply (mem_enumerate_iff compatible univ _).mpr
  have hs : (selected S univ).Sublist univ := List.filter_sublist
  refine ⟨hs, ?_⟩
  have hn : (selected S univ).Nodup := hs.nodup hu
  apply hn.imp_of_mem
  intro x y hx hy hxy
  obtain ⟨hxu, hxs⟩ := (mem_selected S univ x).mp hx
  obtain ⟨hyu, hys⟩ := (mem_selected S univ y).mp hy
  exact hc x hxu y hyu hxs hys hxy

/-- Symmetry upgrades ordered pairwise compatibility to compatibility of every
unordered distinct pair. This direction does not even require nodup. -/
theorem compatible_of_pairwise (compatible : α → α → Bool)
    (symm : ∀ x y, compatible x y = compatible y x)
    (a : List α) (hp : a.Pairwise (fun x y => compatible x y = true)) :
    ∀ x ∈ a, ∀ y ∈ a, x ≠ y → compatible x y = true := by
  induction a with
  | nil => simp
  | cons z zs ih =>
    obtain ⟨hz, hzs⟩ := List.pairwise_cons.mp hp
    intro x hx y hy hxy
    rcases List.mem_cons.mp hx with rfl | hxt
    · rcases List.mem_cons.mp hy with rfl | hyt
      · exact False.elim (hxy rfl)
      · exact hz y hyt
    · rcases List.mem_cons.mp hy with rfl | hyt
      · rw [symm]; exact hz x hxt
      · exact ih hzs x hxt y hyt hxy

/-- On a nodup list and a symmetric compatibility relation, ordered and
unordered formulations coincide. -/
theorem pairwise_iff_unordered (compatible : α → α → Bool)
    (symm : ∀ x y, compatible x y = compatible y x)
    (a : List α) (ha : a.Nodup) :
    a.Pairwise (fun x y => compatible x y = true) ↔
      ∀ x ∈ a, ∀ y ∈ a, x ≠ y → compatible x y = true := by
  constructor
  · exact compatible_of_pairwise compatible symm a
  · intro h
    exact ha.imp_of_mem (fun {x y} hx hy hxy => h x hx y hy hxy)

/-- Exact bridge from predicate-defined unordered subsets to enumeration. -/
theorem selected_mem_enumerate_iff (compatible : α → α → Bool)
    (symm : ∀ x y, compatible x y = compatible y x)
    (S : α → Prop) [DecidablePred S] (univ : List α) (hu : univ.Nodup) :
    selected S univ ∈ enumerate compatible univ ↔
      ∀ x ∈ univ, ∀ y ∈ univ, S x → S y → x ≠ y → compatible x y = true := by
  constructor
  · intro h x hx y hy hsx hsy hxy
    have hp := ((mem_enumerate_iff compatible univ _).mp h).2
    exact compatible_of_pairwise compatible symm (selected S univ) hp
      x ((mem_selected S univ x).mpr ⟨hx, hsx⟩)
      y ((mem_selected S univ y).mpr ⟨hy, hsy⟩) hxy
  · exact selected_mem_enumerate compatible S univ hu

/-- Singleton-extension obstruction is exactly inclusion-maximality among
all enumerated compatible subsets. No diagonal assumption is needed. -/
theorem maximal_iff_no_extension (compatible : α → α → Bool)
    (symm : ∀ x y, compatible x y = compatible y x)
    (univ a : List α) (hu : univ.Nodup)
    (ha : a ∈ enumerate compatible univ) :
    (∀ x ∈ univ, x ∈ a ∨ ∃ y ∈ a, compatible x y = false) ↔
      (∀ b ∈ enumerate compatible univ, (∀ x ∈ a, x ∈ b) → ∀ x ∈ b, x ∈ a) := by
  classical
  obtain ⟨hau, hap⟩ := (mem_enumerate_iff compatible univ a).mp ha
  constructor
  · intro h b hb hab x hxb
    obtain ⟨hbu, hbp⟩ := (mem_enumerate_iff compatible univ b).mp hb
    rcases h x (hbu.subset hxb) with hxa | ⟨y, hya, hfalse⟩
    · exact hxa
    · by_cases hxy : x = y
      · simpa [hxy] using hya
      · have ht := compatible_of_pairwise compatible symm b hbp x hxb y (hab y hya) hxy
        simp [ht] at hfalse
  · intro hm p hpu
    by_cases hpa : p ∈ a
    · exact Or.inl hpa
    · right
      by_cases hbad : ∃ y ∈ a, compatible p y = false
      · exact hbad
      · have hgood : ∀ y ∈ a, compatible p y = true := by
          intro y hy
          cases hv : compatible p y with
          | false => exact False.elim (hbad ⟨y, hy, hv⟩)
          | true => rfl
        let S : α → Prop := fun x => x ∈ a ∨ x = p
        have hcompat : ∀ x ∈ univ, ∀ y ∈ univ,
            S x → S y → x ≠ y → compatible x y = true := by
          intro x _ y _ hsx hsy hxy
          rcases hsx with hxa | rfl
          · rcases hsy with hya | rfl
            · exact compatible_of_pairwise compatible symm a hap x hxa y hya hxy
            · rw [symm]; exact hgood x hxa
          · rcases hsy with hya | rfl
            · exact hgood y hya
            · exact False.elim (hxy rfl)
        have hb := selected_mem_enumerate compatible S univ hu hcompat
        have hab : ∀ x ∈ a, x ∈ selected S univ := by
          intro x hx
          exact (mem_selected S univ x).mpr ⟨hau.subset hx, Or.inl hx⟩
        have hpb : p ∈ selected S univ :=
          (mem_selected S univ p).mpr ⟨hpu, Or.inr rfl⟩
        exact False.elim (hpa (hm (selected S univ) hb hab p hpb))

end AntichainEnumeration

#print axioms AntichainEnumeration.mem_enumerate_iff
#print axioms AntichainEnumeration.nodup_enumerate
#print axioms AntichainEnumeration.sublist_eq_of_same_members
#print axioms AntichainEnumeration.selected_mem_enumerate
#print axioms AntichainEnumeration.pairwise_iff_unordered


#print axioms AntichainEnumeration.selected_mem_enumerate_iff

#print axioms AntichainEnumeration.maximal_iff_no_extension
