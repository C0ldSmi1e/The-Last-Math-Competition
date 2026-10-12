# TLMC 00000002685: translation counterexample

Author: Galaxy-0. Prepared 2026-10-12 UTC.

## Mathematical result

For F(x,y)=(x+1,y) on the affine plane over a characteristic-zero field,
there are no preperiodic points. The orbit of (0,0) has a nonempty closure
contained in the proper closed line Y=0, so that closure is neither the
preperiodic point set nor Zariski dense. Every Jacobian determinant is 1.
This uses only one generator and therefore satisfies the stated at-most-two
restriction. Endomorphism means an algebraic self-map of a variety, not an
algebraic-group homomorphism. The statement is about preperiodic points,
not periodic subvarieties (the line in this example is invariant).

## Exact machine-checked scope

`Main.lean` proves the complete counterexample on rational points Q × Q.
It uses all rational polynomial expressions to define genuine Zariski
closure, recursive iteration, the usual eventual-repetition definition of
preperiodicity, and formal polynomial differentiation. It proves the
iterate formula, the composition law, injectivity in the time parameter,
non-density of the orbit and its closure, and non-containment in the
preperiodic set. Jacobians of every iterate and arbitrary finite products
of their evaluations at arbitrary points are also checked to be 1.

No proof of equality of the closure with the entire line is needed or
claimed. The general characteristic-zero argument in `solution.pdf` is a
paper proof, not a machine-checked field-generalization or complex-point
formalization. No additional axioms, `sorry`, or `native_decide` are used.
The printed dependencies are only Lean's standard propext, Classical.choice,
and Quot.sound.

## Reproduce

Install the official Lean 4.31.0 toolchain (as pinned by `lean-toolchain`).
There is no mathlib or third-party package dependency.

    lake build
    ./reproduce.sh

If the toolchain is not on PATH:

    LEAN_BIN=/absolute/path/to/toolchain/bin ./reproduce.sh

The script performs `lake build`, direct Lean compilation, and a separate
`leanchecker Main` kernel recheck. The checker produces no output on success;
the successful exit status is essential. Evidence logs and source hashes are
stored in `evidence/`. The additional independent-review evidence is an
internal, non-official verification; it is not a competition endorsement.

For the paper, use a standard TeX Live installation including amsmath,
amssymb, amsthm, geometry, microtype, and hyperref:

    ./build_pdf.sh

The script's optional format-directory argument is only for minimal TeX
images with existing package files but missing file-index configuration.
The submitted PDF was compiled twice and both rendered pages visually
reviewed. Reproduction need not produce byte-identical PDFs because TeX
records creation timestamps.

## Files

- `Main.lean`, `lakefile.toml`, `lake-manifest.json`, `lean-toolchain`: proof project
- `reproduce.sh`: compilation and independent kernel-check script
- `solution.tex`, `solution.pdf`, `build_pdf.sh`: paper and reproducible sources
- `evidence/`: build results, source audit, duplicate-search snapshot
- `MANIFEST.sha256`: checksums of submission files, excluding itself

The source snapshot and searches are evidence at the stated time, not proof
that no other unpublished or differently indexed solution exists. The
public repository's full-state PR search for 2685 returned no entries, and
code search for 00000002685 returned only the conjecture source.
