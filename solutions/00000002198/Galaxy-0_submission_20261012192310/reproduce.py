#!/usr/bin/env python3
"""Clean formal replay and independent exact finite check; standard Python only."""
from pathlib import Path
import argparse,os,re,shutil,subprocess,tempfile,sys,hashlib,json
p=argparse.ArgumentParser();p.add_argument('--lean',default='lean');p.add_argument('--skip-checker',action='store_true',help='Skip the extra compiled-module replay, not Lean kernel checking');args=p.parse_args()
root=Path(__file__).resolve().parent
exe=shutil.which(args.lean) or args.lean
lean=Path(exe).resolve()
version=subprocess.check_output([str(lean),'--version'],text=True).strip()
assert 'version 4.31.0,' in version,version
print(version,flush=True)
mods=['EnumLemma','Eulerian','Main']
for mod in mods:
 text=(root/(mod+'.lean')).read_text()
 for pattern in [r'\bsorry\b',r'\badmit\b',r'\bnative_decide\b',r'^\s*axiom\b',r'^\s*unsafe\b']:
  assert not re.search(pattern,text,re.M),(mod,pattern)
with tempfile.TemporaryDirectory(prefix='tlmc2198-') as td:
 build=Path(td)
 for mod in mods:shutil.copy2(root/(mod+'.lean'),build/(mod+'.lean'))
 env=os.environ.copy();env['LEAN_PATH']=td;env['PATH']=str(lean.parent)+os.pathsep+env.get('PATH','')
 for mod in mods:
  print('Clean build:',mod,flush=True)
  r=subprocess.run([str(lean),'-DwarningAsError=true','-o',mod+'.olean',mod+'.lean'],cwd=build,env=env,text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
  print(r.stdout,flush=True);assert r.returncode==0,mod
  assert 'sorryAx' not in r.stdout and 'ofReduceBool' not in r.stdout
 # Audit every named theorem in all three project modules.
 checks=['import Main']
 for mod in mods:
  namespace='AntichainEnumeration' if mod=='EnumLemma' else 'TLMC2198'
  for name in re.findall(r'^\s*theorem\s+([A-Za-z0-9_]+)',(root/(mod+'.lean')).read_text(),re.M):
   checks.append('#print axioms '+namespace+'.'+name)
 (build/'Audit.lean').write_text('\n'.join(checks)+'\n')
 r=subprocess.run([str(lean),'-DwarningAsError=true','Audit.lean'],cwd=build,env=env,text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
 print(r.stdout,flush=True);assert r.returncode==0
 assert 'sorryAx' not in r.stdout and 'ofReduceBool' not in r.stdout
 allowed={'propext','Classical.choice','Quot.sound'}
 for ax in re.findall(r'depends on axioms: \[([^\]]*)\]',r.stdout):
  assert set(x.strip() for x in ax.split(',') if x.strip())<=allowed,ax
 if not args.skip_checker:
  checker=lean.parent/'leanchecker';assert checker.is_file(),'leanchecker missing; use --skip-checker to omit only extra replay'
  for mod in mods:
   print('Compiled-module replay:',mod,flush=True)
   subprocess.run([str(checker),mod],cwd=build,env=env,check=True)
subprocess.run([sys.executable,str(root/'check2198.py')],cwd=root,check=True)
print('PASS: clean Lean build, complete named-theorem axiom audit, and independent enumeration.',flush=True)
