# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.3] — 2026-05-26

### Changed

- `rules/karpathy-4-laws.md` — translated from bilingual (~59% Chinese commentary)
  to fully English; preserved all 4 laws, anti-patterns, compliance tests,
  concrete code examples, and the when-to-apply/when-to-relax matrix
- `rules/dna-routing-table.md` — translated to fully English; preserved all
  11 iron laws, every scenario routing table (before/while/after code,
  language-specific review, debugging, design, research, ops, product, meta),
  parallel-agent orchestration rules, Context7 + Karpathy 4 laws, and the
  5-second self-check
- `rules/pageindex-essence.md` — translated to fully English; preserved the
  decision matrix, 4 stealable patterns, install gotcha, and core API anchors
- `rules/seo-geo-essence.md` — translated to fully English; preserved the
  GEO ≠ SEO comparison, 5-phase workflow (A/B/C/D), Schema.org selection
  table, 9 anti-patterns, and the one-line compression
- `rules/warp-ruflo-skills-essence.md` — translated to fully English;
  preserved 3-library positioning, 12 stealable patterns, format-interop
  spec, and project-fit table
- `memory-system/memory-optimization.md` — translated to fully English;
  preserved all 8 iron laws, pre-write checklist, anti-patterns table,
  compaction survival checklist, and v2 project-isolation strategy

### Notes

This release closes out the long-standing roadmap item flagged in both
README and `docs/COMPARISON.md` ("Chinese-language origin. Some rule files
still have Chinese commentary alongside English. Full English translation
is on the roadmap"). All rule and memory-architecture content now reads
as English. Behavioral content is identical — only the prose changed.
`README.zh.md` remains as the intentional Chinese mirror.

## [0.1.2] — 2026-05-26

### Added

- `examples/verification-gate-demo.md` — concrete before/after of the verification gate firing on a failing test
- `examples/karpathy-laws-in-action.md` — 4 real before/after refactoring pairs, one per law, with red-flag word lists
- `examples/memory-workflow.md` — end-to-end walkthrough of the 3-layer memory architecture from day 1 through day 60 (add → retrieve → search → health check)
- `docs/COMPARISON.md` — honest, sharp-edged comparison vs 7 neighboring projects (SuperClaude, agent-rules, claude-token-efficient, oh-my-claudecode, karpathy-skills, memory-bank, awesome-lists) with stacking layer diagram and explicit weakness list
- `docs/TROUBLESHOOTING.md` — install, memory script, skill-audit, behavioral, and compatibility issues with exact-cause / exact-fix pairs

### Changed

- `examples/` directory grew from 1 file (CLAUDE.md skeleton) to 4 files covering the full first-run experience

### Notes

This release is pure documentation polish — no code, no rules, no scripts changed.
Goal: a curious clickthrough from any awesome-list submission lands on enough real
content to evaluate the project in <5 minutes without running anything.

## [0.1.1] — 2026-05-26

### Added

- `CHANGELOG.md` — this file
- `SECURITY.md` — supported versions + reporting policy
- `CODE_OF_CONDUCT.md` — Contributor Covenant v2.1
- `llms.txt` — applies our own GEO/SEO rules to the repo so AI engines
  (ChatGPT / Claude / Perplexity / Bytespider) ingest it with structured context
- `.github/ISSUE_TEMPLATE/` — bug report, feature/rule proposal, attribution fix
- `.github/pull_request_template.md` — checklist enforcing the "would I miss this"
  rule-bar from CONTRIBUTING.md
- README hero rewrite — added badges, architecture diagram (mermaid), comparison
  table vs. awesome-lists, FAQ, star-history badge
- Cross-links from all 5 owned public repos (was 4 of 7)
- Discussions seeded with `Announcing v0.1.0` thread

### Changed

- README: above-the-fold value prop now explicit (≤ 80-word elevator pitch),
  install snippet moved up, "what it refuses to do" moved into a comparison table
- README.zh.md mirrors all README.md changes

### Fixed

- Nothing — this release is pure additive surface polish

## [0.1.0] — 2026-05-26

### Added

- Initial public release
- 8 DNA rule files in `rules/` — Karpathy 4 laws, 15 operating instincts,
  verification gate, debugging discipline, memory optimization, design discipline
- Memory architecture in `memory-system/` — three-layer access pattern, ADD-only
  writes, GraphRAG-style community summaries
- 3 scripts in `scripts/` — `memory-health.sh`, `memory-search.sh` (BM25-style),
  `skill-spec-audit.sh` (agentskills.io compliance)
- Curated catalog in `catalog/` — 194 skills + 99 agents indexed by category,
  trigger keyword, and compliance score (currently 168 PASS / 23 WARN / 3 FAIL)
- 3 integration examples in `examples/CLAUDE.md`
- `docs/PHILOSOPHY.md` — three principles + 11-library attribution table
- CI workflow — shellcheck, markdown structure, naive secret-pattern scan,
  catalog row-count sanity
- Bilingual README (English + Chinese)
- `install.sh` — 30-second drop-in for `~/.claude/`

[Unreleased]: https://github.com/huangji6693-max/claude-code-dna/compare/v0.1.3...HEAD
[0.1.3]: https://github.com/huangji6693-max/claude-code-dna/compare/v0.1.2...v0.1.3
[0.1.2]: https://github.com/huangji6693-max/claude-code-dna/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/huangji6693-max/claude-code-dna/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/huangji6693-max/claude-code-dna/releases/tag/v0.1.0
