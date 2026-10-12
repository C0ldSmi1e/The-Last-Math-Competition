# Disproof of 00000003992: an all-subgraph parity obstruction

The actual connected triangle has original charge1 at each vertex, total charge odd,
and standard incidence-parity CNF with six binary clauses. Its actual minimum resolution
width is2: all inputs have width2, induction excludes EVERY smaller-width derivation,
and a five-step ordinary resolution refutation has width2.

EVERY actual subgraph with inherited odd charge has an odd vertex count, never2.
Exact equality with the size of a smallest odd-charge subgraph necessarily entails the
existence of such a size2 subgraph. That necessary clause fails regardless of connected,
induced, empty-boundary or contradictory-original-subsystem restrictions on admissible
subgraphs. We do not choose a singleton-only interpretation or add a boundary condition.

## Genuine Formal Bridges

Main.lean uses Mathlib's actual K3, a bijective indexing of its unordered edges and an actual
incidence-set bridge. It generates standard parity CNF from forbidden incidence assignments,
proves semantic equivalence for EVERYassignment and actual contradiction. The standard
input-inclusive bounded resolution calculus includes ordinary resolution and weakening.
Its soundness is proved for all assignments, lower bound for arbitrary derivations, and
the explicit width2 refutation and unique minimum-width specification are proved.
Actual Mathlib Subgraph vertex sets and inherited charge sums yield the all-subgraph
parity obstruction. necessary_width_charge_clause_false and actual_graph_counterexample
prove the source's required existence clause false, not just an assigned Boolean 2!=1.

Both exact source languages and Git/rawSHA256 identities are retained in source.md and
submission.json. statement-alignment.md states the complete bridge and boundaries.

## Reproduction

Use Python3.11+, Git and exactly pinned Lean4.33.1:

```text
python -X utf8 reproduce.py --repo /path/to/The-Last-Math-Competition --lake /path/to/lean4.33.1/bin/lake
```

The default uses pinned Git dependencies, then verifies each HEAD/origin/clean tracked
source, clean-builds this own project with warnings as errors and audits every theorem.
Exact preexisting physical dependency checkouts may use explicit --skip-update after the
same verification. Dependency caches, external path substitutions and tools are not submitted.
Build the actual PDF with Tectonic0.15.0 and SOURCE_DATE_EPOCH=0.

## Interpretation And Limitations

Width counts every used input and derived clause; proof trees and finite DAG/sequence
proofs unroll/list without increasing width. Subgraphs inherit original vertex charges.
Arbitrarily changing boundary charges, treating a different invariant as odd-charge,
or substituting direct XOR inference for resolution changes the input or proof system.
No general Tseitin/treewidth theorem is claimed. No definition of a specific minimum
subgraph class is needed: the weaker existence implied by ANY admissible minimum fails.

AI-assisted implementation for idealistichacker, followed by a different independent Agent
review. No human expert endorsement, affiliation, first-solve credit or acceptance is claimed.
