# 4-phase debugging discipline in action

The single most expensive thing an agent does is "try a fix." A wrong fix costs
the user a round-trip; a hasty fix that masks the symptom costs them production
incidents weeks later. This DNA enforces a 4-phase debugging workflow from
operating-instinct #2 (root cause before fix).

## The 4 phases

```
PHASE 1 — Root cause      : read full error → reproduce → check recent changes → trace data flow
PHASE 2 — Pattern match   : find a working example → compare COMPLETELY → list every difference
PHASE 3 — Hypothesis      : single written hypothesis → minimal test → one variable
PHASE 4 — Implement       : failing test FIRST → single fix → verify → 3+ fails ⇒ STOP, question architecture
```

The reflex isn't memorizing the phases. The reflex is: **when something breaks,
do not propose a fix until Phase 1 has produced evidence**.

## Without the DNA

```
You: the /api/orders endpoint is returning 500 in prod

Agent: Let me add a try/catch around the database call — that should handle it.
       [edits route handler]
       Done!

You: deploys… still 500

Agent: Maybe the issue is the request timeout. Let me bump it to 60s.
       [edits config]
       Done!

You: still 500

Agent: Could be the connection pool. Let me increase max_connections.
       [edits config]
       Done!

You: dude. read the error message.
```

Three speculative fixes. Zero evidence. The error message hadn't been read yet.

## With the DNA

```
You: the /api/orders endpoint is returning 500 in prod

Agent: Phase 1 — root cause before any fix.

       1. Read the full error
          Pulling latest from logs:
          [2026-05-26T14:23:11Z] ERROR /api/orders
          OrderService.findActive: column "deleted_at" does not exist
            at PostgresClient.query (db/client.ts:147)

       2. Reproduce locally
          $ pnpm test --filter orders:integration
          ✗ findActive returns active orders
              column "deleted_at" does not exist

       3. Check recent changes
          $ git log --oneline -5 prisma/schema.prisma
          a4b2c1d  feat: soft-delete on orders (yesterday)
          → the migration added `deleted_at` to the Prisma schema but the
            prod migration didn't run (only dev did)

       4. Trace data flow
          OrderService.findActive() → WHERE deleted_at IS NULL
          Code expects the column; prod schema doesn't have it yet.

       Root cause: missed migration in prod. The route handler is fine;
       the schema is out of sync.

       Fix is not "add a try/catch" — fix is "run the missing migration."
       Confirming with you before touching prod:
         $ pnpm prisma migrate deploy

       Want me to proceed?
```

One investigation. One fix. No speculation.

## When Phase 4 trips the "3+ fails" rule

```
You: this test still fails after I tried 3 different fixes

Agent: 3+ failed attempts on the same hypothesis = STOP per operating-instinct #2.
       This is not a bad fix; this is wrong architecture or wrong hypothesis.

       Going back to Phase 1:
       - What's the FULL error from the most recent attempt?
       - Has anything changed in the test fixture or seed data?
       - Is the test exercising a code path that doesn't exist anymore?

       Pasting the full output before I touch the code again.
```

The "3+ fails ⇒ stop" rule is the hardest reflex to internalize. Without it,
the agent will iterate forever, each attempt drifting further from the truth.
With it, the third failure forces a reset.

## Red-flag words that should freeze the agent

If the agent (or you!) catches itself saying any of these, return to Phase 1:

| Red flag | Why it's wrong |
|---|---|
| "Quick fix for now" | Quick fixes ship to prod and rot there |
| "Just try changing X" | "Just try" = no hypothesis = lottery |
| "Probably the issue is…" | Probably ≠ verified; verify first |
| "One more attempt" (after 2+ failures) | This is attempt #3 — stop, question architecture |
| "Let me wrap it in try/catch" | Hides the symptom, doesn't fix the cause |
| "Add a fallback" (before understanding the failure) | Fallbacks for unknown failures = silent corruption |

## What makes this hard

Phase 1 *feels* slow. It's tempting to "just try" a fix because investigation
takes 2-3 minutes and the user is waiting.

But the math is:
- Phase 1 investigation: 3 min, one round-trip
- 3 speculative fixes: 30 min, three round-trips, possibly a prod incident

The DNA makes Phase 1 the default because the alternative is more expensive
*almost every time*. The exceptions (typos, obvious renames) cost ~30 seconds
to investigate anyway — you don't lose anything by doing Phase 1 on the easy
cases.

## See also

- `rules/operating-instincts.md` — instinct #2 (root cause) and instinct #3 (TDD)
- `examples/verification-gate-demo.md` — the verification gate that fires
  *after* the fix, ensuring "done" isn't a guess
- `examples/karpathy-laws-in-action.md` — Law 4 (goal-driven execution) explains
  why a vague task like "fix the 500" needs to become a specific, testable
  success criterion before any fix is attempted
