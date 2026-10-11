#!/usr/bin/env python3
"""Rebuild and audit this submission with the pinned Lean/Mathlib toolchain."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parent
PARSER = argparse.ArgumentParser()
PARSER.add_argument('--lake', default='lake', help='Lake executable from Lean 4.19.0')
ARGS = PARSER.parse_args()
LOGS = ROOT / 'logs'
LOGS.mkdir(exist_ok=True)


def run(args, name):
    result = subprocess.run(args, cwd=ROOT, text=True,
                            stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    (LOGS / name).write_text('$ ' + ' '.join(args) + '\n' + result.stdout)
    print(result.stdout, end='')
    if result.returncode:
        raise SystemExit(result.returncode)
    return result.stdout


version = run([ARGS.lake, 'env', 'lean', '--version'], 'lean-version.txt')
if 'version 4.19.0' not in version:
    raise SystemExit('The verifier requires Lean 4.19.0.')
manifest = json.loads((ROOT / 'lake-manifest.json').read_text())
packages = {p['name']: p['rev'] for p in manifest['packages']}
observed = {}
for name, expected in packages.items():
    package = ROOT / '.lake' / 'packages' / name
    result = subprocess.run(['git', '-C', str(package), 'rev-parse', 'HEAD'],
                            text=True, capture_output=True)
    if result.returncode or result.stdout.strip() != expected:
        raise SystemExit('Pinned dependency mismatch: ' + name)
    modified = subprocess.run(['git', '-C', str(package), 'status', '--porcelain',
                               '--untracked-files=no'], text=True, capture_output=True)
    if modified.returncode or modified.stdout:
        raise SystemExit('Tracked dependency source changed: ' + name)
    observed[name] = expected
(LOGS / 'dependency-pins.json').write_text(json.dumps(observed, indent=2) + '\n')

inputs = json.loads((ROOT / 'source' / 'input-SHA256SUMS.json').read_text())
for name, expected in inputs.items():
    path = ROOT / name if name in ('lean-toolchain', 'lake-manifest.json') else ROOT / 'source' / name
    if hashlib.sha256(path.read_bytes()).hexdigest() != expected:
        raise SystemExit('Original input hash mismatch: ' + name)

for name in ('Proof.lean', 'TorusTopology.lean', 'BoundaryBound.lean', 'AxiomAudit.lean'):
    source = (ROOT / name).read_text()
    # This source-level scan supplements the kernel and transitive axiom audit.
    if re.search(r'\b(sorry|admit|axiom|native_decide|unsafe)\b', source):
        raise SystemExit('Disallowed source token in ' + name)

run([ARGS.lake, '--wfail', 'build'], 'build.txt')
axioms = run([ARGS.lake, 'env', 'lean', '-DwarningAsError=true', 'AxiomAudit.lean'], 'axioms.txt')
allowed = {'propext', 'Classical.choice', 'Quot.sound'}
for dependencies in re.findall(r'depends on axioms:\s*\[([^]]*)\]', axioms):
    names = {n.strip() for n in dependencies.split(',') if n.strip()}
    if not names <= allowed:
        raise SystemExit('Unexpected axioms: ' + str(names - allowed))
if axioms.count('depends on axioms:') != 14:
    raise SystemExit('Incomplete axiom audit.')
print('All source, pin, build, and transitive axiom checks passed.')
