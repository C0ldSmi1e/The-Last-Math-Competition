#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
lake_bin="${LAKE_BIN:-lake}"
python3 verify.py
for module in Geometry Counting Angular Main; do
  rm -f ".lake/build/lib/lean/${module}.olean"
done
mkdir -p verification
"$lake_bin" env lean --version | tee verification/toolchain.log
"$lake_bin" build 2>&1 | tee verification/build.log
"$lake_bin" env lean Main.lean 2>&1 | tee verification/axioms.log
python3 verify.py verification/axioms.log
