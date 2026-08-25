---
name: idea-crucible
description: "Put an idea or proposal through a three-pass evaluation — fierce critique, genuine steelman, honest verdict with a commit-to-one recommendation — delivered as a self-contained, presentation-grade HTML report fit for board meetings. Input can be a document, a set of files, or a pasted paragraph. Trigger: '/idea-crucible', 'critique this idea', 'stress-test this proposal', 'steelman and critique', or any ask to evaluate whether an idea deserves attention or budget."
---

# /idea-crucible — three-pass idea evaluation

Evaluate an idea using the protocol in [PROMPT.md](PROMPT.md) (same directory as this file). PROMPT.md is the single source of truth for the protocol — read it in full and follow it exactly; do not improvise a different structure. It is deliberately model- and agent-agnostic so it can be pasted into any LLM; this wrapper only handles intake and output for agents that support skills.

## Usage

```
/idea-crucible <paragraph describing the idea>
/idea-crucible <path/to/proposal.md>
/idea-crucible <path/to/dir/>            # evaluates the doc set as one idea
/idea-crucible                           # ask the user to paste or point to the idea
```

## Steps

1. **Gather the input.**
   - Inline text → that is the idea.
   - File path(s) → Read them all. A directory → read the documents inside it (skip build artifacts and code unless the code IS the proposal).
   - Nothing usable → ask the user to paste the idea or give a path. This is the only question you ask; per the protocol, thin input gets stated assumptions, not an interview.

2. **Run the protocol.** Follow PROMPT.md's three passes and ground rules. For substantial doc sets, anchor findings with `file:line` references so they're easy to jump to.

3. **Render the report.** The default deliverable is a self-contained, presentation-grade HTML file — follow [REPORT.md](REPORT.md) (rules + checklist) and fill [TEMPLATE.html](TEMPLATE.html); write `<kebab-slug-of-idea>-crucible.html` next to the source material (or in the working directory for pasted text). Run REPORT.md's pre-delivery checklist before handing it over.

4. **Deliver.** Give the file path plus a short conversational summary: the recommendation, confidence, and the top findings. Skip the HTML file only if the user explicitly asks for a conversation-only answer (then use PROMPT.md's four-section format inline).

## Rules

- Do NOT spawn subagents, creator-critic loops, or other orchestration for this — the adversarial structure is inside the prompt itself. One pass, done well.
- Do not soften the critique or the verdict because the author may be the user. The value of this skill is that it doesn't flatter.
- If the user supplies extra context ("we already have budget", "assume the team is 2 people"), treat it as part of the idea's material — it constrains the critique and the verdict.
