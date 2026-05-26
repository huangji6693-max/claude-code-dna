# Philosophy

> Why this repo exists, what it refuses to be, and the design decisions behind every rule.

## The core insight

After installing 200 skills and 100 agents from various awesome-lists, your `~/.claude/` becomes a graveyard of half-used configs. The agent doesn't get smarter — it gets noisier. Every new skill adds a possible trigger, every new agent adds a possible delegation, but the agent still:

- Claims "done" without verifying
- Writes 200 lines when 50 would do
- Refactors adjacent code while making a fix
- Forgets your preferences across sessions

The problem isn't the *quantity* of skills. The problem is that the agent has **no consistent DNA** — no internalized reflexes that fire *before* the agent picks a skill, *before* it writes code, *before* it claims completion.

This repo ships that DNA. The catalog points at upstream skills. The DNA shapes how all of them are used.

## Three principles

### 1. Reflexes over frameworks

Every rule in this repo is something you'd want to fire **without thinking**. Not a checklist to consult; a behavior that's already running.

Karpathy's 4 laws are reflexes. The verification gate is a reflex. "Don't refactor while fixing" is a reflex.

Heavy abstractions, configurable rule engines, plugin systems — these are anti-reflexes. They require thought to invoke. If a rule needs configuration, it's too complicated to be a reflex, and probably wrong.

### 2. Pattern over inventory

The community has plenty of "awesome lists" — flat inventories of every skill anyone has written. They're useful as discovery, useless as guidance.

This repo's catalog (`catalog/skills.csv`, `catalog/agents.csv`) isn't trying to be exhaustive. It's trying to be **navigable**: every entry has a category, a trigger keyword, a spec-compliance score. The goal is "given a task, find the right skill in 5 seconds" — not "browse 500 skills to feel productive."

### 3. Catalog yes, source code no

We deliberately don't redistribute skills/agents source code from upstream projects (anthropics/skills, ECC, forrestchang/karpathy-skills, etc.).

**Three reasons:**

- **Licensing complexity.** Mixing skills from 11 different repos under one MIT umbrella creates attribution debt.
- **Staleness.** A bundled snapshot is stale the day after upstream releases.
- **Misaligned incentives.** Re-distributing is cheap (rsync); curating is hard. If we ship source, the catalog rots.

The catalog points at upstream homes. The DNA, scripts, and memory architecture are ours and ship here.

## What "rules earn their place" means

Every rule file in `rules/` has to pass: *would I miss this if it weren't there?*

The 15 operating instincts are each tied to a real incident:

- "Verification gate before any done claim" — because the agent has said "done" 50 times without checking
- "Root cause before fix" — because the agent has hot-patched the symptom 50 times instead of fixing the cause
- "Two-stage review" — because reviewing code quality before spec compliance hides the real bugs

If a proposed rule can't name the incident it prevents, it's aspirational and gets rejected (see [CONTRIBUTING.md](../CONTRIBUTING.md)).

## Memory architecture: the killer feature

Most teams default to "throw everything into memory" — every fact, every preference, every project detail. The agent's context window fills up with stale notes, and the actual conversation gets squeezed.

This DNA inverts that:

- **`MEMORY.md`** is a top-level index — ≤200 lines, always loaded.
- Project-scoped files (`<scope>/_INDEX.md`) load **only when a keyword fires**.
- Cross-memory queries (a full scan) happen **only when the user asks for a retrospective**.

This is the GraphRAG community-summary pattern applied to personal agent memory. It's also why `memory-search.sh` doesn't use a vector database: at <1000 markdown files, BM25 + a good index beats embeddings on both latency and quality.

## What we refuse to do

- **No skill bundles.** This isn't a meta-distribution of other people's work.
- **No vector database.** At our scale (a few hundred memory files), it's overhead without payoff.
- **No "AI-first" cleverness.** The scripts are bash + awk + python3. They run anywhere.
- **No telemetry.** We don't phone home. We don't even know if you installed it.
- **No required dependencies.** If `python3` is on your path, you're done.

## Inspirations and credit

The DNA is synthesized from 11 deeply-read libraries. Each contributed something specific:

| Library | What it gave |
|---|---|
| obra/superpowers | Verification + TDD reflexes |
| forrestchang/andrej-karpathy-skills | The 4 anti-pattern laws |
| anthropics/skills | The official agentskills.io spec |
| mem0ai/mem0 | ADD-only memory writes |
| langchain-ai/langmem | 3 memory types × 2 timings |
| microsoft/graphrag | Community-summary indexing |
| VectifyAI/PageIndex | Vectorless RAG philosophy |
| warpdotdev/warp | Block-as-object + spec-PR |
| ruvnet/claude-flow | Multi-agent orchestration patterns |
| ECC (private) | Many of the operating instincts |
| Karpathy public observations | The "LLM coding flaws" framing |

If any rule is recognizably from your work and not attributed in `README.md` or in the relevant rule file, open an issue — attribution will be fixed immediately.

## The bar

When in doubt, ask: *does this rule make the agent better at the thing the user actually wants?*

If yes — keep it.
If no — delete it, no matter how clever.
