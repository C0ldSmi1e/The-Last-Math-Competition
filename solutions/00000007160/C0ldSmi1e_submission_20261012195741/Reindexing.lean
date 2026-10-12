import Mathlib.Algebra.Polynomial.Roots
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Fintype.EquivFin
import Mathlib.Logic.Equiv.Basic

open scoped BigOperators
open Finset Polynomial

namespace HoffmanWielandt

theorem exists_perm_of_prod_X_sub_C_eq {n : Type*} [Fintype n] [DecidableEq n]
    (f g : n → ℂ)
    (h : (∏ i, (X - C (f i))) = ∏ i, (X - C (g i))) :
    ∃ e : Equiv.Perm n, ∀ i, f i = g (e i) := by
  classical
  have hroots (a : n → ℂ) :
      (∏ i, (X - C (a i))).roots = (univ : Finset n).val.map a := by
    simpa only [Finset.prod_eq_multiset_prod, Multiset.map_map, Function.comp_apply] using
      roots_multiset_prod_X_sub_C ((univ : Finset n).val.map a)
  have hm : (univ : Finset n).val.map f = (univ : Finset n).val.map g := by
    rw [← hroots f, ← hroots g, h]
  have hc (c : ℂ) : Fintype.card {i // f i = c} = Fintype.card {i // g i = c} := by
    have hc' := congrArg (Multiset.count c) hm
    simpa [Multiset.count_map, ← Finset.filter_val, Fintype.card_subtype, eq_comm] using hc'
  let e (c : ℂ) : {i // f i = c} ≃ {i // g i = c} := Fintype.equivOfCardEq (hc c)
  exact ⟨Equiv.ofFiberEquiv e, fun i => (Equiv.ofFiberEquiv_map e i).symm⟩

end HoffmanWielandt
