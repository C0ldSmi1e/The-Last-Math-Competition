# Full source-document review: 00000003348

Date: 2026-10-11 UTC. This review is separate from `proof-review.md` and covers all source text of `report.tex`, `SOURCE-MAPPING.md`, and `README.md` supplied by the root. It does not yet certify the exported PDF or the separately assembled engineering evidence.

## Verdict and exact revision

**PASS for mathematical exposition, semantic scope, source mapping, citations, and the stated basic proof-reproduction instructions, after the root corrected one ambiguous derivative sentence.** No outstanding mathematical/document-source correction is required. Final packaging must include the promised exact `original.md`, matching PDF, and engineering verification records.

I read the complete report, mapping document, and README. I checked every proof paragraph against the frozen Lean mathematics already independently audited, checked all cited declaration names, and opened the two primary references at the cited definitions. I made no edit to these three source documents and had no author contact. The root supplied the LaTeX document and implemented the requested wording correction.

| Reviewed file | Final reviewed SHA-256 |
| --- | --- |
| `report.tex` | `66c95372c4aa3614cbc1a5f9d439c6991b0f3a897f3419dc7d3b00673e547210` |
| `SOURCE-MAPPING.md` | `a99cac5325bca9c0e9db96ec3131d2b0f041104210ff1013f12c84b1fe553d18` |
| `README.md` | `a49301af2c2713227cfd956caca7840d01f5f0ef857289e081b5169d1163c61e` |

The first report revision seen had SHA-256 `b33578790330f0aa5ad294d788ec839c349a33457c926aa0a69d16ba5f4fba1f`. During review the root changed long declaration identifiers from unbreakable `texttt` to breakable `path` and corrected the derivative sentence. I reread the entire latest report and hashed it after those changes. Exact snapshots of the reviewed three documents are in `document-snapshot/` under this review directory. The frozen mathematical source remained the revision identified in `proof-review.md`.

## Issue found and resolved

The original report stated that the derivative's norm is `2^n`, followed by the derivative being scalar multiplication “by this value.” That pronoun could incorrectly identify the multiplier with the real norm instead of the actual complex coefficient. I requested an explicit coefficient. The reviewed revision now says that the derivative acts by multiplication by `(f^[n])'(z) = 2^n z^(2^n−1)`. This agrees exactly with `square_iterate_hasDerivAt` and removes the ambiguity. No Lean change was needed.

## Full report audit

- **Title, author disclosure, date, abstract.** The title accurately describes the counterexample. The abstract correctly states the bounded-orbit disk, its circle boundary, the tangent-vector multiplier norm, and the failure of Cantor topology. The phrase “complete argument is formalized” refers to the displayed counterexample argument; the later explicit exclusions prevent it from claiming that normal-family equivalence or pressure theory is formalized. AI assistance and the absence of external human/maintainer approval are disclosed. The date, 11 October 2026 UTC, agrees with the clock check at review time.

- **Original statement and interpretation.** The quoted English text matches the supplied original after line-wrap normalization. The summary of Chinese semantics is accurate: uniform expansion and the two-part conclusion are present in both. The report explicitly states that the original does not select a unique formal proposition. It declares the complex-polynomial category, ordinary topology/norm, degree condition, bounded-orbit definition, and boundary definition. It does not promote an arbitrary invariant set to Julia by naming convention.

- **Expansion convention.** The displayed bound has common positive `C`, common `L > 1`, all iteration times including zero, all points of the compact invariant set, and every tangent vector. It is the actual derivative. The report discloses that Lean additionally requires differentiability of every iterate throughout `ℂ`, and explicitly links scalar derivative norm with real tangent-plane expansion. The expansion locus is the Julia set; no expansion on all of the plane or sphere is claimed. It does not silently substitute mere orbit separation for uniform expansion.

- **Cantor convention and undefined introductory phrase.** Homeomorphism concerns the entire Julia subspace and the standard product Cantor space. The report correctly excludes the weaker assertion that a Cantor subset is embedded in that Julia set. The undefined kernel/embedding phrase is disclosed without manufacturing a hidden separation hypothesis. This satisfies the semantic obligations identified before the proof was read.

- **Orbit argument and Julia identification.** The iterate formula has the correct exponent `2^n`, including the identity iterate. Norms at most one are uniformly bounded. For norms greater than one, the comparison from an ordinary power exceeding a proposed bound to the actual orbit at the same time is correct. Both directions of filled-Julia identification are justified. Passing to the frontier yields the circle, and compactness and forward invariance follow in the stated Euclidean topology. The report does not conflate filled Julia with Julia.

- **Derivative argument.** The actual derivative formula is correct for every natural iteration time. Its norm is `2^n` on the circle; the now-explicit scalar coefficient gives the stated action on all vectors. Restriction of scalars supplies the same real derivative action. The uniform constants are genuinely `C = 1`, `L = 2`, with no point-dependent choices. All these claims have corresponding Lean declarations.

- **Connectedness and non-Cantor argument.** The sphere theorem requires real dimension greater than one, and the complex plane is of real dimension two. The distinct points `1` and `−1` ensure this is not a vacuous connected singleton. Total disconnectedness would force the whole connected Julia set to be a subsingleton. Homeomorphism transport of total disconnectedness supplies the final obstruction to Cantor type. This matches the full homeomorphism predicate and its formal bridge, not an informal synonym for it.

- **Supplementary metric estimate.** The triangle inequality, bound on `|z−w|`, difference-of-squares factorization, and constants `1/2`, `3/2` are correct. The report accurately allows arbitrary nearby complex `w`, because that is what Lean proves. It explicitly limits the claim to local distances and uses equal images of `1` and `−1` to rule out global pairwise distance expansion.

- **Universal negation and conjunction.** The displayed negation has the intended scope over the universal implication, consistent with the surrounding prose and Lean theorem. The degree and expansion hypotheses are both satisfied by the same witness. Projecting the first conjunct from any putative stronger conclusion gives the false Cantor assertion. No interpretation or computation of an arbitrary predicate as pressure is attempted. The report repeatedly and correctly says that it does not disprove the pressure-dimension identity by itself.

- **Origin scope check.** Membership in the filled Julia set, nonmembership in Julia, and zero derivative are all proved in `Checks.lean`. Their use to distinguish Julia-locus from whole-plane expansion is correct.

- **Formal correspondence and verification statements.** Every namespace and theorem identifier printed in the report exists with the stated role. Lean/Mathlib versions and the lock-manifest reference agree with the inspected files. The count of 15 named axiom inspections and the listed three standard axioms agree with my fresh source replay. Absence of admits, custom axioms, and `native_decide` in the mathematical source was independently checked. The distinction between Lean source/kernel checking and a separate dependency-policy inspector is correctly worded. No hosted CI success, external human review, maintainer acceptance, or new-discovery claim is made.

## Reference checks

Both are primary academic sources hosted by the author/institution or an institutional course archive. I checked the cited passages directly rather than relying solely on the report's bibliography:

1. **Davoud Cheraghi, *One dimensional real and complex dynamics*, 8 December 2014.** The title/date match the PDF. Lecture 4, printed p. 22 (PDF index 21), defines the filled Julia set through bounded forward orbits, and Lemma 4.1 identifies its boundary with the Julia set for polynomials of degree at least two. This supports the convention used and the report's explicit distinction between adopting it and newly formalizing its normal-family equivalence. [Primary PDF](https://www.ma.imperial.ac.uk/~dcheragh/Research/CourseNotes.pdf).

2. **John Milnor, *Dynamics in One Complex Variable*, institutional course copy.** Section 14, printed p. 14-1 (PDF index 81), defines expansion on a compact invariant set using uniform exponential derivative growth for all tangent vectors and iteration times. The preceding setup specifies a smooth map and its tangent derivative. This supports the report's chosen uniform-expansion convention; the polynomial witness has the needed smooth structure and actual derivatives. [Primary PDF](https://abel.math.harvard.edu/archive/118r_spring_05/docs/milnor.pdf).

Browser PDF text was sufficient to confirm the exact cited definitions and page markers. An attempted Milnor screenshot encountered a cache error; I did not treat that failed screenshot as evidence. No external competition solution or counterexample search was conducted during this document review.

## Mapping and README

Every row of `SOURCE-MAPPING.md` matches an actual declaration and its conclusion in the frozen Lean file. The document accurately explains the extra differentiability condition, real derivative bridge, absence of pressure/dimension calculation, role of the arbitrary second predicate, and semantic boundary checks. It does not overstate the normal-family work.

The README identifies the theorem and scope correctly. Its four-command reproduction sequence is consistent with the pinned Lake project: retrieve the library cache, build both default targets, and replay each source with warnings as errors. A compatible Lean installation and network for fresh cache/dependency retrieval are necessarily environmental prerequisites; the text names Lean 4.19.0 and the cache network requirement. It instructs readers to preserve the lock. The proof-source replay itself was exercised in the independent proof review; I did not rerun network cache retrieval or the engineering suite merely to inspect these instructions.

The README's trust boundary is sound: it distinguishes reused library caches, absence of a full Mathlib rebuild/compiler bootstrap, dependency inspection, local validation, and hosted/maintainer outcomes. There are a few harmless spacing blemishes such as `includes15`; they do not change any claim or command and are not correctness blockers.

## Final-package conditions and review limits

At source-review time, `/private/tmp/tlmc3348-clean-proof/original.md` was not yet present, although the documents promise it. I notified the root to include the exact bilingual source during assembly. This is an outstanding packaging check, not a mathematical error in the proof. The same final assembly must contain the matching rendered/visually reviewed PDF and the promised `VERIFICATION.md`, verification-tool sources, and evidence. Statements about those engineering artifacts are not independently certified here before those artifacts are supplied.

The root reports native LaTeX compilation succeeded after the wording correction. I do not use that report as a substitute for inspecting the exported PDF. Layout, exact PDF/source correspondence, all-page visual QA, final manifest completeness, and engineering records remain separate finalization checks. Subject to those explicit package checks, the reviewed document sources accurately explain the frozen proof and are ready to accompany it.

### Packaging update received before closing this review

The root subsequently supplied `original.md` and the exported PDF. I independently confirmed that `original.md` is byte-identical to the exact input and has SHA-256 `4c5b2b9cd847d97c48db0bf930fdcbb4c5ac5edc8cd2b05ac0ec362c73fc7232`; the missing-original condition is resolved. I also confirmed the PDF exists with SHA-256 `f50b6b786e28f8de63e9c6fa5c5e14db882418c5726f4d9da32280754b8e17b9`, while the report-source hash remains the reviewed `66c95372…547210` revision. The root reports that all four PDF pages were visually inspected, with no TeX warnings, and records that separate visual review in `logs/pdf-review.json`. I have not independently performed that all-page visual inspection and do not attribute the root's result to this reviewer. The outstanding engineering-evidence/manifest checks remain distinct from the present mathematical/source PASS.
