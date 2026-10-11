# Reproducing the engineering verification

This directory contains the exact tested verification tools, frozen five-file identity manifest, separate expected pin bytes, unchanged final report and summaries, and compressed raw evidence. Copy `verification/` alongside the five submitted files. The main proof/configuration files are supplied by the submission; this package does not replace them.

## What passed

The final review compiled both owned Lean files from source, with warnings treated as errors, and inspected every persistent declaration originating in those modules. All 15 capstones, 36 owned declarations, 21,404 reachable declarations, and 4,074 import identities passed. The six examples in `Checks.lean` are compilation checks and leave no persistent declarations. See `results/REPORT.md` and `results/summary.json` for the exact outcome and trust boundary. Those are unchanged historical records, including their original absolute paths.

## Prerequisites and paths

Use Python 3.9 or later with assertions enabled, the pinned Lean 4.19.0 runtime, Git at `/usr/bin/git`, and a complete stock Mathlib checkout with all pinned package checkouts and required compiled imports. The exact tested driver invokes `/bin/cp -cR`: it requires macOS and a filesystem arrangement that supports its copy-on-write clone operation. The tested runtime was macOS arm64. A Linux adaptation would require changing the copy command and supplying an appropriate runtime; **no Linux adaptation was executed or verified**, and no such changes have been made to these tool bytes.

The expected lock and toolchain live in `verification/expected-pins/` and must remain separate from the submitted files. The verifier compares them byte-for-byte. Their original hashes and all nine pinned revisions are recorded in the evidence. Runtime/cache binaries are intentionally not bundled.

From the submission root, choose absolute paths and fresh, nonexistent output directories:

```sh
submission="/absolute/path/to/submission"
stock="/absolute/path/to/pinned/mathlib"
lean_bin="/absolute/path/to/lean-4.19.0/bin"
prep_output="/absolute/path/to/fresh-preparation-output"
hardening_output="/absolute/path/to/fresh-hardening-output"
review_output="/absolute/path/to/fresh-review-output"
```

First run the actual inspector's synthetic controls and the driver hardening controls:

```sh
python3 "$submission/verification/tools/verify.py" prepare "$stock" "$lean_bin" "$prep_output"
python3 "$submission/verification/tools/test_hardening.py" "$hardening_output"
```

Then compile and inspect the frozen submission in a new review directory:

```sh
python3 "$submission/verification/tools/verify.py" verify "$submission" "$submission/verification/frozen.json" "$stock" "$lean_bin" "$review_output" "$submission/verification/expected-pins"
python3 "$submission/verification/tools/check_audit_graph.py" "$review_output/declaration-audit.json"
```

Do not use `python -O` or set `PYTHONOPTIMIZE`. The main verifier refuses optimized mode. Do not reuse an existing output directory. The verifier copies source and dependencies into the new review directory, preserves failed runs, checks the source/pin hashes again at the end, and records command receipts. Its final summary must say `PASS`; a pending runtime-helper classification needs a separate explicit review.

## Stock cache preparation and the retained stopped run

The supplied cache originally lacked nine Mathlib modules. The first fresh source build and declaration audit passed, but the strengthened import-identity gate stopped because those nine compiled files had no pre-build cache identity. This is recorded in `results/stopped-run.json` and the first-run archive. Its 43 completed command receipts are preserved. The Python exception was captured by the tool interface and is transcribed in that record; it was not a separately saved subprocess receipt.

The nine exact pinned stock sources were separately built with `lake --no-cache --wfail`, then replayed one by one using `lean -DwarningAsError=true` in import-dependency order. The unchanged executed repair script, all ten command receipts, and source/output hashes are in the preparation archive at `preparation/repair_stock.py` and `preparation/stock-repair/`. That script contains historical absolute paths and is supplied as evidence, not as a portable command to run unchanged. When preparing a different stock path, perform the equivalent targeted builds with your selected stock and runtime paths, preserving their receipts, then start a fresh full review. Never populate the stock with author proof `.olean` files.

The final run reused 2,790 preexisting package imports and the nine separately compiled stock modules, plus 1,272 Lean runtime imports. Three further imports were the two freshly compiled owned modules and the inspector. Full Mathlib rebuilding and runtime bootstrapping were not performed.

## Evidence archives and integrity

`ARCHIVES.json` gives each archive's digest and file count. Every archive has an external `*.manifest.json` and a byte-identical internal `RAW-MANIFEST.json`, listing the SHA-256 and length of every other member. `PACKAGE-MANIFEST.json` lists every distributed file except itself and its digest companion. `PACKAGE-MANIFEST.sha256` identifies that manifest. No signature or external timestamp authority is claimed.

Extract the archives into a separate empty evidence directory, away from the active proof source:

```sh
mkdir /absolute/path/to/extracted-evidence
tar -xzf "$submission/verification/evidence/final-raw.tar.gz" -C /absolute/path/to/extracted-evidence
tar -xzf "$submission/verification/evidence/first-stopped-run.tar.gz" -C /absolute/path/to/extracted-evidence
tar -xzf "$submission/verification/evidence/preparation-raw.tar.gz" -C /absolute/path/to/extracted-evidence
```

The final archive includes the complete raw declaration audit, import identities, pinned-source and cache hash inventories, runtime hashes, source checks, all 56 command receipts, generated audit/fixture source texts, and control outputs. The stopped-run archive omits its large declaration audit only because it is byte-identical to the final audit; its record gives the exact final member and SHA-256 to reuse. Other first-run evidence is preserved.

The preparation archive includes the original and hardened controls, exact hardening diffs, all retained source/configuration reviews, stock repair evidence, and the initial graph-helper failure followed by corrected controls. Historical Lean files are stored as `.lean.txt`, and all caches, `.git`, compiled projects, `.olean`, `.ilean`, and Python bytecode are excluded.

The actual graph checker can also be exercised on retained synthetic inputs. It must accept `preparation/graph-adversarial-corrected/good.json` and reject each of `missing_closure_member.json`, `spurious_axiom.json`, and `inconsistent_edge.json` in the same directory. The first helper incorrectly rejected a missing compiler-internal `_obj` name on an unsafe generated runtime root; the correction restricted that missing-node check to trust-enforced roots. The original failure output, one-line correction, explicitly labeled reconstruction of the first helper, exact final helper, and corrected tests are retained. The candidate has no unsafe owned roots or missing dependencies, and the main verifier was unchanged by this supplemental-helper correction.

## Exact tools and limitations

`tools/verify.py`, `tools/templates/ClosureAudit.lean.txt`, `tools/test_hardening.py`, and `tools/check_audit_graph.py` are copied without functional edits from the tested files. Historical repair and inline test sources are supplied separately. Package assembly and documentation do not alter the proof or the original final report.

Fresh compilation invokes Lean's kernel for owned source. The dependency inspector does not independently kernel-recheck imported declarations. Package cache/source identity does not prove that preexisting cache bytes were originally compiled from those sources. The runtime is supplied and hashed, not bootstrapped. PATH wrappers are safeguards against common network/Git commands, not an OS network sandbox. Static scanning does not replace the explicit source/configuration/metaprogramming review. Mathematical fidelity and PDF layout are separate reviews.
