#!/usr/bin/env bash
# Reproducible build with the TeX Live version the original was built with (TeX Live 2019, pdfTeX 1.40.20).
# Requires podman (or docker: export ENGINE=docker).
#   ./build.sh          → build/VINCI-2019-paper-33-cr-sigconf.pdf          (as submitted, v1.0)
#   ./build.sh author   → build/VINCI-2019-paper-33-cr-sigconf-author.pdf   (acmart "authorversion" notice, for Zenodo)
# The original used acmart v1.59 (2019/03/29, bundled as src/acmart.cls); TeX Live 2019 ships v1.70.
set -euo pipefail
cd "$(dirname "$0")"
ENGINE=${ENGINE:-podman}
IMAGE=docker.io/texlive/texlive:TL2019-historic
MAIN=VINCI-2019-paper-33-cr-sigconf
args=(-pdf -interaction=nonstopmode -outdir=/out)
if [[ ${1:-} == author ]]; then
  args+=(-jobname="$MAIN-author" -usepretex='\PassOptionsToClass{authorversion}{acmart}')
fi
mkdir -p build
"$ENGINE" run --rm -e openout_any=a -v "$PWD/src:/src:ro,Z" -v "$PWD/build:/out:Z" -w /src "$IMAGE" \
  latexmk "${args[@]}" "$MAIN.tex"
