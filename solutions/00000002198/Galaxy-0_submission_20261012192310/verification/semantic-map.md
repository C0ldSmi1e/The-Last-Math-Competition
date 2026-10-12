# Formal semantic map

This is the author's mapping of source-language claims to formal objects, not a maintainer review.

- Permutations: `P` is a four-tuple of `Fin 4`; `valid` means the four entries are distinct. `valid_iff_injective`, `valid_surjective`, `entry_ofFunction`, `every_permutation_encoded`, and `permutation_enumeration_complete` establish complete correspondence with permutations of four points. No valid permutations are omitted.
- Order: `inv` evaluates all six genuine position-inversion comparisons. `weakLE_iff` proves exact equivalence to universal inversion-set inclusion. This is the standard weak-order presentation, not an arbitrary graph or comparison table.
- Subsets and antichains: a canonical sublist is a representation of a subset, not an additional restriction. `selected_mem_enumerate_iff`, `actual_subset_bridge`, `sublist_eq_of_same_members`, and `canonical_unique` prove existence and uniqueness of the representation for every antichain subset. Boolean compatibility is symmetric incomparability under the actual order.
- Enumeration: `mem_enumerate_iff` proves soundness and completeness of the executable recursion; `nodup_enumerate` proves no repetitions. These are general proved theorems, not fixed-instance assertions.
- Inclusion-maximality: `maximal_iff_no_extension` and specialized `maximal_iff` equate the executable singleton-extension test with the actual absence of a strictly larger antichain.
- Maximum cardinality: `maximum_iff` proves equivalence to a genuine universal maximum over all antichains. It uses a certified size-six middle-layer witness and the certified upper bound six.
- Counts: 856 total, 190 inclusion-maximal, 4 maximum are exact kernel computations of the above duplicate-free lists. There are no external count axioms or Python-derived facts assumed by Lean.
- Eulerian array: `euler2` is the ordinary second-order Eulerian recurrence (zero-based column convention). `euler2_exclusions` and `euler2_row_sum_exclusions` quantify over all indices, so no missing source subscript is invented. The finite initial cases and infinite lower-bound induction are both kernel checked.
- Conclusion: `all_counts_not_eulerian` and `all_counts_not_row_sum` establish that no version of these three antichain counts equals any standard second-order Eulerian entry or row sum. A direct asserted equality is therefore impossible under maximal, maximum, or all-antichain readings.

Bounds: No arbitrary weighted sums, unspecified subsets of antichains, or alternative number arrays are excluded. No interpretation of the source's undefined “balancing double staircases” is introduced. The result does not require claims about its proposed bijection beyond the necessary equality of cardinalities.
