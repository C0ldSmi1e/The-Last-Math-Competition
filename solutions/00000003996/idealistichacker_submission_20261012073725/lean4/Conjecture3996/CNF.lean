import Mathlib.Combinatorics.SimpleGraph.Clique
import Mathlib.Combinatorics.SimpleGraph.Finite
import Mathlib.Data.Finset.Sym
import Mathlib.Tactic

namespace Conjecture3996.CNF

variable {V : Type*} [Fintype V] [DecidableEq V]

abbrev Edge (V : Type*) := (SimpleGraph.completeGraph V).edgeSet
abbrev Assignment (V : Type*) := Edge V → Bool
abbrev Literal (V : Type*) := Edge V × Bool
abbrev Clause (V : Type*) := Finset (Literal V)
abbrev Formula (V : Type*) := Finset (Clause V)

def literalTrue (a : Assignment V) (l : Literal V) : Prop := a l.1 = l.2
def clauseSatisfied (a : Assignment V) (c : Clause V) : Prop := ∃ l ∈ c, literalTrue a l
def formulaSatisfied (a : Assignment V) (f : Formula V) : Prop := ∀ c ∈ f, clauseSatisfied a c

def edgesIn (s : Finset V) : Finset (Edge V) :=
  Finset.univ.filter (fun e => e.val ∈ s.sym2)

def block (s : Finset V) (b : Bool) : Clause V :=
  (edgesIn s).image (fun e => (e, !b))

/-- Standard Ramsey CNF: forbid each all-red and all-blue k-subset. -/
def ramseyCNF (k : ℕ) : Formula V :=
  Finset.univ.biUnion (fun s : Finset V =>
    if s.card = k then {block s true, block s false} else ∅)

def assignment (g : SimpleGraph V) [DecidableRel g.Adj] (e : Edge V) : Bool :=
  decide (e.val ∈ g.edgeSet)

def colorGraph (g : SimpleGraph V) (b : Bool) : SimpleGraph V := if b then g else gᶜ

theorem block_satisfied_of_not_clique (g : SimpleGraph V) [DecidableRel g.Adj]
    (s : Finset V) (b : Bool) (h : ¬(colorGraph g b).IsClique (s : Set V)) :
    clauseSatisfied (assignment g) (block s b) := by
  simp only [SimpleGraph.isClique_iff, Set.Pairwise] at h
  push Not at h
  obtain ⟨u, hu, v, hv, hne, hn⟩ := h
  let e : Edge V := ⟨s(u, v), (SimpleGraph.mem_edgeSet (SimpleGraph.completeGraph V)).mpr hne⟩
  refine ⟨(e, !b), Finset.mem_image.mpr ⟨e, ?_, rfl⟩, ?_⟩
  · simp only [edgesIn, Finset.mem_filter, Finset.mem_univ, true_and, e,
      Finset.mk_mem_sym2_iff]
    exact ⟨hu, hv⟩
  · cases b <;> simp_all [literalTrue, assignment, colorGraph, e,
      SimpleGraph.mem_edgeSet, SimpleGraph.compl_adj]

theorem cliqueFree_implies_satisfiable (g : SimpleGraph V) [DecidableRel g.Adj] (k : ℕ)
    (hr : g.CliqueFree k) (hb : gᶜ.CliqueFree k) :
    ∃ a : Assignment V, formulaSatisfied a (ramseyCNF k) := by
  refine ⟨assignment g, ?_⟩
  intro c hc
  obtain ⟨s, _, hs⟩ := Finset.mem_biUnion.mp hc
  dsimp [ramseyCNF] at hc
  by_cases hcard : s.card = k
  · simp only [if_pos hcard, Finset.mem_insert, Finset.mem_singleton] at hs
    rcases hs with rfl | rfl
    · apply block_satisfied_of_not_clique g s true
      intro hcl
      exact hr s ⟨by simpa [colorGraph] using hcl, hcard⟩
    · apply block_satisfied_of_not_clique g s false
      intro hcl
      exact hb s ⟨by simpa [colorGraph] using hcl, hcard⟩
  · simp [hcard] at hs

def resolvent (c d : Clause V) (e : Edge V) : Clause V :=
  c.erase (e, true) ∪ d.erase (e, false)

/-- Ordinary resolution and sound weakening, with actual earlier-parent proof trees. -/
inductive Derives (f : Formula V) : Clause V → Prop where
  | input {c} : c ∈ f → Derives f c
  | resolve {c d} (e : Edge V) : Derives f c → Derives f d →
      (e, true) ∈ c → (e, false) ∈ d → Derives f (resolvent c d e)
  | weaken {c d} : Derives f c → c ⊆ d → Derives f d

omit [Fintype V] in
theorem resolvent_sound (a : Assignment V) (c d : Clause V) (e : Edge V)
    (hc : clauseSatisfied a c) (hd : clauseSatisfied a d) :
    clauseSatisfied a (resolvent c d e) := by
  cases hv : a e
  · obtain ⟨l, hl, htrue⟩ := hc
    have hne : l ≠ (e, true) := by
      intro he
      subst l
      simp [literalTrue, hv] at htrue
    exact ⟨l, Finset.mem_union.mpr (Or.inl (Finset.mem_erase.mpr ⟨hne, hl⟩)), htrue⟩
  · obtain ⟨l, hl, htrue⟩ := hd
    have hne : l ≠ (e, false) := by
      intro he
      subst l
      simp [literalTrue, hv] at htrue
    exact ⟨l, Finset.mem_union.mpr (Or.inr (Finset.mem_erase.mpr ⟨hne, hl⟩)), htrue⟩

omit [Fintype V] in
theorem derivation_sound (f : Formula V) (c : Clause V) (h : Derives f c)
    (a : Assignment V) (ha : formulaSatisfied a f) : clauseSatisfied a c := by
  induction h with
  | input hc => exact ha _ hc
  | resolve e _ _ _ _ ihc ihd => exact resolvent_sound a _ _ e ihc ihd
  | weaken _ hsub ih =>
      obtain ⟨l, hl, htrue⟩ := ih
      exact ⟨l, hsub hl, htrue⟩

omit [Fintype V] in
theorem satisfiable_excludes_refutation (f : Formula V)
    (hs : ∃ a : Assignment V, formulaSatisfied a f) : ¬Derives f ∅ := by
  rintro hf
  obtain ⟨a, ha⟩ := hs
  have he := derivation_sound f ∅ hf a ha
  simp [clauseSatisfied] at he

theorem cliqueFree_excludes_ramsey_refutation (g : SimpleGraph V) [DecidableRel g.Adj]
    (k : ℕ) (hr : g.CliqueFree k) (hb : gᶜ.CliqueFree k) :
    ¬Derives (ramseyCNF (V := V) k) ∅ :=
  satisfiable_excludes_refutation _ (cliqueFree_implies_satisfiable g k hr hb)

end Conjecture3996.CNF
