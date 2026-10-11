#!/usr/bin/env python3
"""Validate authored source, exact pins, toolchain, and final theorem axioms."""
import json
import hashlib
import pathlib
import re
import sys

root = pathlib.Path(__file__).resolve().parent
input_hashes = json.loads((root / "source/SHA256SUMS.json").read_text())
for name, expected_hash in input_hashes.items():
    actual_hash = hashlib.sha256((root / "source" / name).read_bytes()).hexdigest()
    if actual_hash != expected_hash:
        raise SystemExit(f"Original input checksum mismatch: {name}")
modules = ["Geometry", "Counting", "Angular", "Main"]
for module in modules:
    path = root / f"{module}.lean"
    text = path.read_text()
    forbidden = re.search(r"\b(sorry|admit|axiom|native_decide|unsafe)\b", text)
    if forbidden:
        raise SystemExit(f"Forbidden source token in {path.name}: {forbidden.group()}")

actual = json.loads((root / "lake-manifest.json").read_text())
stock = json.loads((root / "source/lake-manifest.json").read_text())
if actual["packages"] != stock["packages"]:
    raise SystemExit("Dependency package manifest differs from the original stock pins")
if (root / "lean-toolchain").read_text().strip() != "leanprover/lean4:v4.19.0":
    raise SystemExit("Unexpected Lean toolchain")
if len(sys.argv) == 2:
    log = pathlib.Path(sys.argv[1]).read_text()
    expected = "'GeometricThrackle.geometric_thrackle_bound' depends on axioms: " \
        "[propext, Classical.choice, Quot.sound]"
    if expected not in log:
        raise SystemExit("Final theorem's expected axiom print was not found")
    if re.search(r"\berror\b|sorryAx", log, re.IGNORECASE):
        raise SystemExit("Verification log contains an error or admitted-proof axiom")
    version = (root / "verification/toolchain.log").read_text()
    if not re.search(r"Lean \(version 4\.19\.0(?:,|\))", version):
        raise SystemExit("Actual Lean executable does not report version 4.19.0")
print("PASS: authored source, exact stock package pins, toolchain, and requested axiom audit")
