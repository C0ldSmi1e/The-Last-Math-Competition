#!/usr/bin/env python3
"""Strict local verification against an explicitly supplied cached pinned runtime.

Usage: python3 verify.py --runtime-root /absolute/path/to/competition-work/runtime
The ordinary Lean project also supports `lake build HallReverse Verification`
when the exact dependencies in lake-manifest.json are installed.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys

parser = argparse.ArgumentParser()
parser.add_argument("--runtime-root", type=Path, required=True)
args = parser.parse_args()
root = Path(__file__).resolve().parent
runtime = args.runtime_root.resolve()
stock = runtime / "stock1925"
lean = runtime / "lean-4.19.0-darwin_aarch64/bin/lean"
build = root / ".verification-build"
build.mkdir(exist_ok=True)

expected_pins = {
    "lean-toolchain": "55e97be96000b5e9e290c9e74482e5e317861499a5540353ce845471bded8cea",
    "lake-manifest.json": "56f7aa9722d120b38ffe868179164054411be9398660939609cb8a0c55e48637",
}
for name, expected in expected_pins.items():
    actual = hashlib.sha256((root / name).read_bytes()).hexdigest()
    if actual != expected:
        raise SystemExit(f"Unexpected pin file hash: {name}: {actual}")

version = subprocess.run([str(lean), "--version"], text=True, capture_output=True, check=True)
if not re.search(r"Lean \(version 4\.19\.0(?:,|\s)", version.stdout):
    raise SystemExit(f"Unexpected Lean version: {version.stdout}")

sources = ["HallReverse", "Verification"]
for module in sources:
    source = (root / f"{module}.lean").read_text()
    banned = re.search(r"\b(?:sorry|admit|native_decide|unsafe|axiom)\b", source)
    if banned:
        raise SystemExit(f"Prohibited token {banned.group()!r} in {module}.lean")

paths = [build, stock / ".lake/build/lib/lean"]
paths.extend(sorted((stock / ".lake/packages").glob("*/.lake/build/lib/lean")))
env = dict(os.environ, LEAN_PATH=os.pathsep.join(map(str, paths)))
logs = [version.stdout]
expected_theorems = {
    "finite_fiber", "finite_below", "infinite_tail", "upperBound_mono",
    "infinitelyMany_mono", "quarter_infinitude_refutes_optimality", "conjecture_false",
}
for module in sources:
    command = [str(lean), "-DwarningAsError=true", "-o", str(build / f"{module}.olean"),
               str(root / f"{module}.lean")]
    result = subprocess.run(command, cwd=root, env=env, text=True, capture_output=True)
    output = result.stdout + result.stderr
    logs.extend([f"Module: {module}\n", output, f"Exit status: {result.returncode}\n"])
    print(output, end="")
    if result.returncode:
        (root / "strict-build.log").write_text("".join(logs))
        raise SystemExit(result.returncode)
    if module == "HallReverse":
        found = set()
        for name, axioms in re.findall(
            r"'HallReverse\.([^']+)' depends on axioms: \[([^\]]*)\]", output
        ):
            found.add(name)
            actual_axioms = {a.strip() for a in axioms.split(",") if a.strip()}
            if actual_axioms != {"propext", "Classical.choice", "Quot.sound"}:
                raise SystemExit(f"Unexpected axiom dependencies for {name}: {actual_axioms}")
        if found != expected_theorems:
            raise SystemExit(f"Missing or unexpected axiom print: {found}")

hashes = {f"{m}.lean": hashlib.sha256((root / f"{m}.lean").read_bytes()).hexdigest()
          for m in sources}
logs.append("All strict Lean builds and axiom checks passed.\n")
(root / "strict-build.log").write_text("".join(logs))
(root / "verified-source-hashes.json").write_text(json.dumps(hashes, indent=2) + "\n")
print("All strict Lean builds and axiom checks passed.")
