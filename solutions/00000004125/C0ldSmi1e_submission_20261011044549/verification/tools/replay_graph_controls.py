#!/usr/bin/env python3
"""Replay unchanged graph checker; corrupt copies to exercise rejection paths."""
import copy, hashlib, json, pathlib, subprocess, sys, time

P=pathlib.Path
AUDIT=P(sys.argv[1]).resolve()
CHECKER=P(__file__).resolve().with_name('check_audit_graph.py')
OUT=P(sys.argv[2]).resolve()
OUT.mkdir(exist_ok=False)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def save(p,data):p.write_text(json.dumps(data,indent=2,sort_keys=True)+'\n')
assert sha(CHECKER)=='c4b518f02a17db3778a09ddc3987016973ad67ff057c9d03e1b76ed3eeabae61'
audit_hash=sha(AUDIT)
original=json.loads(AUDIT.read_text())
allowed={'propext','Classical.choice','Quot.sound'}
assert set(original['permitted_axioms'])==allowed
assert original['requested_modules']==['Conjecture4125','Verification']
assert original['strict_dependency_policy'] is True
assert original['kernel_check_performed'] is False
assert not original['failures']
frozen=json.loads((P(__file__).resolve().parent.parent/'frozen/frozen.json').read_text())
roots={r['name']:r for r in original['declarations']}
assert all(n in roots and roots[n]['trust_enforced'] and not roots[n]['unsafe'] for n in frozen['capstones'])
for row in roots.values():
    if row['trust_enforced']:
        assert set(row['axioms'])<=allowed and not row['unsafe_dependencies']

results=[]
def run(label,path,reject=False):
    argv=[sys.executable,str(CHECKER),str(path)];start=time.time()
    r=subprocess.run(argv,cwd=OUT,capture_output=True)
    stdout=OUT/(label+'.stdout');stderr=OUT/(label+'.stderr')
    stdout.write_bytes(r.stdout);stderr.write_bytes(r.stderr)
    receipt={'fixture':label,'argv':argv,'returncode':r.returncode,'expected_rejected':reject,
        'seconds':time.time()-start,'input_sha256':sha(path),'checker_sha256':sha(CHECKER),
        'stdout_sha256':sha(stdout),'stderr_sha256':sha(stderr)}
    save(OUT/(label+'.receipt.json'),receipt)
    if reject:
        assert r.returncode==1 and b'AssertionError' in r.stderr,(label,r.returncode,r.stderr)
    else:
        assert r.returncode==0,(label,r.returncode,r.stderr)
    results.append(receipt)
    print(f'{label}: expected outcome PASS',flush=True)

run('original_graph',AUDIT)
def fixture(label,mutate):
    data=copy.deepcopy(original);mutate(data)
    path=OUT/(label+'.json');save(path,data);run(label,path,True)

def omit_closure(data):
    root=next(r for r in data['declarations'] if r['trust_enforced'] and len(r['closure'])>1)
    root['closure'].remove(next(n for n in root['closure'] if n!=root['name']))
fixture('omitted_transitive_closure_member',omit_closure)

def omit_edge(data):
    node=next(r for r in data['dependency_graph'] if r['dependencies'])
    node['dependencies'].pop()
fixture('inconsistent_dependency_edge',omit_edge)

target='Conjecture4125.aut_simple'
def add_axiom(data):
    next(n for n in data['dependency_graph'] if n['name']==target)['kind']='axiom'
    for root in data['declarations']:
        if target in root['closure']:root['axioms']=sorted(set(root['axioms'])|{target})
fixture('forbidden_axiom_with_consistent_summaries',add_axiom)

def add_unsafe(data):
    next(n for n in data['dependency_graph'] if n['name']==target)['unsafe']=True
    for root in data['declarations']:
        if target in root['closure']:root['unsafe_dependencies']=sorted(set(root['unsafe_dependencies'])|{target})
fixture('unsafe_dependency_with_consistent_summaries',add_unsafe)

def unavailable(data):
    next(n for n in data['dependency_graph'] if n['name']==target)['kind']='unavailable'
fixture('unavailable_trusted_dependency',unavailable)

assert sha(AUDIT)==audit_hash
summary={'status':'PASS','audit_sha256':audit_hash,'baseline_and_negative_controls':results,
    'fixed_policy_check':'Exactly propext, Classical.choice, Quot.sound; nine capstones present and trust-enforced.',
    'limits':['Checker recomputes consistency of exported dependency evidence, not independent Lean environment extraction or kernel checking.',
      'Negative controls deliberately mutate copied audit JSON and leave the real audit and frozen proof unchanged.']}
save(OUT/'summary.json',summary)
print(json.dumps({'status':'PASS','controls':len(results)-1,'audit_sha256':audit_hash},indent=2),flush=True)
