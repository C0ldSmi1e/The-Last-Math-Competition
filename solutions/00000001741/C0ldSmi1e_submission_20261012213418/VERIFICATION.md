# Local verification of conjecture 00000001741

The frozen mathematical source is `lean/HallReverse.lean` (SHA-256 `cd4886721c5149d8ab3497feee968ec58df1ad5cfefc820b10a9074071710633`) and `lean/Verification.lean` (`0a8f742c33f543b54e13f1b6f2d10458b7fe267ce042b60ac4a5fc674669f6c9`). `verification/frozen-v1.json` is relative to `lean/` and includes the exact configuration, pins and author provenance. Neither mathematical module changed after its independent review.

## Checks actually performed

A fresh private project used pinned Lean 4.19.0, all nine exact dependency revisions, and the supplied generic dependency caches. `lake --no-cache --wfail build`, strict checking of the Lake configuration, and direct `lean -DwarningAsError=true` replay of both mathematical modules all passed. Both modules are default Lake targets. The 13 `example` declarations in Verification are kernel-checked during compilation but do not persist as exported declarations.

The declaration audit inventories 17 exported declarations and 13,883 dependency-closure nodes, following types, bodies, recursor and inductive dependencies. All 15 safe declarations, including the final theorem, have no unsafe dependencies and use only the permitted foundational axioms `propext`, `Classical.choice`, and `Quot.sound` (or a subset). Seven explicit theorem axiom prints match these three axioms. An independent Python traversal checks the exported graph's internal closure and trust summaries.

Two compiler-generated implementation declarations, `HallReverse.gap._cstage1` and `HallReverse.gap._cstage2`, are classified separately. Recompiling the exact safe gap definition in a new diagnostic module reproduced their types, direct dependency edges and printed bodies. Neither helper occurs in any safe owned declaration's closure. Their runtime findings remain in the evidence; they are not proof evidence or a blanket exemption for unsafe code.

The run bound 4,057 imported module identities to actual resolved paths. All generic pinned source bytes were checked against their Git objects, cache bytes were recorded before the build and compared on resolution, and the supplied runtime identities remained stable. The stock contains 2,902 Mathlib oleans and 3,149 package oleans in total; 1,272 runtime imports are separately recorded.

Fresh controls accepted a harmless definition/theorem/structure and rejected a custom axiom, an indirect axiom dependency, an admitted proof, native evaluation, and an unsafe declaration. Adversarial driver tests rejected unexpected owned modules, ambiguous import shadowing, untracked package source, changed caches, changed frozen source, changed pins, and multiline kernel-bypass options. These intentional bad fixtures are auditing controls in the archived evidence, not members of the submitted proof library.

The author's optional verifier was independently run in a fresh private source copy. All included auxiliary verification code was exercised; there is no separate numerical computation on which the mathematics depends. The final engineering review rechecked 80 command receipts. The parent reviewer rehashed all 413 compact engineering evidence files and the receipts, checked final source identity and safe-root axioms, and independently compared the compiler-helper reproduction.

One extra initial preparation assertion incorrectly required every package's cache to be nonempty. The Cli package cache was empty. That failed preflight is retained; the unnecessary assertion was removed before the fresh full build. All actual required imports subsequently passed without downloading or restoring dependencies.

Separate AI agents authored the mathematics from the exact original and generic Mathlib APIs and reviewed the complete frozen source and report. The report's initial wording about real powers at unused boundary values was corrected to state Mathlib's total conventions explicitly; no Lean source changed. The final report compiled in the desktop LaTeX editor and was exported with Tectonic. The parent reviewer inspected all three final rendered pages. These are contributor validations, not maintainer acceptance.

## Evidence and reproduction

Top-level review summaries are in `verification/`. The compressed raw archive contains all 413 paths in `verification/engineering-evidence-manifest.json`, including complete audit graphs, source/import/cache inventories, exact commands and stdout/stderr, diagnostic source, controls, operational drivers, and original failure records. It excludes runtime/dependency caches and compiled products. Extract it in a fresh temporary directory to inspect `engineering/full-v1/receipts/`, `engineering/full-v1/declaration-audit.json`, and the helper and control records.

The reusable verification tools are also available directly in `verification/tools/`. With the same pinned stock and Lean runtime available, invoke:

```
python3 verification/tools/verify.py verify lean verification/frozen-v1.json STOCK LEAN_BIN NEW_OUTPUT verification/expected-pins
python3 verification/tools/check_audit_graph.py NEW_OUTPUT/declaration-audit.json
python3 verification/tools/test_hardening.py NEW_HARDENING_OUTPUT
```

Both output paths must not exist. The full cached-stock verifier uses macOS `cp -cR`; the standard Lake build in README.txt is portable. Any `PASS_PENDING_RUNTIME_HELPER_CLASSIFICATION` result still requires the specific helper review described above; it is not silently treated as unconditional approval.

## Trust limits

The source compiler supplies Lean kernel checking; the inspector and Python checker audit exported dependency information and do not implement a second kernel. The full Mathlib library and the official Lean executable were not rebuilt or bootstrapped. Supplied cache bytes are recorded and source-bound, not independently authenticated. Offline PATH wrappers are safeguards, not OS network isolation. Current public upstream metadata was checked for eligibility; no claim is made to know every fork or unpublished work.
