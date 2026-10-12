import Mathlib.Combinatorics.SimpleGraph.Connectivity.Connected
import Mathlib.Combinatorics.SimpleGraph.Finite
import Mathlib.Combinatorics.SimpleGraph.Subgraph
import Mathlib.Tactic

open scoped BigOperators
namespace Conjecture3992

abbrev Vertex := Fin 3
abbrev Edge := Fin 3
abbrev Assignment := Edge → Bool
abbrev Literal := Edge × Bool
abbrev Clause := Finset Literal
abbrev Formula := Finset Clause
abbrev triangle : SimpleGraph Vertex := SimpleGraph.completeGraph Vertex

def next (e : Edge) : Vertex := e + 1
def edgeIndex (e : Edge) : Sym2 Vertex := s(e, next e)

theorem next_ne (e : Edge) : e ≠ next e := by fin_cases e <;> decide
theorem next_next_ne (e : Edge) : next (next e) ≠ e := by fin_cases e <;> decide

theorem triangle_connected : triangle.Connected := SimpleGraph.connected_top

theorem edgeIndex_injective : Function.Injective edgeIndex := by
  intro i j h
  change s(i, next i) = s(j, next j) at h
  rcases Sym2.eq_iff.mp h with ⟨hij, _⟩ | ⟨hij, hji⟩
  · exact hij
  · have htwo : next (next i) = i := (congrArg next hji).trans hij.symm
    exact False.elim (next_next_ne i htwo)

theorem triangle_adj_iff_indexed (u v : Vertex) :
    triangle.Adj u v ↔ ∃ e : Edge, edgeIndex e = s(u, v) := by
  simp only [SimpleGraph.top_adj, edgeIndex, Sym2.eq_iff, next]
  fin_cases u <;> fin_cases v <;> decide

def indexedEdge (e : Edge) : triangle.edgeSet :=
  ⟨edgeIndex e, triangle.mem_edgeSet.mpr (next_ne e)⟩

theorem indexedEdge_bijective : Function.Bijective indexedEdge := by
  constructor
  · intro i j h
    exact edgeIndex_injective (congrArg Subtype.val h)
  · intro f
    have hcover : ∀ a : Sym2 Vertex, a ∈ triangle.edgeSet → ∃ e : Edge, edgeIndex e = a := by
      intro a
      refine Sym2.ind (fun u v => ?_) a
      intro ha
      exact (triangle_adj_iff_indexed u v).mp (triangle.mem_edgeSet.mp ha)
    obtain ⟨e, he⟩ := hcover f.val f.property
    exact ⟨e, Subtype.ext he⟩

def incidence (v : Vertex) : Finset Edge :=
  Finset.univ.filter (fun e => v = e ∨ v = next e)

theorem incidence_actual_graph (v : Vertex) (e : Edge) :
    e ∈ incidence v ↔ edgeIndex e ∈ triangle.incidenceSet v := by
  simp only [incidence, Finset.mem_filter, Finset.mem_univ, true_and, edgeIndex,
    SimpleGraph.mk'_mem_incidenceSet_iff, SimpleGraph.top_adj]
  exact (and_iff_right (next_ne e)).symm

def charge (_v : Vertex) : ℕ := 1
def parityAt (v : Vertex) (a : Assignment) : Prop :=
  (∑ e ∈ incidence v, if a e then 1 else 0) % 2 = charge v

instance (v : Vertex) (a : Assignment) : Decidable (parityAt v a) := by
  unfold parityAt
  infer_instance

def literalTrue (a : Assignment) (l : Literal) : Prop := a l.1 = l.2
def clauseSatisfied (a : Assignment) (c : Clause) : Prop := ∃ l ∈ c, literalTrue a l
def formulaSatisfied (a : Assignment) (f : Formula) : Prop := ∀ c ∈ f, clauseSatisfied a c

instance (a : Assignment) (c : Clause) : Decidable (clauseSatisfied a c) := by
  unfold clauseSatisfied literalTrue
  infer_instance

instance (a : Assignment) (f : Formula) : Decidable (formulaSatisfied a f) := by
  unfold formulaSatisfied
  infer_instance

def blockingClause (v : Vertex) (a : Assignment) : Clause :=
  (incidence v).image (fun e => (e, !(a e)))

def parityCNF : Formula :=
  Finset.univ.biUnion (fun v : Vertex =>
    (Finset.univ.filter (fun a : Assignment => ¬ parityAt v a)).image (blockingClause v))

def concreteCNF : Formula :=
  {{(0, true), (1, true)}, {(0, false), (1, false)},
   {(1, true), (2, true)}, {(1, false), (2, false)},
   {(2, true), (0, true)}, {(2, false), (0, false)}}

theorem parityCNF_eq : parityCNF = concreteCNF := by decide

theorem parityCNF_semantics : ∀ a : Assignment,
    formulaSatisfied a parityCNF ↔ ∀ v, parityAt v a := by decide

theorem total_charge_odd : (∑ v : Vertex, charge v) % 2 = 1 := by decide
theorem parity_inconsistent : ¬ ∃ a : Assignment, ∀ v, parityAt v a := by decide

theorem actual_Tseitin_unsatisfiable : ¬ ∃ a : Assignment, formulaSatisfied a parityCNF := by
  rintro ⟨a, ha⟩
  exact parity_inconsistent ⟨a, (parityCNF_semantics a).mp ha⟩

def resolvent (c d : Clause) (e : Edge) : Clause :=
  c.erase (e, true) ∪ d.erase (e, false)

/-- Standard input-inclusive bounded resolution, also allowing sound weakening. -/
inductive DerivesWithin (f : Formula) (w : ℕ) : Clause → Prop where
  | input {c} : c ∈ f → c.card ≤ w → DerivesWithin f w c
  | resolve {c d} (e : Edge) : DerivesWithin f w c → DerivesWithin f w d →
      (e, true) ∈ c → (e, false) ∈ d → (resolvent c d e).card ≤ w →
      DerivesWithin f w (resolvent c d e)
  | weaken {c d} : DerivesWithin f w c → c ⊆ d → d.card ≤ w → DerivesWithin f w d

def RefutesWithin (f : Formula) (w : ℕ) : Prop := DerivesWithin f w ∅
def IsResolutionWidth (f : Formula) (w : ℕ) : Prop :=
  RefutesWithin f w ∧ ∀ w', RefutesWithin f w' → w ≤ w'

theorem resolvent_sound (a : Assignment) (c d : Clause) (e : Edge)
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

theorem derivation_sound (f : Formula) (w : ℕ) (c : Clause)
    (h : DerivesWithin f w c) (a : Assignment) (ha : formulaSatisfied a f) :
    clauseSatisfied a c := by
  induction h with
  | input hc _ => exact ha _ hc
  | resolve e _ _ _ _ _ ihc ihd => exact resolvent_sound a _ _ e ihc ihd
  | weaken _ hsub _ ih =>
      obtain ⟨l, hl, htrue⟩ := ih
      exact ⟨l, hsub hl, htrue⟩

theorem refutation_implies_unsatisfiable (f : Formula) (w : ℕ) (h : RefutesWithin f w) :
    ¬ ∃ a : Assignment, formulaSatisfied a f := by
  rintro ⟨a, ha⟩
  have hs := derivation_sound f w ∅ h a ha
  simp [clauseSatisfied] at hs

theorem axiom_width_two : ∀ c ∈ parityCNF, c.card = 2 := by
  rw [parityCNF_eq]
  decide

theorem no_derivation_below_two (w : ℕ) (hw : w < 2) (c : Clause) :
    ¬ DerivesWithin parityCNF w c := by
  intro h
  induction h with
  | input hc hwidth => have := axiom_width_two _ hc; omega
  | resolve _ _ _ _ _ _ ih _ => exact ih
  | weaken _ _ _ ih => exact ih

theorem width_two_refutation : RefutesWithin parityCNF 2 := by
  have hxy : DerivesWithin parityCNF 2 {(0, true), (1, true)} :=
    .input (by rw [parityCNF_eq]; decide) (by decide)
  have hnyz : DerivesWithin parityCNF 2 {(1, false), (2, false)} :=
    .input (by rw [parityCNF_eq]; decide) (by decide)
  have hzx : DerivesWithin parityCNF 2 {(2, true), (0, true)} :=
    .input (by rw [parityCNF_eq]; decide) (by decide)
  have hnxny : DerivesWithin parityCNF 2 {(0, false), (1, false)} :=
    .input (by rw [parityCNF_eq]; decide) (by decide)
  have hyz : DerivesWithin parityCNF 2 {(1, true), (2, true)} :=
    .input (by rw [parityCNF_eq]; decide) (by decide)
  have hnznx : DerivesWithin parityCNF 2 {(2, false), (0, false)} :=
    .input (by rw [parityCNF_eq]; decide) (by decide)
  have hp1 : DerivesWithin parityCNF 2 {(0, true), (2, false)} := by
    convert DerivesWithin.resolve 1 hxy hnyz (by decide) (by decide) (by decide) using 1
    decide
  have hp : DerivesWithin parityCNF 2 {(0, true)} := by
    convert DerivesWithin.resolve 2 hzx hp1 (by decide) (by decide) (by decide) using 1
    decide
  have hn1 : DerivesWithin parityCNF 2 {(2, true), (0, false)} := by
    convert DerivesWithin.resolve 1 hyz hnxny (by decide) (by decide) (by decide) using 1
    decide
  have hn : DerivesWithin parityCNF 2 {(0, false)} := by
    convert DerivesWithin.resolve 2 hn1 hnznx (by decide) (by decide) (by decide) using 1
    decide
  unfold RefutesWithin
  convert DerivesWithin.resolve 0 hp hn (by decide) (by decide) (by decide) using 1
  decide

theorem refutation_width_lower_bound (w : ℕ) (h : RefutesWithin parityCNF w) : 2 ≤ w := by
  by_contra hnot
  exact no_derivation_below_two w (by omega) ∅ h

theorem actual_resolution_width_two : IsResolutionWidth parityCNF 2 :=
  ⟨width_two_refutation, refutation_width_lower_bound⟩

theorem resolution_width_unique (w : ℕ) (h : IsResolutionWidth parityCNF w) : w = 2 :=
  Nat.le_antisymm (h.2 2 width_two_refutation) (refutation_width_lower_bound w h.1)

noncomputable section

/-- Charge is the sum of the original vertex charges on an ACTUAL subgraph. -/
def oddChargeSubgraph (h : triangle.Subgraph) : Prop :=
  (∑ v ∈ h.verts.toFinite.toFinset, charge v) % 2 = 1

theorem odd_charge_implies_odd_vertex_count (h : triangle.Subgraph) (ho : oddChargeSubgraph h) :
    h.verts.ncard % 2 = 1 := by
  simpa [oddChargeSubgraph, charge, ← Set.ncard_eq_toFinset_card] using ho

theorem no_odd_charge_subgraph_with_two_vertices (h : triangle.Subgraph) :
    ¬ (oddChargeSubgraph h ∧ h.verts.ncard = 2) := by
  rintro ⟨ho, hc⟩
  have hp := odd_charge_implies_odd_vertex_count h ho
  rw [hc] at hp
  norm_num at hp

theorem singleton_is_odd_charge : oddChargeSubgraph (triangle.singletonSubgraph 0) := by
  simp [oddChargeSubgraph, charge, SimpleGraph.singletonSubgraph]

theorem singleton_vertex_count : (triangle.singletonSubgraph 0).verts.ncard = 1 := by
  simp [SimpleGraph.singletonSubgraph]

/-- Even the existence required by any exact minimum-size equality is impossible.
This does not choose a subclass of admissible odd-charge subgraphs. -/
def NecessaryWidthChargeClause : Prop :=
  ∀ w, IsResolutionWidth parityCNF w →
    ∃ h : triangle.Subgraph, oddChargeSubgraph h ∧ h.verts.ncard = w

theorem necessary_width_charge_clause_false : ¬ NecessaryWidthChargeClause := by
  intro hclaim
  obtain ⟨h, ho, hc⟩ := hclaim 2 actual_resolution_width_two
  exact no_odd_charge_subgraph_with_two_vertices h ⟨ho, hc⟩

theorem actual_graph_counterexample :
    triangle.Connected ∧ (∑ v : Vertex, charge v) % 2 = 1 ∧
    (¬ ∃ a : Assignment, formulaSatisfied a parityCNF) ∧
    IsResolutionWidth parityCNF 2 ∧
    (∀ h : triangle.Subgraph, oddChargeSubgraph h → h.verts.ncard ≠ 2) := by
  refine ⟨triangle_connected, total_charge_odd, actual_Tseitin_unsatisfiable,
    actual_resolution_width_two, ?_⟩
  intro h ho hc
  exact no_odd_charge_subgraph_with_two_vertices h ⟨ho, hc⟩

end
end Conjecture3992
