import Mathlib.Combinatorics.SimpleGraph.Clique
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Fintype.EquivFin
import Mathlib.Tactic

set_option maxRecDepth 10000
set_option maxHeartbeats 2000000

namespace Conjecture3996.Family

open Finset

def cycle5 : SimpleGraph (Fin 5) where
  Adj a b := a ≠ b ∧ (((a.val + 1) % 5 = b.val) ∨ ((b.val + 1) % 5 = a.val))
  symm := ⟨fun _ _ h => ⟨h.1.symm, h.2.symm⟩⟩
  loopless := ⟨fun _ h => h.1 rfl⟩

instance cycle5DecidableRel : DecidableRel cycle5.Adj := by
  intro a b
  unfold cycle5
  infer_instance

theorem cycle5_clique_card (s : Finset (Fin 5))
    (h : cycle5.IsClique (s : Set (Fin 5))) : s.card ≤ 2 := by
  have hAll : ∀ s : Finset (Fin 5), cycle5.IsClique (s : Set (Fin 5)) -> s.card ≤ 2 := by
    decide
  exact hAll s h

theorem cycle5_compl_clique_card (s : Finset (Fin 5))
    (h : cycle5ᶜ.IsClique (s : Set (Fin 5))) : s.card ≤ 2 := by
  have hAll : ∀ s : Finset (Fin 5), cycle5ᶜ.IsClique (s : Set (Fin 5)) -> s.card ≤ 2 := by
    decide
  exact hAll s h

def Words : Nat -> Type
  | 0 => Unit
  | t + 1 => Fin 5 × Words t

instance wordsFintype : (t : Nat) -> Fintype (Words t)
  | 0 => inferInstanceAs (Fintype Unit)
  | t + 1 => by
      letI := wordsFintype t
      exact inferInstanceAs (Fintype (Fin 5 × Words t))

instance wordsDecidableEq : (t : Nat) -> DecidableEq (Words t)
  | 0 => inferInstanceAs (DecidableEq Unit)
  | t + 1 => by
      letI := wordsDecidableEq t
      exact inferInstanceAs (DecidableEq (Fin 5 × Words t))

def red : (t : Nat) -> SimpleGraph (Words t)
  | 0 => ⊥
  | t + 1 => {
      Adj u v := (u.1 ≠ v.1 ∧ cycle5.Adj u.1 v.1) ∨
        (u.1 = v.1 ∧ (red t).Adj u.2 v.2)
      symm := ⟨by
        intro u v h
        rcases h with h | h
        · exact Or.inl ⟨h.1.symm, cycle5.symm.symm _ _ h.2⟩
        · exact Or.inr ⟨h.1.symm, (red t).symm.symm _ _ h.2⟩⟩
      loopless := ⟨by
        intro u h
        rcases h with h | h
        · exact h.1 rfl
        · exact (red t).loopless.irrefl u.2 h.2⟩ }

-- Projection and same-block hypotheses are proved for actual graph adjacency.
theorem clique_card_blocks {V : Type} [DecidableEq V]
    (L : SimpleGraph (Fin 5 × V)) (B : SimpleGraph (Fin 5))
    (H : SimpleGraph V) (b : Nat)
    (baseBound : ∀ s : Finset (Fin 5), B.IsClique (s : Set (Fin 5)) -> s.card ≤ 2)
    (suffixBound : ∀ s : Finset V, H.IsClique (s : Set V) -> s.card ≤ b)
    (cross : ∀ u v, L.Adj u v -> u.1 ≠ v.1 -> B.Adj u.1 v.1)
    (within : ∀ i u v, L.Adj (i, u) (i, v) -> H.Adj u v)
    (s : Finset (Fin 5 × V)) (hs : L.IsClique (s : Set (Fin 5 × V))) :
    s.card ≤ 2 * b := by
  have hp : B.IsClique (s.image Prod.fst : Set (Fin 5)) := by
    intro i hi j hj hij
    obtain ⟨u, hu, rfl⟩ := Finset.mem_image.mp hi
    obtain ⟨v, hv, rfl⟩ := Finset.mem_image.mp hj
    exact cross u v (hs hu hv (fun e => hij (congrArg Prod.fst e))) hij
  have hf : ∀ i : Fin 5, (s.filter (fun u => u.1 = i)).card ≤ b := by
    intro i
    let f := s.filter (fun u => u.1 = i)
    have hfc : H.IsClique (f.image Prod.snd : Set V) := by
      intro u hu v hv huv
      obtain ⟨x, hx, rfl⟩ := Finset.mem_image.mp hu
      obtain ⟨y, hy, rfl⟩ := Finset.mem_image.mp hv
      have hxi : x.1 = i := (Finset.mem_filter.mp hx).2
      have hyi : y.1 = i := (Finset.mem_filter.mp hy).2
      have hxy := hs (Finset.mem_filter.mp hx).1 (Finset.mem_filter.mp hy).1
        (fun e => huv (congrArg Prod.snd e))
      have ex : x = (i, x.2) := Prod.ext hxi rfl
      have ey : y = (i, y.2) := Prod.ext hyi rfl
      rw [ex, ey] at hxy
      exact within i x.2 y.2 hxy
    have hinj : Set.InjOn Prod.snd (f : Set (Fin 5 × V)) := by
      intro x hx y hy hxy
      exact Prod.ext ((Finset.mem_filter.mp hx).2.trans
        (Finset.mem_filter.mp hy).2.symm) hxy
    have hcard := Finset.card_image_of_injOn hinj
    have hb := suffixBound (f.image Prod.snd) hfc
    rw [hcard] at hb
    exact hb
  calc
    s.card = ∑ i ∈ s.image Prod.fst, (s.filter (fun u => u.1 = i)).card :=
      Finset.card_eq_sum_card_image Prod.fst s
    _ ≤ ∑ _i ∈ s.image Prod.fst, b := Finset.sum_le_sum (fun i _ => hf i)
    _ = (s.image Prod.fst).card * b := by simp
    _ ≤ 2 * b := Nat.mul_le_mul_right b (baseBound _ hp)

theorem red_blue_clique_card (t : Nat) :
    (∀ s : Finset (Words t), (red t).IsClique (s : Set (Words t)) -> s.card ≤ 2 ^ t) ∧
    (∀ s : Finset (Words t), (red t)ᶜ.IsClique (s : Set (Words t)) -> s.card ≤ 2 ^ t) := by
  induction t with
  | zero =>
    constructor <;> intro s _
    all_goals
      apply Finset.card_le_one.mpr
      intro a _ b _
      cases a
      cases b
      rfl
  | succ t ih =>
    constructor
    · intro s hs
      have bound := clique_card_blocks (red (t+1)) cycle5 (red t) (2^t)
        cycle5_clique_card ih.1
        (by intro u v h huv; exact h.resolve_right (fun hh => huv hh.1) |>.2)
        (by intro i u v h; exact h.resolve_left (fun hh => hh.1 rfl) |>.2) s hs
      exact bound.trans_eq (by rw [pow_succ, Nat.mul_comm])
    · intro s hs
      have bound := clique_card_blocks (red (t+1))ᶜ cycle5ᶜ (red t)ᶜ (2^t)
        cycle5_compl_clique_card ih.2
        (by
          intro u v h huv
          exact ⟨huv, fun hc => h.2 (Or.inl ⟨huv, hc⟩)⟩)
        (by
          intro i u v h
          exact ⟨fun e => h.1 (congrArg (fun w => (i, w)) e),
            fun hr => h.2 (Or.inr ⟨rfl, hr⟩)⟩) s hs
      exact bound.trans_eq (by rw [pow_succ, Nat.mul_comm])


theorem words_card (t : Nat) : Fintype.card (Words t) = 5 ^ t := by
  induction t with
  | zero => rfl
  | succ t ih =>
    change Fintype.card (Fin 5 × Words t) = 5 ^ (t + 1)
    rw [Fintype.card_prod, Fintype.card_fin, ih, pow_succ, Nat.mul_comm]

theorem diagonal_card_le (t : Nat) (ht : 2 ≤ t) : (2 ^ t + 1) ^ 2 ≤ 5 ^ t := by
  induction t, ht using Nat.le_induction with
  | base => decide
  | succ t _ ih =>
    calc
      (2 ^ (t + 1) + 1) ^ 2 ≤ 5 * (2 ^ t + 1) ^ 2 := by
        rw [show 2 ^ (t + 1) = 2 ^ t * 2 by rw [pow_succ]]
        calc
          (2 ^ t * 2 + 1) ^ 2 ≤
              (2 ^ t * 2 + 1) ^ 2 + ((2 ^ t) ^ 2 + 6 * 2 ^ t + 4) :=
            Nat.le_add_right _ _
          _ = 5 * (2 ^ t + 1) ^ 2 := by ring
      _ ≤ 5 * 5 ^ t := Nat.mul_le_mul_left 5 ih
      _ = 5 ^ (t + 1) := by rw [pow_succ, Nat.mul_comm]

-- Pullback along a genuine injection preserves clique cardinalities.
theorem clique_card_comap {V W : Type} [DecidableEq V] [DecidableEq W]
    (G : SimpleGraph W) (e : V ↪ W) (b : Nat)
    (hb : ∀ s : Finset W, G.IsClique (s : Set W) -> s.card ≤ b)
    (s : Finset V) (hs : (G.comap e).IsClique (s : Set V)) : s.card ≤ b := by
  have himg : G.IsClique (s.image e : Set W) := by
    intro x hx y hy hxy
    obtain ⟨u, hu, rfl⟩ := Finset.mem_image.mp hx
    obtain ⟨v, hv, rfl⟩ := Finset.mem_image.mp hy
    exact hs hu hv (fun h => hxy (congrArg e h))
  have hcard : (s.image e).card = s.card :=
    Finset.card_image_of_injective s e.injective
  have bound := hb (s.image e) himg
  rwa [hcard] at bound

theorem compl_comap_embedding {V W : Type} (G : SimpleGraph W) (e : V ↪ W) :
    (G.comap e)ᶜ = Gᶜ.comap e := by
  ext u v
  change (u ≠ v ∧ ¬G.Adj (e u) (e v)) ↔ (e u ≠ e v ∧ ¬G.Adj (e u) (e v))
  constructor
  · rintro ⟨hne, hnot⟩
    exact ⟨fun h => hne (e.injective h), hnot⟩
  · rintro ⟨hne, hnot⟩
    exact ⟨fun h => hne (congrArg e h), hnot⟩

noncomputable def diagonalEmbedding (t : Nat) (ht : 2 ≤ t) :
    Fin ((2 ^ t + 1) ^ 2) ↪ Words t :=
  Classical.choice (Function.Embedding.nonempty_of_card_le (by
    rw [Fintype.card_fin, words_card]
    exact diagonal_card_le t ht))

noncomputable def diagonalGraph (t : Nat) (ht : 2 ≤ t) :
    SimpleGraph (Fin ((2 ^ t + 1) ^ 2)) :=
  (red t).comap (diagonalEmbedding t ht)

theorem diagonal_clique_card (t : Nat) (ht : 2 ≤ t) :
    (∀ s : Finset (Fin ((2 ^ t + 1) ^ 2)),
      (diagonalGraph t ht).IsClique (s : Set (Fin ((2 ^ t + 1) ^ 2))) -> s.card ≤ 2 ^ t) ∧
    (∀ s : Finset (Fin ((2 ^ t + 1) ^ 2)),
      (diagonalGraph t ht)ᶜ.IsClique (s : Set (Fin ((2 ^ t + 1) ^ 2))) -> s.card ≤ 2 ^ t) := by
  constructor
  · intro s hs
    exact clique_card_comap (red t) (diagonalEmbedding t ht) (2 ^ t)
      (red_blue_clique_card t).1 s hs
  · intro s hs
    rw [diagonalGraph, compl_comap_embedding] at hs
    exact clique_card_comap (red t)ᶜ (diagonalEmbedding t ht) (2 ^ t)
      (red_blue_clique_card t).2 s hs

theorem diagonal_cliqueFree (t : Nat) (ht : 2 ≤ t) :
    (diagonalGraph t ht).CliqueFree (2 ^ t + 1) ∧
    (diagonalGraph t ht)ᶜ.CliqueFree (2 ^ t + 1) := by
  constructor
  · intro s hs
    have hb := (diagonal_clique_card t ht).1 s hs.isClique
    rw [hs.card_eq] at hb
    omega
  · intro s hs
    have hb := (diagonal_clique_card t ht).2 s hs.isClique
    rw [hs.card_eq] at hb
    omega

theorem diagonal_family (t : Nat) (ht : 2 ≤ t) :
    ∃ G : SimpleGraph (Fin ((2 ^ t + 1) ^ 2)),
      G.CliqueFree (2 ^ t + 1) ∧ Gᶜ.CliqueFree (2 ^ t + 1) :=
  ⟨diagonalGraph t ht, diagonal_cliqueFree t ht⟩

-- This is a graph-only necessary Ramsey premise, not a source/CNF alignment claim.
def EventualDiagonalRamsey : Prop :=
  ∃ K : Nat, ∀ k : Nat, K ≤ k -> ∀ G : SimpleGraph (Fin (k ^ 2)),
    (∃ s, G.IsNClique k s) ∨ (∃ s, Gᶜ.IsNClique k s)

theorem beyond_every_threshold (K : Nat) :
    ∃ k : Nat, K ≤ k ∧ ∃ G : SimpleGraph (Fin (k ^ 2)),
      G.CliqueFree k ∧ Gᶜ.CliqueFree k := by
  let t := K + 2
  have ht : 2 ≤ t := by omega
  have hk : K ≤ 2 ^ t + 1 := by
    have hg : t < 2 ^ t := Nat.lt_two_pow_self
    omega
  exact ⟨2 ^ t + 1, hk, diagonal_family t ht⟩

theorem not_eventual_diagonal_ramsey : ¬EventualDiagonalRamsey := by
  rintro ⟨K, hK⟩
  obtain ⟨k, hk, G, hred, hblue⟩ := beyond_every_threshold K
  rcases hK k hk G with ⟨s, hs⟩ | ⟨s, hs⟩
  · exact hred s hs
  · exact hblue s hs

theorem diagonal_color_partition (t : Nat) (ht : 2 ≤ t)
    (u v : Fin ((2 ^ t + 1) ^ 2)) (hne : u ≠ v) :
    ((diagonalGraph t ht).Adj u v ∨ (diagonalGraph t ht)ᶜ.Adj u v) ∧
    ¬((diagonalGraph t ht).Adj u v ∧ (diagonalGraph t ht)ᶜ.Adj u v) := by
  classical
  constructor
  · by_cases h : (diagonalGraph t ht).Adj u v
    · exact Or.inl h
    · exact Or.inr ⟨hne, h⟩
  · rintro ⟨hr, hb⟩
    exact hb.2 hr


end Conjecture3996.Family
