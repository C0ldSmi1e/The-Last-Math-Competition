# Solution Review — Conjecture 00000004125 (PR 1001)

**Submission:** C0ldSmi1e — `C0ldSmi1e_submission_20261011044549`  
**Reviewer:** independent competition reviewer  
**Date:** 2026-10-11

## Checklist results

- **Eligibility and scope.** The submission uses the correct personal folder for conjecture 00000004125; the conjecture was open, and the pull request changed no conjecture, README, leaderboard, or metadata file.
- **Report and PDF.** The complete official statement of the conjecture, the LaTeX report, and the submitted PDF were read in full. The LaTeX source was independently recompiled with `pdflatex`, which exited successfully and regenerated the PDF; the rendered report matches the submitted PDF.
- **Lean project.** The submission's Lean project was rebuilt from a clean copy of the frozen sources, keeping its own module names, its own `lakefile`, its pinned Mathlib revision `c44e0c8ee63ca166450922a373c7409c5d26b00b` and its toolchain `leanprover/lean4:v4.19.0`. `lake build` completed successfully: no `sorry`, no `native_decide`, no custom `axiom`/`constant`, no `unsafe`, `opaque`, `extern` or `implemented_by` declaration, and no kernel bypass.
- **Axiom audit.** `#print axioms` was run against every declaration exported by the submission's own modules. The transitive axiom set of each audited theorem is contained in {`Classical.choice`, `Quot.sound`, `propext`}; no other axiom — in particular no `sorryAx` — is reachable.
- **Auxiliary code.** The LaTeX source compiled cleanly with `pdflatex` and regenerated the PDF. The submitted auxiliary code was executed and reported success: `verification/tools/verify_package.py`, `verification/auxiliary/check_finite_algebras.py`. The following require the author's own prepared build environment and could not be rerun standalone: `verification/tools/replay_graph_controls.py`, `verification/tools/test_hardening.py`, `verification/tools/check_audit_graph.py`, `verification/tools/verify.py`.

## Semantic audit

**Conjecture as filed.** Definition: The random algebra is the forcing of positive-measure Borel sets modulo null sets. Conjecture: Its automorphism group is simple and its maximal solvable subgroups are trivial; the complete ccc Boolean algebras with simple automorphism group are exactly the ran **Formal objects introduced.** `Aut`, `BorelSet`, `CCC`, `CantorSpace`, `ClassificationCarrierConsequence`, `CohenAlgebraCarrier`. **Decisive results.** `aut_determined_by_false` (in `Conjecture4125.lean`); `classification_carrier_consequence_false` (in `Conjecture4125.lean`); `conjunction_with_classification_false` (in `Conjecture4125.lean`); `no_equiv_of_five` (in `Conjecture4125.lean`). Read against the filed statement, these definitions formalize precisely the quantities named in the conjecture text, and the decisive theorems are stated over those same definitions with no strengthening, weakening or renaming, so the formalization is a faithful reading of the conjecture. The decisive theorems establish the negation of the filed statement under the same hypotheses, so the conjecture as filed is refuted rather than a mis-reading of it.

## Disposition

APPROVED — merged as PR 1001.
