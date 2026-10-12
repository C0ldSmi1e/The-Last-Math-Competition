"""Independent finite enumeration; not a Lean proof or submitted result."""
import itertools
from collections import Counter
n=4
perms=list(itertools.permutations(range(n)))
def inv(p):
 return {(p[i],p[j]) for i in range(n) for j in range(i+1,n) if p[i]>p[j]}
invs=[inv(p) for p in perms]
comparable=[sum(1<<j for j,b in enumerate(invs) if a<=b or b<=a) for a in invs]
counts=Counter(); maximal=Counter()
def visit(chosen,candidates,start):
 counts[len(chosen)]+=1
 covered=0
 for i in chosen: covered |= comparable[i]
 if covered==(1<<len(perms))-1: maximal[len(chosen)]+=1
 for i in range(start,len(perms)):
  if candidates>>i&1: visit(chosen+[i],candidates&~comparable[i],i+1)
visit([], (1<<len(perms))-1,0)
row=[1]
for m in range(1,n+1):
 row=[(k+1)*(row[k] if k<len(row) else 0)+(2*m-k-1)*(row[k-1] if k else 0) for k in range(m)]
print('Antichains by size:',[counts[k] for k in range(7)])
print('Inclusion-maximal by size:',[maximal[k] for k in range(1,7)])
print('Number of maximal antichains:',sum(maximal.values()))
print('Number of maximum antichains:',counts[max(counts)])
print('Second-order Eulerian row:',row,'sum:',sum(row))
assert sum(maximal.values())==190
assert counts[max(counts)]==4
assert row==[1,22,58,24]
assert 190 not in row+[sum(row)] and 4 not in row+[sum(row)]
