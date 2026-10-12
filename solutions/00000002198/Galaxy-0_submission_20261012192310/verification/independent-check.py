from itertools import permutations
from collections import Counter
P=list(permutations(range(4))); N=len(P); index={p:i for i,p in enumerate(P)}
# Right weak order covers: swap adjacent positions if inversion length rises by one.
covers=[set() for _ in P]
for i,p in enumerate(P):
 for k in range(3):
  if p[k]<p[k+1]:
   q=list(p); q[k],q[k+1]=q[k+1],q[k]
   covers[i].add(index[tuple(q)])
upper=[]
for i in range(N):
 reached={i}; queue=[i]
 while queue:
  for j in covers[queue.pop()]:
   if j not in reached: reached.add(j);queue.append(j)
 upper.append(reached)
inc=[{j for j in range(N) if j not in upper[i] and i not in upper[j]} for i in range(N)]
cliques=[]
def bk(R,P,X):
 if not P and not X: cliques.append(tuple(sorted(R)));return
 u=max(P|X,key=lambda v:len(P&inc[v])) if P|X else None
 for v in list(P-(inc[u] if u is not None else set())):
  bk(R|{v},P&inc[v],X&inc[v]);P.remove(v);X.add(v)
bk(set(),set(range(N)),set())
assert len(set(cliques))==len(cliques)
print('Right weak order maximal antichains:',len(cliques))
print('Size distribution:',sorted(Counter(map(len,cliques)).items()))
width=max(map(len,cliques)); print('width:',width,'maximum antichain count:',sum(len(c)==width for c in cliques))
# Independent left-vs-right check: inverse permutation maps right cover to left inversion inclusion.
def inv(p): return tuple(p.index(k) for k in range(4))
def inversions(p): return {(i,j) for i in range(4) for j in range(i+1,4) if p[i]>p[j]}
for i,p in enumerate(P):
 for j,q in enumerate(P):
  assert (j in upper[i])==(inversions(inv(p))<=inversions(inv(q)))
print('Cover reachability matches inverse inversion containment for every ordered pair.')
row=[1];print('E2 row 0:',row)
for n in range(1,8):
 row=[(k+1)*(row[k] if k<len(row) else 0)+(2*n-k-1)*(row[k-1] if k>0 else 0) for k in range(n)]
 print('E2 row',n,':',row)
 assert 190 not in row and 4 not in row
assert row[0]==1 and min(row[1:])==240
print('For n>=7 non-first entries remain >=240 by recurrence; outside triangle =0.')
# Count all antichains as all cliques by an include/exclude recurrence, for scope only.
from functools import cache
@cache
def all_clique_polynomial(vertices):
 if not vertices: return (1,)
 v=vertices[0];rest=vertices[1:]
 a=all_clique_polynomial(rest);b=all_clique_polynomial(tuple(w for w in rest if w in inc[v]));r=list(a)+[0]*max(0,len(b)+1-len(a))
 for k,c in enumerate(b):r[k+1]+=c
 return tuple(r)
counts=all_clique_polynomial(tuple(range(N)))
print('All antichains by size, including empty:',counts,'total:',sum(counts))
