---
name: javi-cv
branch: master
run: build-resume.yml
# land: pull-request    a pull request per topic and one a day for small fixes; omit to push everything
ui:
  - "*.tex"
  - "bibliographies/**"
catalogue: docs/decisions.md
inherits:
  - ../.claude/decisions
# tools:                 tool names whose calls change what a person sees
#   - "mcp__server__write_.*"
# mcp:                   MCP configs every chat here gets (plans chat, plans start)
#   - .mcp/server.json
# deny:                  MCP tools an agent here may never call, by agent (regular expressions)
#   assistant:
#     - "mcp__server__write_.*"
form: compact
# reuse: 200000 # the context above which a finished session retires while this project has under five sessions of the agent: one number, or a map of executor and planner; with history the queue works the ceiling out from this project's transcripts
reviews:
  - writing:review
  - writing:proof
---

# This project's part of the workflow

Javi's CV in LaTeX (`cv.tex`, the class `res.cls`, the lists in
`bibliographies/`) and the personal website in `website/`, which is
built from the same bibliography files. The repository is public on
GitHub, and a push to `master` publishes both (setup, 17 November 2026).

## Before a build

`make` needs `pdflatex` and `bibtex`. The website's build
(`website/build.sh`) needs `python3` with `pybtex`, and `pandoc`. The
Overleaf workspace's container (`/Overleaf/.devcontainer`) has them, and
`gh` from GitHub's own apt repository, since 17 November 2026; `gh` is
signed in only once a token or `gh auth login` gives it one.

## While working

`make` in the root builds `cv.pdf`: `pdflatex`, `bibtex` on
`build/publications.aux`, then `pdflatex` twice, with
`-halt-on-error`, so a LaTeX error stops it. `make clean` removes
`build/` and the PDF. For the website, `make -C website build` runs
`build.sh`, and `make -C website serve` builds and serves it on port
8000.

## Before the push

`make` in the root, and `make -C website build` where its tools are
installed.

## After the push

The run `build-resume.yml` builds the PDF and the website, deploys the
website to GitHub Pages, and commits `cv.pdf`, its copy under the old
name `resume.pdf` (kept so links already sent out keep working),
`website/publications_generated.html`, `website/blog_index.json` and
`website/blog/*.html` back to `master` as "Auto-update CV and website
[skip ci]". The site serves both PDFs too. The local branch is then one commit behind: fetch
and fast-forward before the next change.

## Pull requests

How plans group into pull requests, when `land: pull-request` is on:
related plans share one, or a pull request per topic; omit the heading
to let each plan's author decide.

## Reading

The built-in Grep, Glob and Read; no reading server is on here.

## Products

What each kind of thing here is modelled on, a line each, when a chat
looks one up; none recorded yet.
