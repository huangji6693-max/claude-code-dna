# Example CLAUDE.md integration

This file shows how to wire `claude-code-dna` into your project or global `~/.claude/CLAUDE.md`.
After running `./install.sh`, the rules live under `~/.claude/rules/`. Use `@` imports to auto-load them every session.

---

## Minimal — just the 4 laws + memory architecture

Drop this at the top of any `CLAUDE.md` and you get the highest-leverage 50KB of behavior.

```markdown
@rules/karpathy-4-laws.md
@rules/memory-optimization.md
```

That's it. The 4 laws become a reflex (Think → Simplicity → Surgical → Goal-driven), and the memory architecture prevents context bloat.

---

## Recommended — full DNA stack

For agentic projects where you want the routing table, operating instincts, and the essence docs:

```markdown
@rules/karpathy-4-laws.md
@rules/operating-instincts.md
@rules/dna-routing-table.md
@rules/memory-optimization.md

# Optional, load only if relevant to your domain:
@rules/pageindex-essence.md
@rules/seo-geo-essence.md
@rules/warp-ruflo-skills-essence.md
```

Total imported: ~50KB of distilled behavior — under your usual CLAUDE.md budget.

---

## Project-specific layering

Use a global `~/.claude/CLAUDE.md` for the DNA, and a per-project `CLAUDE.md` for project specifics.

**`~/.claude/CLAUDE.md`** (global — always loaded):

```markdown
@rules/karpathy-4-laws.md
@rules/operating-instincts.md
@rules/dna-routing-table.md
@rules/memory-optimization.md

# Your personal preferences
- Respond in English unless the project is Chinese-language
- Avoid emojis in code commits
```

**`<project>/CLAUDE.md`** (per project — loaded when you cd in):

```markdown
# Stack
- Node 20, TypeScript 5.4, Vite, React 18
- Postgres 16, Prisma 5
- Deploy: Vercel

# Project-specific routing
- All migrations live in `prisma/migrations/` — never edit applied ones
- API contracts in `packages/contracts/` — change requires PR review

# Domain-specific rules (optional)
@~/.claude/rules/pageindex-essence.md   # we ingest 100-page PDFs
```

---

## Cursor / other agents

The rules are markdown — they work as `.cursorrules` or `.cursor/rules/*.md` with zero changes.

```bash
# For Cursor
cp ~/.claude/rules/karpathy-4-laws.md     .cursor/rules/
cp ~/.claude/rules/operating-instincts.md .cursor/rules/
cp ~/.claude/rules/memory-optimization.md .cursor/rules/
```

For Codex / Gemini CLI / Aider — concatenate the rules into your system prompt or persona file.

---

## Verify the integration

After installing and adding the `@` imports, kick off a session and ask:

> "What's the first law of Karpathy 4 Laws and when should you apply it?"

If the agent answers without searching — DNA is loaded. If it has to grep — your `@` import path is wrong.

Then run a periodic audit:

```bash
~/.claude/scripts/memory-health.sh
~/.claude/scripts/skill-spec-audit.sh ~/.claude/skills
```

These should be green (or have known WARN counts you've accepted).
