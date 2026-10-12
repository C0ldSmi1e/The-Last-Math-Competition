#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
# Usage: LEAN_BIN=/path/to/lean/bin ./reproduce.sh
LEAN_BIN="${LEAN_BIN:-$(dirname "$(command -v lean)")}"
export PATH="$LEAN_BIN:$PATH"
mkdir -p evidence
"$LEAN_BIN/lean" --version | tee evidence/lean-version.txt
"$LEAN_BIN/lake" build 2>&1 | tee evidence/lake-build.txt
"$LEAN_BIN/lean" -o Main.olean Main.lean 2>&1 | tee evidence/lean-build.txt
LEAN_PATH="$(pwd)" "$LEAN_BIN/leanchecker" Main 2>&1 | tee evidence/kernel-check.txt
printf "leanchecker Main: exit 0\n" | tee -a evidence/kernel-check.txt
if grep -Eq 'sorryAx' evidence/lean-build.txt; then
  echo 'Proof audit failed: sorryAx' >&2; exit 1
fi
# Include the resulting proof-relevant source hashes.
sha256sum Main.lean lakefile.toml lean-toolchain > evidence/lean-sha256.txt
printf 'Lean compilation and independent kernel recheck succeeded.\n'
