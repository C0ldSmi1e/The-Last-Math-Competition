import TorusTopology
import BoundaryBound
import Mathlib.Analysis.SpecialFunctions.Complex.Circle
import Mathlib.Topology.Homotopy.Lifting
import Mathlib.Analysis.Convex.GaugeRescale
import Mathlib.Geometry.Manifold.Instances.Sphere
import Mathlib.Analysis.Convex.Contractible

open Set Function Topology Metric
open scoped RealInnerProductSpace Manifold
noncomputable section
namespace TLMC105

abbrev ExpKernel := {t : ℝ // Circle.exp t = 1}

instance : DiscreteTopology ExpKernel := by
  apply (discreteTopology_iff_locallyInjective (1 : Circle)).2
  have h := isLocalHomeomorph_circleExp.isLocallyInjective.comp_right
    (g := fun x : ExpKernel => (x : ℝ)) continuous_subtype_val Subtype.val_injective
  have heq : (fun x : ExpKernel => Circle.exp x.val) = (fun _ => 1) :=
    funext fun x => x.property
  simpa only [Function.comp_def, heq] using h

def expTrivialization (e : PartialHomeomorph ℝ Circle)
    (he : (Circle.exp : ℝ → Circle) = e) : Trivialization ExpKernel Circle.exp := by
  classical
  let q : Circle → ℝ := fun z => if z ∈ e.target then e.symm z else Complex.arg z
  have hq : ∀ z, Circle.exp (q z) = z := by
    intro z
    dsimp [q]
    split_ifs with hz
    · rw [he]; exact e.right_inv hz
    · exact Circle.exp_arg z
  have hqc : ContinuousOn q e.target := by
    apply e.continuousOn_symm.congr
    intro z hz
    simp [q, hz]
  refine {
    toFun := fun t => (Circle.exp t, ⟨t - q (Circle.exp t), ?_⟩)
    invFun := fun zk => q zk.1 + zk.2.val
    source := Circle.exp ⁻¹' e.target
    target := e.target ×ˢ univ
    map_source' := fun t ht => ⟨ht, mem_univ _⟩
    map_target' := ?_
    left_inv' := ?_
    right_inv' := ?_
    open_source := e.open_target.preimage Circle.exp.continuous
    open_target := e.open_target.prod isOpen_univ
    continuousOn_toFun := ?_
    continuousOn_invFun := ?_
    baseSet := e.target
    open_baseSet := e.open_target
    source_eq := rfl
    target_eq := rfl
    proj_toFun := fun _ _ => rfl }
  · simp [Circle.exp_sub, hq]
  · intro zk hzk
    change Circle.exp (q zk.1 + zk.2.val) ∈ e.target
    simpa only [Circle.exp_add, hq, zk.2.property, mul_one] using hzk.1
  · intro t _
    change q (Circle.exp t) + (t - q (Circle.exp t)) = t
    ring
  · intro zk hzk
    apply Prod.ext
    · simp only [Circle.exp_add, hq, zk.2.property, mul_one]
    · apply Subtype.ext
      change q zk.1 + zk.2.val - q (Circle.exp (q zk.1 + zk.2.val)) = zk.2.val
      simp only [Circle.exp_add, hq, zk.2.property, mul_one]
      ring
  · exact Circle.exp.continuous.continuousOn.prodMk
      (continuousOn_iff_continuous_restrict.mpr
        ((continuousOn_iff_continuous_restrict.mp (continuousOn_id.sub
          (hqc.comp Circle.exp.continuous.continuousOn fun _ hx => hx))).subtype_mk _))
  · exact (hqc.comp continuousOn_fst fun _ hz => hz.1).add
      (continuous_subtype_val.comp continuous_snd).continuousOn

theorem exp_covering : IsCoveringMap Circle.exp := by
  intro z
  obtain ⟨e, he, hEq⟩ := isLocalHomeomorph_circleExp (Complex.arg z)
  apply IsEvenlyCovered.to_isEvenlyCovered_preimage (I := ExpKernel)
  refine ⟨inferInstance, expTrivialization e hEq, ?_⟩
  change z ∈ e.target
  simpa only [← hEq, Circle.exp_arg] using e.map_source he

theorem no_exp_section (f : Circle → ℝ) (hf : Continuous f)
    (hs : ∀ z, Circle.exp (f z) = z) : False := by
  have h : (fun t : ℝ => f (Circle.exp t)) = (fun t => t + f 1) := by
    refine exp_covering.eq_of_comp_eq (hf.comp Circle.exp.continuous)
      (continuous_id.add continuous_const) ?_ 0 ?_
    · ext t
      simp [Circle.exp_add, hs]
    · simp
  have h2 := congr_fun h (2 * Real.pi)
  simp only [Circle.exp_two_pi] at h2
  linarith [Real.pi_pos]

/-- A circle cannot be a retract of any contractible topological space. -/
theorem no_circle_retract {V : Type*} [TopologicalSpace V] [ContractibleSpace V]
    (i : C(Circle, V)) (r : C(V, Circle)) (hri : ∀ z, r (i z) = z) : False := by
  obtain ⟨v, ⟨H⟩⟩ := id_nullhomotopic V
  let G : C(unitInterval × Circle, Circle) :=
    ⟨fun tz => r (H.symm (tz.1, i tz.2)), by fun_prop⟩
  let f0 : C(Circle, ℝ) := ContinuousMap.const _ (Complex.arg (r v))
  have h0 : ∀ z, G (0, z) = Circle.exp (f0 z) := by
    intro z
    change r (H.symm (0, i z)) = Circle.exp (Complex.arg (r v))
    rw [H.symm.apply_zero]
    exact (Circle.exp_arg (r v)).symm
  let L := exp_covering.liftHomotopy G f0 h0
  apply no_exp_section (fun z => L (1, z))
    (L.continuous.comp (continuous_const.prodMk continuous_id))
  intro z
  have hL := congr_fun (exp_covering.liftHomotopy_lifts G f0 h0) (1, z)
  change Circle.exp (L (1, z)) = G (1, z) at hL
  rw [hL]
  change r (H.symm (1, i z)) = z
  rw [H.symm.apply_one]
  exact hri z

/-- The standard topological torus is not homeomorphic to the two-sphere. -/
theorem no_torus_sphere_homeomorph
    (e : (Circle × Circle) ≃ₜ sphere (0 : EuclideanSpace ℝ (Fin 3)) 1) : False := by
  obtain ⟨i, r, hri⟩ := circle_retract_of_torus_sphere_homeomorph e
  exact no_circle_retract i r hri

/-- The torus cannot be homeomorphic to a nonempty contractible space. -/
theorem no_torus_contractible_homeomorph {V : Type*} [TopologicalSpace V]
    [ContractibleSpace V] (e : (Circle × Circle) ≃ₜ V) : False := by
  apply no_circle_retract
    (⟨fun z => e (z, 1), e.continuous.comp (continuous_id.prodMk continuous_const)⟩ :
      C(Circle, V))
    (⟨fun v => (e.symm v).1, continuous_fst.comp e.symm.continuous⟩ : C(V, Circle))
  intro z
  exact congrArg Prod.fst (e.symm_apply_apply (z, 1))

/-- No bounded convex subset of real three-space has a toroidal boundary.
This includes lower-dimensional convex sets; no interior assumption is hidden. -/
theorem no_torus_convex_boundary {K : Set (EuclideanSpace ℝ (Fin 3))}
    (hc : Convex ℝ K) (hb : Bornology.IsBounded K)
    (e : (Circle × Circle) ≃ₜ frontier K) : False := by
  by_cases hne : (interior K).Nonempty
  · obtain ⟨h, _, _, hh⟩ :=
      exists_homeomorph_image_interior_closure_frontier_eq_unitBall hc hne hb
    exact no_torus_sphere_homeomorph
      (e.trans ((h.image (frontier K)).trans (Homeomorph.setCongr hh)))
  · have hempty : interior K = ∅ := Set.not_nonempty_iff_eq_empty.mp hne
    have hfront : frontier K = closure K := by simp [frontier, hempty]
    let e' := e.trans (Homeomorph.setCongr hfront)
    have hnonempty : (closure K).Nonempty := ⟨e' (1, 1), (e' (1, 1)).property⟩
    letI : ContractibleSpace (closure K) := hc.closure.contractibleSpace hnonempty
    exact no_torus_contractible_homeomorph e'

/-- No closed convex subset of real three-space, bounded or unbounded, has a
boundary homeomorphic to the torus. Compactness of the proposed surface supplies
boundedness, and the whole-space case has empty boundary. -/
theorem no_torus_closed_convex_boundary {K : Set (EuclideanSpace ℝ (Fin 3))}
    (hclosed : IsClosed K) (hc : Convex ℝ K)
    (e : (Circle × Circle) ≃ₜ frontier K) : False := by
  have hproper : K ≠ univ := by
    intro hK
    have hp := (e (1, 1)).property
    simp only [hK, frontier_univ, Set.mem_empty_iff_false] at hp
  have hcompact : IsCompact (frontier K) :=
    isCompact_iff_compactSpace.mpr e.compactSpace
  exact no_torus_convex_boundary hc
    (bounded_of_convex_compact_frontier hclosed hc hproper hcompact) e

/-- In particular, no finite convex hull realizes the standard genus-one surface. -/
theorem no_torus_polytope_boundary
    (vertices : Finset (EuclideanSpace ℝ (Fin 3))) :
    ¬ Nonempty ((Circle × Circle) ≃ₜ frontier (convexHull ℝ (vertices : Set (EuclideanSpace ℝ (Fin 3))))) := by
  rintro ⟨e⟩
  exact no_torus_convex_boundary (convex_convexHull ℝ _)
    vertices.finite_toSet.isCompact_convexHull.isBounded e

/-- A genus-one surface is, by the standard topological model, a space homeomorphic
to the torus. The predicate does not assume any fact about convex realization. -/
def HasGenusOne (S : Type*) [TopologicalSpace S] : Prop :=
  Nonempty (S ≃ₜ (Circle × Circle))

/-- Genuine convex-polytope realization: a homeomorphism onto the frontier of a
finite convex hull in real three-space. Vertex/edge restrictions can only narrow it. -/
def HasConvexPolyhedralRealization (S : Type*) [TopologicalSpace S] : Prop :=
  ∃ vertices : Finset (EuclideanSpace ℝ (Fin 3)),
    Nonempty (S ≃ₜ frontier (convexHull ℝ (vertices : Set (EuclideanSpace ℝ (Fin 3)))))

theorem torus_has_genus_one : HasGenusOne (Circle × Circle) :=
  ⟨Homeomorph.refl _⟩

/-- No surface of genus one has a convex-polyhedral realization. -/
theorem genus_one_not_convex_polyhedral {S : Type*} [TopologicalSpace S]
    (hg : HasGenusOne S) : ¬ HasConvexPolyhedralRealization S := by
  rintro ⟨vertices, ⟨e⟩⟩
  obtain ⟨g⟩ := hg
  exact no_torus_polytope_boundary vertices ⟨g.symm.trans e⟩


/-- The usual torus has the topological properties of a closed connected surface.
Its product charts are modeled on two one-dimensional real Euclidean spaces. -/
theorem torus_closed_surface_properties :
    CompactSpace (Circle × Circle) ∧ T2Space (Circle × Circle) ∧
      SecondCountableTopology (Circle × Circle) ∧ PathConnectedSpace (Circle × Circle) ∧
      IsManifold ((𝓡 1).prod (𝓡 1)) ω (Circle × Circle) := by
  letI : PathConnectedSpace Circle := Function.Surjective.pathConnectedSpace
    (fun z => ⟨Complex.arg z, Circle.exp_arg z⟩) Circle.exp.continuous
  letI : PathConnectedSpace (Circle × Circle) :=
    ⟨⟨(1, 1)⟩, fun x y => ⟨(PathConnectedSpace.somePath x.1 y.1).prod
      (PathConnectedSpace.somePath x.2 y.2)⟩⟩
  exact ⟨inferInstance, inferInstance, inferInstance, inferInstance, inferInstance⟩

/-- The real dimension of the torus chart model is two. -/
theorem torus_chart_dimension :
    Module.finrank ℝ (EuclideanSpace ℝ (Fin 1) × EuclideanSpace ℝ (Fin 1)) = 2 := by
  simp

/-- The explicit counterexample to conjecture 00000000105. -/
theorem conjecture_00000000105_counterexample :
    HasGenusOne (Circle × Circle) ∧
      ¬ HasConvexPolyhedralRealization (Circle × Circle) :=
  ⟨torus_has_genus_one, genus_one_not_convex_polyhedral torus_has_genus_one⟩

end TLMC105
