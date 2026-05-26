# `dna-doctor.sh` — single-command health check

`dna-doctor.sh` is the one command that tells you whether the DNA install is
healthy. It wraps shellcheck, file-presence audits, the translation guard, and
cross-reference checks into 17 individual checks that run in under a second.

There are two modes — one for contributors, one for end users.

## Mode 1 — repo audit (before opening a PR)

```bash
$ bash scripts/dna-doctor.sh
== DNA DOCTOR @ /home/you/claude-code-dna  (mode: repo) ==

1. Rules
[OK]   6 rule file(s) present
[OK]   no empty rule files
[OK]   all rule files are English-only

2. Memory system
[OK]   1 memory-system file(s) present
[OK]   memory-optimization.md present
[OK]   memory-optimization.md is English-only

3. Scripts
[OK]   4 script(s) present
[OK]   all scripts have portable shebangs
[OK]   shellcheck clean (warning+)

4. Examples
[OK]   5 example file(s) present

5. Cross-references
[OK]   README.md present
[OK]   README references install.sh
[OK]   README references rules/
[OK]   README references memory-system/
[OK]   README references CHANGELOG
[OK]   CHANGELOG.md present
[OK]   llms.txt present (AI ingestion discoverability)

== SUMMARY ==
Total checks: 17
PASS: 17    WARN: 0    FAIL: 0

DNA health: GREEN
```

CI runs the same script on every PR. If it's green locally, it's green on GitHub.

## Mode 2 — installed audit (after `./install.sh`)

```bash
$ bash scripts/dna-doctor.sh --installed
== DNA DOCTOR @ /home/you/.claude  (mode: installed) ==

1. Rules
[OK]   6 rule file(s) present
[OK]   no empty rule files

2. Memory system
[OK]   delegating to memory-health.sh (/home/you/.claude/projects/-root/memory)
    [OK] MEMORY.md = 84 lines
    [OK] 23 memory files (markdown-only threshold 1000)
    [OK] all MEMORY.md links resolve
    [OK] no orphan files
    [OK] no files >90d stale
    [OK] 0 strikethrough entries
    [OK] all files have frontmatter

3. Scripts
[OK]   4 script(s) present
[OK]   all scripts have portable shebangs
[OK]   shellcheck clean (warning+)
```

If you don't have a real memory store yet (fresh install), the doctor warns
instead of failing — that's expected on day one.

## What it actually catches

Real failures we've caught in dogfooding:

### 1. Chinese leftover after a translation pass

```
[WARN] memory-optimization.md has 12 line(s) with Chinese
```

The v0.1.3 milestone translated every rule file to English. If a future PR
re-introduces Chinese commentary by mistake, the doctor catches it before CI
does.

### 2. shellcheck regression

When `dna-doctor.sh` was first written, local `shellcheck -S warning` was
clean but CI runs default severity (style+info), which caught 5 `SC2015`
violations (`A && B || C` ambiguity). The doctor now runs `shellcheck` (no
`-S` filter) so the local check matches CI exactly.

### 3. README forgets to reference a new doc

```
[WARN] README does not reference CHANGELOG
```

Easy to forget when you add `CHANGELOG.md` but never link it from the README.
The doctor surfaces it as a warning — not a hard fail, but a useful nudge.

### 4. Empty rule files (accidental `touch`)

```
[FAIL] 1 empty rule file(s)
```

If you `touch rules/new-thing.md` and forget to populate it, the doctor blocks
the commit.

## Exit codes

| Exit | Meaning |
|---|---|
| `0` | All checks pass (or warnings only — repo is healthy) |
| `1` | At least one FAIL — fix before merging |

The script never throws warnings to non-zero — warnings are informational and
should not block CI. Only FAILs (missing file, empty file, shellcheck error)
fail the run.

## Integrating into your own workflow

### Pre-commit hook

```bash
# .git/hooks/pre-commit
#!/usr/bin/env bash
bash scripts/dna-doctor.sh || {
  echo "dna-doctor failed — fix before committing"
  exit 1
}
```

### GitHub Actions

Already wired into `.github/workflows/lint.yml`:

```yaml
dna-doctor:
  name: DNA Doctor (repo health)
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v4
    - run: sudo apt-get update -qq && sudo apt-get install -y shellcheck
    - run: bash scripts/dna-doctor.sh
```

## Why one command and not three

Before `dna-doctor`, the recommended flow was:

```bash
bash scripts/memory-health.sh           # memory audit
bash scripts/skill-spec-audit.sh        # spec audit
shellcheck scripts/*.sh install.sh      # lint
```

Three commands. Different output formats. Easy to forget one. The doctor's
job is to be the single entry point — one command, one summary, one exit code.
If you need a deeper dive, the individual scripts are still there and the
doctor delegates to `memory-health.sh` for the live-memory audit.

## Adding new checks

The script is intentionally simple — every check is a 3-line block:

```bash
if <condition>; then
  check_pass "<message>"
else
  check_fail "<message>"   # or check_warn
fi
```

To add a check: open `scripts/dna-doctor.sh`, find the relevant section
(`1. Rules`, `3. Scripts`, etc.), add a 3-line block, and run the script.
The summary auto-updates. PRs with new checks should explain *what failure
mode the check prevents* — the rule from `CONTRIBUTING.md` applies here too:
no aspirational checks, only ones that come from a real incident.
