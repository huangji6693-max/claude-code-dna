# Cross-harness compatibility walkthrough

The DNA is markdown + bash + python3. No SDK, no plugin, no binary. That
means it ports to any agent harness that accepts a system prompt, rule
file, or persona file. This walkthrough shows the concrete copy-paste
steps for the 5 harnesses the project gets asked about most often.

## What ports cleanly vs not

| Layer | Ports to anything? | Why |
|---|---|---|
| `rules/karpathy-4-laws.md` | ✅ | Pure markdown, no `@` imports, no tool-specific syntax |
| `rules/operating-instincts.md` | ✅ | Same |
| `rules/dna-routing-table.md` | ✅ | Same |
| `rules/memory-optimization.md` | ⚠️ partial | The *philosophy* ports; the `@~/.claude/...` import syntax is Claude Code-specific. Other tools need a flat file. |
| `memory-system/` scripts | ✅ if bash + python3 | OS-level, harness-agnostic |
| `examples/CLAUDE.md` `@` imports | ❌ | Claude Code only |

The rule of thumb: anything in `rules/` is content; the only tool-specific
piece in this repo is the *loading mechanism*. Each section below shows
the right loading mechanism for one tool.

---

## Cursor

Cursor reads `.cursorrules` (single file at project root) or
`.cursor/rules/*.md` (directory of files, newer format). Both work.

### Single-file (legacy, simplest)

```bash
cd your-project
cat ~/.claude/rules/karpathy-4-laws.md \
    ~/.claude/rules/operating-instincts.md \
    > .cursorrules
```

### Directory (recommended for v0.40+)

```bash
cd your-project
mkdir -p .cursor/rules
cp ~/.claude/rules/karpathy-4-laws.md     .cursor/rules/
cp ~/.claude/rules/operating-instincts.md .cursor/rules/
cp ~/.claude/rules/memory-optimization.md .cursor/rules/
```

### Verify

Open Cursor, start a chat, ask:

> "What's Karpathy's third law and when does it apply?"

If the agent answers "surgical changes — every diff line traces back to
the user's request, no refactor-while-fixing" without searching, it's
loaded.

### Caveats

- Cursor's `.cursorrules` has no `@` import support — keep everything in one file or use the directory format
- Cursor's memory features are independent of this repo's memory architecture; use one or the other, not both, to avoid duplicate context
- Cursor truncates very long rule files in the sidebar UI but the agent still gets the full text

---

## Codex CLI (OpenAI)

Codex uses a single system prompt set via `--system` flag or `~/.config/codex/system.md`.

```bash
mkdir -p ~/.config/codex
cat ~/.claude/rules/karpathy-4-laws.md \
    ~/.claude/rules/operating-instincts.md \
    ~/.claude/rules/memory-optimization.md \
    > ~/.config/codex/system.md
```

Then either:

```bash
# Per-invocation:
codex --system ~/.config/codex/system.md "your task"

# Or set the path in ~/.config/codex/config.toml:
echo 'system_prompt = "~/.config/codex/system.md"' >> ~/.config/codex/config.toml
```

### Verify

```bash
codex "what's the verification gate and when do you run it?"
```

Look for a 5-step answer (IDENTIFY → RUN → READ → VERIFY → STATE). If it
gives a generic answer about testing, the rules didn't load — re-check
the `--system` path.

---

## Gemini CLI

Gemini CLI reads `~/.config/gemini/persona.md` (or `--persona` flag).

```bash
mkdir -p ~/.config/gemini
cat ~/.claude/rules/karpathy-4-laws.md \
    ~/.claude/rules/operating-instincts.md \
    > ~/.config/gemini/persona.md
```

### Verify

```bash
gemini "list the 4 Karpathy laws in one line each"
```

Expected: four laws, no exposition. If you get a paragraph essay, the
persona didn't load.

---

## Aider

Aider's `~/.aider.conf.yml` accepts a `--read` array for always-loaded
context files.

```yaml
# ~/.aider.conf.yml
read:
  - ~/.claude/rules/karpathy-4-laws.md
  - ~/.claude/rules/operating-instincts.md
```

Aider auto-loads these into every session. No restart needed — the files
are re-read each invocation.

### Caveat

Aider counts these toward its context budget, so don't load all 5 rules
unless you've raised the model's context limit. The 4 laws + operating
instincts is ~12KB — fine for any model.

---

## Continue.dev (VSCode extension)

Continue uses `~/.continue/config.json` with a `systemMessage` field.

```bash
SYSTEM=$(cat ~/.claude/rules/karpathy-4-laws.md \
             ~/.claude/rules/operating-instincts.md | \
         python3 -c "import json,sys; print(json.dumps(sys.stdin.read()))")
# Then paste $SYSTEM into the systemMessage field in config.json
```

Or use the new `~/.continue/rules/` directory (v0.9.200+) which accepts
markdown files directly:

```bash
mkdir -p ~/.continue/rules
cp ~/.claude/rules/karpathy-4-laws.md     ~/.continue/rules/
cp ~/.claude/rules/operating-instincts.md ~/.continue/rules/
```

---

## What the doctor *won't* catch in non-Claude harnesses

`dna-doctor.sh` validates the source repo and a Claude Code install. It
can't see Cursor's `.cursorrules` or Codex's `~/.config/codex/`. So your
per-harness verification is the "ask the agent a rule-specific question"
test in each section above.

If you want a doctor-style audit across harnesses, that's not yet built
— see [the roadmap](../README.md#roadmap). PRs welcome.

## Combining harnesses

Several developers run this repo across Claude Code + Cursor
simultaneously (e.g., Claude for terminal work, Cursor for editing). The
rules behave identically in both because they're just markdown. Memory,
however, is single-source: pick one tool to own `~/.claude/projects/*/memory/`
and read-only it from the other, or you'll get write conflicts.

## See also

- [docs/TROUBLESHOOTING.md](../docs/TROUBLESHOOTING.md#compatibility-issues) — common loading failures
- [examples/CLAUDE.md](CLAUDE.md) — the Claude Code-native `@` import pattern
- [docs/COMPARISON.md](../docs/COMPARISON.md) — how this stacks with tools that have their own rule systems
