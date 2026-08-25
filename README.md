# agent-skills

Reusable, agent-agnostic skills by [@liquid1982](https://github.com/liquid1982). Each skill is a self-contained directory under [`skills/`](skills/) with a `SKILL.md` wrapper (for agents) and, where it makes sense, a portable `PROMPT.md` core you can paste into any LLM directly.

## Install

```bash
npx skills add liquid1982/agent-skills                          # interactive picker
npx skills add liquid1982/agent-skills --skill idea-crucible    # a specific skill
npx skills add liquid1982/agent-skills --skill '*'              # everything
```

Works with Claude Code, Cursor, Codex, Copilot, Windsurf, Cline, and any other agent supported by the [skills CLI](https://github.com/vercel-labs/skills). Discover more skills at [skills.sh](https://skills.sh).

## Skills

### [idea-crucible](skills/idea-crucible/)

Puts any idea or proposal through a three-pass evaluation:

1. **Fierce critique** — every hole, contradiction, and impractical aspect, each finding rated **FATAL / SERIOUS / FRICTION** and ordered by severity.
2. **Genuine steelman** — the strongest case a smart proponent would make, required to answer the critique head-on (repairs to the idea are allowed but must be flagged).
3. **Honest verdict** — what deserves attention, what doesn't, the real risks, and a commit-to-one recommendation: **PURSUE / PURSUE WITH CHANGES / TEST FIRST / PARK / KILL**, with confidence and tripwires.

Feed it a structured document, a set of files, or a two-line paragraph. Thin input gets stated assumptions and ranked open questions, not an interview. The prompt is built to resist the usual failure modes: strawmanning (it must restate the idea first and target the restatement), nitpick floods that bury the fatal flaw, steelmen that ignore the objections, and hedged "time will tell" verdicts.

```
/idea-crucible <paragraph, file path, or directory>
```

No agent? Paste [`skills/idea-crucible/PROMPT.md`](skills/idea-crucible/PROMPT.md) into any LLM and drop your idea into the `{{IDEA}}` placeholder.

## Layout

Each skill follows the same shape:

- `skills/<name>/SKILL.md` — thin agent wrapper: name/description frontmatter, intake and output rules.
- `skills/<name>/PROMPT.md` — the model-agnostic protocol, single source of truth.

## License

[MIT](LICENSE)
