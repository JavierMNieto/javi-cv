---
paths:
  - "website/index.html"
signals:
  - "\\\\section|list2|\\\\item"
  - "\\\\hfill"
  - "class=\"bio\"|id=\"experience\"|timeline"
---
# CV: Javi's calls on what the CV shows

Grammar and tiers: `/Overleaf/.claude/decisions/README.md`. This is the project layer for `javi-cv`; it overrides the global catalogue where it names an `id`.

- `undergrad-jobs-one-bullet` **Each undergraduate job (Amazon Robotics, AASI, DecisionQ) keeps its heading lines and one bullet, kept from its strongest existing bullet: what the job was, not the tool list.** (Javi, 2026-11-17) The assistant's advice, agreed by Javi while preparing the a16z Frontier research internship application: a research reader cares what the job was. No fact is added that the earlier bullets did not state.
- `published-version-with-eprint` **Each paper is one entry in `bibliographies/publications.bib`, the published version, with its preprint as `eprinttype = {iacr}` (or `{arXiv}`) and `eprint = {<id>}` (DBLP's field names). `cv.pdf` shows only the published version; the website links the DOI and the preprint (ePrint or arXiv), and the entry's `url` only when it has neither.** (Javi, 2026-11-17) Javi asked for the official DOI and the eprint on the website and only the published version on the CV; `resume.bst` ignores the eprint fields, so one entry serves both.
- `hackathons-as-awards` **There is no Hackathons section; each hackathon win is one dated line at the end of Honors and Awards (place, prize, role, event), newest first.** (Javi, 2026-11-17) Chosen with the question tool on 2026-11-17; the wins stay visible while the section's space goes to research.
- `cv-not-resume` **The document is called the CV everywhere: the source is `cv.tex`, the PDF is `cv.pdf`, the website's button and link say CV, and the build's step names and commit message say CV. The template's internals (`res.cls`, `resume.bst`, the `resume` environment) keep their names.** (Javi, 2026-11-17) Javi: rename resume to CV all around the site, for consistency with the website's CV button.
- `cv-old-address-kept` **The build also publishes the CV as `resume.pdf`, in the repository and on the website, next to `cv.pdf`.** (Javi, 2026-11-17) Chosen with the question tool: links already sent out (applications, LinkedIn, an email signature) keep working after the rename in `cv-not-resume`.
- `cv-button-opens-site-copy` **The website's CV button links to the site's own `cv.pdf`, which opens in the browser, not to the GitHub raw file, which downloads.** (Javi, 2026-11-17) Chosen with the question tool after the site audit.
- `photo-small-no-location` **The profile photo on the website is at most 500×500 pixels (twice its 250-pixel display size) with all metadata stripped, location included.** (Javi, 2026-11-17) Chosen with the question tool after the audit found the 3000×3000, 2.6 MB original carried the GPS position where it was taken.
- `site-bio-not-lists` **The website lists no Experience, Education or Honors and Awards: the bio says the current position, the latest research internship, the background (degree and former employers) and the honors in two short paragraphs, and the details stay in the CV PDF behind the CV button.** (Javi, 2026-11-17) Chosen with the question tool over one data file feeding both the CV and one-line lists on the site (al-folio, Hugo Blox, bamos/cv); it follows Joachim Neu's (https://www.jneu.net/) and Ling Ren's (https://sites.google.com/view/renling) homepages, which keep positions and fellowships in the bio, so there is nothing to keep in sync by hand.
