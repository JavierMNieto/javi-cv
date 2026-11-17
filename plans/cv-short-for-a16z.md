# The résumé gives one line to each undergraduate job and lists the hackathon wins as awards

Short plan, 17 November 2026, by the assistant with Javi; the maker builds it (form: compact).
Read with `.claude/rules/writing-style.md` and `.claude/rules/latex-style.md` (in `/Overleaf/.claude/rules/`).

## What was asked

Javi sends this CV with his application to the a16z Frontier research internship, due 20 November 2026 at 12 p.m. PT. He asked to shorten the undergraduate internships and the hackathons; the wins stay, as lines under Honors and Awards. The Category Labs entry he wrote stays as he wrote it.

## Decided, 17 November 2026

- Each of the three undergraduate jobs (Amazon Robotics, AASI, DecisionQ) keeps its heading lines and gets one bullet, kept from its strongest existing bullet: the research reader cares what the job was, not the tool list (assistant's advice, agreed by Javi).
- The Hackathons section goes; each win becomes one dated line at the end of Honors and Awards, newest first (Javi, question tool).
- No fact is added that his current bullets do not state.

## Done when

- `make` in `/Overleaf/javi-cv` ends with no error and writes `resume.pdf`.
- When Javi opens `resume.pdf`, then each of Amazon Robotics, AASI and DecisionQ shows one bullet, the Hackathons heading is gone, and Honors and Awards ends with the two hackathon lines, 2020 then 2018.
- When he looks at the Category Labs entry, then it reads as it does today, with only the date range's dash changed.
- `git diff resume.tex` shows changes only in Honors and Awards, Experience and Hackathons, and the date dashes.
- The page count of `resume.pdf` is the same or lower than before the change (check with `pdfinfo` before and after).

## The change

`resume.tex` only.

- **Honors and Awards**: after the Sloan Scholar line, add the two hackathon lines from "The words", each ending `\hfill <year> \\`, the last line keeping the `\\` the Sloan line has today.
- **Experience**: in each of the Amazon Robotics, AASI and DecisionQ entries, replace the `list2` items with the single item from "The words". The heading lines (company, place, title, dates) stay.
- **Hackathons**: delete the `\section{\sc Hackathons}` and both entries under it. Leave the commented-out blocks after them as they are.
- **Dates**: date ranges in Education and Experience use `--` (`May -- Aug 2022`), per writing-style.md's "Properly use `-`, `--`, `---`".
- **Skills**: "Golang" becomes "Go", matching the job bullets.

## The words

| String | Where | Kind | Shown by | Rests on |
|---|---|---|---|---|
| `1st place (\$10,000) as team lead, WWT STEM Student Forum hackathon` + `\hfill 2020` | Honors and Awards | award line | PDF | his WWT bullets ("Led ... team of 10 students to win \$10,000 for 1st place") |
| `3rd place (\$2,500) as team lead, GlobalHack VII international hackathon` + `\hfill 2018` | Honors and Awards | award line | PDF | his GlobalHack bullets |
| `Built a Python dashboard that attributes robot test errors to the responsible teams and flags flaky tests` | Amazon Robotics | bullet | PDF | his three Amazon bullets merged |
| `Optimized flight paths in C++ over 10,000 airports and 500 refueling routes for AROPS, Rolls-Royce's planning system for over 600 U.S. Air Force tanker aircraft` | AASI | bullet | PDF | his AASI bullets 1 and 3; "aircrafts" corrected |
| `Designed concurrent Go pipelines that load over 14 terabytes of Ethereum-based blockchain data into PostgreSQL` | DecisionQ | bullet | PDF | his DecisionQ bullets 1 and 2 |
| `Go` | Technical Skills | list item | PDF | "Golang" renamed to match the bullets |

## Building it

Run `pdfinfo resume.pdf | grep Pages` before the edit, make the edit, run `make`, and check the page count again. Do not commit, stage or push: Javi commits, and a push to `master` publishes the website.

## Not in this plan

- The Category Labs entry's wording, the publications and their `.bib` entries.
- The website's pages.
- A research statement or anything else in the a16z application.

## Sources

None: every string comes from Javi's existing bullets.

## Decisions for Javi

None.
