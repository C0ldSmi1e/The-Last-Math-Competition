from fractions import Fraction
from math import comb, gcd
from collections import deque

def partitions(n, largest=None):
    if n == 0:
        yield ()
        return
    if largest is None: largest = n
    for x in range(min(n, largest), 0, -1):
        for xs in partitions(n-x, x): yield (x,) + xs

def cells(p):
    return {(i,j) for i,row in enumerate(p) for j in range(row)}

def is_core(p,t):
    s=cells(p)
    for i,j in s:
        hook=1+sum(r==i and c>j for r,c in s)+sum(c==j and r>i for r,c in s)
        if hook%t == 0: return False
    return True

def border(a,b):
    x,y=cells(a),cells(b)
    if not x <= y: return False
    z=y-x
    if not z: return False
    if any({(i,j),(i+1,j),(i,j+1),(i+1,j+1)} <= z for i,j in z): return False
    seen={next(iter(z))}; todo=list(seen)
    while todo:
        i,j=todo.pop()
        for c in [(i-1,j),(i+1,j),(i,j-1),(i,j+1)]:
            if c in z and c not in seen: seen.add(c); todo.append(c)
    return seen == z

ps=[p for n in range(21) for p in partitions(n)]
cores=[p for p in ps if is_core(p,2) and is_core(p,3)]
assert cores == [(),(1,)],cores
assert border((),(1,))
assert not border((1,),())
assert not border((),())
assert not border((),(2,2))
assert gcd(2,3)==1 and Fraction(comb(5,2),5)==2
visited={cores[0]}
for u in list(visited):
    for v in cores:
        if border(u,v) or border(v,u): visited.add(v)
assert len(visited)==len(cores)
print(f'PASS: {len(ps)} actual partitions of sizes 0..20 independently checked; simultaneous cores = {cores}.')
print('PASS: actual singleton border, self/noncontainment/2x2 negatives, graph connected, exact Catalan 10/5=2.')
print('This bounded enumeration supplements, and does not replace, the unbounded Lean classification.')
