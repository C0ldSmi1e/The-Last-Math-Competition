# Disproof of Conjecture 00000002114

Start with one ball of each colour and replacement matrix I_2, whose two row sums are 1. The actual urn count law is uniform on 0,...,n. Both closed proportion tails [0,1/4] and [3/4,1] have probability at least 1/(n+1), so their speed-n logarithmic probabilities tend to zero. For every c>0 and centre m, one of these tails has infimum at least c/16 for I(x)=c(x-m)^2, contradicting the LDP closed-set upper bound.

## Scope

Refutes the claim that balance implies positive definiteness, using the standard speed-n LDP for colour proportions. The source imposes no irreducibility or positive off-diagonal condition. The paper states this explicitly. It does not claim to refute a degenerate zero quadratic by itself or to prove existence/classification of all urn LDPs. Assigning infinity outside [0,1] does not affect the contradiction.

## Formalization

Lean defines the actual count-law recursion, proves its uniform closed formula, nonnegativity and normalization, and constructs event probabilities from the actual colour proportion. It proves both logarithmic limits for all times and refutes the limsup/infimum closed-set upper bound for every positive translated quadratic. The upper-bound predicate is expressly a necessary restriction of an LDP, not an assumed existence theorem. Exact Python checks independently reconstruct transitions and colour histories; no finite numerical check is used as proof of a limit.

## Reproduction

In `lean/`, run `lake exe cache get`, `lake build`, and
`lake env lean -DwarningAsError=true Main.lean`.
Lean 4.19.0 and Mathlib `c44e0c8ee63ca166450922a373c7409c5d26b00b` are pinned.
Run `python verify.py` (standard library only) for supplementary exact checks,
and `tectonic main.tex` to regenerate the PDF.

`SOURCE.md` preserves the bilingual source. `verification/` contains
source provenance, actual fresh build and script logs, hashes and PDF review.
Review was a solo adversarial self-review; no independent reviewer or subagent
was used. The classical urn law is not claimed as a new probability result.
