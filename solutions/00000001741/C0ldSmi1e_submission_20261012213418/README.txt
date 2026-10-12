Conjecture 00000001741: disproof of the stated upward optimality

Result and scope
The literal conjunction says I(1/4) and that no larger logarithmic exponent admits infinitely many pairs. Lean proves I(a) -> I(b) for a <= b, using finite bounded-x fibers and eventual monotonicity of real powers. Taking b=1 contradicts the conjunction. The final theorem is HallReverse.conjecture_false with no hypotheses.

This does not decide I(1/4) by itself, Hall's conjecture, or an optimality claim involving decreased exponents. The exact bilingual source is conjecture.md. The matching complete proof is report.tex/report.pdf. Mathlib's boundary conventions are explicit in the report; the actual conjecture uses positive coordinates and positive exponents.

Standard reproduction
Install Lean through the pinned lean/lean-toolchain. From lean/ run:
  lake exe cache get
  lake --wfail build
  lake env lean -DwarningAsError=true HallReverse.lean
  lake env lean -DwarningAsError=true Verification.lean
Both HallReverse and Verification are default targets. The manifest pins Mathlib v4.19.0 and all nine package revisions. Seven principal theorems print only propext, Classical.choice, and Quot.sound. Verification.lean contains 13 checked boundary/definition/scope examples. No auxiliary numerical computation is required.

Contributor checks
See VERIFICATION.md for fresh build, replay, closure, identity, negative-control, semantic-review and PDF evidence. These are local checks and separate AI-agent reviews, not competition-maintainer acceptance. Only this personal submission folder is added.

Optional author-local runner
lean/verify.py was independently executed in a fresh copy. It expects --runtime-root pointing to the original local runtime layout: lean-4.19.0-darwin_aarch64/bin/lean and stock1925/ containing the generic pinned Mathlib tree. The stock1925 name is a local cache label; no previous candidate source is imported. This optional runner is not required for the portable Lake commands above, and it does not itself authenticate stock caches.

Hashes
SHA256SUMS.json covers every packaged file except itself. Evidence archive entries are independently listed and hashed in verification/engineering-evidence-manifest.json. Archive paths, receipts, and contributor reviews record original local validation paths; they are historical provenance, not paths that a reviewer must reproduce verbatim.
