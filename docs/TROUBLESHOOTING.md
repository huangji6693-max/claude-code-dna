# Troubleshooting

Common issues people hit installing and running claude-code-dna, with the
actual cause and the actual fix.

---

## Install issues

### `install.sh: Permission denied`

```
$ ./install.sh
bash: ./install.sh: Permission denied
```

**Cause:** the executable bit got stripped (common after downloading the repo as a ZIP from GitHub).

**Fix:**
```bash
chmod +x install.sh scripts/*.sh
./install.sh
```

### `install.sh` exits with "backup directory exists"

```
$ ./install.sh
[ERROR] backup dir ~/.claude/.dna-backup already exists from a previous run
```

**Cause:** a previous install was interrupted and left the backup directory behind.

**Fix:** decide whether you want to restore or discard the prior backup.

```bash
# Inspect what's in the backup
ls -la ~/.claude/.dna-backup/

# If you want to keep the backup as a dated archive:
mv ~/.claude/.dna-backup ~/.claude/.dna-backup-$(date +%Y%m%d)

# If you're sure you don't need it:
rm -rf ~/.claude/.dna-backup

# Then retry
./install.sh
```

### Install seems to succeed but the agent doesn't behave differently

**Cause:** the `@` imports aren't reaching your active `CLAUDE.md`. Most common scenarios:

1. You have a per-project `CLAUDE.md` that shadows the global one.
2. Your global `CLAUDE.md` is in `~/CLAUDE.md` instead of `~/.claude/CLAUDE.md`.
3. The `@` imports point at a path that doesn't resolve.

**Diagnostic:**

```bash
# What does Claude Code load? (current working dir matters)
cat ~/.claude/CLAUDE.md 2>/dev/null
ls -la ~/.claude/rules/karpathy-4-laws.md

# In a Claude Code session, ask:
> What's the first law of Karpathy 4 Laws and when does it apply?
```

If the agent has to grep before answering, the import path is wrong.

**Fix:** see `examples/CLAUDE.md` for working `@` import patterns.

---

## Memory script issues

### `memory-health.sh` reports "broken links"

```
[ERR] MEMORY.md → project-a/feedback_old_thing.md (file missing)
```

**Cause:** you deleted a memory file but didn't update `MEMORY.md` (or the per-scope `_INDEX.md`).

**Fix:** remove the dangling link from the index, or restore the file. The script tells you which is which.

### `memory-search.sh` returns no results when you know the content exists

**Cause #1:** the search is BM25 — exact tokens matter. Try synonyms.

**Cause #2:** you scoped to the wrong project.

```bash
# Search everywhere instead of one scope:
~/.claude/scripts/memory-search.sh "your query"

# Search a specific scope:
~/.claude/scripts/memory-search.sh -s project-a "your query"

# Search by type only:
~/.claude/scripts/memory-search.sh -t feedback "your query"
```

**Cause #3:** the file lives outside the standard memory dir.

```bash
# Check where your memories actually live:
ls ~/.claude/projects/*/memory/
```

If your project dir doesn't appear, the cwd hash for that project hasn't received any memories yet.

### `memory-health.sh` flags files as "stale >90d" but I want to keep them

**Cause:** the rule defaults to "30d-90d unused → warn". You probably want to mark them as never-expiring.

**Fix:** add `expires_when: never` to the frontmatter.

```yaml
---
name: ...
description: ...
type: feedback
expires_when: never
---
```

---

## `skill-spec-audit.sh` issues

### Reports FAIL on a skill that you know is correct

**Cause:** the agentskills.io spec has hard requirements that aren't optional. Common FAILs:

- `name:` field missing or contains uppercase / underscores
- `description:` > 1024 characters
- File > 500 lines (recommended max)
- Frontmatter not closed properly (`---` on its own line)

**Fix:** open the skill's `SKILL.md` and fix the specific issue the audit names. The audit output includes line numbers.

```bash
# Run audit on a single skill for focused output:
./scripts/skill-spec-audit.sh ~/.claude/skills/my-skill
```

### Reports many WARN entries — should I worry?

WARN means "spec-recommended but not required". Common ones:

- `allowed-tools` field not set → consider adding for tighter permissions
- Skill name doesn't match directory name → confusing but legal
- Heading hierarchy skips H1 → harder for LLMs to parse

You can ignore WARNs at first. Address them when you have time.

### `Total skills: 0`

**Cause:** wrong path argument.

```bash
# Audit your global skills:
./scripts/skill-spec-audit.sh ~/.claude/skills

# Audit a project's skills:
./scripts/skill-spec-audit.sh ./my-project/.claude/skills
```

---

## Behavioral issues

### Agent still says "Done!" without verifying

**Cause #1:** the `operating-instincts.md` rule isn't loaded. Check your `CLAUDE.md`:

```bash
grep -l "operating-instincts" ~/.claude/CLAUDE.md
```

If grep finds nothing, add the import:

```markdown
@rules/operating-instincts.md
```

**Cause #2:** the rule is loaded but the agent forgot mid-session. This happens after long sessions because of context compaction. Remind it: *"verification gate before claiming done"* — once is usually enough; the rule re-engages.

### Agent over-refactors when asked to fix a small bug

**Cause:** Karpathy Law 3 (Surgical Changes) isn't loaded.

**Fix:** ensure `@rules/karpathy-4-laws.md` is imported in your `CLAUDE.md`. After loading, the agent should surface unrelated observations instead of touching them.

### Agent is too terse / too verbose

The DNA does **not** opinionate on response length. If you want terse:

- Combine with [drona23/claude-token-efficient](https://github.com/drona23/claude-token-efficient) — it's one CLAUDE.md focused on verbosity reduction
- Or add a personal rule: *"Default to ≤3 sentences unless asked to explain"*

---

## Compatibility issues

### Cursor doesn't load the rules

**Cause:** Cursor uses `.cursorrules` (file) or `.cursor/rules/` (dir) — both at the project root, not in `~/.claude/`.

**Fix:**

```bash
# Per-project:
cp ~/.claude/rules/karpathy-4-laws.md     .cursor/rules/
cp ~/.claude/rules/operating-instincts.md .cursor/rules/
cp ~/.claude/rules/memory-optimization.md .cursor/rules/

# Or as a single file:
cat ~/.claude/rules/karpathy-4-laws.md \
    ~/.claude/rules/operating-instincts.md \
    > .cursorrules
```

### Codex CLI / Gemini CLI / Aider doesn't auto-load

**Cause:** these tools have their own rule/persona loading mechanisms that don't read `~/.claude/`.

**Fix:** concatenate the rule files into the tool's system-prompt / persona / config file.

```bash
# Example for a Codex-style system prompt:
cat ~/.claude/rules/karpathy-4-laws.md ~/.claude/rules/operating-instincts.md \
  > ~/.config/your-tool/system-prompt.md
```

---

## Reporting bugs

If your issue isn't here:

1. Search [open issues](https://github.com/huangji6693-max/claude-code-dna/issues)
2. If new, open one with:
   - the command you ran
   - the full error output
   - your OS + `bash --version` + `python3 --version`
   - whether you cloned the repo or downloaded a ZIP
3. For security issues, see [SECURITY.md](../SECURITY.md) — don't open public issues for those.
