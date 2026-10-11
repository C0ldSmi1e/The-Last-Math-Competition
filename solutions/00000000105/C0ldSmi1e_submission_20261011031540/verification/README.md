# Verification record

The complete mathematical report is `../report.tex` and the matching five-page `../report.pdf`. The exact original bilingual statement and rules are in `../source/`. All paths in this directory are personal pre-submission validation; none is a maintainer acceptance or repository review decision.

`root-validation.json` combines the independent semantic reviews under `semantic/`, the strict compilation/dependency results in `summary.json`, the executed auxiliary verifier output, and the complete PDF visual review. The main proof has no admitted proof, custom axiom, native evaluation, or unsafe dependency. Its only transitive axioms are Lean's ordinary `propext`, `Classical.choice`, and `Quot.sound`.

All four authored Lean modules were freshly compiled and replayed with warnings treated as errors in a separate project using Lean 4.19.0 and exact pinned dependencies. The Lake configuration was checked separately. Dependency inspection selected every declaration by originating module, not by a chosen theorem namespace, and traversed types, bodies, recursor rules and inductive declarations. It inspected 44 local declarations and a closure of 32,715 declarations, with no unsafe runtime roots. The inspector checks dependency policy; fresh source compilation supplies Lean's kernel checking. This is not an independently implemented kernel checker.

`readable-statements.stdout` records the actual compiled theorem types. The torus surface-properties theorem is universal in the regularity parameter; `analytic-specialization.stdout` checks its specialization to analytic regularity. The report's analytic claim is therefore justified.

`engineering-evidence.tar.gz` contains full raw command receipts and streams, tracked dependency-source inventories, imported-object identities, the complete declaration graph, control results, and source-check snippets. `engineering-archive-members.json` hashes every member. Expected failures are confined to deliberately invalid verifier fixtures; they are generated only in the independent temporary review project and are never imported by the mathematical proof. The valid control passes, while custom/transitive axioms, an admitted proof, native evaluation, and unsafe declarations are rejected.

The original basic verifier can be rerun using the instructions in `../README.md`. For the stronger independent replay, use macOS Python 3 and the supplied operational driver:

```text
python3 verification/tools/verify.py verify . verification/mathematical-input-manifest.json /path/to/stock/mathlib /path/to/lean-4.19.0/bin /path/to/new-review-output
```

The output directory must not already exist. The stock Mathlib checkout must match the pinned revision and contain its pinned dependency clones and the compiled imports needed by the project. The driver uses macOS copy-on-write cloning, validates source revisions and identities, builds fresh authored objects, and blocks network downloader commands during the proof replay. It does not download dependencies. `stock-build/` records the separate warning-failing compilation of the 46 missing stock modules used here. Other cached dependencies were byte matched, and neither the entire Mathlib library nor the supplied Lean runtime was rebuilt.

The proof is entirely topological; there are no unreported numerical computations. The frozen `verify.py` was also executed independently and passed. PDF source compilation succeeded in the desktop compiler, export succeeded with the existing Tectonic runtime after fetching a standard missing package, and all five rendered pages were visually inspected. The final export log contains no typesetting warnings.

The prior-submission check is deliberately bounded to current repository metadata, path history, the retained prior metadata screen, updated issue/comment and changed-PR paths, and targeted searches. It found no existing solution. It makes no claim to search every historical fork. All checks are local contributor evidence; final mathematical acceptance remains with repository maintainers.
