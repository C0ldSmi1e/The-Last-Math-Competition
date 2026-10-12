"""Independent explicit-oracle probes of the finite sanity-check implementation.

This checks implementation behavior, not the general Hoffman–Wielandt theorem.
Run with Python -B; importing the reviewed script does not invoke its main().
"""
from fractions import Fraction as F
from pathlib import Path
import json
import runpy

source = Path(__file__).resolve().parent.parent / 'auxiliary' / 'check_examples.py'
s = runpy.run_path(str(source), run_name='independent_auxiliary_import')
Q = s['QComplex']
z, o, i = Q(), Q(1), Q(0, 1)
checks = []

def expect(label, actual, wanted):
    if actual != wanted:
        raise RuntimeError(f'{label}: {actual!r} != {wanted!r}')
    checks.append(label)

# Independent rational-pair arithmetic formulas.
values = [(F(0), F(0)), (F(1), F(0)), (F(0), F(1)),
          (F(-2), F(1)), (F(1, 2), F(2, 3))]
for a, b in values:
    expect(f'conjugate({a},{b})', Q(a, b).conj(), Q(a, -b))
    expect(f'modulus_squared({a},{b})', Q(a, b).abs_sq(), a*a+b*b)
    for c, d in values:
        expect(f'addition({a},{b};{c},{d})', Q(a, b)+Q(c, d), Q(a+c, b+d))
        expect(f'product({a},{b};{c},{d})', Q(a, b)*Q(c, d), Q(a*c-b*d, a*d+b*c))

# Closed-form determinants, including a genuinely off-diagonal 3-cycle.
expect('empty determinant', s['characteristic_polynomial']([]), [o])
expect('scalar determinant', s['characteristic_polynomial']([[Q(2, 3)]]), [Q(-2, -3), o])
expect('cycle determinant x^3-1',
       s['characteristic_polynomial']([[z,o,z],[z,z,o],[o,z,z]]),
       [Q(-1),z,z,o])
expect('repeated nonreal roots (x-i)^3',
       s['characteristic_polynomial']([[i,z,z],[z,i,z],[z,z,i]]),
       [i,Q(-3),Q(0,-3),o])
h = [[z,i],[-i,z]]
expect('Hermitian complex off-diagonal determinant x^2-1',
       s['characteristic_polynomial'](h), [Q(-1),z,o])
expect('Hermitian conjugate transpose', s['adj'](h), h)
expect('Hermitian normality', s['normal'](h), True)
expect('empty matching', s['matching_costs']([], []), [((),0)])
expect('all two-point matching costs',
       s['matching_costs']([z,o], [o,z]), [((0,1),F(2)),((1,0),F(0))])
expect('entrywise squared norm', s['frobenius_difference_sq']([[Q(1,2),Q(3,4)],[Q(-1),z]], [[z,z],[z,z]]), F(31))
expect('Jordan matrix is nonnormal', s['normal']([[z,o],[z,z]]), False)

print(json.dumps({'status':'PASS','explicit_oracle_checks':len(checks),'checks':checks,
                  'limits':'Implementation probes only; not a general theorem proof.'}, indent=2))
