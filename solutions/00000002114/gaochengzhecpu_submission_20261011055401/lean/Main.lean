import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Topology.Instances.Nat
import Mathlib.Topology.Algebra.Order.LiminfLimsup
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring

/-!
The classical two-colour urn starts with one ball of each colour and
adds one ball of the colour drawn. Its actual count-law recursion is
solved below. Closed tails have zero exponential decay at speed n,
excluding every strictly positive translated quadratic rate.
-/

namespace Conjecture2114
set_option autoImplicit false
open Filter Finset
open scoped Topology
noncomputable section
attribute [local instance] Classical.propDecidable

def replacement : Fin 2 → Fin 2 → ℕ := fun i j => if i = j then 1 else 0

def Balanced (R : Fin 2 → Fin 2 → ℕ) : Prop :=
  R 0 0 + R 0 1 = R 1 0 + R 1 1

theorem balanced : Balanced replacement := by norm_num [Balanced, replacement]

/-- Probability of k red draws after n draws, defined by the urn transition.
The two incoming terms correspond to a blue draw and a red draw. -/
def mass : ℕ → ℕ → ℝ
  | 0, k => if k = 0 then 1 else 0
  | n + 1, 0 => mass n 0 * (n + 1) / (n + 2)
  | n + 1, k + 1 =>
      mass n (k + 1) * (↑(n - k)) / (n + 2) + mass n k * (k + 1) / (n + 2)

theorem mass_formula (n k : ℕ) : mass n k = if k ≤ n then 1 / (n + 1 : ℝ) else 0 := by
  induction n generalizing k with
  | zero => simp [mass]
  | succ n ih =>
    have hn : (n : ℝ) + 1 ≠ 0 := by positivity
    have hn2 : (n : ℝ) + 2 ≠ 0 := by positivity
    cases k with
    | zero => simp [mass, ih, Nat.cast_add, Nat.cast_one]; field_simp; ring
    | succ k =>
      by_cases hk : k + 1 ≤ n
      · have hkn : k ≤ n := by omega
        have hknew : k + 1 ≤ n + 1 := by omega
        simp only [mass, ih, if_pos hk, if_pos hkn, if_pos hknew,
          Nat.cast_add, Nat.cast_one, Nat.cast_sub hkn]
        field_simp
        ring
      · by_cases hkn : k ≤ n
        · have hkeq : k = n := by omega
          subst k
          simp [mass, ih, Nat.cast_add, Nat.cast_one]
          field_simp
          ring
        · have hknew : ¬ k + 1 ≤ n + 1 := by omega
          simp [mass, ih, hk, hkn, hknew]

theorem mass_nonneg (n k : ℕ) : 0 ≤ mass n k := by
  rw [mass_formula]
  split_ifs <;> positivity

theorem mass_total (n : ℕ) : ∑ k ∈ range (n + 1), mass n k = 1 := by
  have hs : ∀ k ∈ range (n + 1), mass n k = 1 / (n + 1 : ℝ) := by
    intro k hk
    rw [mass_formula, if_pos (Nat.le_of_lt_succ (mem_range.mp hk))]
  rw [sum_congr rfl hs]
  simp
  field_simp

/-- Actual fraction of red balls after n draws and k red draws. -/
def proportion (n k : ℕ) : ℝ := (k + 1 : ℝ) / (n + 2 : ℝ)

/-- Event probability under the finitely supported, normalized urn count law. -/
def prob (n : ℕ) (F : Set ℝ) : ℝ :=
  ∑ k ∈ range (n + 1), if proportion n k ∈ F then mass n k else 0

theorem proportion_mem_unit {n k : ℕ} (hk : k ≤ n) :
    proportion n k ∈ Set.Icc 0 1 := by
  have hkn : (k : ℝ) ≤ n := by exact_mod_cast hk
  constructor
  · dsimp [proportion]; positivity
  · apply (div_le_iff₀ (show (0 : ℝ) < n + 2 by positivity)).mpr
    linarith

theorem prob_unit (n : ℕ) : prob n (Set.Icc 0 1) = 1 := by
  unfold prob
  calc
    _ = ∑ k ∈ range (n + 1), mass n k := by
      apply sum_congr rfl
      intro k hk
      exact if_pos (proportion_mem_unit (Nat.le_of_lt_succ (mem_range.mp hk)))
    _ = 1 := mass_total n

theorem prob_nonneg (n : ℕ) (F : Set ℝ) : 0 ≤ prob n F := by
  apply sum_nonneg
  intro k _
  split_ifs
  · exact mass_nonneg n k
  · exact le_refl 0

theorem prob_le_one (n : ℕ) (F : Set ℝ) : prob n F ≤ 1 := by
  rw [← mass_total n]
  apply sum_le_sum
  intro k _
  split_ifs
  · exact le_refl _
  · exact mass_nonneg n k

theorem atom_le_prob {n k : ℕ} {F : Set ℝ}
    (hk : k ≤ n) (hF : proportion n k ∈ F) : mass n k ≤ prob n F := by
  have hm : k ∈ range (n + 1) := mem_range.mpr (by omega)
  have hs := single_le_sum (fun j (_ : j ∈ range (n+1)) =>
    show 0 ≤ (if proportion n j ∈ F then mass n j else 0) from by
      split_ifs
      · exact mass_nonneg n j
      · exact le_refl 0) hm
  simpa only [if_pos hF] using hs

def rightTail : Set ℝ := Set.Icc (3 / 4) 1
def leftTail : Set ℝ := Set.Icc 0 (1 / 4)

theorem right_atom (n : ℕ) (hn : 2 ≤ n) : proportion n n ∈ rightTail := by
  have hn' : (2 : ℝ) ≤ n := by exact_mod_cast hn
  have hp : (0 : ℝ) < n + 2 := by positivity
  dsimp [proportion, rightTail]
  constructor
  · apply (le_div_iff₀ hp).mpr
    linarith
  · apply (div_le_iff₀ hp).mpr
    linarith

theorem left_atom (n : ℕ) (hn : 2 ≤ n) : proportion n 0 ∈ leftTail := by
  have hn' : (2 : ℝ) ≤ n := by exact_mod_cast hn
  have hp : (0 : ℝ) < n + 2 := by positivity
  dsimp [proportion, leftTail]
  constructor
  · positivity
  · apply (div_le_iff₀ hp).mpr
    norm_num
    linarith

theorem tail_bounds (n : ℕ) (hn : 2 ≤ n) :
    1 / (n + 1 : ℝ) ≤ prob n rightTail ∧
    1 / (n + 1 : ℝ) ≤ prob n leftTail := by
  constructor
  · simpa [mass_formula] using atom_le_prob (le_refl n) (right_atom n hn)
  · simpa [mass_formula] using atom_le_prob (Nat.zero_le n) (left_atom n hn)

theorem log_atom_limit :
    Tendsto (fun n : ℕ => Real.log (1 / (n + 1 : ℝ)) / n) atTop (𝓝 0) := by
  have ha : Tendsto (fun n : ℕ => (n : ℝ) + 1) atTop atTop :=
    by simpa only [Nat.cast_add, Nat.cast_one] using
      (tendsto_add_atTop_iff_nat 1).mpr (tendsto_natCast_atTop_atTop (R := ℝ))
  have ht := (Real.tendsto_pow_log_div_mul_add_atTop 1 (-1) 1 one_ne_zero).comp ha
  have hlog : Tendsto (fun n : ℕ => Real.log ((n : ℝ) + 1) / n) atTop (𝓝 0) := by
    simpa [Function.comp_def] using ht
  simpa [Real.log_div, neg_div] using hlog.neg

theorem log_prob_limit (F : Set ℝ)
    (hF : ∀ᶠ n : ℕ in atTop, 1 / (n + 1 : ℝ) ≤ prob n F) :
    Tendsto (fun n : ℕ => Real.log (prob n F) / n) atTop (𝓝 0) := by
  apply log_atom_limit.squeeze' tendsto_const_nhds
  · filter_upwards [hF] with n hn
    exact div_le_div_of_nonneg_right (Real.log_le_log (by positivity) hn) (Nat.cast_nonneg n)
  · filter_upwards [hF] with n hn
    have hp : 0 < prob n F := lt_of_lt_of_le (by positivity) hn
    have hl : Real.log (prob n F) ≤ 0 := by
      simpa using Real.log_le_log hp (prob_le_one n F)
    exact div_nonpos_of_nonpos_of_nonneg hl (Nat.cast_nonneg n)

theorem right_log_limit :
    Tendsto (fun n : ℕ => Real.log (prob n rightTail) / n) atTop (𝓝 0) := by
  apply log_prob_limit
  filter_upwards [eventually_ge_atTop 2] with n hn
  exact (tail_bounds n hn).1

theorem left_log_limit :
    Tendsto (fun n : ℕ => Real.log (prob n leftTail) / n) atTop (𝓝 0) := by
  apply log_prob_limit
  filter_upwards [eventually_ge_atTop 2] with n hn
  exact (tail_bounds n hn).2

/-- The standard speed-n closed-set LDP upper bound, restricted to closed
sets inside the support with eventually positive probability. Any LDP
with real-valued rate on [0,1] necessarily satisfies this restriction. -/
def ClosedUpperBound (I : ℝ → ℝ) : Prop :=
  ∀ F : Set ℝ, IsClosed F → F.Nonempty → F ⊆ Set.Icc 0 1 →
    (∀ᶠ n : ℕ in atTop, 0 < prob n F) →
      limsup (fun n : ℕ => Real.log (prob n F) / n) atTop ≤ -sInf (I '' F)

theorem no_positive_quadratic (c m : ℝ) (hc : 0 < c) :
    ¬ ClosedUpperBound (fun x => c * (x - m) ^ 2) := by
  intro h
  by_cases hm : m ≤ 1 / 2
  · have hpos : ∀ᶠ n : ℕ in atTop, 0 < prob n rightTail := by
      filter_upwards [eventually_ge_atTop 2] with n hn
      exact lt_of_lt_of_le (by positivity) (tail_bounds n hn).1
    have hne : rightTail.Nonempty := ⟨1, by norm_num [rightTail]⟩
    have hsub : rightTail ⊆ Set.Icc 0 1 := by
      intro x hx
      exact ⟨by dsimp [rightTail] at hx; linarith [hx.1], hx.2⟩
    have hi : c / 16 ≤ sInf ((fun x => c * (x - m) ^ 2) '' rightTail) := by
      apply le_csInf (hne.image _)
      rintro _ ⟨x, hx, rfl⟩
      have hdiff : 1 / 4 ≤ x - m := by
        dsimp [rightTail] at hx
        linarith [hx.1]
      have hsq : (1 : ℝ) / 16 ≤ (x - m) ^ 2 := by nlinarith
      nlinarith [mul_le_mul_of_nonneg_left hsq hc.le]
    have hu := h rightTail isClosed_Icc hne hsub hpos
    rw [right_log_limit.limsup_eq] at hu
    linarith
  · have hpos : ∀ᶠ n : ℕ in atTop, 0 < prob n leftTail := by
      filter_upwards [eventually_ge_atTop 2] with n hn
      exact lt_of_lt_of_le (by positivity) (tail_bounds n hn).2
    have hne : leftTail.Nonempty := ⟨0, by norm_num [leftTail]⟩
    have hsub : leftTail ⊆ Set.Icc 0 1 := by
      intro x hx
      exact ⟨hx.1, by dsimp [leftTail] at hx; linarith [hx.2]⟩
    have hi : c / 16 ≤ sInf ((fun x => c * (x - m) ^ 2) '' leftTail) := by
      apply le_csInf (hne.image _)
      rintro _ ⟨x, hx, rfl⟩
      have hdiff : 1 / 4 ≤ m - x := by
        dsimp [leftTail] at hx
        linarith [hx.2]
      have hsq : (1 : ℝ) / 16 ≤ (x - m) ^ 2 := by nlinarith
      nlinarith [mul_le_mul_of_nonneg_left hsq hc.le]
    have hu := h leftTail isClosed_Icc hne hsub hpos
    rw [left_log_limit.limsup_eq] at hu
    linarith

theorem counterexample : Balanced replacement ∧
    ∀ c m : ℝ, 0 < c → ¬ ClosedUpperBound (fun x => c * (x - m) ^ 2) :=
  ⟨balanced, no_positive_quadratic⟩

#print axioms mass_formula
#print axioms mass_total
#print axioms prob_unit
#print axioms tail_bounds
#print axioms right_log_limit
#print axioms left_log_limit
#print axioms counterexample

end
end Conjecture2114
