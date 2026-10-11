Conjecture 4125 — independent engineering verification bundle

Recorded result: PASS. This bundle covers source compilation, dependency trust,
source side-effect review, operational controls, and independent finite code
review. Mathematical interpretation and the written report are separate reviews.

The unchanged verifier initially reported PASS_PENDING_RUNTIME_HELPER_CLASSIFICATION.
The separate runtime-helper-classification.json completes that classification:
134 owned declarations = 80 safe mathematical declarations + 54 generated runtime
helpers. All safe-root closures contain 28,360 declarations, exactly the three
standard axioms propext, Classical.choice, Quot.sound, and no unsafe dependency.
The full exported graph contains 28,481 declarations; 4,056 imports were identified.
There are nine checked capstones. Verification.lean contains anonymous examples,
so it exports zero declarations; every example was strictly source-compiled.

The fresh strict Lake build and direct strict replay of both owned modules passed.
No cache repair or failed candidate run occurred. All 62 verification/graph command
receipts were checked. Six Lean operational controls, seven hardening controls,
and five deliberate graph corruptions had their expected outcomes. Expected
failures of negative controls are preserved. An optional process-observation
attempt was denied by the sandbox; it did not affect verification.

CONTENTS

frozen/frozen.json contains the exact selected manifest. The five frozen
source/configuration inputs and that manifest are in records/frozen-input.tar.gz.
expected-pins/ contains the independently prepared pin snapshot.
tools/ contains byte-identical verify.py, test_hardening.py, check_audit_graph.py,
and ClosureAudit.lean.txt, plus portable package and graph-replay helpers.
results/ contains convenient copies of the engineering verdict, capstone types,
helper classification, and receipt validation.
auxiliary/ contains the independently reviewed finite script and its fresh result.
records/ contains compressed full engineering records and per-member manifests.
The original source-review/control/replay scripts and all relevant receipts remain
inside those archives, including historical intermediate verdicts and controls.

Generated proof/cache artifacts, private dependency clones, .git directories,
Python bytecode, and duplicate copies of byte-identical audit output are excluded
from the archives. Every exclusion is listed with its reason in the member
manifest. The authoritative full audit, deterministic mutation helper, and every
raw graph-control receipt/output are retained. Five large derived mutant JSON
copies are omitted; each exclusion records its exact historical SHA-256, size,
and reconstruction command. Adversarial Lean fixtures occur only inside archives.

VERIFY THE TRANSPORTED BUNDLE

From this directory, with Python 3.9 or newer:

  python3 tools/verify_package.py .

This hashes every bundle file, then reads and hashes every archive member without
extracting it. It rejects unlisted members, links, unsafe paths, and unwanted
cache/repository/bytecode members. bundle-manifest.json records all bundle members
other than itself; the enclosing delivery must identify its hash independently.

REPRODUCE THE CHECKS

The bundle contains no active .lean files, so placing it beside a submission does
not introduce duplicate modules into recursive source discovery. The bundle is
transportable evidence, not a bundled Lean distribution. The
unchanged driver requires macOS native cp -cR, Python 3.9+, a Lean 4.19.0 runtime,
and a complete supplied Mathlib v4.19.0 source/cache tree with its pinned packages.
Mathlib revision: c44e0c8ee63ca166450922a373c7409c5d26b00b.
Use new, nonexistent output directories for every command that produces a run.
Replace the illustrative absolute paths below with actual local paths. After the
bundle integrity check, unpack frozen inputs into a scratch directory outside any
submission directory that a verifier will scan recursively:

  mkdir /path/to/unpacked-frozen
  tar -xzf records/frozen-input.tar.gz -C /path/to/unpacked-frozen

  PYTHONDONTWRITEBYTECODE=1 python3 tools/test_hardening.py /path/to/new-hardening

  python3 tools/verify.py prepare /path/to/pinned/mathlib /path/to/lean-4.19.0/bin /path/to/new-preparation

  python3 tools/verify.py verify /path/to/unpacked-frozen /path/to/unpacked-frozen/frozen.json /path/to/pinned/mathlib /path/to/lean-4.19.0/bin /path/to/new-review expected-pins

  python3 tools/replay_graph_controls.py /path/to/new-review/declaration-audit.json /path/to/new-graph-controls

  python3 auxiliary/check_finite_algebras.py

The ordinary graph checker can also be run by itself:

  python3 tools/check_audit_graph.py /path/to/new-review/declaration-audit.json

To reconstruct the exact five omitted historical mutant JSON files, use the
authoritative archived audit rather than the output of a new proof compilation:

  mkdir /path/to/archived-verification
  tar -xzf records/verification.tar.gz -C /path/to/archived-verification
  python3 tools/replay_graph_controls.py /path/to/archived-verification/declaration-audit.json /path/to/reconstructed-graph-controls

The five generated JSON files must match the SHA-256 and byte counts recorded in
records/verification.members.json under exclusions. Their original raw receipts
and stdout/stderr remain in the verification archive. All five reconstructions
were replayed and checked against those historical identities when packaging.

The portable graph replay separately enforces the fixed three-axiom policy and
nine capstones, then runs the unchanged checker on the original graph and five
corrupted copies. A fresh driver run can again require runtime-helper
classification. Compare its complete helper inventory with the archived explicit
classification and verify that no safe-root closure reaches a runtime helper;
do not reinterpret a pending status as an unconditional PASS.

TRUST AND SCOPE LIMITS

Owned source was freshly compiled. Supplied cached dependency oleans were matched
byte-for-byte to the stock cache, and tracked stock source bytes were checked
against the pinned Git objects. Full Mathlib was not rebuilt. The supplied Lean
runtime was identified and checked for stability, not bootstrapped or separately
authenticated against a downloaded distribution. Runtime source files were not
available in that supplied installation, so no runtime-source rebuild is claimed.

Native macOS clone copying succeeded; separate inodes and independent mutation
were tested. Physical storage-block sharing was not independently measured.
PATH wrappers limit expected downloader/Git operations; they are safeguards,
not OS-level network isolation. The graph audit extracts and checks dependency
evidence; strict source compilation supplies the Lean kernel checking.

The finite Python enumeration examines powersets on zero through three atoms.
It is corroboration only and does not establish a general theorem or the named
algebra bridges. Bounds, complement, every finite-carrier subset join, and the
whole order relation are checked; meet preservation follows from those checks.

The archived audit includes unsafe compiler stages, specialization placeholders,
and erased runtime artifacts. None is reachable from a mathematical root. Their
presence is disclosed, not hidden by a claim that the entire environment is safe.
