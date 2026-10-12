# Independent review of TLMC 00000003829

Review date: 2026-10-11 UTC. Result: PASS for the explicitly stated ordinary border-strip interpretation. This is an independent AI-assisted mathematical, source, build, and document review; it is not organizer acceptance.

## Mathematical and semantic checks

The arbitrary-size classification of simultaneous (2,3)-cores as the empty partition and the one-cell partition is correct. The induction on row count is complete and uses direct hook lengths; it does not depend on a finite experimental bound. IsPartition represents positive weakly decreasing row lengths, and the core test examines divisibility of every hook.

The formal graph uses the subtype of all actual simultaneous cores. Its Border predicate operates on actual diagram/skew cells and requires containment, a nonempty edge-connected skew diagram, and absence of a 2-by-2 square. The singleton edge is explicitly verified. Reach is the undirected path-equivalence closure and Component is its quotient. HasCard expresses an actual bijection with Fin n. The project proves one component and excludes two. The exact binomial numerator is 10 = 5 * 2, so natural-number division agrees with the rational Catalan value at the witness.

The additional theorem connected_for_any_border_relation proves connectivity for every relation that retains the singleton edge. The report correctly discloses that the original statement does not specify border lengths, and that a different rule restricting border lengths to s or t is not refuted by this witness. This qualification must remain in the public submission. No organizer decision about the intended meaning is claimed.

## Independent executable checks

The Lean source and project files were copied to a newly created directory with no .lake cache. Lean 4.31.0 and Lake 5.0.0-src+68218e8 were used.

All checks returned exit code 0:

- bash reproduce.sh, including lake build +Basic, lake env lean Basic.lean, and lake env leanchecker -v Basic
- lake env lean -DwarningAsError=true Basic.lean
- Source scan for sorry, admit, axiom declarations, native_decide, unsafe, implemented_by, and extern: no matches
- Printed transitive axiom dependencies for the classification, singleton border, component cardinality, generic connectivity, and capstone counterexample: only propext and Quot.sound
- An independent Python calculation using actual cell sets checked all 2714 partitions of sizes 0 through 20, found exactly the empty and singleton (2,3)-cores, verified the singleton border and negative border tests, connectivity, and the exact value 10/5 = 2. This bounded experiment supplements, and does not replace, the unbounded Lean proof.

## Report and PDF

The complete LaTeX report was compared against the formal definitions and theorem statements. It accurately describes the proof scope and the semantic qualification above. The final two-page PDF was rendered and both pages were visually inspected. No clipping, missing characters, formula corruption, or broken references were found.

The supplied build_pdf.sh was rerun against a copied source in the independent directory. The rebuilt PDF's extracted text exactly matched the delivered PDF. The final LaTeX build log contained no warnings, overfull boxes, underfull boxes, errors, or missing-character messages.

## Reviewed SHA256 identities

- Basic.lean: a30c172e97d48af64f350344bbbe4865599ac209756b82b174c6027eb41f00f9
- report.tex: 642e07d63dc3b17b540ca65bac5be9549e4a1a09e2a7cabb3f832918bda6af0c
- Delivered report.pdf: 4c6bb19c29949987f15b9fc782c37911e8c4e1fa6b3cb5794dc41bff503f2387
- build_pdf.sh: 253d4acc61a70f600399073afc64c2aa9df67884c220551a593aa919f1676879

No blocking defect remains in this reviewed version. Eligibility and publication authorization must still be checked immediately before submission; neither is established by this mathematical/build review alone.
