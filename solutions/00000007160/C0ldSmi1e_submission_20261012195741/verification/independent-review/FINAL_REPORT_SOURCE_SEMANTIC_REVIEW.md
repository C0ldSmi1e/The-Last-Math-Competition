# Independent final report-source semantic review — 00000007160

## Verdict and exact scope

**PASS: no remaining mathematical or factual correction is requested for the final report text.** The reviewer read the complete typography-fixed report, checked its mathematical correspondence to the exact frozen Lean project, and checked its validation claims against the specified final engineering records and supporting control/package evidence.

This verdict is bound to `report/report.tex` SHA-256:

    444277be1163d5b44011cc3e51fe4a7405ff02e8d62ebaf352c8100b529ef975

Its exact 235 lines are retained as `report-final-reviewed.tex`; `FINAL_REPORT_READ_MANIFEST.json` records the complete read, snapshot, and evidence identities. No author source, report, or engineering record was modified by this reviewer. PDF rendering/visual review was handled separately by the root reviewer. The final archive and submission directory layout are promised by the root but were not independently inspected at this stage; the packaging statements must be fulfilled before publication.

## Mathematical and source correspondence

The full final report was read, not merely its changed paragraphs. Its Sections 1–4 are byte-identical to the earlier independently reviewed mathematical draft. The source-to-report analysis in `FROZEN_PROJECT_V1_SEMANTIC_REVIEW.md` therefore continues to apply in full. All nine frozen proof/configuration files were rehashed and remain unchanged. The auxiliary Python source was also rehashed and remains the version previously inspected and replayed.

The report accurately defines normality, a complete eigenvalue list by characteristic-polynomial factorization, and optimal ℓ² matching of the resulting multisets. Its main theorem includes arbitrary finite complex normal matrices, arbitrary complete lists, repeated and nonreal eigenvalues, singular matrices, noncommuting pairs, and zero dimension. Its Frobenius norm is the unnormalized entrywise Euclidean norm. The complete-normal-eigenbasis argument, characteristic-polynomial bridge, exact squared-overlap identity, Birkhoff selection, permutation relabeling, and square-root consequence agree with the formal declarations. The finite-minimum distance conclusion is the immediate mathematical consequence of the formally proved existential permutation bound; the report does not claim a separate Lean metric-instance or `LipschitzWith` theorem.

The abstract's updated claim of successful local source review, fresh project build, and dependency/axiom audit is supported by the independent source-review records and the supplied final engineering evidence. It correctly distinguishes these checks from maintainer acceptance.

Section 5 names the actual public arbitrary-list capstones `hoffman_wielandt_sq` and `hoffman_wielandt`, records the correct Lean/Mathlib versions and commit, and correctly explains that separate normal-matrix existence theorems make the complete-list hypotheses nonvacuous. The module-by-module correspondence and the list of formal verification examples match the fully read source. There is no newly introduced mathematical or source-scope claim beyond the verified project.

## Engineering statements checked

The reviewer read `engineering-finalization-v1/summary.json`, `engineering-finalization-v1/runtime-helper-classification.json`, and `root-engineering-review-v1.json` in full. Additional evidence inspected was the controls section of the raw engineering summary, complete `control-results.json`, complete `package-identities.json`, and the driver's relevant Git-object/copy verification and compile/audit code. All nine source-inventory files were parsed for counts and their hashes were recomputed against the package identity record. This verifies report/evidence consistency; it is not a duplicate execution of the entire engineering audit or an independent reconstruction of all 30,338 dependency edges.

The final engineering summary's nine `tested_source_sha256` values equal the independently reviewed frozen source map exactly. The engineering and author freeze records use distinct manifest representations, so their whole-file hashes differ; the report does not conflate them, and the exact source file identities agree. The finalization and root review also agree on the engineering manifest hash and declaration-audit hash.

| Final report claim | Evidence consistency result |
| --- | --- |
| Fresh private `lake --no-cache --wfail build` | Recorded PASS; root reviewed all 61 raw command receipts and expected exits. |
| Six mathematical sources and Lake configuration directly replayed with warnings as errors | Recorded exact replay scope matches all six final `.lean` modules plus `lakefile.lean`. |
| Both theorem and verification libraries are default targets | Directly confirmed in the reviewed `lakefile.lean`. |
| 49 originating-module declarations | Final engineering inventory count is 49. |
| 36 safe originating declarations | Finalization, helper classification, and root review each report 36. |
| 13 generated runtime helpers | Exact name sets agree across final helper classification and root review, with 13 distinct names. |
| Dependency graph contains 30,338 declarations | Finalization and root review agree on 30,338. |
| 4,152 imported module identities | Finalization and root review agree; the per-package counts sum to 4,152. |
| Safe declarations use only the three allowed axioms and have no unsafe proof dependency | Final engineering audit reports no failures, the stated axiom allowlist, and no safe-root reachability to the classified helpers; this matches the source review and the earlier independent building-block axiom audit. |
| No mathematical source admissions, custom axioms, or `native_decide` | Confirmed in the complete frozen mathematical-source reading. Deliberately invalid verification-tool fixtures are explicitly distinguished from the mathematical sources. |

One wording issue was found and corrected before the final hash: the 4,152 import identities include seven `owned` module identities. The report now correctly says they are bound to the recorded runtime, pinned dependency copies **and rebuilt local modules**. The count itself never required correction.

The 13 names in the helper classification are exactly the compiler-stage/closed-value forms of `HoffmanWielandtVerification.A` and `.B`, the explicit matrices independently reviewed in `Verification.lean`. The classification explicitly labels them as not trust-enforced and not mathematical evidence. Both the classification and root engineering review state that no safe originating declaration or capstone reaches them; the report repeats precisely that limitation. It does not claim that the helpers themselves are safe or that the raw pending-classification record already constituted final acceptance. Preserving that raw record alongside the final classification is accurately described.

The control evidence contains a passing `Good` fixture and rejecting `Axiom`, `Transitive`, `Sorry`, `Native`, and `Unsafe` fixtures. Their recorded failures respectively identify direct custom axioms, transitive custom-axiom dependencies, `sorryAx`, native-computation trust axioms/runtime dependencies, and unsafe declarations. Thus the report's five negative-control categories are supported. The report does not claim these finite controls establish universal correctness of the auditing tools.

The package identity record contains all nine revisions in the final dependency lock and a total of 7,507 tracked files. All nine inventory hashes and file counts were independently checked. The inspected driver verifies each package HEAD against its locked revision, reads `git ls-tree`, recomputes each file's Git blob identity, and compares stock bytes to the private copy. This supports the report's claim that all nine pinned dependency source trees were checked against their Git objects.

## Limits are accurately stated

The report explicitly says recorded stock dependency caches were used, all Mathlib sources were not rebuilt, and the Lean runtime was not bootstrapped. It distinguishes dependency inspection and graph consistency from independent kernel rechecking and attributes kernel checks to fresh Lean source compilations. It does not claim OS network isolation, independently rebuilt dependency binaries, or formal correctness of the inspection tools. These are accurate limits of the engineering records.

The local checks are explicitly separated from maintainer acceptance. The finite Python examples are explicitly separated from proof of the general theorem. There is no statement that an example, runtime helper, or empirical control is a premise of the universal Lean proof.

## Auxiliary and reproduction claims

The final report's Python counts match the reviewer's raw replay exactly: 361 generated pairs across dimensions 0–3, including 194 noncommuting pairs, 335 with a non-Hermitian member, 127 with repeated eigenvalues, and 188 strict inequalities. The report correctly says the categories overlap and that four additional examples are semantic controls. The 71 independently run implementation probes are accurately described. The checker uses only Python's standard library and exact rational complex arithmetic, computes full characteristic polynomials, and exhausts each matching set.

Section 6's `lake --wfail build` command invokes both verified default libraries when run from the package root with the stated toolchain and dependencies. `python3 -B auxiliary/check_examples.py` matches the reviewed auxiliary source and suppresses bytecode writes. Standard LaTeX/Tectonic compilation is compatible with the report's ordinary package set; native/PDF reproduction and visual quality were checked separately by root.

The final layout delta shortened Section 6's prose to remove an orphan page. The reviewer read the entire resulting 235-line source. Its commands, archival-evidence description, separation of deliberately invalid fixtures from the mathematical proof, and distinction between local validation and maintainer acceptance retain the verified meaning. No new factual or mathematical issue arises from that delta.

The report's planned `verification` directory, raw-evidence archive, and separate verification-tool/negative-control sources must be present in the final package as stated. This reviewer has confirmed the underlying records exist and correspond to the claims, but has not inspected the eventual archive or package layout. Deliberately invalid control fixtures must remain test inputs rather than become default mathematical proof sources, as the report correctly explains.

## Evidence locations

`FINAL_REPORT_ENGINEERING_EVIDENCE_MANIFEST.json` records the hashes of all engineering/supporting records inspected and the cross-record count/source-identity checks. `FINAL_REPORT_READ_MANIFEST.json` binds the final complete report read and source/auxiliary rehashes. Earlier detailed mathematical and auxiliary findings remain in `FROZEN_PROJECT_V1_SEMANTIC_REVIEW.md`, `BUILDING_BLOCK_DRAFT_SEMANTIC_REVIEW.md`, `REPORT_DRAFT_MATHEMATICAL_REVIEW.md`, and `AUXILIARY_SOURCE_REVIEW.md`.

No report-text correction remains for the exact final hash above. Final PDF inspection and package assembly verification remain separate responsibilities, not unperformed parts of this report-source semantic review.
