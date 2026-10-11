# Independent frozen-document review: conjecture 00000000105

## Scope and source-level verdict

I read all of the frozen `report.tex` (217 lines), `README.md` (55 lines), `verify.py` (69 lines), `PROVENANCE.json` (38 lines), and `SOURCE-SHA256SUMS.json` (18 lines). I compared their mathematical statements and semantic descriptions with the exact bilingual original/rules and all three previously reviewed final Lean proof files, including the integrated closed-convex extension.

**SOURCE-LEVEL PASS.** No substantive mathematical error, mismatch with the reviewed proof, or semantic evasion was found. The report presents the whole geometric/topological disproof, and the README and provenance describe its scope accurately. There is no document-level correction request.

This is a source/document verdict only. I did not run the Lean project or `verify.py`, audit compiled objects/axioms, inspect run logs, export/render the PDF, or visually inspect any PDF pages. The coordinating reviewer is independently handling those execution and artifact checks. Their completion remains necessary before an overall competition-rules acceptance. Author provenance/history claims are identified below as attestations rather than facts independently established by this reviewer.

## Frozen hashes and checks actually executed

| File | SHA-256 |
| --- | --- |
| `SOURCE-SHA256SUMS.json` | `735928b90363041392c0c6a1dbdf09bbe590990719c1e3cdb7cca10c1aae5062` |
| `report.tex` | `468e6b46790f374457f21243bc4b810d672f3b826242df80660d2b6232f246ea` |
| `README.md` | `c1708f0e4e19f1d0d1f8dedd8f423ceddd20c53a88764dde8c1cbb3bff6c4d5a` |
| `verify.py` | `ebdb64256c2ea52b7e3de7444b293f08882cab3fec36a808f5c947226bf3deb3` |
| `PROVENANCE.json` | `9775252df0b129777d2cc08e03393ecf3677c3661769dea50d1b7d2ba4f7bd2f` |
| `Proof.lean` | `9a990ec7f184e69033a96aa7305d58034a305def12ed21a3cfb14022462c3bbf` |
| `TorusTopology.lean` | `47285ebd3038294d260dcd988fed9cf9b99a19a05a0d7f78c7a7ddf0e9654150` |
| `BoundaryBound.lean` | `b35015d5a835d0aa60b710cc5837441c50cd15ea43566def8801fede40b901c2` |

I executed a read-only hash check over all 16 paths named in the freeze manifest: every file matches its recorded digest. The manifest's own digest exactly matches the freeze notification. I also compared the submitted copies of `original.md`, `RULES.en.md`, and `RULES.zh-CN.md` byte-for-byte with the authorized clean original inputs: all three are unchanged. Their hashes agree with the provenance entries. Python's `ast.parse` accepts `verify.py`; the manifest and provenance parse as JSON. These are the only execution claims in this document.

## Mathematical report review

**Statement and semantics.** The English conjecture is quoted accurately, and the Chinese version is correctly described as making the same claim. The report explicitly adopts realization by a homeomorphism to the entire actual boundary in R³. It first explains the compact-polyhedral convention, then separately covers the possibly unbounded closed-halfspace convention through the stronger closed-convex theorem. It does not silently weaken convexity or substitute a graph/Euler predicate for the geometric object.

The genus-one model is the actual product of unit circles. The report correctly describes the separately proved compactness, separation, countability, path connectedness, full real product manifold model, and dimension two. Using the standard orientable torus as the genus-one model is legitimate; it does not depend on a hypothetical convex realization or an assumed Euler relation.

**Covering and no-retraction argument.** The local inverse, actual discrete kernel, full-preimage trivialization, inverse formula, continuity, and covering conclusion match `Proof.lean`. The report explicitly avoids claiming global continuity of the extended argument function. The no-section proof correctly uses uniqueness of lifts on connected R and the nonzero period 2π. The contractible-space argument reverses an actual contraction and uses homotopy lifting to obtain a section at time one. It correctly states that this route requires no local path-connectedness assumption on the contractible space.

**Torus versus sphere.** The report uses the same pole e(1,1), avoiding slice `(z,−1)`, stereographic projection, inverse defined on the whole orthogonal-complement vector space, and first-coordinate retraction as the source. It correctly derives the contradiction from contractibility of the vector space, without assuming simple connectedness of the sphere or asserting contractibility of the punctured torus.

**Bounded convex boundaries.** The added statement `interior(closure K) = interior K` is valid for the convex nonempty-interior sets in question. Thus the written Minkowski-functional argument may pass to the closure without changing the boundary. Its two ball bounds, subadditivity-based continuity estimate, positive radial factors, boundary level set, and mutually inverse radial maps are mathematically correct. The report accurately distinguishes this explanation from the exact stock gauge-rescaling theorem used in Lean, which supplies an ambient homeomorphism carrying the actual frontier to the sphere.

The empty-interior case correctly uses `frontier K = closure K`, proves nonemptiness from the alleged torus homeomorphism, and uses actual convex contractibility. It covers the degenerate and nonclosed bounded cases claimed in the theorem.

**Closed sets without a boundedness assumption.** The report contains the complete bounded-frontier proof: choose an exterior center, use a sufficiently large sphere disjoint from the frontier, partition it by the two disjoint open interior/exterior sets, use sphere connectedness, and contradict exteriority by the reflected midpoint. It requires both closedness and properness where needed. The main proof then derives properness and compact frontier from the proposed torus homeomorphism, derives boundedness, and invokes the already established bounded obstruction. This matches `BoundaryBound.lean` and the reviewed integration wrapper exactly.

**Logical conclusion.** A single genuine genus-one closed surface without any convex realization disproves the universal claim before prime lengths or vertex bounds are imposed. The report states this implication explicitly. It neither invents edge arithmetic nor exploits Big-O at genus zero. The permissive finite-generating-set predicate is honestly described, including redundant points and the absence of an inferred vertex-cardinality claim. The broader theorem independently handles closed halfspace intersections without a finite-hull equivalence theorem.

## README, verifier, and provenance review

The README correctly identifies the roles of the proof files, the stronger theorem, and the ordinary geometric interpretation. Its generic checkout instructions do not require an author's temporary directory. It explicitly keeps PDF generation/visual checking separate, and describes axiom inspection as supplementary to Lean compilation rather than as an independent kernel implementation.

The verification script's source performs the advertised basic checks: Lean version, package revision and tracked-source cleanliness, original input hashes, disallowed tokens in the four named Lean sources, a warning-failing Lake build, a warning-as-error axiom-audit invocation, an allowlist of standard axioms, and a requirement for 14 reported audit entries. It records the actual command output. I found no discrepancy between those operations and the report's stated workflow.

The script is an incremental Lake-based verifier, and its final audit-output count is not itself an independent proof that the intended theorem identities were selected or that cached imported objects match source. Those facts properly remain part of the coordinating reviewer's source/compiled-module inspection and strict source replay. This is a limit of what the script alone establishes, not a discovered defect in the mathematical proof or a reason to reject the frozen documents. The report does not claim an independent kernel implementation.

The provenance's source hashes and semantic interpretations are consistent with the original inputs, freeze manifest, report, and reviewed Lean sources. Its claims about author independence, child-author activity, dependency modifications, historical PDF-workflow authorization, and prior validation are author-supplied attestations. I did not inspect other chats, author history, execution logs, or workflow markers to independently establish those historical claims. The coordinating reviewer can assess them from its own evidence.

## Final source disposition

The frozen report and supporting documents faithfully present the reviewed formal strategy and the original conjecture's negation under its ordinary meaning, including the unbounded closed-polyhedron convention. All source-level and document-level checks assigned to this reviewer pass. Overall acceptance still requires the separately assigned clean Lean execution, compiled dependency/axiom checks, and complete PDF export/render/visual review; none is claimed here.

## Compiled-type clarification: the regularity parameter

After the coordinating reviewer reported successful execution, I independently read `/private/tmp/tlmc105-independent-engineering/readable-statements.stdout`. Its displayed type for `torus_closed_surface_properties` contains an implicit **universally quantified** parameter `{ω : WithTop ℕ∞}` and concludes the manifold property at that parameter, with no extra hypotheses. In the submitted source only the `Manifold` and `RealInnerProductSpace` scopes are opened; the stock analytic notation `ω` belongs to the separate `ContDiff` scope. Consequently the source occurrence was elaborated as an implicit parameter rather than the scoped notation for analytic regularity.

This does not invalidate the report's analytic-manifold claim. Stock `Analysis/Calculus/ContDiff/FTaylorSeries.lean:106` defines analytic regularity as `(⊤ : WithTop ℕ∞)`, whereas infinite differentiability is the distinct lower value `((⊤ : ℕ∞) : WithTop ℕ∞)`. Stock `Geometry/Manifold/IsManifold/Basic.lean` documents this distinction and supplies an instance lowering analytic manifold regularity to any parameter. The compiled theorem proves the asserted conjunction for **every** parameter, so specializing it as `TLMC105.torus_closed_surface_properties (ω := ⊤)` gives exactly the analytic case, in addition to the independently relevant topological surface case. The parameter is not an assumption of an unproved manifold fact.

Thus the SOURCE-LEVEL PASS remains unchanged, and no mathematical-source edit is needed. The coordinating reviewer is executing the explicit analytic-specialization check; I have inspected the supplied readable type and stock definitions rather than claiming that execution as my own. The reported wider engineering pass (44 roots, 32,715-declaration closure, no unsafe dependencies, only the three standard axioms, and successful negative controls) is coordinating-review evidence, not a check independently run by this document reviewer.
