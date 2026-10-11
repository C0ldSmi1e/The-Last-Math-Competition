import Mathlib.Geometry.Manifold.Instances.Sphere

noncomputable section

open Metric

namespace TLMC105

/-- A torus-to-sphere homeomorphism would exhibit the circle as a retract of a real
vector space, by removing the image of `(1, 1)` and stereographically projecting. -/
theorem circle_retract_of_torus_sphere_homeomorph
    (e : (Circle × Circle) ≃ₜ Metric.sphere (0 : EuclideanSpace ℝ (Fin 3)) 1) :
    ∃ i : C(Circle, (ℝ ∙ (e (1, 1)).val)ᗮ),
      ∃ r : C((ℝ ∙ (e (1, 1)).val)ᗮ, Circle),
        ∀ z : Circle, r (i z) = z := by
  let south : Circle := ⟨-1, by simp [Submonoid.unitSphere]⟩
  have south_ne_one : south ≠ 1 := by
    intro h
    have hc := congrArg (fun z : Circle => (z : ℂ)) h
    norm_num [south] at hc
  have hn : ‖(e (1, 1)).val‖ = 1 :=
    mem_sphere_zero_iff_norm.mp (e (1, 1)).property
  let p := stereographic hn
  have havoid (z : Circle) : e (z, south) ∈ p.source := by
    change e (z, south) ≠ e (1, 1)
    intro h
    exact south_ne_one (congrArg Prod.snd (e.injective h))
  have hi : Continuous (fun z : Circle => p (e (z, south))) :=
    p.continuousOn.comp_continuous
      (e.continuous.comp (continuous_id.prodMk continuous_const)) havoid
  have hp : Continuous p.symm :=
    continuous_iff_continuousOn_univ.mpr p.continuousOn_symm
  refine ⟨⟨fun z => p (e (z, south)), hi⟩,
    ⟨fun v => (e.symm (p.symm v)).1,
      continuous_fst.comp (e.symm.continuous.comp hp)⟩, ?_⟩
  intro z
  change (e.symm (p.symm (p (e (z, south))))).1 = z
  rw [p.left_inv (havoid z), e.symm_apply_apply]

end TLMC105
