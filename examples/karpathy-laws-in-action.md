# Karpathy 4 Laws — before / after

Four anti-patterns, four reflexes. Each one is something you've probably seen an LLM do without realizing. Here's what changes once the laws are loaded.

---

## Law 1 — Think Before Coding

> Surface assumptions and trade-offs. Don't silently pick one interpretation.

### Without

```
You: add input validation to the user signup form

Agent: [writes 200 lines including custom regex for email, phone, password
        complexity, profanity filtering, and a captcha widget]
```

Five things the agent assumed: which fields, what counts as valid, server-side or
client-side, whether profanity matters, whether you want captcha. None confirmed.

### With

```
You: add input validation to the user signup form

Agent: A few assumptions worth confirming first:
       1. Fields to validate — email + password? Or also name + phone + DOB?
       2. Validation surface — client only (UX), server only (security),
          or both (recommended)?
       3. Email — RFC 5322 strict, or "looks-like-an-email" practical?
       4. Password — length-only, or also charset rules / breach-check via HIBP?
       5. Captcha or rate-limit — out of scope for this task, or include?

       Default if you don't reply: client + server, email looks-like, password
       12+ chars with HIBP, no captcha. Want me to proceed on that?
```

Five questions, one default — the agent gets unblocked fast without silently building the wrong thing.

---

## Law 2 — Simplicity First

> If you wrote 200 lines and 50 would do, rewrite.

### Without

```python
class DiscountStrategy:
    def calculate(self, amount, percent): raise NotImplementedError

class PercentDiscount(DiscountStrategy):
    def calculate(self, amount, percent):
        return amount * percent / 100

class DiscountCalculator:
    def __init__(self, strategy: DiscountStrategy):
        self.strategy = strategy
    def apply(self, amount, percent):
        return self.strategy.calculate(amount, percent)

# usage
calc = DiscountCalculator(PercentDiscount())
result = calc.apply(100, 10)
```

ABC + Strategy + Calculator + factory. For one calculation that's needed in one place.

### With

```python
def calculate_discount(amount, percent):
    return amount * percent / 100
```

If a second discount type appears in 3 months, that's when the abstraction earns its place — not before.

**Red-flag words**: `abstract`, `strategy`, `manager`, `configurable`, `extensible`, `future-proof`. Each one of those, in code that doesn't yet have a current need for the flexibility, is a Law 2 violation.

---

## Law 3 — Surgical Changes

> Every diff line must trace back to the request. No "while I'm here" cleanup.

### Without

```
You: this function returns null sometimes — add a check

Agent: [diff shows]
       - added null check on the function's return ✓
       - reformatted 3 nearby functions with prettier (unrequested)
       - renamed a parameter from `cb` to `callback` (unrequested)
       - extracted a magic number into a constant (unrequested)
       - 47 lines changed
```

Now your reviewer has to read 47 lines and trust that 43 of them are "harmless".

### With

```
You: this function returns null sometimes — add a check

Agent: [diff shows]
       - added null check on the function's return ✓
       - 4 lines changed

       Noticed nearby: parameter `cb` could be `callback`; magic number 86400
       on line 22 might want a name. Not changing — let me know if you want
       those as follow-ups.
```

Surfaced the adjacent observations without touching them. The user can choose to expand scope; the agent doesn't expand it unilaterally.

**Test**: every diff line should answer "which sentence of the user's request justifies this?". If a line can't answer, delete it.

---

## Law 4 — Goal-Driven Execution

> Convert weak goals into verifiable success criteria. Then loop until verified.

### Without

```
You: make this page load faster

Agent: [optimizes images, lazy-loads scripts, adds prefetch hints,
        rewrites the CSS]
       I've optimized the page. It should be faster now.
```

"Faster" is a weak goal. The agent has no way to know if the work is enough. The user has no way to know if the agent's optimizations actually helped.

### With

```
You: make this page load faster

Agent: Converting "faster" to a verifiable goal first:
       — LCP target: <2.5s (current: 4.1s per Lighthouse)
       — CLS target: <0.1 (current: 0.18)
       — bundle target: gzipped JS <150KB (current: 287KB)

       I'll loop: change → re-measure → continue until all three pass or I
       hit something that needs your input.

       [makes changes]
       [runs lighthouse]
       Iteration 1: LCP 3.2s, CLS 0.04, bundle 162KB
       LCP and bundle still over. Splitting the vendor chunk next.

       [continues...]
       Iteration 3: LCP 2.1s ✓, CLS 0.02 ✓, bundle 134KB ✓
       All three pass. Diff summary: 4 files, +89 -47.
```

The agent self-loops because the goal is verifiable. The user reads one final report instead of nine "should-be-faster" updates.

---

## How to use the 4 laws daily

Read `rules/karpathy-4-laws.md` once. Then memorize the pre-code self-check:

```
1. Think       — what am I assuming? what are the alternatives?
2. Simplicity  — if I write 200 lines, would 50 do?
3. Surgical    — does every line trace to the request?
4. Goal-driven — what command proves I'm done?
```

If you can't answer any of the four, stop coding. The task isn't understood yet.
