# Solution Review — Conjecture 00000001925 (PR 1011)

**Submission:** C0ldSmi1e — `C0ldSmi1e_submission_20261012204919`  
**Reviewer:** independent competition reviewer  
**Date:** 2026-10-12

## Checklist results

- **Eligibility and scope.** The submission uses the correct personal folder for conjecture 00000001925; the conjecture was open, and the pull request changed no conjecture, README, leaderboard, or metadata file.
- **Report and PDF.** The complete official statement of the conjecture, the LaTeX report, and the submitted PDF were read in full. The LaTeX source was independently recompiled with `pdflatex`, which exited successfully and regenerated the PDF; the rendered report matches the submitted PDF.
- **Lean project.** The submission's Lean project was rebuilt from a clean copy of the frozen sources, keeping its own module names, its own `lakefile`, its pinned Mathlib revision `c44e0c8ee63ca166450922a373c7409c5d26b00b` and its toolchain `v4.19.0`. `lake build` completed successfully: no `sorry`, no `native_decide`, no custom `axiom`/`constant`, no `unsafe`, `opaque`, `extern` or `implemented_by` declaration, and no kernel bypass.
- **Axiom audit.** `#print axioms` was run against every declaration exported by the submission's own modules. The transitive axiom set of each audited theorem is contained in {`Classical.choice`, `Quot.sound`, `propext`}; no other axiom — in particular no `sorryAx` — is reachable.
- **Auxiliary code.** The LaTeX source compiled cleanly with `pdflatex` and regenerated the PDF. The submitted auxiliary code was executed and reported success: `verification/tools/check_audit_graph.py`. The offline-review driver `verification/tools/verify.py` passed its preparation step, but its full run needs the author's prepared stock import cache (it stops on a missing generated ProofWidgets bundle); the same properties were independently reproduced by the clean build and axiom audit recorded above.

## Semantic audit

**Conjecture as filed.** The polynomial ergodic averages converge in the L^∞ norm at a polylogarithmic multiple-logarithm rate (a Bernstein-type bound for p-averages). **Formal objects introduced.** A probability space (Ω, μ) with an invertible measurable measure-preserving transformation `rotation`; the degree-two polynomial `squarePolynomial`; the bounded observable with 0 ≤ observable ≤ 1 and `MemLp observable ∞ μ`; the normalised polynomial averages `average N x` and their L^p classes `averageLp N`. **Decisive results.** `average_eq_polynomial_average` (the averages are exactly the conventional normalised polynomial averages), `lp_norm_gap_all` (‖average (2N) − average N‖ ≥ 1/2 for every N > 0), `averages_not_cauchy`, `no_Linfinity_limit` (no g ∈ L^∞ satisfies averageLp → g), and the capstone `counterexample`, which also records `¬ Ergodic rotation μ`. The sequence of polynomial ergodic averages is not even Cauchy in L^∞ and admits no L^∞ limit, so no convergence rate — polylogarithmic or otherwise — can hold for the system exhibited. The submission discloses explicitly that the transformation is non-ergodic and that neither language of the filed conjecture imposes ergodicity, so it refutes the unqualified general convergence assertion as written and makes no claim about an amended ergodic-only version. Read against the filed statement, the definitions formalize precisely the quantities named in the conjecture text, and the decisive theorems are stated over those same definitions with no strengthening, weakening or renaming, so the formalization is a faithful reading of the conjecture. The decisive theorems establish the negation of the filed statement, so the conjecture as filed is refuted rather than a mis-reading of it.

## Disposition

APPROVED — merged as PR 1011.
