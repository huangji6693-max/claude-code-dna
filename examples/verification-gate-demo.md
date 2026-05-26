# The Verification Gate in action

The verification gate is the single highest-value reflex in this DNA. It fires before the agent claims any task is done. Here's what changes when it's installed.

## Without the DNA

```
You: refactor the payment retry logic to use exponential backoff

Agent: I've refactored the payment retry logic in src/payment/retry.ts to use
       exponential backoff with jitter. The change should handle the edge case
       where multiple retries hit the rate limiter simultaneously. Done!

You: did you run the tests?

Agent: Let me check... [runs tests] ... 3 tests failed.
```

The "done" was a guess. The tests caught it. You wasted one round-trip.

## With the DNA

```
You: refactor the payment retry logic to use exponential backoff

Agent: [edits src/payment/retry.ts]
       Verification gate before claiming done:
       1. IDENTIFY  — `pnpm test --filter payment-retry`
       2. RUN
            ✓ retries on 429 with 1s, 2s, 4s, 8s
            ✓ jitter prevents thundering herd
            ✗ gives up after 5 attempts                  ← FAIL
                expected throw RetryExhaustedError
                got     undefined
       3. READ — fail count 1
       4. VERIFY — my refactor lost the giveup branch on line 47

       Fixing before reporting back.
       [edits again]
       [runs tests]
            ✓ all 12 pass

       Confirmed: 12/12 passing. Diff: +18 -11 in retry.ts. No other files touched.
```

The agent never said "done" until the test command exited 0. The forbidden softeners (*should*, *probably*, *seems*, *Great!*) are not in its vocabulary.

## What the rule looks like

From `rules/operating-instincts.md`:

> Before saying done / fixed / works / passing / complete:
> 1. IDENTIFY  — what command proves this claim?
> 2. RUN       — execute the full command, fresh
> 3. READ      — full output + exit code + failure count
> 4. VERIFY    — does output truly confirm the claim?
> 5. STATE     — claim WITH evidence inline
>
> Forbidden softeners: "should", "probably", "looks correct", "seems to",
> "Great!", "Perfect!", "Done!", "Thanks for catching" → if I'm about to type
> these, STOP. Run the gate.

## Why it matters

One bad "done" per session × 10 sessions/week = 10 wasted round-trips. The gate adds 5 seconds. The math is obvious.

The gate also forces a *naming* of the verification: "what command proves this?" If the agent can't answer, it doesn't know what done means — that's the actual problem and the user gets to know before more code gets written.

## When to override

For trivial work (typo, rename in one file, one-line config tweak), running a full test suite is overkill. The rule allows a lighter gate:

```
trivial diff: grep for the old token; confirm new token replaced it; report file paths.
```

Even then, the gate isn't skipped — it's downgraded. The "I just edited it, it should work" claim is never acceptable.

## Try it yourself

Add a contrived bug to a small test:

```bash
echo "test('always passes', () => expect(1).toBe(2));" >> some.test.ts
```

Ask the agent: *"Add a test that 1 equals 1."* — then watch whether it claims done before noticing your contrived `1 === 2` is failing nearby. If it does, your DNA isn't loaded.
