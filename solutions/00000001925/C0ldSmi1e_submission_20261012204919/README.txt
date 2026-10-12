Conjecture 00000001925: failure of qualitative L-infinity convergence

Build with Lean 4.19.0 and the unchanged pinned lake-manifest.json:
  lake build

The only default target is the Conjecture1925 Lean library. Its root imports Tests,
which imports Counterexample, Nonconvergence, Measure, and Dynamics. Thus the default
build checks every authored proof and every formal integration test. Warnings are
errors through the package's moreLeanArgs. No custom build hook is used.

Main theorem: Conjecture1925.counterexample.
Its components verify a single fixed probability space, an invertible measurable
measure-preserving transformation, a bounded measurable observable, a degree-two
polynomial, the conventional normalized polynomial-average formula, a quotient-norm
gap of at least 1/2 for all positive N, non-Cauchyness, and absence of every L-infinity
limit. The final clause explicitly verifies that this example is nonergodic.

Neither supplied language of the conjecture imposes ergodicity of the transformation.
The result refutes its unqualified general convergence assertion, and consequently
any rate tending to zero. No result about an additional ergodicity hypothesis or a
specialized alternative definition of p-averages is claimed. The unspecified rate
is not assigned an invented formula.

No auxiliary numerical computation is required. Tests.lean checks the public
objects and emits axiom dependencies for the principal theorems. Expected axiom
lists contain only propext, Classical.choice and Quot.sound.

All dependency entries and pins are preserved exactly from the neutral input;
the root project name remains tlmc_neutral. Generated dependencies and binaries
in .lake and temporary direct-build artifacts are not submission source.
