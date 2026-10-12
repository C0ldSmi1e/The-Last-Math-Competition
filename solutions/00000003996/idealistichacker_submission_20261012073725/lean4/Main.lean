import Conjecture3996.CNF
import Conjecture3996.Family

namespace Conjecture3996

/-- A finite asymptotic resolution upper bound requires eventual refutability. -/
def EventualFiniteRefutations : Prop :=
  ∃ K : ℕ, ∀ k : ℕ, K ≤ k →
    CNF.Derives (CNF.ramseyCNF (V := Fin (k ^ 2)) k) ∅

theorem beyond_every_threshold_satisfiable (K : ℕ) :
    ∃ k : ℕ, K ≤ k ∧
      ∃ a : CNF.Assignment (Fin (k ^ 2)),
        CNF.formulaSatisfied a (CNF.ramseyCNF (V := Fin (k ^ 2)) k) := by
  classical
  obtain ⟨k, hk, g, hr, hb⟩ := Family.beyond_every_threshold K
  exact ⟨k, hk, CNF.cliqueFree_implies_satisfiable g k hr hb⟩

theorem beyond_every_threshold_no_refutation (K : ℕ) :
    ∃ k : ℕ, K ≤ k ∧
      ¬CNF.Derives (CNF.ramseyCNF (V := Fin (k ^ 2)) k) ∅ := by
  obtain ⟨k, hk, a, ha⟩ := beyond_every_threshold_satisfiable K
  exact ⟨k, hk, CNF.satisfiable_excludes_refutation _ ⟨a, ha⟩⟩

/-- Negates a necessary clause of the claimed finite matching upper bound,
not the lower bound alone and not a single small-parameter assertion. -/
theorem necessary_finite_upper_bound_false : ¬EventualFiniteRefutations := by
  rintro ⟨K, hK⟩
  obtain ⟨k, hk, hn⟩ := beyond_every_threshold_no_refutation K
  exact hn (hK k hk)

theorem actual_diagonal_counterexamples :
    ∀ K : ℕ, ∃ k : ℕ, K ≤ k ∧
      ∃ g : SimpleGraph (Fin (k ^ 2)),
        g.CliqueFree k ∧ gᶜ.CliqueFree k ∧
        (∃ a : CNF.Assignment (Fin (k ^ 2)),
          CNF.formulaSatisfied a (CNF.ramseyCNF (V := Fin (k ^ 2)) k)) ∧
        ¬CNF.Derives (CNF.ramseyCNF (V := Fin (k ^ 2)) k) ∅ := by
  classical
  intro K
  obtain ⟨k, hk, g, hr, hb⟩ := Family.beyond_every_threshold K
  have hs := CNF.cliqueFree_implies_satisfiable g k hr hb
  exact ⟨k, hk, g, hr, hb, hs, CNF.satisfiable_excludes_refutation _ hs⟩

end Conjecture3996
