# Solution Review — Conjecture 00000007160 (PR 1010)

**Submission:** C0ldSmi1e — `C0ldSmi1e_submission_20261012195741`  
**Reviewer:** independent competition reviewer  
**Date:** 2026-10-12

## Checklist results

- **Eligibility and scope.** The submission uses the correct personal folder for conjecture 00000007160; the conjecture was open, and the pull request changed no conjecture, README, leaderboard, or metadata file.
- **Report and PDF.** The complete official statement of the conjecture, the LaTeX report, and the submitted PDF were read in full. The LaTeX source was independently recompiled with `pdflatex`, which exited successfully and regenerated the PDF; the rendered report matches the submitted PDF.
- **Lean project.** The submission's Lean project was rebuilt from a clean copy of the frozen sources, keeping its own module names, its own `lakefile`, its pinned Mathlib revision `c44e0c8ee63ca166450922a373c7409c5d26b00b` and its toolchain `v4.19.0`. `lake build` completed successfully: no `sorry`, no `native_decide`, no custom `axiom`/`constant`, no `unsafe`, `opaque`, `extern` or `implemented_by` declaration, and no kernel bypass.
- **Axiom audit.** `#print axioms` was run against every declaration exported by the submission's own modules. The transitive axiom set of each audited theorem is contained in {`Classical.choice`, `Quot.sound`, `propext`}; no other axiom — in particular no `sorryAx` — is reachable.
- **Auxiliary code.** The LaTeX source compiled cleanly with `pdflatex` and regenerated the PDF. The submitted auxiliary code was executed and reported success: `independent-review/independent_auxiliary_probes.py`, `verification/tools/test_hardening.py`, `verification/tools/check_audit_graph.py`, `auxiliary/check_examples.py`. The offline-review driver `verification/tools/verify.py` passed its preparation step, but its full run needs the author's prepared stock import cache (it stops on a missing generated ProofWidgets bundle); the same properties were independently reproduced by the clean build and axiom audit recorded above.

## Semantic audit

**Conjecture as filed.** The spectra of normal matrices are Lipschitz with the Frobenius norm as constant (Hoffman–Wielandt). **Formal objects introduced.** The complete eigenvalue list `IsEigenvalueList` (characteristic-polynomial factorisation, retaining multiplicity) and `frobeniusSq` / `frobeniusNorm`; the orthonormal-eigenbasis bridge `normal_exists_eigenbasis`; the doubly-stochastic overlap matrix with the optimal-matching lemma `exists_perm_cost_le`; and the multiplicity bridge `exists_perm_of_prod_X_sub_C_eq`. **Decisive results.** `eigenbasis_matching_sq`, `normal_matrices_hoffman_wielandt_sq`, `normal_matrices_hoffman_wielandt`, `hoffman_wielandt_sq`, `hoffman_wielandt`, and the public capstone `HoffmanWielandtVerification.full_statement`: for arbitrary complex normal matrices A, B of any size there exist complete eigenvalue lists λ, μ and a permutation σ with √(Σ‖λᵢ − μ_σ(i)‖²) ≤ √(Σᵢⱼ‖Aᵢⱼ − Bᵢⱼ‖²). Read against the filed statement, the definitions formalize precisely the quantities named in the conjecture text, and the decisive theorems are stated over those same definitions with no strengthening, weakening or renaming, so the formalization is a faithful reading of the conjecture. The decisive theorems establish the conjecture exactly as filed — no commutation between A and B is assumed, the dimension-zero case is covered, and repeated eigenvalues are handled with multiplicity — so the filed statement is proved.

## Disposition

APPROVED — merged as PR 1010.
