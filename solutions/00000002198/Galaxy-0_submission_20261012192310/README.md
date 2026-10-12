# Disproof of TLMC 00000002198

The S4 weak order has 190 inclusion-maximal antichains, four maximum antichains, and 856 antichains in total. None occurs anywhere among second-order Eulerian numbers, or as any row sum. This deals with the English/Chinese maximal/maximum ambiguity and the missing Eulerian indices.

## Reproduce

Use exactly Lean 4.31.0 with its bundled Std library. No Mathlib or network dependency is needed.

- `lake build` builds all three formal modules, treating warnings as errors.
- `python3 reproduce.py --lean /absolute/path/to/lean` performs a clean temporary-directory build, audits every named theorem, replays each compiled module with `leanchecker`, and runs the independent Python enumeration. The optional `--skip-checker` skips only that additional replay, not the Lean kernel proof checking.
- `bash build_pdf.sh` compiles `report.tex` twice. On a minimal TeX image, an optional argument gives a directory containing a compatible `pdflatex.fmt`; the script exposes the standard TeX Live source/font trees.

## Real mathematical objects

`Main.lean` encodes every permutation as a four-tuple, checks injectivity/surjectivity, proves inversion-set weak-order correspondence, and defines the actual antichain and maximal/maximum properties.

`EnumLemma.lean` proves the recursive enumeration sound, complete and duplicate-free, provides canonical subset representation and its uniqueness, and proves the singleton-extension criterion equivalent to genuine inclusion-maximality.

`Eulerian.lean` defines the standard recurrence and proves that 190, 4, and 856 occur nowhere in the infinite triangle and nowhere as a row sum.

Main statements: `all_counts_not_eulerian` and `all_counts_not_row_sum`. The semantic links are `every_permutation_encoded`, `weakLE_iff`, `actual_subset_bridge`, `antichain_complete`, `maximal_iff`, and `maximum_iff`.

The project has no admitted proofs, no `native_decide`, no custom axioms and no unsafe declarations. Only standard Lean axioms are permitted by the reproduction script. Python is an independent check, not a proof oracle.

## Scope

The exact original bilingual text is in `source.md`. The standard second-order Eulerian numbers are used. The report does not invent definitions for “balancing double staircases,” and does not claim to exclude arbitrary sums of triangle entries or unrelated unspecified statistics. No maintainer acceptance, priority, or external expert endorsement is claimed.

All work is AI-assisted for Galaxy-0. Eligibility files record a read-only snapshot; eligibility must be checked again immediately before submission.
