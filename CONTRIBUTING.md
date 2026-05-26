# Contributing to claude-code-dna

Thank you for considering a contribution. This project is small on purpose — every
rule earns its place by passing the "would I miss this if it weren't there?" test.

## What we welcome

- **Translations** — Chinese → English (priority), or any other language
- **New decision routing tables** for libraries not yet covered
- **Real `examples/`** of CLAUDE.md files that integrate this DNA into a real workflow
- **Better catalog scoring** — methodology improvements to skill/agent classification
- **Bug fixes** in scripts (`memory-health.sh`, `memory-search.sh`, `skill-spec-audit.sh`)
- **Attribution fixes** — if any rule is recognizably yours and unattributed, file an issue

## What we usually decline

- **New skills or agents bundled in this repo** — see [Philosophy](README.md#philosophy);
  catalog yes, source code no
- **Heavy abstractions** — rules should be reflexes, not frameworks
- **Aspirational rules** — every rule must come from a real incident, not "what good
  agents should do in theory"
- **Style preferences** that don't change agent behavior

## Submission process

1. Open an issue first if the change is non-trivial (>20 lines or new file)
2. Branch from `main`
3. Keep diffs small and surgical (see `rules/karpathy-4-laws.md` — Law 3)
4. Update README if user-visible behavior changes
5. Run `./scripts/skill-spec-audit.sh` if you touched anything skill-shaped
6. PR title: conventional commits style (`feat:`, `fix:`, `docs:`, `refactor:`)

## Writing new rules

Every rule file must answer four questions in the first 100 lines:

1. **What** is the rule? (one-line summary)
2. **Why** does it exist? (the incident or anti-pattern it prevents)
3. **When** does it fire? (the trigger conditions)
4. **How** is it verified? (the check the agent can run to confirm compliance)

If you can't answer all four, the rule isn't ready.

## Style notes

- Markdown only for rules — no YAML configs, no JSON schemas
- Imperative voice ("Do X" not "You should consider X")
- No ALL-CAPS MUST — research shows LLMs respond better to explanation than command
- Examples > prose where possible
- Concrete > abstract ("forbidden softeners: should/probably/seems" not "avoid hedging")

## Code of conduct

Be kind. Assume good faith. Critique the rule, not the person.

## License

By contributing, you agree your work is released under the MIT license.
