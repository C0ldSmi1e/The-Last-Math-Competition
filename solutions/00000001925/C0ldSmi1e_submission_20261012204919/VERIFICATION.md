# Local verification of conjecture 00000001925

This submission supplies an explicit counterexample to the conventional, unqualified reading of the bilingual conjecture. The transformation is **nonergodic**, as formally proved and disclosed in the report. The result makes no claim about an amended ergodic-only statement or another specialized definition of p-averages. Local verification is not maintainer acceptance.

## Build and mathematical coverage

Use Lean 4.19.0 and the exact nine dependency revisions in `lake-manifest.json`. From this personal submission directory, run:

```sh
lake build
```

The single default library target imports all six proof/test modules. Its configuration treats warnings as errors. `Conjecture1925.counterexample` bundles the fixed probability space, invertible measurable transformation and inverse, measure preservation, bounded observable, degree-two polynomial and conventional average identity, the norm gap for every positive length, no Cauchy property, no possible L-infinity limit, and explicit nonergodicity.

The proof uses Mathlib's actual `Lp` space at exponent infinity and `MemLp.toLp`. Positive singleton masses justify the passage from witness values to the essential supremum. All identities are symbolic universal proofs; there is no numerical program needed for the mathematics. `Tests.lean` has 15 formal integration examples and emits axiom reports. The main five theorem axiom lists are exactly `propext`, `Classical.choice`, and `Quot.sound`.

## Recorded execution and semantic review

A fresh private build passed. Every authored module and `lakefile.lean` also passed direct source replay with `-DwarningAsError=true`. The audit covers 96 originating declarations, a 20,672-node dependency graph and 4,063 uniquely resolved imported modules. It verifies both type and body dependencies, including relevant inductive/recursor dependencies. All 74 kernel-safe originating declarations pass the permitted-axiom and safe-dependency policy. A separate reviewer read the exact bilingual original, the entire frozen source and the complete report; the final three-page PDF was compiled with both the native editor and Tectonic and visually inspected page by page.

The remaining 22 originating entries are compiler-generated unsafe runtime helpers, not mathematical assumptions. They include two unsafe `_elambda_` axiom-kind entries created by Lean's eager lambda lifting. The official compiler source at Lean v4.19.0 commit `6caaee842e9495688c1567e78c0e68dbb96942aa` documents these entries and the `_cstage` definitions. The record explicitly classifies them and proves that no helper is reachable from **any** of the 74 safe declaration closures. No custom axiom, admission, native-decision shortcut or unsafe declaration was authored in the mathematical source. The original auditor's `PASS_PENDING_RUNTIME_HELPER_CLASSIFICATION` status is retained alongside the separate completed finalization; it has not been silently overwritten.

Six isolated Lean control fixtures verify the audit: one ordinary proof is accepted; an unrelated custom axiom, a transitive axiom, an admitted proof, native decision and unsafe code are rejected by the audit policy. These intentionally invalid fixtures are separate from the mathematical library and are retained as audit evidence. The compiler can accept an explicit axiom as a declaration; it is the additional dependency policy that rejects its use. A failed display-only helper probe using an unsupported `pp.width` option is preserved with its corrected successful probe. It did not change the candidate source or its successful build.

## Records and reproduction

`verification/frozen-v1.json` identifies the exact source files and five capstones. The independent source and final report reviews, root semantic/engineering decisions, finalization summary, eligibility check and PDF identity are under `verification/`. `SHA256SUMS.json` covers the delivered package. `verification/raw-evidence.tar.gz` contains the complete recorded build/replay/audit/control outputs and supporting provenance, with its member hashes in `raw-evidence-manifest.json`. Generated dependency checkouts and cached binaries are excluded. Absolute paths in raw records identify the original local verification environment; they are not required installation paths.

The generic source/closure verifier and graph checker are included under `verification/tools`. To rerun the full audit on macOS (the verifier uses `/bin/cp -cR`), provide a separate immutable checkout of the exact Mathlib/transitive pins with the required official cached modules, the official Lean4.19 runtime bin directory, and a new output path that does not yet exist:

```sh
python3 -B verification/tools/verify.py verify . verification/frozen-v1.json /path/to/pinned-mathlib-stock /path/to/lean-4.19.0/bin /path/to/new-audit verification/expected-pins
python3 -B verification/tools/check_audit_graph.py /path/to/new-audit/declaration-audit.json
```

If the generic verifier reports generated runtime helpers, review them explicitly as done in the supplied finalization records; do not treat a pending classification as an unconditional pass. The complete compiler sources retained for provenance carry their original notices and the corresponding Lean release license files in the evidence archive.

## Trust limits and repository scope

All nine pinned source revisions and tracked source bytes were checked. Cached imports were matched to the supplied pinned stock; full Mathlib was not rebuilt, and the supplied Lean runtime was not bootstrapped. The dependency inspector is not a second kernel implementation: source compilation supplies kernel checking. PATH wrappers are execution safeguards, not operating-system network isolation. Semantic correctness and report correspondence were reviewed separately from compilation.

The current original and operative bilingual contribution rules were rechecked, together with unsolved metadata, the absence of a prior solution directory and same-path main history, and bounded complete public claim searches and feedback deltas. This does not claim access to unpublished work or every fork. All delivered files are within this personal submission folder. The report and proof do not modify or silently strengthen the original conjecture.
