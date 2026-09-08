# Debian-based devcontainer base: ships the `vscode` user (uid 1000), git,
# sudo and curl, which is what devcontainer.json expects.
FROM mcr.microsoft.com/devcontainers/base:debian

# Minimal toolchain for `make` (resume.pdf) and `website/build.sh`.
#
#   resume.tex needs: pdflatex, bibtex, hyperref, xstring, multibib
#     - texlive-latex-base ....... pdflatex + hyperref (pulls texlive-binaries -> bibtex)
#     - texlive-latex-recommended  packages hyperref/res.cls lean on
#     - texlive-latex-extra ...... xstring
#     - texlive-bibtex-extra ..... multibib
#     - texlive-fonts-recommended  the standard Type1 fonts pdflatex embeds
#     - cm-super ................. Type1 EC/TC faces; without it pdflatex falls
#                                  back to generating a tcrm1000 bitmap (.pk)
#     - latexmk .................. default build recipe of the LaTeX Workshop extension
#
#   website/build.sh needs: bash (base image), python3 + pybtex, pandoc
#
# --no-install-recommends keeps this to the packages actually exercised by the
# two builds; texlive-full would be ~4 GB for the same output.
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        make \
        texlive-latex-base \
        texlive-latex-recommended \
        texlive-latex-extra \
        texlive-bibtex-extra \
        texlive-fonts-recommended \
        cm-super \
        latexmk \
        python3 \
        python3-pybtex \
        pandoc \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
