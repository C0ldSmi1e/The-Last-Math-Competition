#!/usr/bin/env python3
"""Exact finite sanity checks for conjecture 7160; not a proof of the theorem.

Uses rational complex arithmetic, determinants, and exhaustive permutations in
sizes 0--3. No numerical eigensolver or floating-point tolerance is involved.
"""
from dataclasses import dataclass
from fractions import Fraction as F
from itertools import permutations
from random import Random
import json

@dataclass(frozen=True)
class QComplex:
    re: F = F(0)
    im: F = F(0)
    def __post_init__(self):
        object.__setattr__(self, 're', F(self.re))
        object.__setattr__(self, 'im', F(self.im))
    def __add__(self, other):
        other = qc(other)
        return QComplex(self.re + other.re, self.im + other.im)
    __radd__ = __add__
    def __neg__(self):
        return QComplex(-self.re, -self.im)
    def __sub__(self, other):
        return self + -qc(other)
    def __rsub__(self, other):
        return qc(other) + -self
    def __mul__(self, other):
        other = qc(other)
        return QComplex(self.re*other.re-self.im*other.im,
                        self.re*other.im+self.im*other.re)
    __rmul__ = __mul__
    def conj(self):
        return QComplex(self.re, -self.im)
    def abs_sq(self):
        return self.re*self.re + self.im*self.im

def qc(x):
    return x if isinstance(x, QComplex) else QComplex(x)

ZERO, ONE, I = QComplex(), QComplex(1), QComplex(0, 1)

def require(condition, message):
    if not condition:
        raise RuntimeError(message)

def ident(n):
    return [[ONE if i == j else ZERO for j in range(n)] for i in range(n)]

def adj(a):
    return [[a[j][i].conj() for j in range(len(a))] for i in range(len(a))]

def mul(a, b):
    n = len(a)
    return [[sum((a[i][k]*b[k][j] for k in range(n)), ZERO)
             for j in range(n)] for i in range(n)]

def diag(values):
    return [[x if i == j else ZERO for j in range(len(values))]
            for i, x in enumerate(values)]

def normal(a):
    return mul(a, adj(a)) == mul(adj(a), a)

def frobenius_difference_sq(a, b):
    return sum((a[i][j]-b[i][j]).abs_sq()
               for i in range(len(a)) for j in range(len(a)))

def polynomial_multiply(a, b):
    out = [ZERO] * (len(a)+len(b)-1)
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            out[i+j] = out[i+j] + x*y
    return out

def characteristic_polynomial(a):
    """Leibniz determinant of xI-A, coefficients in ascending order."""
    n = len(a)
    out = [ZERO] * (n+1)
    for p in permutations(range(n)):
        inversions = sum(p[i] > p[j] for i in range(n) for j in range(i+1, n))
        term = [qc((-1)**inversions)]
        for i in range(n):
            term = polynomial_multiply(term, [-a[i][p[i]], ONE if i == p[i] else ZERO])
        for k, x in enumerate(term):
            out[k] = out[k] + x
    return out

def characteristic_from_roots(values):
    out = [ONE]
    for v in values:
        out = polynomial_multiply(out, [-v, ONE])
    return out

def matching_costs(a, b):
    return [(p, sum((x-b[p[i]]).abs_sq() for i, x in enumerate(a)))
            for p in permutations(range(len(a)))]

def unitary(n, rng):
    u = ident(n)
    if not n:
        return u
    for _ in range(5):
        phase = ident(n)
        i = rng.randrange(n)
        phase[i][i] = rng.choice([ONE, -ONE, I, -I])
        u = mul(u, phase)
        if n > 1:
            i, j = rng.sample(range(n), 2)
            rotation = ident(n)
            c, s = rng.choice([(F(3,5),F(4,5)), (F(5,13),F(12,13)), (F(0),F(1))])
            rotation[i][i] = rotation[j][j] = qc(c)
            rotation[i][j], rotation[j][i] = qc(-s), qc(s)
            u = mul(u, rotation)
    require(mul(u, adj(u)) == ident(n) == mul(adj(u), u), 'unitary generator')
    return u

def check_pair(a, b, la, lb):
    require(len(a) == len(b) == len(la) == len(lb), 'dimension agreement')
    require(normal(a) and normal(b), 'normality of positive test')
    require(characteristic_polynomial(a) == characteristic_from_roots(la), 'A eigenvalue multiplicity')
    require(characteristic_polynomial(b) == characteristic_from_roots(lb), 'B eigenvalue multiplicity')
    best = min(cost for _, cost in matching_costs(la, lb))
    bound = frobenius_difference_sq(a, b)
    require(best <= bound, 'Hoffman-Wielandt sanity inequality')
    return best, bound

def main():
    rng = Random(7160)
    values = [ZERO, ONE, -ONE, I, -I, QComplex(F(1,2),F(2,3)), QComplex(-2,1)]
    counts = dict(normal_pairs=0, dimensions={}, noncommuting_pairs=0,
                  nonhermitian_pairs=0, repeated_eigenvalue_pairs=0, strict_inequalities=0)
    for n in range(4):
        total = 1 if n == 0 else 120
        counts['dimensions'][str(n)] = total
        for _ in range(total):
            la, lb = [[rng.choice(values) for _ in range(n)] for _ in range(2)]
            u, v = unitary(n, rng), unitary(n, rng)
            a, b = mul(mul(u, diag(la)), adj(u)), mul(mul(v, diag(lb)), adj(v))
            best, bound = check_pair(a, b, la, lb)
            counts['normal_pairs'] += 1
            counts['noncommuting_pairs'] += mul(a,b) != mul(b,a)
            counts['nonhermitian_pairs'] += a != adj(a) or b != adj(b)
            counts['repeated_eigenvalue_pairs'] += len(set(la)) < n or len(set(lb)) < n
            counts['strict_inequalities'] += best < bound
    require(all(counts[k] > 0 for k in ['noncommuting_pairs','nonhermitian_pairs',
                'repeated_eigenvalue_pairs','strict_inequalities']), 'positive-test coverage')
    # Same matrix with oppositely enumerated eigenvalues: matching is essential.
    a = diag([ZERO, ONE]); la, lb = [ZERO, ONE], [ONE, ZERO]
    best, bound = check_pair(a, a, la, lb)
    fixed_cost = sum((x-y).abs_sq() for x,y in zip(la,lb))
    require(best == bound == 0 and fixed_cost == 2, 'ordering control')
    # Same spectrum as a set, different multiplicities: sets lose information.
    la, lb = [ZERO,ZERO,ONE], [ZERO,ONE,ONE]
    best, bound = check_pair(diag(la), diag(lb), la, lb)
    require(set(la) == set(lb) and best == bound == 1, 'multiplicity control')
    # For 0 and I_3 the operator norm squared is 1, while matching cost is 3.
    la, lb = [ZERO]*3, [ONE]*3
    best, bound = check_pair(diag(la), diag(lb), la, lb)
    require(best == bound == 3 and best > 1, 'matrix norm control')
    # Dropping normality fails: spectra of these matrices are {0,0}, {-1/2,1/2}.
    a = [[ZERO,ONE],[ZERO,ZERO]]
    b = [[ZERO,ONE],[qc(F(1,4)),ZERO]]
    la, lb = [ZERO,ZERO], [qc(F(-1,2)),qc(F(1,2))]
    require(not normal(a) and not normal(b), 'nonnormal control hypotheses')
    require(characteristic_polynomial(a) == characteristic_from_roots(la), 'nonnormal A roots')
    require(characteristic_polynomial(b) == characteristic_from_roots(lb), 'nonnormal B roots')
    best = min(cost for _,cost in matching_costs(la,lb))
    bound = frobenius_difference_sq(a,b)
    require(best == F(1,2) and bound == F(1,16) and best > bound, 'normality control')
    print(json.dumps({'status':'PASS','arithmetic':'exact rational complex',
        'seed':7160,'coverage':counts,'semantic_controls':4,
        'limits':'Finite sanity examples and invalid-strengthening controls only; not a general proof.'},indent=2,sort_keys=True))

if __name__ == '__main__':
    main()
