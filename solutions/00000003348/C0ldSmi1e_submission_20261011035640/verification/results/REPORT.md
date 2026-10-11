# Independent engineering verification: conjecture 3348

**PASS** for the frozen Lean submission whose manifest SHA-256 is `5e38bba343cb2bea78ee005d6a52b8a66846455dfe795664639c9cc020b42a5f`.

## Frozen inputs and build

The five selected files were `Counterexample.lean`, `Checks.lean`, `lakefile.toml`, `lake-manifest.json`, and `lean-toolchain`. Their hashes were verified before use and after verification; review copies were also checked for stability. The supplied lock and toolchain were required byte-for-byte. Lean is `leanprover/lean4:v4.19.0`; Mathlib is `c44e0c8ee63ca166450922a373c7409c5d26b00b`. All nine package revisions and tracked bytes were verified against their pinned Git objects. Runtime executables and shared libraries were hashed and checked for stability.

The final review used a fresh output directory with no author compiled artifacts. `lake --no-cache --wfail build` succeeded, and both Lean files were then compiled directly with `-DwarningAsError=true`. All six boundary examples in `Checks.lean` were checked by compilation. These `example` commands do not leave persistent declarations, so the exported module inventory correctly records zero declarations from `Checks`.

## Complete dependency inspection

The module-origin inventory contains **36 owned declarations**, including private/generated proof declarations, and **21,404 reachable declarations**. All **15 named capstones** are present and safe. Each capstone's axiom set is exactly `propext`, `Classical.choice`, and `Quot.sound`. No owned declaration has a forbidden axiom or unsafe dependency. There are no unsafe owned runtime helpers requiring classification.

The exported graph follows types, values including opaque bodies, projection structure names, recursor-rule expressions, and inductive/constructor/mutual-family relationships. The graph was independently traversed in Python to recompute every closure, edge union, axiom set, unsafe set, count, and Lean-collector containment check. That consistency check passed. It is a check of the exported graph, not an independent extraction from Lean.

All **4,074 imported modules** have unique resolved paths and SHA-256 hashes. They comprise 3 review-owned modules (the 2 candidate modules and inspector), 1,272 Lean runtime modules, and 2,799 package modules. Shadowed imports and unexpected own-library modules were rejected. Every package import matched its pre-build cache snapshot and had a pinned tracked source hash.

## Cache provenance and retained initial failure

The first fresh build compiled nine previously missing stock Mathlib modules. The stricter import gate correctly stopped because those files were absent from the pre-build cache snapshot. That run remains unchanged at `/private/tmp/tlmc3348-independent-engineering`; its successful source compilation and declaration audit were retained.

The nine exact pinned stock sources were then built separately in the review-owned stock with `lake --no-cache --wfail`, and each was replayed directly with `-DwarningAsError=true`. Those commands and hashes are in `/private/tmp/tlmc3348-engineering-prep/stock-repair`. A second fresh review, using identical frozen proof source and unchanged verifier, passed here. Its Lake build compiled only the two owned modules. The first and final declaration-audit JSON files are byte-identical.

Of the final 2,799 package imports, 2,790 reuse preexisting supplied cache files and 9 use the separately compiled pinned stock modules. The full Mathlib library was not rebuilt. No author `.olean` was reused.

## Adversarial controls and auxiliary review

The actual inspector accepted its good control and rejected an unrelated-namespace custom axiom, an opaque/transitive axiom, `sorryAx`, native-decision axioms (`Lean.ofReduceBool`, `Lean.trustCompiler`), and unsafe definitions. The admitted proof also failed compilation with warnings treated as errors. Positive graph controls confirm projection, constructor-parent, and recursor-family edges.

The actual Python checker methods rejected unexpected own-library outputs, an owned import shadow, untracked package module source, changed cached bytes, changed copied source, and altered exact pins. Multiline kernel-bypass scanning and comment/string erasure were tested. The secondary graph checker accepted a genuine good graph and rejected three deliberately corrupted graphs. Its first synthetic run exposed the need to permit missing compiler-internal names only on non-enforced unsafe runtime roots; that helper was corrected and the full control suite rerun. The candidate has no such unsafe roots or missing dependencies. All retained fixtures are reviewer operational tests, not submitted mathematical premises.

Both Lean source files and the TOML configuration were read completely. No custom elaborator, macro, initializer, foreign code, kernel-bypass option, source mutation, file/network operation, or custom runtime computation occurs in the submission. The configuration is declarative. No auxiliary numerical computation supports the mathematical result. The Python verifier, Lean inspector, adversarial runner, and supplemental graph checker were fully reviewed; exact changes from the archived generic toolkit and tool hashes are preserved in `/private/tmp/tlmc3348-engineering-prep`.

## Scope and trust boundary

Fresh Lean source compilation supplies kernel checking for the owned proof. The closure inspector checks declaration dependency policy; it does **not** independently kernel-recheck imported declarations. Pinned source identity plus cache-byte identity does not prove that cached bytes were originally built from those sources. The supplied Lean runtime is hashed, not bootstrapped. PATH wrappers are safeguards against common network/Git commands, not OS network isolation. Mathematical fidelity and PDF review are separate reviews.

## Evidence

- `summary.json`: final machine-readable PASS, pins, packages, capstones, controls, and limitations.
- `declaration-audit.json`: full declaration inventory and dependency graph.
- `graph-consistency.json`: separately recomputed graph consistency.
- `import-identities.json`: all resolved import paths and hashes.
- `stock/`: pinned source inventories and pre-build package cache snapshots.
- `runtime-identities.json`: executable/shared-library hashes.
- `receipts/0039.*`: final Lake build; `0040.*` and `0041.*`: direct source replay; `0043.*`: declaration audit.
- `active-source-token-audit.json`: empty forbidden-token findings.
- `runtime-helper-inventory.json`: empty.
- `stock-index-stability.json`: unchanged source stock Git indexes.

Exact invocation:

```
python3 /private/tmp/tlmc3348-engineering-tools/verify.py verify /private/tmp/tlmc3348-review-input /private/tmp/tlmc3348-review-input/frozen.json /private/tmp/tlmc3348-review-stock/mathlib /private/tmp/tlmc310-runtime/lean-4.19.0-darwin_aarch64/bin /private/tmp/tlmc3348-independent-engineering-final /private/tmp/tlmc3348-clean-author-input
```
