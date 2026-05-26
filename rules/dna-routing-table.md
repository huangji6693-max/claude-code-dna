# 11-Library Fusion DNA v2.1 · Executable Routing Table · Auto-loaded every session

> 179 skills + 99 agents + Context7 MCP + Karpathy Guidelines + 98 rules · all read closely
> This is not notes. It's behavioral routing — scenario hits, trigger fires.

---

## 1 · Iron Laws (non-negotiable · v2.1 expanded to 11)

1. Self-check 4 questions before acting
2. No failing test → no code
3. No verification → no "done"
4. Stop after 3 failed fixes
5. Two-stage review is irreversible (Spec → Quality)
6. Design not approved → no code
7. Small diffs
8. **[Karpathy 1] Surface assumptions and tradeoffs before writing** · don't silently pick one of many interpretations
9. **[Karpathy 2] Simplicity first** · if 50 lines does what 200 does, rewrite · don't abstract single-use code
10. **[Karpathy 3] Surgical changes** · every diff line traces back to the user's request · no "while I'm here" refactoring
11. **[Karpathy 4] Convert tasks to verifiable goals** · weak goals = guaranteed failure · strong goals = self-loop

---

## 2 · Scenario Routing Table (hit → fire · no user reminder needed)

### Before writing code

| Scenario | Skill | Agent | Notes |
|---|---|---|---|
| Using uncertain API/library | `Context7 resolve-library-id → query-docs` | docs-lookup | Don't guess — look it up first |
| Looking for existing solutions/packages | `/search-first` | explore | Search GitHub/npm/PyPI first |
| Deep research | `/deep-research` + `/exa-search` | — | firecrawl + exa MCP |
| Vague requirements | `/deep-interview` | analyst | Generate spec only when ambiguity ≤20% |
| New feature planning | `/brainstorming` → `/plan` → `/writing-plans` | planner, architect | 2-3 approaches → user picks |
| Complex architectural decision | `/council` | architect, critic | Four-voice council |

### While writing code

| Scenario | Skill | Agent | Notes |
|---|---|---|---|
| New feature / bug fix | `/tdd` (test-driven-development) | tdd-guide | Write the failing test first |
| Parallel multi-task | `dispatching-parallel-agents` | Compose as needed | 2+ independent tasks must go parallel |
| Subtask execution | `subagent-driven-development` | executor | Fresh agent per task |
| End-to-end autonomous | `/autopilot` | Built-in 5 stages | Idea → spec → plan → implement → QA |
| Must-complete | `/ralph` | Built-in reviewer | PRD-driven · don't stop until done |
| Code cleanup | `/deslop` (ai-slop-cleaner) | refactor-cleaner | Deletion-first · behavior-safe |

### After writing code

| Scenario | Skill | Agent | Notes |
|---|---|---|---|
| Code review | `requesting-code-review` | code-reviewer | **Trigger immediately after writing · don't wait for the user** |
| Security review | `security-review` | security-reviewer | Anything touching auth/input/API/payments |
| Silent failure check | — | silent-failure-hunter | Empty catch / swallowed errors |
| Verification | `/verify` + `verification-loop` | verifier | Build + types + lint + tests + security |
| E2E tests | `e2e-testing` | e2e-runner | Critical user flows |
| Commit | Commit trailer spec | git-master | Confidence + Scope-risk |

### Language-specific review (auto-matched per project)

| Language | Review agent | Build-fix agent | Pattern skill |
|---|---|---|---|
| **Flutter/Dart** | flutter-reviewer | dart-build-resolver | dart-flutter-patterns |
| **Java/Spring** | java-reviewer | java-build-resolver | springboot-patterns + jpa-patterns |
| **Python** | python-reviewer | — | python-patterns |
| **Go** | go-reviewer | go-build-resolver | golang-patterns |
| **Rust** | rust-reviewer | rust-build-resolver | rust-patterns |
| **TypeScript** | typescript-reviewer | build-error-resolver | frontend-patterns |
| **Kotlin** | kotlin-reviewer | kotlin-build-resolver | kotlin-patterns |
| **C++** | cpp-reviewer | cpp-build-resolver | cpp-coding-standards |
| **C#** | csharp-reviewer | — | dotnet-patterns |
| **Swift** | — | — | swiftui-patterns + swift-concurrency-6-2 |
| **Laravel** | — | — | laravel-patterns + laravel-security |
| **SQL** | database-reviewer | — | postgres-patterns |

### Debugging

| Phase | What to do | Tools |
|---|---|---|
| Phase 1 root cause | Read the error → reproduce → check recent changes → trace data flow | `/debug` + systematic-debugging |
| Phase 2 pattern | Find working code → compare completely | debugger agent |
| Phase 3 hypothesis | Single hypothesis → minimal test | tracer agent |
| Phase 4 implement | Failing test → single fix → verify | tdd-guide |
| Agent itself is stuck | Capture → diagnose → recover | agent-introspection-debugging |

### Design / UI

| Scenario | Skill | Agent |
|---|---|---|
| Frontend UI design | `frontend-design` | designer, ui-designer |
| UX architecture | — | ux-architect |
| User research | — | ux-researcher |
| Brand visuals | `brand-voice` | brand-guardian |
| SEO | `seo` | seo-specialist |
| iOS liquid glass | `liquid-glass-design` | — |
| Slides / decks | `frontend-slides` | — |
| UI demo recording | `ui-demo` | — |

### Research / Content

| Scenario | Skill | Notes |
|---|---|---|
| Tech doc lookup | Context7 MCP | `resolve-library-id` → `query-docs` |
| Market research | `market-research` | Competitors / investors / industry |
| Article writing | `article-writing` | Long-form + brand voice |
| Multi-platform content | `content-engine` + `crosspost` | X / LinkedIn / TikTok / YouTube |
| Video production | `video-editing` / `remotion-video-creation` / `manim-video` | Pick per need |
| AI imagery | `fal-ai-media` | fal.ai MCP |
| Prompt optimization | `prompt-optimizer` | Analyze + improve |

### Ops / Deployment

| Scenario | Skill | Agent |
|---|---|---|
| Docker orchestration | `docker-patterns` | devops-automator |
| CI/CD pipelines | `deployment-patterns` | devops-automator |
| Database migrations | `database-migrations` | database-optimizer |
| GitHub ops | `github-ops` | — |
| Production incidents | — | incident-response-commander |
| SRE / reliability | — | sre |
| Performance issues | — | performance-optimizer, performance-benchmarker |

### Product / Business

| Scenario | Skill | Agent |
|---|---|---|
| PRD → implementation plan | `product-capability` | product-manager |
| Sprint planning | — | sprint-prioritizer |
| User feedback analysis | — | feedback-synthesizer |
| Trend research | — | trend-researcher |
| Investor materials | `investor-materials` + `investor-outreach` | — |

### Meta-capability (self-evolution)

| Scenario | Skill | Description |
|---|---|---|
| Workflow repeats 3+ times | `skillify` | Turn it into a reusable skill |
| Discover codebase insight | `learner` | Extract as a principle |
| Audit existing skills | `skill-stocktake` | Quality check |
| Configure ECC | `configure-ecc` | Interactive installer |
| Session analysis → hook | `hookify-rules` | Auto-generate rules |

---

## 3 · Parallel Agent Orchestration Rules

| Condition | Strategy |
|---|---|
| 2+ independent tasks | **Must parallelize** · dispatching-parallel-agents |
| Linked failures | Investigate together · don't parallelize |
| Shared files | Sequential |
| Complex multi-step | `/ralph` or `/autopilot` |
| Needs multiple perspectives | `/council` (architect + skeptic + pragmatist + critic) |
| Compose a team | `/team` (team-builder interactive selection) |

### Agent capability tiers

| Model | Use case | Agent roles |
|---|---|---|
| Haiku | Search / rename / simple edit / docs | writer, explore |
| Sonnet | Implement / refactor / test / debug / review | executor, code-reviewer, tdd-guide |
| Opus | Architecture / root-cause / consensus / multi-file invariants | architect, critic, analyst |

---

## 4 · Context7 Live Docs (10th library)

```
Uncertain API → resolve-library-id(libraryName, query)
                    ↓ get /org/project ID
            query-docs(libraryId, query)
                    ↓ latest docs + code examples
            write code (use the real API, don't guess)
```

Limit: up to 3 resolves + 3 queries per turn.

---

## 4.5 · Karpathy's 4 Laws · LLM coding anti-pattern corrector (11th library)

Recite before writing, editing, or reviewing code. See `~/.claude/rules/karpathy-4-laws.md` + skill `karpathy-guidelines`.

| Law | One-liner | Trigger self-check |
|---|---|---|
| **Think** | Surface assumptions + tradeoffs · don't silently take orders | How many undeclared assumptions am I making? How many reasonable interpretations does this task have? |
| **Simplicity** | If 50 lines does what 200 does, rewrite · don't abstract single-use code | Would a senior call this overcomplicated? |
| **Surgical** | Every diff line traces directly to the user's request · no drive-by refactoring | Can I trace this line back to the original request? Can't trace = delete |
| **Goal-driven** | Weak goals guarantee failure · convert to verifiable success criteria | What concrete command proves I'm done? |

**When to invoke the skill**: production code / before commit / PR review / debugging after 3 failed attempts → `Skill karpathy-guidelines`
**When to relax**: trivial typo / rename / one-off script

---

## 5 · Open-Source Release Pipeline (3 stages)

1. `opensource-forker` → copy + strip secrets + clean git history
2. `opensource-sanitizer` → 20+ regex scans · PASS/FAIL
3. `opensource-packager` → CLAUDE.md + README + LICENSE + setup.sh

---

## 6 · GAN Generation Pipeline

1. `gan-planner` → expand a one-line prompt into a full product spec
2. `gan-generator` → implement against the spec
3. `gan-evaluator` → Playwright tests + scoring + feedback → loop

---

## 7 · UX Quality Standards (user perspective, not dev perspective)

### User-journey completeness check

Every feature must cover 7 states:

```
empty → loading → normal → error → boundary → offline → recovery
```

| State | Must have | Forbidden |
|---|---|---|
| empty | Designed illustration / message + guidance button | Blank page / plain "no data" text |
| loading | Skeleton / shimmer / brand animation | White screen / unresponsive spinner |
| normal | Clear content hierarchy + interaction feedback | Flat info with no focal point |
| error | Specific message + retry button | "Something went wrong" / silent failure |
| boundary | Long-text truncation / large-image compression / extreme data | Overflow / broken layout |
| offline | Cached content + "no network" notice | White screen / infinite loading |
| recovery | Auto-refresh when network returns / prompt to refresh | Requires manual restart |

### Interaction response-time standards

| Operation | Target | If exceeded |
|---|---|---|
| Click feedback | < 100ms | Must have visual feedback (scale / opacity / ripple) |
| Page transition | < 300ms | Animation masks the load |
| Data load | < 1s | Skeleton / shimmer |
| First paint | < 2s | Inline critical CSS + `font-display: swap` |
| Image load | Progressive | Blur → sharp transition |

### Form UX iron laws

| Rule | Why |
|---|---|
| Live validation | Instant feedback on input · don't wait for submit |
| Error focus | Scroll to the first failing field |
| Password reveal | Must have a show/hide toggle |
| Input memory | Don't clear filled fields on error |
| Keyboard awareness | Input must not be hidden by the keyboard |
| Submit debounce | Disable button + loading state to prevent double-submit |

### Agents that trigger UX audits

| Agent | Use |
|---|---|
| qa-tester | Interactive testing · tmux managed |
| evidence-collector | Screenshots + evidence collection |
| ux-researcher | User behavior analysis |
| accessibility-auditor | A11y compliance |
| e2e-runner | Playwright automation |

---

## 8 · 5-Second Self-Check at the Start of Every Task

```
1. Decomposition — can this go parallel? → dispatching-parallel-agents
2. Docs — using an external API? → Context7
3. Pattern — which skill covers this directly? → check the routing table
4. Agent — does this need expert review? → match a language-specific reviewer
5. Failure — what's the TDD / pre-mortem / verification command?
```

**Can't answer all 5 = don't touch anything yet.**
