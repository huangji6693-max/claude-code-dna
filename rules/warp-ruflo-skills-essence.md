# Warp + Ruflo + anthropics/skills Essentials · Auto-loaded (decision matrix + triggers + quick reference)

> Full deep reads (Read on demand):
> - `~/.claude/references/anthropics-skills-deep.md` — agentskills.io spec + 17 templates + skill-creator eval protocol
> - `~/.claude/references/warp-deep.md` — Warp Rust architecture + Agent Mode + Block-as-object + spec-PR flow
> - `~/.claude/references/ruflo-deep.md` — claude-flow rebrand · 46k stars · Federation/AgentDB/GOAP/Verification

## Three libraries, one-line positioning

| Library | What it is | Unique core value |
|---|---|---|
| **anthropics/skills** | Official 17 skills + agentskills.io formal spec (131k stars) | **Spec layer + eval layer** · the two things the existing 179 community skills lack |
| **warpdotdev/warp** | Rust agentic terminal · client open-source · ships with 20 skills | **Block-as-object + mandatory spec-PR gate + skill format 100% interoperable with Anthropic** |
| **ruvnet/ruflo** | claude-flow rebrand · 46k stars · industrial-grade agent orchestration | **Federation across machines with zero trust + AgentDB(HNSW) + GOAP A\* planner + byte-signature verification** |

## When to auto-load the full doc (signal-word hit → Read)

| Scenario | Signal words | Which doc to read |
|---|---|---|
| Writing / reviewing / editing a skill | "write a skill / SKILL.md / improve description / skill eval / agentskills.io / audit 179 skills" | anthropics-skills-deep |
| Agent tool allowlist | "allowed-tools / skill-level permissions / narrow tools" | anthropics-skills-deep |
| Terminal / CLI agent UI | "warp / agentic terminal / block-as-object / addressable command blocks / replay / add X to RTK" | warp-deep |
| Spec-driven flow | "spec-PR / spec-driven / specs directory / PRODUCT.md + TECH.md before code" | warp-deep |
| Three-tier feature flags | "dogfood/preview/release / runtime flag" | warp-deep |
| Agent orchestration framework | "ruflo / claude-flow / multi-agent orchestration / Queen-led swarm" | ruflo-deep |
| Cross-machine agents | "agent federation / zero-trust collaboration / mTLS+ed25519 / PII 4-tier BLOCK/REDACT/HASH/PASS" | ruflo-deep |
| Persistent agent memory | "AgentDB / HNSW / SONA / ReasoningBank / trajectory learning" | ruflo-deep |
| State-space planner | "GOAP / A* planner / state-space search replacing CoT" | ruflo-deep |

**Doesn't trigger**: invoking specific skills day-to-day / regular terminal commands / single-shot single-agent tasks.

## 12 Engineering Patterns to Steal Immediately (essentials across all three)

### Skill spec (from anthropics/skills)
1. **Description = trigger** (not explanation) · write "what it does + when to use + keywords" · ≤1024 chars · use "should / must / don't" voice
2. **500-line hard cap · split into references/ if over** · `SKILL.md` main file stays lean · long docs split into topic files
3. **Imperative + explain "why"** · against the ALL-CAPS-MUST anti-pattern · "LLMs respond better to reasoning than to commands" (**matches the user's 'no PUA tone' feedback exactly**)
4. **Eval protocol**: `evals.json` + 20 queries (10 should-trigger + 10 should-not-trigger) + 60/40 train-test split + 5 iterations to pick the best description
5. **`allowed-tools` field**: skill-level permission narrowing · experimental but already in the spec · removes dependency on global `settings.json` allow

### Warp (CLI / agent UI patterns)
6. **Runtime feature flags > #[cfg]** · three tiers dogfood/preview/release · switch without recompile · easy PR cleanup
7. **Block-as-object** · model command output as an entity (id + metadata + exit_code + cwd + ai_context) · addressable / shareable / replayable / injectable into the agent
8. **Action / ActionResult / Citation trio** · every agent tool call uses a typed action + typed result + mandatory citation (prevents hallucination, makes everything auditable)
9. **Diff validation gate** · agent-generated patches must pass validators (syntax / types / lint) before apply · failures loop back to regenerate
10. **Spec-PR before Code-PR** · `specs/<ticket>/PRODUCT.md + TECH.md` must clear review before any code · mandatory for 1k+ LOC / cross-subsystem changes

### Ruflo (agent orchestration depth)
11. **Federation trust score formula**: `0.4 × success + 0.2 × uptime + 0.2 × threat + 0.2 × integrity` · behavior-driven trust up/down-grading
12. **GOAP A\* replaces CoT**: natural language → explicit state-space visualization → on failure, replan instead of restarting the conversation

## The Format Interop (this is the gold)

**Warp `.agents/skills/` and Anthropic `anthropics/skills/skills/` use the exact same SKILL.md format**:
```
---
name: kebab-case-name           # ≤64 chars · [a-z0-9-]+
description: what + when + keywords   # ≤1024 chars
allowed-tools: Bash(git:*) Read       # optional · skill-level permissions
---

Body (≤500 lines)
```
→ Any existing skill collection can be **audited for compliance** under this spec + **reused across tools** (Claude Code / Warp / any agent that implements the spec).

## How these three complement the 11-library DNA (pure delta, no overlap)

| Source of delta | Content | Use |
|---|---|---|
| anthropics/skills | Spec length + regex constraints / eval protocol / allowed-tools | Add a compliance audit gate to `skillify` and `skill-stocktake` |
| warp | Block-as-object / spec-PR / 3-tier feature flags | RTK could add `rtk replay <id>` · big changes mandate spec-PR |
| ruflo | Federation / AgentDB / GOAP planner / signature verification | Drop in wholesale when doing cross-machine agent collaboration |

**Already covered (don't re-absorb)**:
- Skill creation (already have `skillify` / `writing-skills`)
- Document / frontend skills (already have `pptx-pro / docx-pro / frontend-design`)
- Agent orchestration (already have `dispatching-parallel-agents` / oh-my-claudecode)
- Progressive disclosure tiers ≈ Karpathy Law 2 + memory-optimization 3-tier access

## Project relevance

- **Consumer apps** weak fit (web/mobile-driven, don't need agent federation)
- **Trading systems** medium fit (GOAP planner is useful for trade-decision state machines; Federation not needed)
- **Internal tools** weak fit (agent orchestration usually sits in your own backend, ruflo not needed)
- **Custom CLI tools** strong fit (Warp Block-as-object is directly stealable, e.g. `rtk replay <block_id>`)
- **The Claude Code workflow itself** strong fit (the anthropics/skills spec gives 179 skills a real standard)

## One-line compression

> **anthropics/skills = spec layer (mandatory reading when writing skills) · warp = agent UI / engineering-pattern gold (command blocks + spec-PR + flag tiers) · ruflo = industrial ceiling for agent orchestration (Federation + AgentDB + GOAP).** Three libraries, no overlap, one slot each · Read the matching deep ref when signal words hit · the rest of the time, this page is enough.
