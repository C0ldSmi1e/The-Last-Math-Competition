# Disproof of conjecture 00000004125

The four-element Boolean algebra `Set Bool` is complete and ccc. Its **full** automorphism group has exactly two elements and is simple. It cannot be isomorphic to the random or Cohen algebra: the formalization constructs five distinct elements of each actual standard carrier, which rules out even a carrier bijection with a four-element set.

This refutes the classification clause, and hence the conjecture as written. Both language versions allow finite atomic Boolean algebras and abelian simple groups. The submission makes no separate claim about the random algebra's automorphism group or its maximal solvable subgroups. It does not address a modified conjecture restricted to atomless algebras or nonabelian simple groups.

## Contents and exact formal scope

- `conjecture.md`: the unchanged bilingual original.
- `Conjecture4125.lean`: the finite algebra, full automorphism group, exact random/Cohen carriers, and quantified disproof.
- `Verification.lean`: boundary cases, actual instances, and nine capstone axiom queries.
- `report.tex` and `report.pdf`: matching mathematical report, independently reviewed in full; all four PDF pages visually inspected.
- `verification/`: reproducible audit tools, exhaustive finite auxiliary computation, command records, dependency identities, and explicit trust boundaries.
- `review/`: independent semantic review, author read-scope record, and root verification records. These are local contributor checks, not official maintainer acceptance.

`ClassificationCarrierConsequence` is explicitly a **necessary consequence** of the classification, not a purported formalization of every original clause. It says that every complete ccc Boolean algebra with simple full automorphism group has a carrier equivalence with one of the two named carriers. Its negation is proved using `Set Bool`.

The random carrier is the quotient of actual Borel subsets of the real line by null symmetric difference for Lebesgue measure restricted to `[0,1]`. The source proves the null-equivalence, unit-support, and positive-class bridges. The Cohen carrier is the actual regular-open subsets of binary Cantor space. Their Boolean operations need not be implemented for the stronger no-bijection obstruction. Any algebra isomorphism must induce a carrier bijection.

## Reproduce the mathematical checks

Use the supplied `lean-toolchain` (Lean 4.19.0), `lakefile.toml`, and unchanged `lake-manifest.json` (Mathlib v4.19.0, commit `c44e0c8ee63ca166450922a373c7409c5d26b00b`). From this directory, after installing the pinned Lean toolchain:

```sh
lake exe cache get
lake --no-cache --wfail build
lake env lean -DwarningAsError=true Conjecture4125.lean
lake env lean -DwarningAsError=true Verification.lean
python3 verification/auxiliary/check_finite_algebras.py
```

The first command obtains the pinned library's compiled dependencies and requires network access when uncached. Both owned modules are default library roots. Source and project options also treat warnings as errors and disable automatic implicit variables. All nine printed capstones depend only on `propext`, `Classical.choice`, and `Quot.sound`.

The finite Python check enumerates every carrier permutation of powerset algebras on zero through three atoms, verifies their full order relation and Boolean/complete-join preservation, and enumerates normal subgroups. Expected automorphism orders are `1, 1, 2, 6`; only the two-atom case is simple. This corroboration does not replace the Lean proof or either named-carrier bridge.

For the additional hardened dependency audit, use the instructions inside `verification/`. The independent build and strict replay passed. The audit resolved 4,056 imports, examined 134 declarations originating in the owned mathematical module, and checked all 80 safe mathematical roots and their 28,360-declaration dependency union. The other 54 entries are explicitly classified compiler runtime helpers; none is a mathematical proof dependency. No admitted proof, custom mathematical axiom, `native_decide`, or unsafe proof dependency is used.

The audit examines dependencies and identities; Lean source compilation supplies kernel checking. The supplied Lean runtime and pinned library compiled artifacts remain trusted inputs. Neither a bootstrap of Lean nor a full source rebuild of Mathlib is claimed. Independent source review, fresh compilation, auxiliary execution, and PDF inspection are documented separately.

## Report reproduction

Compile `report.tex` with a standard LaTeX installation or Tectonic. The submitted PDF was exported with Tectonic after successful compilation in the native LaTeX editor, and every page was rendered and inspected. The report cites primary references only to identify standard presentations of the two named algebras; the finite obstruction and all required calculations are proved in Lean.

Only this personal submission directory is part of the change. A bounded current-repository duplicate check found no existing submission for this conjecture; its scope and dated evidence are recorded in `review/`. Local verification does not imply maintainer acceptance.
