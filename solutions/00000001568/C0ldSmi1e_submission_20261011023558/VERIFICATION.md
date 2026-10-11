# Verification of conjecture 00000001568

This submission proves `GeometricThrackle.geometric_thrackle_bound`: every finite geometric thrackle has at most as many edges as vertices. These are local checks by the submission workflow, not a maintainer acceptance or a claim of historical novelty.

The exact bilingual source and both repository rule sections are retained under `source/`. An independent reviewer read the original before the proof, then read every Lean module and the entire report. The detailed assessment is in `verification/independent-semantic-review.txt`. It checks closed segments, distinct unordered edges, ordinary injective vertex placement, endpoint and collinear cases, and the empty/disconnected graph cases. The final report differs from the independently inspected version only by three recorded layout edits; the original report text and the final PDF review receipt are retained.

## Reproduce the proof

Use Lean 4.19.0 and the exact stock dependencies in `lake-manifest.json` (Mathlib `c44e0c8ee63ca166450922a373c7409c5d26b00b`). Provision those packages and their ordinary Mathlib cache, then run `./verify.sh`. The script forces a fresh build of all four authored modules, records the actual compiler version, prints the final theorem's axioms, and runs the auxiliary Python checks. Set `LAKE_BIN` to an absolute Lake executable if needed. The parent independently replayed this exact script successfully; see `verification/auxiliary-replay.log`.

No numerical computation is a premise of the proof. The auxiliary programs check the supplied source, toolchain, package pins, and verification output.

## Additional independent engineering checks

A separate fresh project compiled all authored modules and replayed their source with warnings treated as errors. Fresh compilation and strict replay supplied Lean kernel checking for the authored declarations. A separate Lean environment inspector traversed the full dependency closure and enforced the allowed-axiom and unsafe-dependency policy on every safe local declaration. It inspected 45 local declarations (43 safe declarations and two generated runtime helpers), a closure of 16,024 declarations, and 4,068 imported module identities. Every safe local declaration has only standard logical axiom dependencies; the final theorem uses exactly `propext`, `Classical.choice`, and `Quot.sound`. There are no admitted proofs, custom axioms, `native_decide`, or unsafe proof dependencies.

The two generated helpers are `GeometricThrackle.det._cstage1` and `GeometricThrackle.det._cstage2`, runtime artifacts of real arithmetic. Neither is reachable from any safe authored declaration or the final theorem. The automated summary deliberately leaves their classification pending; `verification/root-engineering-review.json` records the subsequent explicit classification and final pass. The initial generic manifest did not list a designated capstone; the root separately checked the exact final theorem's type, axiom set, and dependency-policy result, as recorded there. The inspector field `trust_enforced` denotes this dependency policy; it is not a separate kernel rechecker.

The inspector accepted a valid control and rejected controls containing a custom axiom, a transitive custom axiom, an admitted proof, `native_decide`, and an unsafe definition. Full inspection output is compressed under `verification/engineering/`; its execution archive includes command receipts, inspector source, and control fixtures. The driver and inspector template are included under `audit/`.

To repeat the additional engineering audit on macOS with a clean stock Mathlib checkout and populated cache, run from this folder:

```sh
python3 audit/verify.py verify . FROZEN-SHA256.json /absolute/path/to/stock/mathlib /absolute/path/to/lean-4.19.0/bin /absolute/path/to/new-audit-output
```

The output directory must not already exist. This optional driver uses macOS copy-on-write copies and never modifies the supplied stock checkout. Any generated runtime helpers require the same explicit dependency review before calling its result a final pass. The four mathematical source files and package pins are byte-identical to the audited versions. The archived selected manifest binds the pre-layout report; the current `FROZEN-SHA256.json` binds the final report. All submitted files are additionally covered by `SHA256SUMS.json`.

The stock package revisions and tracked source identities were checked; cached imported modules were byte-matched to the stock cache. Mathlib itself was not rebuilt, and the Lean runtime was not bootstrapped. These are explicit limits of the local validation.

## Report

The standalone `report.tex` compiled successfully in the native editor and was exported with Tectonic. Every page of the three-page `report.pdf` was rendered and visually inspected. The final export had no layout warnings. A TeX engine with the listed standard packages can reproduce the report, for example `tectonic report.tex`.

Repository eligibility is recorded separately in `verification/eligibility.json`. The submission changes only this personal submission folder.
