# Agents Catalog

> Curated index of **99 agents** across 8 categories. Generated from `catalog/agents.csv`.

> Like skills, this repo does **not redistribute agent source code**. Use this index to find the right agent for your task, then install from upstream.


## Table of contents

- [Specialized Domain Experts](#specialized) — 32 agents
- [Language-Specific Reviewers](#language-reviewer) — 19 agents
- [Testing](#testing) — 11 agents
- [Planning & Architecture](#planning) — 9 agents
- [Build Error Resolvers](#build-resolver) — 8 agents
- [Multi-Agent Orchestration](#orchestration) — 8 agents
- [Design & UX](#design) — 7 agents
- [Product Management](#product) — 5 agents

---


## Specialized Domain Experts

<a id="specialized"></a>

> 32 agents

| Agent | Model | Tools | Description |
|---|---|---|---|
| `ai-engineer` | inherit | All tools | Expert AI/ML engineer specializing in machine learning model development deployment and integration into production systems. |
| `⚠️ chief-of-staff` | opus | Read; Grep; Glob; Bash; Edit; Write | Personal communication chief of staff that triages email Slack LINE and Messenger. Classifies messages into 4 tiers generates draft replies and enforces post-send follow-through... |
| `data-scientist` | sonnet | Bash; Read; Write | Data analysis expert for SQL queries BigQuery operations and data insights. Use PROACTIVELY for data analysis tasks and queries. |
| `database-optimizer` | inherit | All tools | Expert database specialist focusing on schema design query optimization indexing strategies and performance tuning. |
| `debugger` | inherit | Read; Edit; Bash; Grep; Glob | Debugging specialist for errors test failures and unexpected behavior. Use PROACTIVELY when encountering any issues. |
| `devops-automator` | inherit | All tools | Expert DevOps engineer specializing in infrastructure automation CI/CD pipeline development and cloud operations. |
| `doc-updater` | haiku | Read; Write; Edit; Bash; Grep; Glob | Documentation and codemap specialist. Runs /update-codemaps and /update-docs generates docs/CODEMAPS/* updates READMEs and guides. |
| `docs-lookup` | sonnet | Read; Grep; mcp__context7__resolve-library-id; mcp__conte... | When the user asks how to use a library framework or API use Context7 MCP to fetch current documentation and return answers with examples. |
| `documentation-writer` | inherit | Read; Write; Grep | Technical documentation specialist for API docs user guides and architecture documentation. |
| `explore` | haiku | All tools (disallowed: Write; Edit) | Codebase search specialist for finding files and code patterns. Read-only. |
| `frontend-developer` | inherit | All tools | Expert frontend developer specializing in modern web technologies React/Vue/Angular frameworks UI implementation and performance optimization. |
| `git-master` | sonnet | All tools | Git expert for atomic commits rebasing and history management with style detection. |
| `git-workflow-master` | inherit | All tools | Expert in Git workflows branching strategies and version control best practices including conventional commits rebasing worktrees and CI-friendly branch management. |
| `implementation-agent` | inherit | Read; Write; Edit; Bash; Grep; Glob | Full-stack implementation specialist for feature development. Has complete tool access for end-to-end implementation. |
| `incident-response-commander` | inherit | All tools | Expert incident commander specializing in production incident management structured response coordination post-mortem facilitation SLO/SLI tracking and on-call process design. |
| `mcp-builder` | inherit | All tools | Expert Model Context Protocol developer who designs builds and tests MCP servers that extend AI agent capabilities with custom tools resources and prompts. |
| `mobile-app-builder` | inherit | All tools | Specialized mobile application developer with expertise in native iOS/Android development and cross-platform frameworks. |
| `opensource-forker` | sonnet | Read; Write; Edit; Bash; Grep; Glob | Fork any project for open-sourcing. Copies files strips secrets and credentials (20+ patterns) replaces internal references with placeholders generates .env.example and cleans g... |
| `opensource-packager` | sonnet | Read; Write; Edit; Bash; Grep; Glob | Generate complete open-source packaging for a sanitized project. Produces CLAUDE.md setup.sh README.md LICENSE CONTRIBUTING.md and GitHub issue templates. |
| `opensource-sanitizer` | sonnet | Read; Grep; Glob; Bash | Verify an open-source fork is fully sanitized before release. Scans for leaked secrets PII internal references and dangerous files using 20+ regex patterns. Generates PASS/FAIL... |
| `performance-optimizer` | sonnet | Read; Write; Edit; Bash; Grep; Glob | Performance analysis and optimization specialist. Identifies bottlenecks optimizes slow code reduces bundle sizes and improves runtime performance. |
| `rapid-prototyper` | inherit | All tools | Specialized in ultra-fast proof-of-concept development and MVP creation using efficient tools and frameworks. |
| `refactor-cleaner` | sonnet | Read; Write; Edit; Bash; Grep; Glob | Dead code cleanup and consolidation specialist. Runs analysis tools (knip depcheck ts-prune) to identify dead code and safely removes it. |
| `security-engineer` | inherit | All tools | Expert application security engineer specializing in threat modeling vulnerability assessment secure code review security architecture design and incident response. |
| `security-reviewer` | sonnet | Read; Write; Edit; Bash; Grep; Glob | Security vulnerability detection and remediation specialist. Flags secrets SSRF injection unsafe crypto and OWASP Top 10 vulnerabilities. |
| `senior-developer` | inherit | All tools | Premium implementation specialist — masters Laravel/Livewire/FluxUI advanced CSS Three.js integration. |
| `seo-specialist` | sonnet | Read; Grep; Glob; Bash; WebSearch; WebFetch | SEO specialist for technical SEO audits on-page optimization structured data Core Web Vitals and content/keyword mapping. |
| `sre` | inherit | All tools | Expert site reliability engineer specializing in SLOs error budgets observability chaos engineering and toil reduction for production systems at scale. |
| `tracer` | sonnet | All tools | Evidence-driven causal tracing with competing hypotheses evidence for/against uncertainty tracking and next-probe recommendations. |
| `verifier` | sonnet | All tools | Verification strategy evidence-based completion checks and test adequacy specialist. |
| `workflow-optimizer` | inherit | All tools | Expert process improvement specialist focused on analyzing optimizing and automating workflows across all business functions for maximum productivity and efficiency. |
| `writer` | haiku | All tools | Technical documentation writer for README API docs and comments. |


## Language-Specific Reviewers

<a id="language-reviewer"></a>

> 19 agents

| Agent | Model | Tools | Description |
|---|---|---|---|
| `clean-code-reviewer` | inherit | Read; Grep; Glob; Bash | Clean Code principles enforcement specialist. Reviews code for violations of Clean Code theory and best practices. Use PROACTIVELY after writing code. |
| `code-reviewer` | sonnet | Read; Grep; Glob; Bash | Expert code review specialist. Proactively reviews code for quality security and maintainability. Use immediately after writing or modifying code. MUST BE USED for all code chan... |
| `code-simplifier` | sonnet | Read; Write; Edit; Bash; Grep; Glob | Simplifies and refines code for clarity consistency and maintainability while preserving behavior. Focus on recently modified code unless instructed otherwise. |
| `comment-analyzer` | sonnet | Read; Grep; Glob; Bash | Analyze code comments for accuracy completeness maintainability and comment rot risk. |
| `cpp-reviewer` | sonnet | Read; Grep; Glob; Bash | Expert C++ code reviewer specializing in memory safety modern C++ idioms concurrency and performance. Use for all C++ code changes. |
| `csharp-reviewer` | sonnet | Read; Grep; Glob; Bash | Expert C# code reviewer specializing in .NET conventions async patterns security nullable reference types and performance. Use for all C# code changes. |
| `database-reviewer` | sonnet | Read; Write; Edit; Bash; Grep; Glob | PostgreSQL database specialist for query optimization schema design security and performance. Incorporates Supabase best practices. |
| `engineering-code-reviewer` | inherit | All tools | Expert code reviewer who provides constructive actionable feedback focused on correctness maintainability security and performance. |
| `flutter-reviewer` | sonnet | Read; Grep; Glob; Bash | Flutter and Dart code reviewer. Reviews Flutter code for widget best practices state management patterns Dart idioms performance pitfalls accessibility and clean architecture vi... |
| `go-reviewer` | sonnet | Read; Grep; Glob; Bash | Expert Go code reviewer specializing in idiomatic Go concurrency patterns error handling and performance. Use for all Go code changes. |
| `healthcare-reviewer` | opus | Read; Grep; Glob | Reviews healthcare application code for clinical safety CDSS accuracy PHI compliance and medical data integrity. Specialized for EMR/EHR and clinical decision support. |
| `java-reviewer` | sonnet | Read; Grep; Glob; Bash | Expert Java and Spring Boot code reviewer specializing in layered architecture JPA patterns security and concurrency. Use for all Java code changes. |
| `kotlin-reviewer` | sonnet | Read; Grep; Glob; Bash | Kotlin and Android/KMP code reviewer. Reviews Kotlin code for idiomatic patterns coroutine safety Compose best practices clean architecture violations and common Android pitfalls. |
| `python-reviewer` | sonnet | Read; Grep; Glob; Bash | Expert Python code reviewer specializing in PEP 8 compliance Pythonic idioms type hints security and performance. Use for all Python code changes. |
| `rust-reviewer` | sonnet | Read; Grep; Glob; Bash | Expert Rust code reviewer specializing in ownership lifetimes error handling unsafe usage and idiomatic patterns. Use for all Rust code changes. |
| `secure-reviewer` | inherit | Read; Grep | Security-focused code review specialist with minimal permissions. Read-only access ensures safe security audits. |
| `silent-failure-hunter` | sonnet | Read; Grep; Glob; Bash | Review code for silent failures swallowed errors bad fallbacks and missing error propagation. |
| `type-design-analyzer` | sonnet | Read; Grep; Glob; Bash | Analyze type design for encapsulation invariant expression usefulness and enforcement. |
| `typescript-reviewer` | sonnet | Read; Grep; Glob; Bash | Expert TypeScript/JavaScript code reviewer specializing in type safety async correctness Node/web security and idiomatic patterns. MUST BE USED for TypeScript/JavaScript projects. |


## Testing

<a id="testing"></a>

> 11 agents

| Agent | Model | Tools | Description |
|---|---|---|---|
| `accessibility-auditor` | inherit | All tools | Expert accessibility specialist who audits interfaces against WCAG standards tests with assistive technologies and ensures inclusive design. |
| `api-tester` | inherit | All tools | Expert API testing specialist focused on comprehensive API validation performance testing and quality assurance across all systems and third-party integrations. |
| `e2e-runner` | sonnet | Read; Write; Edit; Bash; Grep; Glob | End-to-end testing specialist using Vercel Agent Browser (preferred) with Playwright fallback. Manages test journeys quarantines flaky tests uploads artifacts. |
| `evidence-collector` | inherit | All tools | Screenshot-obsessed fantasy-allergic QA specialist. Requires visual proof for everything. Defaults to finding 3-5 issues. |
| `performance-benchmarker` | inherit | All tools | Expert performance testing and optimization specialist focused on measuring analyzing and improving system performance across all applications and infrastructure. |
| `pr-test-analyzer` | sonnet | Read; Grep; Glob; Bash | Review pull request test coverage quality and completeness with emphasis on behavioral coverage and real bug prevention. |
| `qa-tester` | sonnet | All tools | Interactive CLI testing specialist using tmux for session management. |
| `reality-checker` | inherit | All tools | Stops fantasy approvals — evidence-based certification specialist. Defaults to NEEDS WORK and requires overwhelming proof for production readiness. |
| `tdd-guide` | sonnet | Read; Write; Edit; Bash; Grep | Test-Driven Development specialist enforcing write-tests-first methodology. Use PROACTIVELY when writing new features fixing bugs or refactoring code. Ensures 80%+ test coverage. |
| `test-engineer` | inherit | Read; Write; Bash; Grep | Test automation expert for writing comprehensive tests. Use PROACTIVELY when new features are implemented or code is modified. |
| `test-results-analyzer` | inherit | All tools | Expert test analysis specialist focused on comprehensive test result evaluation quality metrics analysis and actionable insight generation from testing activities. |


## Planning & Architecture

<a id="planning"></a>

> 9 agents

| Agent | Model | Tools | Description |
|---|---|---|---|
| `analyst` | opus | Read; Grep; Glob | Pre-planning consultant for requirements analysis — converts product scope into implementable acceptance criteria catching gaps before planning begins. |
| `architect` | opus | Read; Grep; Glob | Software architecture specialist for system design scalability and technical decision-making. Use PROACTIVELY when planning new features refactoring large systems or making arch... |
| `backend-architect` | inherit | All tools | Senior backend architect specializing in scalable system design database architecture API development and cloud infrastructure. |
| `code-architect` | sonnet | Read; Grep; Glob; Bash | Designs feature architectures by analyzing existing codebase patterns and conventions then providing implementation blueprints with concrete files interfaces data flow and build... |
| `code-explorer` | sonnet | Read; Grep; Glob; Bash | Deeply analyzes existing codebase features by tracing execution paths mapping architecture layers and documenting dependencies to inform new development. |
| `critic` | opus | Read; Grep; Glob (disallowed: Write; Edit) | Work plan and code review expert — thorough structured multi-perspective review with Opus-level reasoning. |
| `planner` | opus | Read; Grep; Glob | Expert planning specialist for complex features and refactoring. Use PROACTIVELY when users request feature implementation architectural changes or complex refactoring. |
| `software-architect` | inherit | All tools | Expert software architect specializing in system design domain-driven design architectural patterns and technical decision-making for scalable maintainable systems. |
| `workflow-architect` | inherit | All tools | Workflow design specialist who maps complete workflow trees for every system user journey and agent interaction covering happy paths failure modes and recovery paths. |


## Build Error Resolvers

<a id="build-resolver"></a>

> 8 agents

| Agent | Model | Tools | Description |
|---|---|---|---|
| `build-error-resolver` | sonnet | Read; Write; Edit; Bash; Grep; Glob | Build and TypeScript error resolution specialist. Fixes build/type errors only with minimal diffs no architectural edits. Focuses on getting the build green quickly. |
| `cpp-build-resolver` | sonnet | Read; Write; Edit; Bash; Grep; Glob | C++ build CMake and compilation error resolution specialist. Fixes build errors linker issues and template errors with minimal changes. Use when C++ builds fail. |
| `dart-build-resolver` | sonnet | Read; Write; Edit; Bash; Grep; Glob | Dart/Flutter build analysis and dependency error resolution specialist. Fixes dart analyze errors Flutter compilation failures pub dependency conflicts and build_runner issues. |
| `go-build-resolver` | sonnet | Read; Write; Edit; Bash; Grep; Glob | Go build vet and compilation error resolution specialist. Fixes build errors go vet issues and linter warnings with minimal changes. Use when Go builds fail. |
| `java-build-resolver` | sonnet | Read; Write; Edit; Bash; Grep; Glob | Java/Maven/Gradle build compilation and dependency error resolution specialist. Fixes build errors Java compiler errors and Maven/Gradle issues. Use when Java or Spring Boot bui... |
| `kotlin-build-resolver` | sonnet | Read; Write; Edit; Bash; Grep; Glob | Kotlin/Gradle build compilation and dependency error resolution specialist. Fixes build errors Kotlin compiler errors and Gradle issues. Use when Kotlin builds fail. |
| `pytorch-build-resolver` | sonnet | Read; Write; Edit; Bash; Grep; Glob | PyTorch runtime CUDA and training error resolution specialist. Fixes tensor shape mismatches device errors gradient issues DataLoader problems and mixed precision failures. |
| `rust-build-resolver` | sonnet | Read; Write; Edit; Bash; Grep; Glob | Rust build compilation and dependency error resolution specialist. Fixes cargo build errors borrow checker issues and Cargo.toml problems with minimal changes. |


## Multi-Agent Orchestration

<a id="orchestration"></a>

> 8 agents

| Agent | Model | Tools | Description |
|---|---|---|---|
| `agents-orchestrator` | inherit | All tools | Autonomous pipeline manager that orchestrates the entire development workflow — the conductor who runs the entire dev pipeline from spec to ship. |
| `conversation-analyzer` | sonnet | Read; Grep | Analyze conversation transcripts to find behaviors worth preventing with hooks. Triggered by /hookify without arguments. |
| `executor` | sonnet | All tools | Focused task executor for implementation work. |
| `gan-evaluator` | opus | Read; Write; Bash; Grep; Glob | GAN Harness — Evaluator agent. Tests the live running application via Playwright scores against rubric and provides actionable feedback to the Generator. |
| `gan-generator` | opus | Read; Write; Edit; Bash; Grep; Glob | GAN Harness — Generator agent. Implements features according to the spec reads evaluator feedback and iterates until quality threshold is met. |
| `gan-planner` | opus | Read; Write; Grep; Glob | GAN Harness — Planner agent. Expands a one-line prompt into a full product specification with features sprints evaluation criteria and design direction. |
| `harness-optimizer` | sonnet | Read; Grep; Glob; Bash; Edit | Analyze and improve the local agent harness configuration for reliability cost and throughput. |
| `loop-operator` | sonnet | Read; Grep; Glob; Bash; Edit | Operate autonomous agent loops monitor progress and intervene safely when loops stall. |


## Design & UX

<a id="design"></a>

> 7 agents

| Agent | Model | Tools | Description |
|---|---|---|---|
| `brand-guardian` | inherit | All tools | Expert brand strategist and guardian specializing in brand identity development consistency maintenance and strategic brand positioning. |
| `designer` | sonnet | All tools | UI/UX Designer-Developer for stunning interfaces. |
| `image-prompt-engineer` | inherit | All tools | Expert photography prompt engineer specializing in crafting detailed evocative prompts for AI image generation tools. |
| `ui-designer` | inherit | All tools | Expert UI designer specializing in visual design systems component libraries and pixel-perfect interface creation. |
| `ux-architect` | inherit | All tools | Technical architecture and UX specialist who provides developers with solid foundations CSS systems and clear implementation guidance. |
| `ux-researcher` | inherit | All tools | Expert user experience researcher specializing in user behavior analysis usability testing and data-driven design insights. |
| `visual-storyteller` | inherit | All tools | Expert visual communication specialist focused on creating compelling visual narratives multimedia content and brand storytelling through design. |


## Product Management

<a id="product"></a>

> 5 agents

| Agent | Model | Tools | Description |
|---|---|---|---|
| `behavioral-nudge-engine` | inherit | All tools | Behavioral psychology specialist that adapts software interaction cadences and styles to maximize user motivation and success. |
| `feedback-synthesizer` | inherit | WebFetch; WebSearch; Read; Write; Edit | Expert in collecting analyzing and synthesizing user feedback from multiple channels to extract actionable product insights. |
| `product-manager` | inherit | All tools | Holistic product leader who owns the full product lifecycle — from discovery and strategy through roadmap stakeholder alignment go-to-market and outcome measurement. |
| `sprint-prioritizer` | inherit | WebFetch; WebSearch; Read; Write; Edit | Expert product manager specializing in agile sprint planning feature prioritization and resource allocation. Maximizes team velocity and business value delivery. |
| `trend-researcher` | inherit | WebFetch; WebSearch; Read; Write; Edit | Expert market intelligence analyst specializing in identifying emerging trends competitive analysis and opportunity assessment. |
