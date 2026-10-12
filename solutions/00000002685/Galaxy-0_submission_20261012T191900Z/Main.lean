import Std
import Init.Data.Rat.Lemmas

/-! A genuine rational affine-plane counterexample to TLMC 2685.
Polynomial expressions are finite expressions built from rational constants,
two variables, addition and multiplication. They represent all polynomials in
Q[X,Y]; duplicate syntactic representatives do not affect common zero sets.
No closure oracle, dynamical assumption or additional axiom is used. -/
namespace TLMC2685
abbrev Point := Rat × Rat
inductive Poly where
  | c : Rat → Poly
  | x : Poly
  | y : Poly
  | add : Poly → Poly → Poly
  | mul : Poly → Poly → Poly

def Poly.eval : Poly → Point → Rat
  | .c a, _ => a
  | .x, p => p.1
  | .y, p => p.2
  | .add f g, p => f.eval p + g.eval p
  | .mul f g, p => f.eval p * g.eval p

def Poly.dx : Poly → Poly
  | .c _ => .c 0
  | .x => .c 1
  | .y => .c 0
  | .add f g => .add f.dx g.dx
  | .mul f g => .add (.mul f.dx g) (.mul f g.dx)

def Poly.dy : Poly → Poly
  | .c _ => .c 0
  | .x => .c 0
  | .y => .c 1
  | .add f g => .add f.dy g.dy
  | .mul f g => .add (.mul f.dy g) (.mul f g.dy)

abbrev Locus := Point → Prop
/-- The intersection of all polynomial zero loci containing S. -/
def zariskiClosure (S : Locus) : Locus :=
  fun p => ∀ f : Poly, (∀ q, S q → f.eval q = 0) → f.eval p = 0

def Dense (S : Locus) : Prop := ∀ p, zariskiClosure S p

def fx : Poly := .add .x (.c 1)
def fy : Poly := .y
def F (p : Point) : Point := (fx.eval p, fy.eval p)
def iterate : Nat → Point → Point
  | 0, p => p
  | n + 1, p => F (iterate n p)
def orbit (p : Point) : Locus := fun q => ∃ n : Nat, iterate n p = q
/-- Eventual repetition, the usual preperiodicity for one generator. -/
def Preperiodic (p : Point) : Prop :=
  ∃ m n : Nat, m < n ∧ iterate m p = iterate n p

def origin : Point := (0, 0)

theorem iterate_formula (n : Nat) (p : Point) :
    iterate n p = (p.1 + (n : Rat), p.2) := by
  induction n with
  | zero => simp [iterate, Rat.add_zero]
  | succ n ih =>
    simp [iterate, ih, F, fx, fy, Poly.eval, Rat.natCast_add, Rat.add_assoc]

/-- The iterates form the one-generator transformation monoid. -/
theorem iterate_add (m n : Nat) (p : Point) :
    iterate (m + n) p = iterate m (iterate n p) := by
  simp only [iterate_formula, Rat.natCast_add]
  simp only [Rat.add_assoc, Rat.add_comm (n : Rat) (m : Rat)]

/-- Every iterate is itself given by two polynomial coordinate expressions. -/
theorem iterate_polynomial (n : Nat) (p : Point) :
    iterate n p = ((Poly.add .x (.c (n : Rat))).eval p, Poly.y.eval p) := by
  exact iterate_formula n p

theorem iterate_injective_time (p : Point) {m n : Nat}
    (h : iterate m p = iterate n p) : m = n := by
  rw [iterate_formula, iterate_formula] at h
  have he := Rat.add_left_cancel p.1 (congrArg Prod.fst h)
  have hn := congrArg Rat.num he
  have hi : (m : Int) = (n : Int) := by simpa using hn
  omega

theorem no_preperiodic (p : Point) : ¬ Preperiodic p := by
  intro ⟨m, n, hlt, heq⟩
  have h := iterate_injective_time p heq
  omega

theorem subset_closure (S : Locus) {p : Point} (h : S p) :
    zariskiClosure S p := by
  intro f hf
  exact hf p h

theorem origin_in_closure : zariskiClosure (orbit origin) origin :=
  subset_closure _ ⟨0, rfl⟩

theorem orbit_on_line (q : Point) (h : orbit origin q) : q.2 = 0 := by
  obtain ⟨n, rfl⟩ := h
  simp [iterate_formula, origin]

theorem closure_on_line (q : Point) (h : zariskiClosure (orbit origin) q) :
    q.2 = 0 := h .y (fun r hr => orbit_on_line r hr)

theorem not_dense : ¬ Dense (orbit origin) := by
  intro h
  have hf : (1 : Rat) = 0 := closure_on_line (0, 1) (h (0, 1))
  contradiction

theorem closure_not_dense : ¬ Dense (zariskiClosure (orbit origin)) := by
  intro h
  have hz : (1 : Rat) = 0 := h (0, 1) .y (fun q hq => closure_on_line q hq)
  contradiction

theorem closure_not_preperiodic_set :
    ¬ (∀ q, zariskiClosure (orbit origin) q ↔ Preperiodic q) := by
  intro h
  exact no_preperiodic origin ((h origin).mp origin_in_closure)

/-- Also refutes the weaker interpretation 'the closure consists of
preperiodic points', not merely equality with the full preperiodic set. -/
theorem closure_not_contained_preperiodic :
    ¬ (∀ q, zariskiClosure (orbit origin) q → Preperiodic q) := by
  intro h
  exact no_preperiodic origin (h origin origin_in_closure)

/-- Determinant of the actual formal Jacobian of the polynomial map. -/
def jacobian (p : Point) : Rat :=
  fx.dx.eval p * fy.dy.eval p - fx.dy.eval p * fy.dx.eval p

theorem jacobian_one (p : Point) : jacobian p = 1 := by
  simp [jacobian, fx, fy, Poly.dx, Poly.dy, Poly.eval,
    Rat.add_zero, Rat.mul_one, Rat.mul_zero]
  rw [Rat.sub_eq_add_neg, Rat.neg_zero, Rat.add_zero]

/-- Jacobian of the polynomial coordinate formulas for the n-th iterate. -/
def iterateJacobian (n : Nat) (p : Point) : Rat :=
  let a : Poly := .add .x (.c (n : Rat))
  a.dx.eval p * fy.dy.eval p - a.dy.eval p * fy.dx.eval p

theorem iterateJacobian_one (n : Nat) (p : Point) : iterateJacobian n p = 1 := by
  simp [iterateJacobian, fy, Poly.dx, Poly.dy, Poly.eval,
    Rat.add_zero, Rat.mul_one, Rat.mul_zero]
  rw [Rat.sub_eq_add_neg, Rat.neg_zero, Rat.add_zero]

/-- Products may involve arbitrary iterates, evaluated at arbitrary points;
this includes every pullback choice along an orbit. -/
def determinantProduct : List (Nat × Point) → Rat
  | [] => 1
  | (n, p) :: xs => iterateJacobian n p * determinantProduct xs

theorem determinantProduct_one (xs : List (Nat × Point)) :
    determinantProduct xs = 1 := by
  induction xs with
  | nil => rfl
  | cons a xs ih => simp [determinantProduct, iterateJacobian_one, ih, Rat.mul_one]

theorem arbitrary_determinant_products_nonzero (xs : List (Nat × Point)) :
    determinantProduct xs ≠ 0 := by
  rw [determinantProduct_one]
  decide

/-- Includes every finite multiplicative product of this determinant.
The empty product is 1; every nonempty product also evaluates to 1. -/
def jacobianProduct : Nat → Point → Rat
  | 0, _ => 1
  | n + 1, p => jacobian p * jacobianProduct n p

theorem jacobianProduct_one (n : Nat) (p : Point) :
    jacobianProduct n p = 1 := by
  induction n with
  | zero => rfl
  | succ n ih => simp [jacobianProduct, jacobian_one, ih, Rat.mul_one]

theorem multiplicative_zero_set_empty :
    ¬ (∃ p : Point, ∃ n : Nat, jacobianProduct n p = 0) := by
  intro ⟨p, n, h⟩
  rw [jacobianProduct_one] at h
  contradiction

/-- Main counterexample: even with empty multiplicative Jacobian zero set,
neither alternative of the claimed orbit-closure dichotomy holds. -/
theorem counterexample :
    (¬ (∃ p : Point, ∃ n : Nat, jacobianProduct n p = 0)) ∧
    ¬ ((∀ q, zariskiClosure (orbit origin) q ↔ Preperiodic q) ∨
       Dense (zariskiClosure (orbit origin))) := by
  exact ⟨multiplicative_zero_set_empty, fun h => h.elim
    closure_not_preperiodic_set closure_not_dense⟩

#print axioms TLMC2685.counterexample
#print axioms TLMC2685.closure_not_contained_preperiodic
end TLMC2685
