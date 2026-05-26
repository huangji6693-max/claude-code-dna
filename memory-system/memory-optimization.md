# Memory System Optimization

> Synthesized from mem0 v3 (ADD-only), langmem (3 types × 2 timings), GraphRAG (community summary indexing), Karpathy's LLM KB (files+index beats vectors), dream-skill (consolidation), claude-memory-compiler (SessionEnd archival). Auto-loaded into every conversation.

---

## 1 · Core Principles (8 Iron Laws)

### 1. Memory stores facts. Rules store behavior.

- `~/.claude/projects/<proj>/memory/*.md` → **facts** (user / feedback / project / reference)
- `~/.claude/rules/**/*.md` → **behavioral rules** (procedural, e.g. "don't leave the user with a TODO list")
- The most common contamination is putting the wrong content in the wrong place: behavioral rules dumped into memory → MEMORY.md explodes past 200 lines, and other sessions can't see them anyway
- **Rule of thumb**: if the content is "next time, do X / don't do Y" → rules; if it's "the thing itself is X" → memory

### 2. Three types × two timings (langmem)

| Type | Content | When to write |
|---|---|---|
| **semantic** | Facts, preferences, project metadata | Hot-path (write immediately when explicitly stated) |
| **episodic** | A single success/failure case | After the task ends, filename includes date |
| **procedural** | What to do next time | **Don't write to memory. Write to rules.** |

Hot-path is **append-only**. No merging/dedup (that stalls the conversation). Consolidation goes to a background job.

### 3. ADD-only beats UPDATE (mem0 v3)

- Old memory turns out wrong → **write a new correction with the date**, downgrade the old link in MEMORY.md to `~~strikethrough~~`
- Why: preserves the decision timeline + prevents the LLM from accidentally deleting context
- Batch-archive monthly (delete the strikethrough entries)
- Exception: pure typos / path renames can be Edited directly

### 4. Index = community summary (GraphRAG + Karpathy KB)

Every hook line in `MEMORY.md` must answer three questions: **what it is / when to use it / current status**.

```
❌ Bad:  - [project-b lessons](feedback_project-b_lessons.md) — trading lessons
✅ Good: - [⭐ Trading wreckage lessons](feedback_project-b_lessons.md) — no counter-trend / no averaging-in / WEL / atomic write · read before every order
```

5× information density difference.

### 5. Explicit eviction rules (added to fill mem0/langmem gap)

Every memory's frontmatter must answer "when can this be deleted?". Suggested fields:

```yaml
expires_when: project_archived       # Delete after the project is archived
expires_when: superseded_by: <file>  # Replaced by a newer file
expires_when: never                  # User identity / iron law — never delete
expires_when: 30d_unused             # Demote if not referenced for 30 days
```

Memories without an `expires_when` field default to `30d_unused`.

### 6. Conflict resolution order

When two memories conflict, adjudicate in this order:

1. Narrower scope wins (project-specific > common)
2. More recent wins (frontmatter `updated:` field)
3. Higher priority marker (⭐⭐⭐) wins
4. None of the above → write a `conflict_<topic>.md` listing both sides, ask the user next time

### 7. Plain files + index > vector DB (Karpathy)

- Personal scale (<1000 entries): markdown + frontmatter + MEMORY.md index is fully sufficient
- Retrieval works by having the LLM read the index once and hit the right file — no Chroma/SQLite
- The filename is the index: `<type>_<scope>_<topic>.md` (e.g. `feedback_project-b_lessons.md`)
- Reconsider vectorization only **above 1000 entries** — currently project-a + project-b + project-c combined is nowhere near

### 8. Three-tier memory access

```
Session start (auto-injection):  MEMORY.md top-level index (must read · ≤200 lines)
Keyword hit:                     full text of the relevant feedback_*.md (on demand)
Cross-memory reasoning:          only when the user says "let's do a retrospective"
```

**Forbidden**: importing all `feedback_*.md` into CLAUDE.md → blows past the 200-line red line.

---

## 2 · Pre-write Checklist (before writing any memory)

- [ ] Is this a fact or a behavioral rule? (Behavioral → goes to `~/.claude/rules/`)
- [ ] Is there an overlapping entry already in MEMORY.md or the same-type file? (Grep keywords → if hit, Edit to merge rather than Write a new one)
- [ ] Does the filename follow the `<type>_<scope>_<topic>.md` template?
- [ ] Does the frontmatter contain `name / description / type / expires_when`?
- [ ] Are relative dates ("yesterday / last week") converted to absolute dates?
- [ ] Does the MEMORY.md index line's hook answer "what / when / status"?

---

## 3 · Anti-patterns (mistakes already made)

| Anti-pattern | Why it's wrong | Correct approach |
|---|---|---|
| Recording code patterns / architecture / paths in memory | Code is the first source of truth — memory will rot | Read the code / git blame |
| Stuffing behavioral rules into memory/feedback_*.md | Other project sessions can't see them | Put them in `rules/common/` |
| One memory per small preference | MEMORY.md blows past the 200-line red line | Merge same-topic entries into one file |
| Merging/deduping on the hot path | Stalls the conversation | Background hook handles it async |
| Spinning up Chroma/SQLite vector DB | Overkill for <1000 entries | Markdown + index is enough |
| Using relative dates like "yesterday" | All references break a few weeks later | Write absolute dates like `2026-04-20` |
| MEMORY.md with only links and no hooks | Hit rate craters | Every line needs a high-density hook |
| Auto-writing tons of memory at session end | Noise pollution | SessionEnd writes a marker only — consolidation needs a human |

---

## 4 · Compaction Survival Checklist

Iron laws that are most likely to get lost after context compaction (proactively check these at SessionStart in each session; restore from `operating-instincts.md` if missing):

- Self-check 4 questions before acting / no failing test, no code / no verification, no "done" / stop after 3 failed fixes
- Don't leave the user with a TODO — give them a done-list instead
- SSH heredocs must use `set -o pipefail`
- Demos always use `agent.example.com` — never `trycloudflare`
- APK / build / ffmpeg / inference all go to the VPS — don't run locally
- Answer in the user's language · no emoji decoration · no PUA tone

---

## 5 · Project-Isolation Loading Strategy (v2, implemented 2026-04-20)

The user explicitly requested: "don't let specific project memories from different chat sessions bleed into each other."
Claude Code's auto-memory mechanism injects the full `MEMORY.md` into every conversation's system context — if the top-level MEMORY.md lists every project's specific hooks, then project-a / project-b / project-c / tools details cross-contaminate.

### Current structure

```
~/.claude/projects/-root/memory/
├── MEMORY.md                 # Top-level index: only _global in full + a project routing table (no project-specific hooks expanded)
├── _global/                  # Cross-project (user preferences, SOPs, lib notes, toolchain) · always loaded
├── project-a/
│   ├── _INDEX.md             # project-a's own index · loaded on demand
│   └── <project-a-scoped>.md
├── project-b/
│   ├── _INDEX.md             # project-b's own index · loaded on demand
│   └── <project-b-scoped>.md
├── project-c/
│   └── _INDEX.md + scoped
└── tools/
    └── _INDEX.md + scoped
```

### Loading rules (default behavior at session start)

1. **Auto-load only consumes `MEMORY.md`** → the context contains only the full `_global/` index + 4 project routing entries (no project-specific file hooks exposed)
2. **When scope keywords appear in the conversation** → proactively `Read <scope>/_INDEX.md`, then read specific files as the index dictates
3. **Scope keyword mapping** (customize per your projects):
   - `project-a / <product-name> / <stack>` → project-a
   - `project-b / <product-name> / <stack>` → project-b
   - `project-c / <product-name> / <stack>` → project-c
   - `tools-pack / <utility-name>` → tools
4. **Cross-project requests load separately**: only read both INDEXes when actively discussing project-a + project-b together — don't pull both in by default
5. **Don't cross-reference during decisions**: when working on a project-a issue, don't cite project-b's session handoff / bug records as justification (and vice versa)

### Future direction: real cwd-hash isolation (requires user opt-in)

Claude Code's native auto-memory routes by cwd-hash (`~/.claude/projects/<cwd-hash>/memory/`). Currently all sessions launch from `/root`, so they all land under `-root`.

Fully-isolated approach:
- A project-a session launches from `/root/projects/project-a` → auto-memory automatically switches to a separate directory
- `_global` content gets symlinked or included into each project directory via a SessionStart hook
- Requires the user to decide on a project working-directory layout

The current v2 structure (slim MEMORY.md + per-subdirectory INDEX lazy-loading) already achieves the main goal of "no context contamination". The reason cwd switching wasn't done is to avoid changing the user's launch habits.

---

## 6 · Related Files

- `~/.claude/projects/*/memory/MEMORY.md` — per-project memory index
- `~/.claude/rules/common/operating-instincts.md` — 15 operating iron laws (the procedural workhorse)
- `~/.claude/rules/dna-routing-table.md` — scenario routing table (procedural)
- CLAUDE.md auto-memory section — memory system usage guide

Changing this file = changing global behavior. Edit with care.
