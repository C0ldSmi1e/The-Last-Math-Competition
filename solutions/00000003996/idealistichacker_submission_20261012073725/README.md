# Disproof of 00000003996: satisfiable Ramsey diagonals beyond every threshold

For every threshold K, the proof constructs k>=K and an actual red/blue coloring of
the complete graph on k^2 vertices with no monochromatic k-clique. Its standard Ramsey
CNF is satisfiable, so ordinary resolution has NOrefutation of any finite length.
This contradicts the necessary eventual-refutability premise of the stated matching
finite upper bound at n=k^2. It does NOT refute the lower bound alone or Ramsey theorem.

## Actual Infinite Family And Formal Bridges

The actual C5 graph and its complement have clique sizes at most2. The recursive
word graphs on Words(0)=Unit and Words(t+1)=Fin5 x Words(t) have5^t actual vertices.
All red and blue clique sizes are at most2^t by a proved image/fiber counting induction.
For t>=2, (2^t+1)^2<=5^t. A genuine finite injection and SimpleGraph.comap yield
actual graphs on Fin(k_t^2), k_t=2^t+1, with both colors CliqueFree(k_t).
These parameters exceed every threshold. No finite k=4 example stands in for asymptotics.

CNF.lean generates the actual standard Ramsey clauses over the COMPLETE graph's
unordered nonloop edges, taking both blocking clauses for EVERYk-vertex subset.
Actual graph assignments satisfy every clause. General ordinary resolution and
weakening soundness exclude the empty clause, without bounding proof length.
Conjecture3996.necessary_finite_upper_bound_false in Main.lean proves the CLOSED
negation; actual_diagonal_counterexamples exhibits actual graph, both clique-free
properties, assignment and no-refutation beyond every threshold.

All24 public theorem transitive axioms are audited in Check.lean, not just final
theorems or an assigned Boolean. Both unchanged source languages and exact Git/raw
SHA256 identities are retained in source.md and submission.json.

## Reproduction

Use Python3.11+, Git and exactly pinned Lean4.33.1:

```text
python -X utf8 reproduce.py --repo /path/to/The-Last-Math-Competition --lake /path/to/lean4.33.1/bin/lake
```

Default mode updates the portable pinned Git dependencies, verifies every actual
HEAD/origin/clean tracked source, clean-builds this OWNproject with warnings as errors
and audits all theorem axioms. Exact physical checkouts can use explicit --skip-update
after the same verification. Shared caches/path substitutions/tool binaries are not
part of the submission. Actual main.pdf is built from main.tex using Tectonic0.15.0
and SOURCE_DATE_EPOCH=0, and the release validator rebuilds and compares its bytes.

Finite regressions check every C5 triple and all53130 five-subsets of its lexicographic
square. They are supplemental samples, not the all-t/all-threshold/all-clause proofs.
The restriction embedding uses standard Classical.choice from proved finite cardinality;
no computed lexicographic initial segment or exact chosen graph enumeration is claimed.

## Interpretation And Limits

This uses the standard two-EDGE-color Ramsey counterexample CNF and ordinary resolution.
Any finite asymptotic matching upper bound on the selected diagonal must provide
refutations eventually; that weaker necessary condition already fails. Merely assigning
infinite minimal length to a satisfiable CNF does not rescue a FINITEupper bound.
Adding a condition n>=R(k,k) or an unspecified unsatisfiable subsequence changes the source.
The lower bound alone, optimal Ramsey numbers and other proof systems are not assessed.
Finite DAG/listed proofs unroll to inductive proof trees as a paper argument, not an
additional general Lean DAG theorem. statement-alignment.md maps the exact scope.

AI-assisted coordinator/CNF/integration and separate Curie family implementation,
followed by a different independent Agent reviewer. No human expert endorsement,
affiliation, first-solve credit, award or organizer acceptance is claimed.
