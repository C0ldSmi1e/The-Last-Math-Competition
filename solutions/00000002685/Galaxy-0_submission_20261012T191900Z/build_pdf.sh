#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p evidence
# Normal TeX installations need no arguments. Minimal-image fallback:
# ./build_pdf.sh /path/to/directory/containing/pdflatex.fmt
if [ "${1:-}" != "" ]; then
 export TEXFORMATS="$1:"
 export TEXINPUTS=.:/usr/share/texlive/texmf-dist/tex//:/usr/share/texmf/tex//:
 export TFMFONTS=/usr/share/texlive/texmf-dist/fonts/tfm//:/usr/share/texmf/fonts/tfm//:
 export T1FONTS=/usr/share/texlive/texmf-dist/fonts/type1//:/usr/share/texmf/fonts/type1//:
 export TEXFONTMAPS=/usr/share/texlive/texmf-dist/fonts/map//:/usr/share/texmf/fonts/map//:
 export TEXMFVAR="$(pwd)/.tex-cache"
fi
pdflatex -output-format=pdf -interaction=nonstopmode -halt-on-error solution.tex > evidence/latex-build.log 2>&1
pdflatex -output-format=pdf -interaction=nonstopmode -halt-on-error solution.tex >> evidence/latex-build.log 2>&1
