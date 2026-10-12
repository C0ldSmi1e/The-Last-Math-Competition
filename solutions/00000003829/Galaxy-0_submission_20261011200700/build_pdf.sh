#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
# Ordinary TeX installations can run pdflatex twice directly. In the cloud
# image, source/font files exist but the global format/search indexes do not.
export TEXINPUTS=/usr/share/texlive/texmf-dist/tex//:
export TFMFONTS=/usr/share/texlive/texmf-dist/fonts/tfm//:
export T1FONTS=/usr/share/texlive/texmf-dist/fonts/type1//:
export TEXFONTMAPS=/usr/share/texlive/texmf-dist/fonts/map//:
export TEXMFVAR="$PWD/tex-cache"
mkdir -p "$TEXMFVAR"
if [ ! -f "$TEXMFVAR/pdflatex.fmt" ]; then
  (cd "$TEXMFVAR" && pdftex -ini -etex -interaction=nonstopmode -halt-on-error \
    -jobname=pdflatex '\pdfoutput=1 \input latex.ltx' > format-build.log 2>&1)
fi
export TEXFORMATS="$TEXMFVAR:"
pdflatex -interaction=nonstopmode -halt-on-error report.tex > latex-build.log 2>&1
pdflatex -interaction=nonstopmode -halt-on-error report.tex >> latex-build.log 2>&1
