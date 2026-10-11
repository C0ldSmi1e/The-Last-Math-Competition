"""Exact independent finite checks for the classical balanced Polya urn.

These are supplementary checks, not the proof of the limit or the universal
formula. Those statements are proved in the accompanying Lean project.
"""
from fractions import Fraction as Q
from itertools import product
from math import factorial
import json

replacement = ((1, 0), (0, 1))
assert sum(replacement[0]) == sum(replacement[1]) == 1
law = [Q(1)]
for n in range(201):
    assert law == [Q(1, n + 1)] * (n + 1)
    assert sum(law) == 1
    assert all(p >= 0 for p in law)
    xs = [Q(k + 1, n + 2) for k in range(n + 1)]
    assert all(0 <= x <= 1 for x in xs)
    if n >= 2:
        left = sum(p for x, p in zip(xs, law) if 0 <= x <= Q(1, 4))
        right = sum(p for x, p in zip(xs, law) if Q(3, 4) <= x <= 1)
        assert Q(1, n + 1) <= left <= 1
        assert Q(1, n + 1) <= right <= 1
        assert left == right
    updated = [Q(0)] * (n + 2)
    for k, probability in enumerate(law):
        red, blue = k + 1, n - k + 1
        updated[k] += probability * Q(blue, red + blue)
        updated[k + 1] += probability * Q(red, red + blue)
    law = updated

# Independently enumerate actual colour histories with evolving ball counts.
histories_checked = 0
for n in range(11):
    totals = [Q(0)] * (n + 1)
    for history in product((0, 1), repeat=n):
        balls = [1, 1]
        weight = Q(1)
        for colour in history:
            weight *= Q(balls[colour], sum(balls))
            balls = [balls[j] + replacement[colour][j] for j in range(2)]
        k = history.count(0)
        assert weight == Q(factorial(k) * factorial(n - k), factorial(n + 1))
        totals[k] += weight
        histories_checked += 1
    assert totals == [Q(1, n + 1)] * (n + 1)

print(json.dumps({"result": "PASS", "exact_arithmetic": "fractions.Fraction",
                  "recurrence_checked_through_n": 200,
                  "histories_checked": histories_checked,
                  "limit_proof": "Lean; finite checks do not certify a limit"}))
