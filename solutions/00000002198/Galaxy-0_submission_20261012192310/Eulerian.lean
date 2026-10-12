import Std

namespace TLMC2198

/-- Second-order Eulerian triangle, with zero-based columns. -/
def euler2 : Nat → Nat → Nat
  | 0, 0 => 1
  | 0, _ + 1 => 0
  | _ + 1, 0 => 1
  | n + 1, k + 1 => (k + 2) * euler2 n (k + 1) + (2 * n - k) * euler2 n k

theorem euler2_first (n : Nat) : euler2 n 0 = 1 := by
  cases n <;> rfl

theorem euler2_outside (n k : Nat) (hn : 0 < n) (hk : n ≤ k) : euler2 n k = 0 := by
  induction n generalizing k with
  | zero => omega
  | succ n ih =>
    cases k with
    | zero => omega
    | succ k =>
      cases n with
      | zero => simp [euler2]
      | succ n =>
        have h1 := ih (k + 1) (by omega) (by omega)
        have h2 := ih k (by omega) (by omega)
        change (k + 2) * euler2 (n + 1) (k + 1) + (2 * (n + 1) - k) * euler2 (n + 1) k = 0
        rw [h1, h2]
        omega

/-- The ninth row has no positive noninitial entry below 1004. -/
theorem euler2_nine_lower (k : Nat) (hk : 0 < k) (hb : k < 9) :
    1004 ≤ euler2 9 k := by
  have hk' : k = 1 ∨ k = 2 ∨ k = 3 ∨ k = 4 ∨ k = 5 ∨ k = 6 ∨ k = 7 ∨ k = 8 := by omega
  rcases hk' with h | h | h | h | h | h | h | h <;> subst k <;> decide

/-- The recurrence preserves the lower bound on every noninitial in-range entry. -/
theorem euler2_large (n k : Nat) (hn : 9 ≤ n) (hk : 0 < k) (hb : k < n) :
    1004 ≤ euler2 n k := by
  induction n using Nat.strongRecOn generalizing k with
  | ind n ih =>
    by_cases h9 : n = 9
    · subst n; exact euler2_nine_lower k hk hb
    · have hn10 : 10 ≤ n := by omega
      obtain ⟨m, rfl⟩ : ∃ m, n = m + 1 := ⟨n - 1, by omega⟩
      obtain ⟨j, rfl⟩ : ∃ j, k = j + 1 := ⟨k - 1, by omega⟩
      by_cases hj : j + 1 < m
      · have lower := ih m (by omega) (j + 1) (by omega) (by omega) hj
        have mulLower : euler2 m (j + 1) ≤ (j + 2) * euler2 m (j + 1) :=
          Nat.le_mul_of_pos_left _ (by omega)
        simp only [euler2]
        omega
      · have heq : j + 1 = m := by omega
        have hjpos : 0 < j := by omega
        have lower := ih m (by omega) j (by omega) hjpos (by omega)
        have multpos : 0 < 2 * m - j := by omega
        have mulLower : euler2 m j ≤ (2 * m - j) * euler2 m j :=
          Nat.le_mul_of_pos_left _ multpos
        simp only [euler2]
        omega

/-- All remaining indices lie in a finite 9 by 9 table. -/
theorem euler2_small_exclusions :
    ∀ n : Fin 9, ∀ k : Fin 9,
      euler2 n.val k.val ≠ 190 ∧ euler2 n.val k.val ≠ 4 ∧ euler2 n.val k.val ≠ 856 := by
  decide

/-- None of these actual weak-order antichain counts occurs anywhere in the triangle. -/
theorem euler2_exclusions (n k : Nat) :
    euler2 n k ≠ 190 ∧ euler2 n k ≠ 4 ∧ euler2 n k ≠ 856 := by
  by_cases hn : n < 9
  · by_cases hk : k < 9
    · exact euler2_small_exclusions ⟨n, hn⟩ ⟨k, hk⟩
    · cases n with
      | zero => cases k <;> simp_all [euler2]
      | succ n => have hz := euler2_outside (n + 1) k (by omega) (by omega); omega
  · by_cases hk0 : k = 0
    · subst k; simp [euler2_first]
    · by_cases hk : k < n
      · have hl := euler2_large n k (by omega) (by omega) hk; omega
      · have hz := euler2_outside n k (by omega) (by omega); omega

/-- Full row sum, including the zero outside entry in nonzero rows. -/
def euler2RowSum (n : Nat) : Nat := ((List.range (n + 1)).map (euler2 n)).sum

private theorem member_le_nat_sum {x : Nat} {xs : List Nat} (h : x ∈ xs) : x ≤ xs.sum := by
  induction xs with
  | nil => simp at h
  | cons a xs ih =>
    simp only [List.mem_cons] at h
    simp only [List.sum_cons]
    rcases h with rfl | h
    · omega
    · have hl := ih h; omega

theorem euler2_row_sum_exclusions (n : Nat) :
    euler2RowSum n ≠ 190 ∧ euler2RowSum n ≠ 4 ∧ euler2RowSum n ≠ 856 := by
  by_cases hn : n < 9
  · have small : ∀ m : Fin 9,
        euler2RowSum m.val ≠ 190 ∧ euler2RowSum m.val ≠ 4 ∧ euler2RowSum m.val ≠ 856 := by decide
    exact small ⟨n, hn⟩
  · have hl := euler2_large n 1 (by omega) (by omega) (by omega)
    have hm : euler2 n 1 ∈ (List.range (n + 1)).map (euler2 n) := by
      apply List.mem_map.mpr
      exact ⟨1, List.mem_range.mpr (by omega), rfl⟩
    have hs := member_le_nat_sum hm
    change euler2RowSum n ≠ 190 ∧ euler2RowSum n ≠ 4 ∧ euler2RowSum n ≠ 856
    unfold euler2RowSum
    omega

#print axioms euler2_exclusions
#print axioms euler2_row_sum_exclusions
end TLMC2198
