# Independent report review: conjecture 00000001741

Review date: 2026-10-12. Reviewer: independent AI agent assigned to semantic, source, and report review. This is a contributor review, not competition-maintainer acceptance.

**Disposition: the final report receives mathematical and semantic clearance. The initial definition-domain issue and a later package-wide wording issue were both repaired and are resolved. Engineering and PDF checks are separate; the coordinator subsequently reported that the fresh build, source replays, audit checks, and visual inspection passed. This reviewer did not independently execute those checks.**

The whole updated LaTeX report was read. Its statement and proof were compared with the exact bilingual conjecture and the previously reviewed frozen `HallReverse.lean` and `Verification.lean`. No report or author-source edits were made by this reviewer. PDF rendering and compilation were not independently checked in this review; the coordinator is handling them separately.

## Exact reviewed versions

Paths below are relative to:

`/Users/daniel/.codex/visualizations/2026/10/04/01a10508-f155-7f33-b06c-d34f02168fbf/competition-work`

| File | SHA-256 |
| --- | --- |
| Final `1741/report/report.tex` — version cleared by this review | `297b9c4061e5b196a456d62f7f0a2b6f6548c886ca0773abe34f85ef75a7e854` |
| `1741/author/HallReverse.lean` | `cd4886721c5149d8ab3497feee968ec58df1ad5cfefc820b10a9074071710633` |
| `1741/author/Verification.lean` | `0a8f742c33f543b54e13f1b6f2d10458b7fe267ce042b60ac4a5fc674669f6c9` |
| `clean-conjecture-corpus/00000001741.md` | `c703aa91d423fbc1e16edad2b866bb0e66324fbdb5ff0532e32b20d748a04179` |
| `selection-after1925/RULES.en.md` | `200d9a783c08a5edfd1b508e6942b3b851a63c726506291f6de6a59773f1163a` |
| `selection-after1925/RULES.zh-CN.md` | `7c5b49bb84403feea1eb14d23d48491400c7749d58db345cd317231949a9e82b` |

The initial report version had SHA-256 `76857986c5a5b200c2d51555c03be4e99b51178b2b0e13e004dc6eaa0409de51`. Its issue is preserved below as a resolved finding. The boundary-corrected intermediate version had SHA-256 `f0f3e355818c25a72112ed57ae80701ce9c39fc06da202210e7b897000bf45aa`. A subsequent page-break-only version had SHA-256 `96e022dfccaa13e76a2b853355d77ee63889bd175a5c19a66405af9103415596`; that full source was read. The final version makes only the package-scope precision correction documented below, which this reviewer inspected using the complete source diff and verified hash. Clearance applies to the final hash above, not silently to the earlier versions.

## Statement, interpretation, and scope

The title precisely identifies a disproof of the stated upward optimality. The abstract describes a contradiction between the two asserted clauses and explicitly disclaims a resolution of the infinitude clause alone, standard Hall's conjecture, or a corrected assertion involving a decrease of the exponent.

Section 1 reproduces the English conjecture accurately, with equivalent LaTeX typography for its mathematics. The statement that the Chinese version also says the exponent cannot be increased matches the original “指数 1/4 不可再增大.” The positive-integer domain is properly carried over from the original definition paragraph.

The report treats the Hall-definition paragraph as background, not as an assumed mathematical theorem. This agrees with the Lean source, which has no such hypothesis. It therefore does not exploit the preamble's separate omission of the nonzero-gap exception to prove a vacuous result.

The definitions of the real absolute cube-square gap, bound, admissible pair set, and infinitude predicate match the source. They retain both positive-coordinate restrictions and both strict inequalities. The subtraction is explicitly real subtraction after coercion, and infinitude is explicitly about distinct pairs.

The parenthetical “cannot be increased” is formalized as

\[
C=I(1/4)\wedge\bigl(\forall b\in\mathbb R,\ b>1/4\Rightarrow\neg I(b)\bigr).
\]

This agrees with `HallReverse.conjecture` and the fully expanded final example in `Verification.lean`. The witness exponent 1 matches the source. Its rationality also supports the report's statement that restricting candidate larger exponents to rational numbers would not save the asserted conjunction.

The report consistently distinguishes `¬ C` from `¬ I(1/4)`. It does not claim to construct infinitely many approximations, prove that the original pair set is finite, or settle a changed conjecture. No standalone infinitude claim was found.

## Proof completeness and correspondence

The finite-fiber lemma does the necessary work on the second coordinate. It selects a natural \(M>x^3+B_a(x)\), derives \(y^2<x^3+B_a(x)<M\) from the absolute-value inequality, and uses the positive-integer fact \(y\le y^2\) to conclude \(y<M\). This is exactly the reasoning in `finite_fiber` and does not merely infer finite pairs from finite first coordinates.

The finite union over \(x<N\) matches `finite_below`. The next lemma removes this finite strip from an actually infinite set, matching `infinite_tail`. These arguments handle all small first coordinates without numerical approximations to logarithms.

The monotonicity theorem chooses a natural cutoff \(N\ge\exp(1)\), so that \(x\ge N\) implies \(\log x\ge1\). Real powers are nondecreasing in their exponent on that base range. Multiplying by the nonnegative square root and retaining the original strict inequality gives inclusion of the entire infinite tail in the new admissible set. This matches `upperBound_mono` and `infinitelyMany_mono`; the report does not incorrectly claim pointwise monotonicity for every positive integer \(x\).

The final contradiction uses the first clause of \(C\) to infer \(I(1)\), while the second clause gives \(\neg I(1)\). This matches `quarter_infinitude_refutes_optimality` and `conjecture_false`. The conclusion has no unmentioned arithmetic or Hall assumption.

The stronger implication for every \(b\ge1/4\) is a valid consequence of the proved monotonicity theorem. The observation about any fixed logarithm base greater than one is also justified: the bound's base eventually exceeds one and the exceptional integer fibers remain finite. It is not needed to enlarge the formal theorem's claim.

## Resolved finding: boundary conventions

The initial report called the operation “ordinary real exponentiation” while defining \(B_a(x)\) for arbitrary real \(a\), and its finite-fiber lemma allowed every natural \(x\). Under ordinary partial-function conventions, \(\log0\) is undefined and \((\log1)^a=0^a\) is undefined for negative \(a\). Thus that initial wording did not completely specify the general statements it subsequently proved, even though the target disproof only uses positive exponents.

The coordinator repaired the definitions paragraph. The updated report explicitly states the Mathlib totalized boundary conventions \(\log0=0\), \(0^0=1\), and \(0^a=0\) when \(a\ne0\). It then explains that the conjecture itself uses positive coordinates and positive exponents, with the usual nonnegative-base interpretation. The coordinator reported checking the relevant Mathlib zero-value lemmas. This reviewer read and accepted the updated paragraph in context.

The issue is resolved. The broad all-real-exponent lemmas now have well-defined expressions at every natural coordinate and accurately describe the already-sound Lean implementation. No change to the mathematical argument or formal source was required.

## Resolved finding: archived negative controls

Final package inspection revealed that the sentence asserting an absence of admitted proofs, custom axioms, or `native_decide` proofs “in the submission” was broader than the package contents. The archived `ReviewControls/Axiom.lean`, `ReviewControls/Sorry.lean`, and `ReviewControls/Native.lean` intentionally contain exactly those constructs as rejected auditing fixtures. They are not imported into the submitted mathematical modules, and the package verification guide already distinguished them correctly.

The final report now limits the absence claim to “the submitted mathematical modules” and explicitly states that archived negative controls contain rejected constructs to test the auditing tools and lie outside the mathematical proof library. This corrects the package-wide wording without changing the proof, its formal statement, or any mathematical source. The exact diff contained only this wording correction.

The coordinator reports successful native/Tectonic compilation of this final version, visual inspection of the changed third PDF page, and byte identity of rendered pages one and two with the previously inspected versions. The reported final PDF SHA-256 is `ff6371c03449b2109fdbed1cd95b8f41d603f141967f4e93685ccf02e8c6d523`. This reviewer will verify the packaged PDF identity in the final package review; the visual review remains the coordinator's inspection.

## Verification description and engineering evidence

The correspondence section correctly names all seven principal theorems and correctly states the final theorem's unconditional type. The inventory of 13 verification examples accurately describes the inspected `Verification.lean`: two signs of the gap, two zero-coordinate exclusions, the perfect-power family, the two \(x=1\) checks, the fully expanded predicate, the infinite-tail check, two explicit greater exponents, general monotonicity, and the fully expanded final negation.

The listed reproduction commands describe a conventional cached-dependency build followed by direct checking of both source modules with warnings treated as errors. They do not claim to rebuild all of Mathlib. The published package must actually contain the described `lean/` layout and pinned configuration for those commands to reproduce the results. This reviewer did not execute these commands or inspect the pending engineering configuration.

Several statements in this section are empirical completion claims, not consequences of the mathematical source. They must be supported before final submission by the engineering records for the final package:

- The Lean/Mathlib version and complete transitive-revision pinning; both modules being default Lake targets; and presence of the copied exact `conjecture.md` and named package files.
- Successful fresh build of both submitted modules and direct source replay with warnings treated as errors, thereby substantiating the phrase “13 kernel-checked examples.”
- Completed dependency-closure and axiom checks, including results for the stated positive and negative audit controls and the exact final sources.
- Absence of admitted proofs, custom axioms, and `native_decide` proofs under the declared audit scope; the source review alone observes no such constructs in the two mathematical modules but is not the full dependency audit.
- The asserted identity checks for pinned dependency sources and supplied cached imports, plus the inclusion of records and hashes supporting those checks.

During the initial report review, the coordinator identified final engineering evidence as still in progress, and this reviewer flagged the foregoing statements as contingent. Before this review was finalized, the coordinator reported that the fresh full build and every source replay passed, together with the declaration audit, import-identity checks, audit controls, and independent graph checker. The reported declaration audit covered 17 roots and 13,883 closure nodes; the reported identity check covered 4,057 imports. The coordinator also reported successful native compilation and Tectonic export without warnings and visual inspection of all three final PDF pages.

These are explicitly attributed coordination reports, not independent runtime observations by this reviewer. The coordinator additionally identified two generated `gap._cstage1` and `gap._cstage2` helpers for explicit engineering classification and reported that neither is reachable from the safe proof roots. Final engineering records must preserve that classification and support the report's actual proof and axiom claims; there is no source-level mathematical finding concerning those reported generated helpers. If any promised check ultimately fails or remains unperformed, the report must be corrected before it is represented as verified.

The trust-limit wording is otherwise appropriately candid. It distinguishes an independent AI-agent contributor review from maintainer acceptance, states that the entire Mathlib library is not rebuilt and that the supplied Lean executable is not bootstrapped, and distinguishes local validation from those trust assumptions. No numerical experiment is required for the mathematical proof.

## Conclusion

The final report fully explains the literal disproof and matches the frozen mathematical sources. There is no unresolved mathematical or semantic finding. Its source-level and proof-level clearance is complete. Engineering validation and PDF inspection are separate checks reported by the coordinator, subject to their own recorded scope and final artifact identities. No maintainer decision or competition acceptance is claimed by this review.
