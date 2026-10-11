import Std

/-!
A counterexample to TLMC conjecture 00000003829.
Integer partitions are ordinary nonincreasing lists of positive row lengths.
Every hook length is computed directly from the Young diagram.
-/
namespace TLMC3829

/-- The hook length in column `j` of a row of length `x`,
    with lower rows `xs`; columns are numbered from zero. -/
def hook (x : Nat) (xs : List Nat) (j : Nat) : Nat :=
  x - j + (xs.filter (fun y => j < y)).length

/-- No hook length is divisible by `t`. The recursion visits every row. -/
def IsCore (t : Nat) : List Nat → Prop
  | [] => True
  | x :: xs => (∀ j, j < x → ¬ t ∣ hook x xs j) ∧ IsCore t xs

def IsPartition (xs : List Nat) : Prop :=
  (∀ x ∈ xs, 0 < x) ∧ xs.Pairwise (fun x y => y ≤ x)

def IsCore23 (xs : List Nat) : Prop :=
  IsPartition xs ∧ IsCore 2 xs ∧ IsCore 3 xs

/-- The complete classification, for arbitrary finite partition size. -/
theorem classify {xs : List Nat} (hp : ∀ x ∈ xs, 0 < x)
    (h2 : IsCore 2 xs) (h3 : IsCore 3 xs) : xs = [] ∨ xs = [1] := by
  induction xs with
  | nil => exact Or.inl rfl
  | cons x xs ih =>
    have hx : 0 < x := hp x (by simp)
    have ht : ∀ y ∈ xs, 0 < y := by
      intro y hy
      exact hp y (by simp [hy])
    rcases ih ht h2.2 h3.2 with ht0 | ht1
    · subst xs
      have hx1 : x = 1 := by
        by_cases hn : x = 1
        · exact hn
        apply False.elim
        have hx2 : 2 ≤ x := by omega
        have bad := h2.1 (x - 2) (by omega)
        have heq : hook x [] (x - 2) = 2 := by
          simp [hook]
          omega
        rw [heq] at bad
        exact bad (by decide)
      subst x
      exact Or.inr rfl
    · subst xs
      have bad : False := by
        by_cases hx1 : x = 1
        · subst x
          have z := h2.1 0 (by decide)
          exact z (by decide)
        · by_cases hx2 : x = 2
          · subst x
            have z := h3.1 0 (by decide)
            exact z (by decide)
          · have hx3 : 3 ≤ x := by omega
            have z := h2.1 (x - 2) (by omega)
            have heq : hook x [1] (x - 2) = 2 := by
              have hcol : ¬ x - 2 < 1 := by omega
              simp [hook, hcol]
              omega
            rw [heq] at z
            exact z (by decide)
      exact False.elim bad


/-- Cells of a Young diagram in zero-based row and column coordinates. -/
def cells : List Nat → List (Nat × Nat)
  | [] => []
  | x :: xs => (List.range x).map (fun j => (0,j)) ++
      (cells xs).map (fun p => (p.1 + 1, p.2))

/-- Edge-sharing of two squares. -/
def CellAdjacent (a b : Nat × Nat) : Prop :=
  (a.1 = b.1 ∧ (a.2 + 1 = b.2 ∨ b.2 + 1 = a.2)) ∨
  (a.2 = b.2 ∧ (a.1 + 1 = b.1 ∨ b.1 + 1 = a.1))

inductive CellPath (s : List (Nat × Nat)) : (Nat × Nat) → (Nat × Nat) → Prop
  | refl (a) : a ∈ s → CellPath s a a
  | step {a b c} : a ∈ s → CellAdjacent a b → CellPath s b c → CellPath s a c

/-- The skew diagram obtained by adding cells to `xs` to reach `ys`. -/
def skew (xs ys : List Nat) : List (Nat × Nat) :=
  (cells ys).filter (fun p => !(cells xs).contains p)

/-- An ordinary border strip: nonempty, edge-connected, and containing no
    2-by-2 square, added while preserving the Young diagram. -/
def Border (xs ys : List Nat) : Prop :=
  (∀ p ∈ cells xs, p ∈ cells ys) ∧
  skew xs ys ≠ [] ∧
  (∀ a ∈ skew xs ys, ∀ b ∈ skew xs ys, CellPath (skew xs ys) a b) ∧
  (∀ a ∈ skew xs ys,
    ¬ ((a.1 + 1, a.2) ∈ skew xs ys ∧
       (a.1, a.2 + 1) ∈ skew xs ys ∧
       (a.1 + 1, a.2 + 1) ∈ skew xs ys))

theorem empty_core : IsCore23 [] := by simp [IsCore23, IsPartition, IsCore]
theorem box_core : IsCore23 [1] := by
  simp [IsCore23, IsPartition, IsCore, hook]

theorem singleton_border : Border [] [1] := by
  constructor
  · simp [cells]
  constructor
  · decide
  constructor
  · intro a ha b hb
    have ha0 : a = (0,0) := by simpa [skew, cells] using ha
    have hb0 : b = (0,0) := by simpa [skew, cells] using hb
    subst a; subst b
    exact CellPath.refl _ (by decide)
  · intro a ha
    have ha0 : a = (0,0) := by simpa [skew, cells] using ha
    subst a
    decide

abbrev Vertex := {xs : List Nat // IsCore23 xs}
def emptyVertex : Vertex := ⟨[], empty_core⟩
def boxVertex : Vertex := ⟨[1], box_core⟩

def Adj (a b : Vertex) : Prop := Border a.val b.val ∨ Border b.val a.val

/-- Undirected path equivalence, hence its quotient is the component set. -/
inductive Reach : Vertex → Vertex → Prop
  | refl (a) : Reach a a
  | edge {a b} : Adj a b → Reach a b
  | symm {a b} : Reach a b → Reach b a
  | trans {a b c} : Reach a b → Reach b c → Reach a c

theorem vertex_classification (v : Vertex) : v = emptyVertex ∨ v = boxVertex := by
  rcases classify v.property.1.1 v.property.2.1 v.property.2.2 with h | h
  · exact Or.inl (Subtype.ext h)
  · exact Or.inr (Subtype.ext h)

theorem empty_to_box : Reach emptyVertex boxVertex :=
  Reach.edge (Or.inl singleton_border)

theorem connected (a b : Vertex) : Reach a b := by
  rcases vertex_classification a with ha | ha <;>
    rcases vertex_classification b with hb | hb <;> subst a <;> subst b
  · exact Reach.refl _
  · exact empty_to_box
  · exact Reach.symm empty_to_box
  · exact Reach.refl _

def pathSetoid : Setoid Vertex where
  r := Reach
  iseqv := ⟨Reach.refl, Reach.symm, Reach.trans⟩

abbrev Component := Quotient pathSetoid

theorem component_unique (a b : Component) : a = b := by
  induction a using Quotient.inductionOn with
  | h a =>
    induction b using Quotient.inductionOn with
    | h b => exact Quotient.sound (connected a b)

/-- An explicit bijection with `Fin n` expresses finite cardinality. -/
def HasCard (α : Type) (n : Nat) : Prop :=
  ∃ f : Fin n → α, (∀ i j, f i = f j → i = j) ∧ (∀ a, ∃ i, f i = a)

theorem component_count_one : HasCard Component 1 := by
  refine ⟨(fun _ => Quotient.mk pathSetoid emptyVertex), ?_, ?_⟩
  · intro i j _
    apply Fin.ext
    have hi := i.isLt
    have hj := j.isLt
    omega
  · intro a
    exact ⟨0, component_unique _ _⟩

theorem component_count_not_two : ¬ HasCard Component 2 := by
  intro ⟨f, hf, _⟩
  have h := hf 0 1 (component_unique _ _)
  have hv := congrArg Fin.val h
  contradiction


/-- The argument depends only on allowing the elementary singleton border.
    Any extra permitted borders preserve the conclusion. -/
inductive ReachFor (R : Vertex → Vertex → Prop) : Vertex → Vertex → Prop
  | refl (a) : ReachFor R a a
  | edge {a b} : R a b → ReachFor R a b
  | symm {a b} : ReachFor R a b → ReachFor R b a
  | trans {a b c} : ReachFor R a b → ReachFor R b c → ReachFor R a c

theorem connected_for_any_border_relation (R : Vertex → Vertex → Prop)
    (hbox : R emptyVertex boxVertex) (a b : Vertex) : ReachFor R a b := by
  rcases vertex_classification a with ha | ha <;>
    rcases vertex_classification b with hb | hb <;> subst a <;> subst b
  · exact ReachFor.refl _
  · exact ReachFor.edge hbox
  · exact ReachFor.symm (ReachFor.edge hbox)
  · exact ReachFor.refl _

/-- Pascal's binomial coefficients, with no external numerical oracle. -/
def binom : Nat → Nat → Nat
  | _, 0 => 1
  | 0, _ + 1 => 0
  | n + 1, k + 1 => binom n k + binom n (k + 1)

def rationalCatalan (s t : Nat) : Nat := binom (s + t) s / (s + t)

theorem coprime_pair : Nat.gcd 2 3 = 1 := by decide
theorem binomial_numerator : binom 5 2 = 5 * 2 := by decide
theorem rational_catalan_two : rationalCatalan 2 3 = 2 := by decide

/-- The conjectured coprime formula fails for the complete (2,3)-core graph. -/
theorem counterexample : Nat.gcd 2 3 = 1 ∧ HasCard Component 1 ∧
    ¬ HasCard Component (rationalCatalan 2 3) := by
  exact ⟨coprime_pair, component_count_one,
    by rw [rational_catalan_two]; exact component_count_not_two⟩

#print axioms classify
#print axioms singleton_border
#print axioms component_count_one
#print axioms connected_for_any_border_relation
#print axioms counterexample
end TLMC3829
