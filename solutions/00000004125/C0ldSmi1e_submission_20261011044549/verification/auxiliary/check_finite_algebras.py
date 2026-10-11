#!/usr/bin/env python3
"""Exact independent finite checks; Lean supplies the proof, not this script.

Enumerates every carrier permutation for powersets of zero through three
atoms, then checks the full order relation. No assumed automorphism formula.
"""
from itertools import permutations
import json


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


def inspect(atom_count):
    size = 1 << atom_count
    order = tuple(tuple((a & b) == a for b in range(size)) for a in range(size))
    auts = [p for p in permutations(range(size))
            if all(order[a][b] == order[p[a]][p[b]]
                   for a in range(size) for b in range(size))]
    identity = tuple(range(size))
    require(identity in auts, "identity missing")
    for p in auts:
        require(p[0] == 0 and p[-1] == size - 1, "bounds not preserved")
        require(all(p[(size - 1) ^ a] == ((size - 1) ^ p[a])
                    for a in range(size)), "complement not preserved")
        for family in range(1 << size):
            join = image_join = 0
            for a in range(size):
                if family & (1 << a):
                    join |= a
                    image_join |= p[a]
            require(p[join] == image_join, "arbitrary join not preserved")
    index = {p: i for i, p in enumerate(auts)}
    multiply = tuple(tuple(index[tuple(p[q[a]] for a in range(size))]
                           for q in auts) for p in auts)
    e = index[identity]
    inverse = [next(j for j in range(len(auts))
                    if multiply[i][j] == e and multiply[j][i] == e)
               for i in range(len(auts))]
    subgroups = []
    normal = []
    for mask in range(1 << len(auts)):
        h = {i for i in range(len(auts)) if mask & (1 << i)}
        if e not in h or not all(inverse[i] in h for i in h):
            continue
        if not all(multiply[i][j] in h for i in h for j in h):
            continue
        subgroups.append(sorted(h))
        if all(multiply[multiply[g][x]][inverse[g]] in h
               for g in range(len(auts)) for x in h):
            normal.append(sorted(h))
    simple = len(auts) > 1 and len(normal) == 2
    expected_order = (1, 1, 2, 6)[atom_count]
    expected_simple = atom_count == 2
    require(len(auts) == expected_order, "unexpected automorphism count")
    require(simple == expected_simple, "unexpected simplicity")
    return {"atoms": atom_count, "carrier_size": size,
            "all_carrier_permutations_examined": (1, 2, 24, 40320)[atom_count],
            "order_automorphisms": [list(p) for p in auts],
            "automorphism_count": len(auts),
            "subgroups": subgroups, "normal_subgroups": normal,
            "simple_nontrivial_group": simple,
            "all_boolean_operations_and_arbitrary_joins_checked": True}


if __name__ == "__main__":
    print(json.dumps({"status": "PASS", "cases": [inspect(n) for n in range(4)],
                      "scope": "Finite corroboration only; not the Lean proof or named-algebra bridge."},
                     indent=2))
