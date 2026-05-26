<!--
Thanks for the PR. Before submitting, please confirm the checklist below.

The rule-bar for this repo is "would I miss this if it weren't there?" —
small surgical diffs are preferred over sweeping refactors.
-->

## What does this PR do?

<!-- One sentence -->

## Why (the incident, if it's a rule change)

<!-- "Aspirational" rules get rejected. Name the real-world failure this prevents. -->

## Checklist

- [ ] PR title uses conventional commits (`feat:`, `fix:`, `docs:`, `refactor:`, `chore:`)
- [ ] Diff is small and surgical (no "while I'm here" refactoring)
- [ ] If you touched a `rules/*.md`, it answers the 4 questions: What / Why / When / How verified
- [ ] If you touched a `scripts/*.sh`, `shellcheck` is clean
- [ ] If you touched `catalog/*.csv`, row count still passes CI
- [ ] If you added a file, it has a top-level heading (CI requirement)
- [ ] No secrets, API keys, internal URLs, or PII anywhere in the diff
- [ ] CHANGELOG.md updated under `[Unreleased]` if user-visible

## Scope-risk

<!-- narrow / moderate / broad — see operating-instincts.md commit trailer protocol -->

## Confidence

<!-- high / medium / low -->
