# Memory workflow — a concrete walkthrough

This is what working with the 3-layer memory architecture actually looks like, end-to-end, on a single project.

## The setup

```
~/.claude/projects/<cwd-hash>/memory/
├── MEMORY.md                  # always loaded · ≤200 lines
├── _global/                   # cross-project (always-loaded global memories)
│   └── user_profile.md
├── project-a/                 # project-scoped (lazy-loaded)
│   ├── _INDEX.md
│   ├── feedback_deploy_path.md
│   └── reference_s3_creds.md
└── project-b/                 # another project (lazy-loaded)
    ├── _INDEX.md
    └── feedback_no_pua_tone.md
```

`MEMORY.md` lists only the always-loaded global section + project routing table (one line per project). Project specifics live in `<scope>/_INDEX.md` and are loaded **only when keywords from that scope appear in conversation**.

## Day 1 — first conversation with a new project

You start a session and the agent reads `MEMORY.md`. It sees:

```markdown
# Memory Index

## [global] always loaded
- [User profile](_global/user_profile.md) — calls user "boss", prefers terse replies
- [No PUA tone](_global/feedback_no_pua_tone.md) — no fake enthusiasm, no emoji decoration

## [projects] lazy load on keyword
| scope     | trigger keywords                          |
|-----------|-------------------------------------------|
| project-a | "project-a", "the SaaS", "billing"        |
| project-b | "project-b", "the trading bot", "binance" |
```

You ask: *"how should I deploy project-a?"*

The agent sees `project-a` in your message → opens `project-a/_INDEX.md` → finds the `feedback_deploy_path.md` entry → reads it → answers based on real history, not generic advice.

Project-b context never enters this session. Zero cross-contamination.

## Day 1 (continued) — adding a memory

After deploying, you tell the agent: *"the deploy path is /var/www/project-a, not /opt/app — I just spent 30 min debugging this."*

The agent writes a new memory:

```bash
# ~/.claude/projects/<cwd-hash>/memory/project-a/feedback_deploy_path.md
---
name: project-a deploy path
description: production deploy lives at /var/www/project-a (not /opt/app); cost the boss 30min today
type: feedback
expires_when: superseded_by_better_path_or_project_archived
updated: 2026-05-26
---

Production deploy is `/var/www/project-a`, NOT `/opt/app`.

**Why:** Today (2026-05-26) the boss spent 30 minutes debugging because I assumed `/opt/app`.

**How to apply:** Before suggesting any deploy command for project-a, default to `/var/www/project-a`. If the user mentions `/opt/app`, push back — that's the wrong path.
```

Then updates `project-a/_INDEX.md`:

```diff
+ - [⭐ deploy path](feedback_deploy_path.md) — /var/www/project-a (not /opt/app) · cost 30min
```

The frontmatter `expires_when` tells future-you when this memory can be deleted.

## Day 30 — same project, different agent session

You start fresh. Agent reads `MEMORY.md` (sees only global + routing table). You say: *"redeploy project-a"*.

Trigger fires → `project-a/_INDEX.md` loads → the deploy_path memory loads → agent uses `/var/www/project-a` immediately, no asking, no /opt/app mistake.

The fact survived the 30-day gap because it was written down on day 1.

## Day 45 — searching memory

You vaguely remember telling Claude about something months ago. You don't remember which project:

```bash
$ ~/.claude/scripts/memory-search.sh "deploy path debugging"

  4.21  project-a/feedback_deploy_path.md
        └─ /var/www/project-a (not /opt/app) · cost 30min

  1.83  project-b/feedback_postdeploy_smoketest.md
        └─ binance api ping must precede any trade enable
```

BM25-style relevance ranking across all memory files in <50ms. No vector DB, no embeddings, no LangChain — just bash + awk + a tuned scoring function. Works up to ~1000 files; past that, swap for a vector backend.

## Day 60 — memory health check

```bash
$ ~/.claude/scripts/memory-health.sh

[OK] MEMORY.md = 142 lines (limit 200)
[OK] 47 memory files (markdown-only threshold 1000)
[OK] all MEMORY.md links resolve
[OK] all files have valid frontmatter
[WARN] 3 files untouched >90d
        - project-a/reference_dead_endpoint.md
        - project-b/feedback_yolo_mode.md
        - _global/reference_old_vendor.md
        review their `expires_when` clause

== SUMMARY: 0 err / 1 warn ==
```

The warn surface flags stale memories. You triage each — keep, update, or delete. The system stays clean by design instead of by hope.

## The principle

Memory is for facts, not behavior. Behavior goes in `rules/` (which auto-loads). Facts go in `memory/` (which loads on demand).

If you find yourself writing the same instruction every project ("always use pnpm, never npm"), that's a `rules/` candidate. If it's project-specific ("project-a's pnpm-lock is in `apps/web/`"), it's `memory/`.

Getting this split right keeps both surfaces small and load fast.

## Quick reference

| Operation | Command |
|---|---|
| Audit memory health | `~/.claude/scripts/memory-health.sh` |
| Search memory | `~/.claude/scripts/memory-search.sh "query"` |
| Search a single scope | `~/.claude/scripts/memory-search.sh -s project-a "query"` |
| Search by type | `~/.claude/scripts/memory-search.sh -t feedback "query"` |
| Read a specific memory | `cat ~/.claude/projects/*/memory/<scope>/<file>.md` |

See `memory-system/memory-optimization.md` for the 8 hard rules and the full design rationale.
