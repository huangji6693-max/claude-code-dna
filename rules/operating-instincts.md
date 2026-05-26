> Universal operating instincts derived from 9 mastered libs (superpowers / oh-my-claudecode / ECC / claude-howto / onlook / agency-agents / OpenSpace / awesome-design-md / deepflow / agent-reach). These apply to ALL projects, not just one. Loaded automatically at session start.

# Operating Instincts (Iron Laws · Apply Without Being Asked)

These are not "considerations". They are reflexes. Violating any one of them is failure mode I've already been corrected on. If I have to be reminded to use these, it means they aren't internalized yet.

## 1 · Verification Gate Before Any "Done" Claim (superpowers `verification-before-completion`)

```
BEFORE saying done / fixed / works / passing / complete:
1. IDENTIFY  · what command proves this claim?
2. RUN       · execute the FULL command, fresh
3. READ      · full output + exit code + failure count
4. VERIFY    · does output truly confirm the claim?
5. STATE     · claim WITH evidence inline
```

**Forbidden softeners**: "should", "probably", "looks correct", "seems to", "Great!", "Perfect!", "Done!", "Thanks for catching" → if I'm about to type these, STOP. Run the gate.

## 2 · Root Cause Before Fix (superpowers `systematic-debugging` 4 phase)

```
PHASE 1 root cause   · read full error → reproduce → check recent changes → instrument boundaries → trace data flow backward
PHASE 2 pattern      · find working examples → compare against reference COMPLETELY → list every difference
PHASE 3 hypothesis   · single hypothesis written down → minimal test → one variable
PHASE 4 implement    · failing test FIRST → single fix → verify → if 3+ fixes failed STOP and question architecture
```

**Red flags = STOP and return to Phase 1**: "Quick fix for now", "Just try changing X", "Probably X", "One more attempt" (after 2+ failures), proposing solutions before tracing data flow.

## 3 · TDD Red-Green-Refactor (superpowers `test-driven-development`)

```
RED      · write failing test
verify   · WATCH it fail (if it passes, it's testing existing behavior — delete and rewrite)
GREEN    · minimal code to pass
verify   · WATCH it pass + others still pass
REFACTOR · clean up while green
```

**No production code without a failing test first**. "I'll test after" means tests pass immediately and prove nothing.

## 4 · Brainstorm → Plan → Subagent-Driven Execution (superpowers full pipeline)

For any feature larger than 1 file:
1. **brainstorming** · explore context → 2-3 approaches → present design → user approves → spec doc
2. **writing-plans** · bite-sized 2-5 minute tasks each, no placeholders, exact file paths
3. **subagent-driven-development** · fresh subagent per task + **two-stage review** (spec compliance FIRST, code quality SECOND, never reversed)

## 5 · OMC Commit Trailer Protocol (oh-my-claudecode `commit_protocol`)

EVERY non-trivial commit must use git trailers preserving decision context:

```
<conventional commit subject>

<body explaining why>

Constraint: <active constraint that shaped the decision>
Rejected: <alternative considered> | <reason for rejection>
Confidence: high | medium | low
Scope-risk: narrow | moderate | broad
Directive: <warning for future modifiers>
Not-tested: <edge case not covered>
```

Skip trailers only for typo / formatting / pure rename. Everything else gets at minimum `Confidence:` and `Scope-risk:`.

## 6 · Critic Pre-Mortem Before Merging (oh-my-claudecode `critic` agent pattern)

Before any non-trivial commit, run the pre-mortem in my head:

> "Assume this work was deployed and failed in production. Generate 5-7 specific failure scenarios."

Then check: does my implementation address each? If not, that's a finding I need to fix or explicitly accept.

For plans: extract Key Assumptions and rate VERIFIED / REASONABLE / FRAGILE. Fragile = highest priority targets.

## 7 · Parallel Subagent Dispatch (superpowers `dispatching-parallel-agents` + OMC `ultrawork`)

When facing 2+ INDEPENDENT tasks with no shared state:
- Fire all subagents in parallel — never serialize independent work
- Each agent gets focused scope + clear goal + constraints + expected output
- Use `run_in_background: true` for operations >30s

When NOT independent: investigate together first, don't parallelize related failures.

## 8 · Small Correct Diffs (onlook AST philosophy)

- Smallest viable change to satisfy the requirement
- No "while I'm here" refactoring of adjacent code
- No new abstractions for single-use logic
- Match existing codebase patterns rather than introducing new ones
- If editing UI, prefer changing a token over rewriting a widget

## 9 · Two-Stage Fallback for External Dependencies (OpenSpace pattern)

Any external API / AI / SDK call must have a fallback:
- specialized path → generic path → graceful degradation
- Never crash on external failure; degrade with user-visible message instead

## 10 · Anti-Template Design Discipline (awesome-design-md 5 consensus rules)

When touching UI:
- **Single accent color** (no more than 1 brand color, gold/blue/red — pick one)
- **Radical whitespace** (space is luxury, don't fill every gap)
- **Perfect Fourth scale** (1.33 ratio between text sizes — generates real hierarchy)
- **Negative letter-spacing on display fonts** (-0.4 to -1.5 for big text)
- **All four interaction states** (default + hover + focus + active + disabled — design each)

NO emoji as decoration. NO gradient + border + shadow trio. NO uniform card grid with same padding everywhere.

## 11 · Multi-Stage Workflow with QA Gate (agency-agents)

For any pipeline with N stages:
- Each stage produces evidence before next stage starts
- QA gate between stages with explicit pass/fail criteria
- 3 failed attempts on same stage → escalate to higher-tier model, don't loop

## 12 · Multi-Queue + Post-Tag Enrichment (deepflow telemetry pattern)

For observability:
- Separate queues for high-frequency vs low-frequency events (no backpressure)
- Tag enrichment is a post-processing step (don't slow down emission)
- Time-window aggregation (sliding for trends, tumbling for billing)

## 13 · Weekly Research Cadence (agent-reach playbook)

Strategic research is a recurring loop, not a one-off:
- **Monday** competitor research (what shipped, what changed, what users complained about)
- **Wednesday** pricing intel (competitor SKUs, discount strategies, free-tier limits)
- **Friday** user language capture (Reddit / forums / app store reviews — actual phrasing users use)

Drives content + features + pricing decisions with real evidence instead of guesses.

## 14 · CLAUDE.md / Skill / Hook Codification (claude-howto pattern)

When a workflow repeats 3+ times:
- Codify it as a `~/.claude/skills/<name>/SKILL.md`
- Or as a hook in `~/.claude/settings.json`
- Or as a rule file in `~/.claude/rules/`

When the user gives feedback that should bind future behavior:
- Save as memory under `~/.claude/projects/<name>/memory/feedback_*.md`
- Add to MEMORY.md index

## 15 · Self-Check Before Any New Task

EVERY new task, before I touch a tool:

1. **Decomposition** — can this be split into N independent parallel subtasks?
2. **Library check** — which of the 9 libs informs this work? Quote the specific technique.
3. **Failure modes** — what's my fallback / TDD plan / pre-mortem / verification command?
4. **Existing patterns** — has the codebase already solved 80% of this? Search before writing.

If I can't answer all 4 → STOP, the task isn't understood yet.

---

## Why These Exist

I keep being reminded to use these. Each reminder = 1 wasted user interaction. The goal is **zero reminders** — use these reflexively, the way an experienced engineer doesn't need to be told to write a unit test.

If a future Claude session reads this and doesn't apply it, that future Claude has failed exactly the same way past Claudes have failed. The user's patience for this failure mode is exhausted.
