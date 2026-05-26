# Karpathy's 4 Laws · LLM coding anti-pattern corrector · always loaded

> Source: [Karpathy's public observations on LLM coding flaws](https://x.com/karpathy/status/2015883857489522876), distilled into 4 behavioral guidelines by [andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills).
> This rule is **complementary** to `operating-instincts.md` / `coding-style.md` / `dna-routing-table.md`: those rules tell you "what to do", the 4 laws tell you "what NOT to do".
> **Recite once before every write/edit/review of code.** Trivial tasks can relax this; production code cannot.

---

## Law 1 · Think Before Coding (think first · don't hide confusion)

**Core: don't assume, don't hide, surface the tradeoffs.**

Pre-code self-check:
- [ ] How many **undeclared assumptions** am I making? (Export *all* users? Which fields? File path? Format?)
- [ ] How many **reasonable interpretations** does this task have? ("Make search faster" → response time / throughput / perceived speed?)
- [ ] Is there a **simpler alternative**? If yes, say so · push back · don't dumbly take orders
- [ ] Is anything **ambiguous**? Stop · name the confusion · ask

**Anti-patterns**:
- Take a vague request and silently write 200 lines → turns out it wasn't what was wanted
- **Silently pick one interpretation** out of many → user has to correct you 5 times to get back to the right one
- Know a simpler path → don't mention it → blindly implement the literal request as a mess

**Compliance test**: can you **list 2-3 assumptions and ask the user to confirm**? If not → you're not ready to start.

---

## Law 2 · Simplicity First (extreme minimalism · no speculative code)

**Core: smallest code that solves the problem · zero speculation.**

Forbidden:
- Features that weren't requested → don't write
- Single-use code → don't abstract (no factory / no ABC / no Strategy pattern)
- "Flexibility / configurability" that wasn't requested → don't add
- Errors that can't happen → don't handle
- Wrote 200 lines and realize 50 would do → **rewrite**

**Self-test**: "would a senior engineer call this overcomplicated?" → if yes → simplify.

**Concrete anti-patterns**:
- "Write a discount calculator" → NOT 5 classes + Strategy + Config + Calculator · IS `def calculate_discount(amount, percent): return amount * percent / 100`
- "Save user preferences" → NOT a `PreferenceManager` with cache/validator/notifier/merge and 4 flags · IS `db.execute("UPDATE ... SET preferences=?", ...)`

**Red-flag words**: abstract / strategy / manager / configurable / extensible / future-proof → without a present-need justifying them = delete.

---

## Law 3 · Surgical Changes (only touch what must change)

**Core: only touch what's necessary · only clean up what *you* made messy.**

When editing existing code:
- ❌ Don't "while I'm here" change adjacent code, comments, or formatting
- ❌ Don't refactor things that aren't broken
- ❌ Don't force "how I'd write it" → match existing style
- ✅ Notice unrelated dead code → **mention it · don't delete** → let the user decide

Your change created orphans (unused import / var / func):
- ✅ Delete the ones **your change** caused to be unused
- ❌ Do NOT delete **pre-existing** dead code (unless asked)

**Passing test**: every line of change can be directly traced to the user's request. Can't trace it = delete.

**Anti-patterns**:
- User: "fix this bug" · You: fixed the bug + refactored 3 nearby files + renamed 2 variables → 200-line diff · user can't review · risk spreads
- User: "add a field" · You: added the field + reordered 5 nearby imports + changed `  ` to `\t` → noise drowns signal

---

## Law 4 · Goal-Driven Execution (verifiable goals close the loop)

**Core: convert the task into a verifiable goal · then loop until verified.**

Task → goal transformation (required):

| Vague task | Verifiable goal |
|---|---|
| "Add input validation" | Write tests covering invalid input → implement to pass |
| "Fix this bug" | Write a failing test that **reproduces the bug** → implement to pass |
| "Refactor X" | Tests pass **both before and after** the refactor |
| "Make it work" | ❌ Too weak → need: run `<concrete command>` and see `<concrete output>` |

Multi-step tasks: list the plan first:
```
1. [step] → verify: [how to check]
2. [step] → verify: [how to check]
3. [step] → verify: [how to check]
```

**Strong success criteria** → you can **self-loop without bothering the user**
**Weak success criteria** → you must ask the user every step to continue → failure mode

---

## When to apply, when to relax

| Scenario | Strictness |
|---|---|
| Production code / pre-commit / PR review | **All 4 laws strict** |
| Debugging / ad-hoc scripts / one-off queries | Laws 2 + 4 (minimal + verify) |
| Exploratory prototype / spike | Law 1 (think first) |
| Trivial typo / rename | Use judgment · skip the full 4-law cycle |

---

## Relationship to other rules

- `operating-instincts.md` items 1/2/3/8 ⇄ this rule's laws 1/2/4/3 align strongly · Karpathy gives **sharper** language
- `dna-routing-table.md` is **scenario routing** (which skill fires when) · this rule is **coding reflexes** (the self-check before every line of code)
- `coding-style.md` is the **positive spec** · this rule is the **anti-pattern detector**

**Conflict resolution**: this rule is more specific → wins (specific overrides general).

---

## One-line compression

> Think clearly before writing · prefer simple over complex · only touch what must move · define verifiable success.

Reciting before coding = ~70% reduction in rework. That's measured, not slogan.
