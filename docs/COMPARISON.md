# How claude-code-dna compares

Honest, sharp-edged comparison with the closest neighbors. If one of these
serves you better, install that one instead — they're all good projects solving
adjacent problems.

## At a glance

| Project | What it ships | Best fit when you want |
|---|---|---|
| **claude-code-dna** *(this repo)* | Behavioral rules + memory architecture + audit tooling + catalog | The *reflexes* that make any skill behave; cross-session memory done right |
| [SuperClaude_Framework](https://github.com/SuperClaude-Org/SuperClaude_Framework) | 30+ slash commands + 16 agents + 7 behavioral modes | Pre-built workflows and personas to invoke as commands |
| [agent-rules](https://github.com/steipete/agent-rules) | Guardrail rules + helper scripts for Claude Code and Cursor | Universal "don't do this" rules across tools |
| [claude-token-efficient](https://github.com/drona23/claude-token-efficient) | One drop-in `CLAUDE.md` to reduce verbosity | One specific problem solved (terse responses) |
| [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) | 19 agents + 4 orchestration modes | Multi-agent parallelization patterns |
| [andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) | The 4 anti-pattern laws packaged as a skill | Just the 4 laws, nothing else |
| [memory-bank (Nagendhra-web)](https://github.com/Nagendhra-web/memory-bank) | Persistent memory skill — token savings, session protocol | Memory only, without the surrounding rules |
| Awesome-lists (hesreallyhim, LangGPT, helloianneo, etc.) | Curated links | Discovery |

## Decision matrix

### Pick **claude-code-dna** if:

- You want the agent to **internalize reflexes** that fire without being asked (verification gate, TDD, root cause)
- You want **cross-session memory** that doesn't bloat context (mem0 ADD-only + langmem 3-types + GraphRAG community summaries)
- You want **audit tooling** for the skills you already installed (`skill-spec-audit.sh` against agentskills.io)
- You want one **<200KB drop-in** instead of 5 partial overlapping packages

### Pick **SuperClaude_Framework** instead if:

- You want **pre-built commands** to invoke (`/analyze`, `/build`, etc.) — claude-code-dna gives reflexes, not commands
- You want **personas** to swap into — claude-code-dna keeps the agent as itself, just better-behaved
- You're comfortable with **larger surface area** in exchange for more out-of-the-box utility

### Pick **agent-rules** instead if:

- You want **rules-only** without the memory architecture
- You're using **multiple AI tools** (Cursor + Claude + others) and need the same minimal guardrails everywhere
- The audit scripts and catalog don't matter to you

### Pick **claude-token-efficient** instead if:

- Your **only** problem is the agent being too verbose
- You don't want any other behavioral changes

### Pick **andrej-karpathy-skills** instead if:

- You want **just the 4 laws** as a callable skill, not as always-loaded rules
- You don't want the operating instincts, memory, or catalog

### Pick **memory-bank** instead if:

- You want **memory only**, with no rules layer
- You want a **session continuation protocol** baked in
- You're OK with vendor-specific skill format

### Pick **awesome-lists** if:

- You're **discovering** for the first time and want a flat menu
- You're not yet committed to any particular methodology

## How they stack

You can install several of these together. They occupy different layers:

```
┌─────────────────────────────────────────────────────┐
│  awesome-lists                                      │  ← discovery
├─────────────────────────────────────────────────────┤
│  Skills (anthropics/skills, individual repos)       │  ← what the agent CAN do
├─────────────────────────────────────────────────────┤
│  Agents (wshobson/agents, etc.)                     │  ← delegation surfaces
├─────────────────────────────────────────────────────┤
│  Commands (SuperClaude, oh-my-claudecode)           │  ← how you INVOKE workflows
├─────────────────────────────────────────────────────┤
│  Rules + Memory + Audit (claude-code-dna)           │  ← how the agent BEHAVES across all of the above
└─────────────────────────────────────────────────────┘
```

claude-code-dna sits at the bottom layer — it shapes how every layer above behaves. Adding it doesn't remove the need for skills/agents/commands; it makes them all behave better.

## What we deliberately don't compete with

- **Skill bundles.** We catalog upstream; we don't redistribute. Use the catalog to install from source.
- **MCP server collections.** Not in scope — MCP is about tool surface, not agent behavior.
- **IDE-specific extensions.** The rules are markdown; they work everywhere markdown is read.
- **Plugin marketplaces** (`/plugin marketplace add ...`). We're a single git repo, intentionally.

## Why we don't bundle SuperClaude or oh-my-claudecode patterns

Two reasons:

1. **License + attribution complexity.** Mixing rule packs from 5+ upstream MIT/Apache projects under one umbrella creates attribution debt.
2. **Bundle staleness.** A snapshot of SuperClaude inside this repo would be stale the day after SuperClaude releases. The catalog approach stays fresh because it points at upstream HEAD.

If you want the SuperClaude commands *and* this DNA, install both. They don't conflict — one provides commands, the other provides reflexes.

## Honest weaknesses

To match the comparison's honesty, here's where this repo is **weaker** than alternatives:

- **No GUI / dashboard.** SuperClaude and davila7/claude-code-templates have web UIs. We're CLI only.
- **No pre-built personas/modes.** You don't get `/analyst` or `/architect` commands out of the box. Use the wshobson/agents catalog if you want those.
- **Smaller community.** This is a young repo. SuperClaude has years of issue history; we have weeks.
- **No CI/CD for the catalog.** Catalog entries are hand-curated. There's no nightly job verifying upstream links are still alive (yet — see roadmap).
- **Chinese-language origin.** Some rule files still have Chinese commentary alongside English. Full English translation is on the roadmap.

If any of those matter to you, pick another tool — or send a PR.

## When to combine vs choose one

Combine `claude-code-dna` with:

- ✅ Any **awesome-list** (they're discovery, we're behavior)
- ✅ **Skills you install from upstream** (we make them behave better)
- ✅ **SuperClaude commands** (we don't add commands; they don't add rules)
- ✅ **agent-rules** (we have some overlap; install both, the latter wins where they overlap)

Don't combine with:

- ❌ Another memory architecture (mem0 SDK, memory-bank skill) — they fight each other
- ❌ Another rules-system that auto-loads its own `karpathy-4-laws.md` — pick one

## Verdict

If you're starting fresh: read [README](../README.md), run `install.sh`, read `examples/karpathy-laws-in-action.md`, and decide if the reflexes feel like what you want.

If you have an existing setup: install side-by-side — the audit script alone (`skill-spec-audit.sh`) will tell you within 60 seconds whether your current skills meet the agentskills.io spec.
