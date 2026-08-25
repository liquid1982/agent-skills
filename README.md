# Idea Crucible

An agent skill that puts any idea or proposal through a three-pass evaluation:

1. **Fierce critique** — every hole, contradiction, and impractical aspect, each finding rated **FATAL / SERIOUS / FRICTION** and ordered by severity.
2. **Genuine steelman** — the strongest case a smart proponent would make, required to answer the critique head-on (repairs to the idea are allowed but must be flagged).
3. **Honest verdict** — what deserves attention, what doesn't, the real risks, and a commit-to-one recommendation: **PURSUE / PURSUE WITH CHANGES / TEST FIRST / PARK / KILL**, with confidence and tripwires.

Feed it a structured document, a set of files, or a two-line paragraph. Thin input gets stated assumptions and ranked open questions, not an interview. The prompt is built to resist the usual failure modes: strawmanning (it must restate the idea first and target the restatement), nitpick floods that bury the fatal flaw, steelmen that ignore the objections, and hedged "time will tell" verdicts.

## Install

```bash
npx skills add liquid1982/idea-crucible
```

Works with Claude Code, Cursor, Codex, Copilot, Windsurf, Cline, and any other agent supported by the [skills CLI](https://github.com/vercel-labs/skills). Then invoke it:

```
/idea-crucible <paragraph, file path, or directory>
```

or just ask: *"stress-test this proposal"*, *"critique this idea"*.

## Use without an agent

The full protocol lives in [`skills/idea-crucible/PROMPT.md`](skills/idea-crucible/PROMPT.md) and is deliberately model-agnostic — no tools, no agent assumptions. Paste the whole file into any LLM (ChatGPT, Gemini, a local model) and drop your idea into the `{{IDEA}}` placeholder at the bottom.

## Layout

- [`skills/idea-crucible/SKILL.md`](skills/idea-crucible/SKILL.md) — thin agent wrapper: intake (text / files / directory), output rules.
- [`skills/idea-crucible/PROMPT.md`](skills/idea-crucible/PROMPT.md) — the protocol itself, single source of truth.

## License

[MIT](LICENSE)
