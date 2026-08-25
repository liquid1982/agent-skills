# The report — rendering the evaluation as a presentation-grade HTML document

The default deliverable of this skill is a **single self-contained HTML file** that presents the full three-pass evaluation. It must be defensible in high-stakes settings — a board meeting, a public event — which means the bar is not "looks nice": every claim traceable, every severity legible, nothing decorative that could be attacked as padding.

Run the protocol in [PROMPT.md](PROMPT.md) **first and in full**. The report is a rendering of a finished evaluation, never a substitute for one. Write the analysis, then pour it into the template.

## The template

Start from [TEMPLATE.html](TEMPLATE.html) in this directory — copy it and replace the `{{PLACEHOLDERS}}`; duplicate the blocks marked `repeat` per item. Do not redesign it ad hoc: the tokens, spacing, and structure ARE the quality bar. You may extend it only where the content genuinely demands it (e.g., more steelman subsections), staying inside its design system.

Document order (deliberately different from analysis order — decision-makers read page one):

1. **Masthead** — idea title, one-sentence description, meta row (date, evaluator, source material, method).
2. **Verdict banner** — the recommendation up front: the chosen call, one-sentence rationale, the five-option scale with exactly one chip active, confidence + what would flip it.
3. **Stat tiles** — finding counts by severity, open-question count. Real counts only.
4. **01 · The idea as I understand it** — the restatement; assumptions box only if the input was thin.
5. **02 · Critique** — framing paragraph naming the strongest single objection, then findings ordered FATAL → SERIOUS → FRICTION, each with a stable ID (F1, F2, …).
6. **03 · Steelman** — why-now, upside, answers keyed to finding IDs (`Re F1 —`), repairs marked with the `Repair` chip, the kernel worth keeping.
7. **04 · Honest verdict** — where the truth sits, attention / not / risks / realism callouts, the recommendation restated in full, tripwires table (T1, …), open questions table (Q1, …).
8. **Footer** — method note.

## Hard rules

- **Self-contained, zero fetched resources.** No webfonts, no CDN CSS/JS, no external images, no `<script>` at all. Outbound hyperlinks are fine; anything the browser would *download* is not. The file must render perfectly from `file://`, offline, in any modern browser — a boardroom has no guaranteed network.
- **Nothing invented.** No charts, percentages, or market figures that aren't in the source material or explicitly derived from it (show the derivation). A fabricated-looking visual is the fastest way to lose a boardroom. If the material contains no numbers, the report contains no numbers — the stat tiles count findings, which are yours to count.
- **Every finding anchored.** Each critique card carries a quote or tight paraphrase from the source plus a locator (`file:line`, section, or page). If the input was a verbal paragraph, anchor to its exact words.
- **IDs are load-bearing.** F/T/Q numbering must be consistent everywhere — the steelman's `Re F2` must answer the card labeled F2. Cross-reference by ID, never by "the point above".
- **Severity is never color-alone.** The word (FATAL/SERIOUS/FRICTION) and the shape mark (▮ / ▲ / ●) always accompany the color — the template does this; keep it intact for colorblind readers and grayscale print.
- **Verdict color mapping:** PURSUE and PURSUE WITH CHANGES → `var(--good)` · TEST FIRST → `var(--caution)` · PARK → `var(--friction)` · KILL → `var(--fatal)`. Set it via the `--verdict` style on both banners; both must match, and the active chip must match the recommendation text.
- **Numbers and values stay in ink** (`--ink`), never tinted with a status color — the tag and mark carry severity, the text stays neutral and legible.
- **Prose discipline.** Finding bodies 60–120 words; callout bullets one sentence each; no filler sections. An empty section (e.g., zero FATAL findings) is stated in one line ("No fatal findings."), not padded.
- **File naming:** `<kebab-slug-of-idea>-crucible.html`, written next to the source material when the input was files, otherwise in the working directory.

## Pre-delivery checklist

Verify before handing the file over — each item is a way reports die in the room:

1. Open-from-disk test: no console errors, no network requests (grep the file: no `http` in `src=` or `<link href=`).
2. Recommendation appears identically in three places: banner word, active chip, restated banner in §04.
3. Stat-tile counts equal the actual number of finding cards per severity.
4. Every F-id referenced in §03/§04 exists in §02, and every FATAL/SERIOUS finding gets an answer (or an explicit concession) in §03.
5. Print preview: sections break cleanly, cards don't split, still legible in grayscale.
6. Read the verdict banner alone, out of context — it must be a complete, defensible position in itself, since it's the only part many readers will read.
