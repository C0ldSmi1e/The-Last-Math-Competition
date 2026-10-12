#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
lean --version
lake --version
lake build +Basic
lake env lean Basic.lean
lake env leanchecker -v Basic
printf '\nAll formal checks passed.\n'
