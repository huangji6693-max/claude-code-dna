# warp + ruflo + anthropics/skills 精华 · 自动加载（决策器 + 触发词 + 速查）

> 完整深读（按需 Read 一次）：
> - `~/.claude/references/anthropics-skills-deep.md` — agentskills.io spec + 17 范本 + skill-creator 评测协议
> - `~/.claude/references/warp-deep.md` — Warp Rust 架构 + Agent Mode + Block-as-object + spec-PR 流程
> - `~/.claude/references/ruflo-deep.md` — claude-flow rebrand · 46k stars · Federation/AgentDB/GOAP/Verification

## 三库一句话定位

| 库 | 是什么 | 核心唯一价值 |
|---|---|---|
| **anthropics/skills** | 官方 17 skill + agentskills.io 正式 spec（131k stars） | **规范层 + 评测层** · 现有 179 民间 skill 缺这两个 |
| **warpdotdev/warp** | Rust agentic 终端 · 客户端开源 · 自带 20 skill 仓库 | **Block-as-object + spec-PR 强制门禁 + skill 格式与 Anthropic 100% 互通** |
| **ruvnet/ruflo** | claude-flow rebrand · 46k stars · 工业级 agent 编排 | **Federation 跨机器零信任 + AgentDB(HNSW) + GOAP A* planner + 字节签名 verification** |

## 何时触发自动加载完整版（信号词命中即 Read）

| 场景 | 信号词 | 读哪份 |
|---|---|---|
| 写 / 审 / 改 skill | "写一个 skill / SKILL.md / description 优化 / skill 评测 / agentskills.io / 审计 179 skill" | anthropics-skills-deep |
| Agent 工具白名单 | "allowed-tools / skill 级权限 / 收窄工具" | anthropics-skills-deep |
| 终端 / CLI agent UI | "warp / agentic terminal / block-as-object / 命令块可寻址 / replay / RTK 加 X" | warp-deep |
| Spec-driven 流程 | "spec-PR / spec-driven / specs 目录 / PRODUCT.md+TECH.md 先于代码" | warp-deep |
| Feature flag 三档 | "dogfood/preview/release / 运行时 flag" | warp-deep |
| Agent 编排框架 | "ruflo / claude-flow / multi-agent orchestration / Queen-led swarm" | ruflo-deep |
| 跨机器 Agent | "agent federation / 零信任协作 / mTLS+ed25519 / PII 4 级 BLOCK/REDACT/HASH/PASS" | ruflo-deep |
| 持久 agent 内存 | "AgentDB / HNSW / SONA / ReasoningBank / trajectory learning" | ruflo-deep |
| 状态空间 planner | "GOAP / A* planner / 状态空间搜索替代 CoT" | ruflo-deep |

**不触发**：日常调用具体 skill / 用普通终端命令 / 单线程一次性 agent 任务。

## 12 条可立即偷的工程模式（合三库精华）

### Skills 规范类（来自 anthropics/skills）
1. **Description = 触发器**（不是说明）· 写"做什么 + 何时用 + 关键词" · ≤1024 字 · 带"应该 / 必须 / 不要"语气
2. **500 行硬上限 · 超出拆 references/** · `SKILL.md` 主文件不堆料 · 长文档拆专题文件
3. **Imperative + 解释"为什么"** · 反 ALL-CAPS-MUST 反模式 · "LLM 对推理响应优于命令"（**与用户"不要 PUA 腔调"反馈完全一致**）
4. **eval 协议**：`evals.json` + 20 query（10 should-trigger + 10 should-not-trigger）+ 60/40 train-test split + 5 轮迭代选 best description
5. **`allowed-tools` 字段**：skill 级权限收窄 · 实验性但已写进 spec · 不再依赖全局 settings.json allow

### Warp 类（CLI / agent UI 模式）
6. **运行时 feature flag > #[cfg]** · 三档 dogfood/preview/release · 免重编切 · PR 易清理
7. **Block-as-object** · 命令输出建模成 entity（id+metadata+exit_code+cwd+ai_context）· 可寻址 / 分享 / replay / 注入 agent
8. **Action / ActionResult / Citation 三件套** · agent 每个工具调用强制 typed action + typed result + 强制 citation（防幻觉、可审计）
9. **Diff Validation 闸门** · agent 生成 patch 在 apply 前过 validator（语法/类型/lint）· 失败回环重生成
10. **Spec-PR 先于 Code-PR** · `specs/<ticket>/PRODUCT.md+TECH.md` 走完 review 才写代码 · 1k+ LOC / 跨子系统强制

### Ruflo 类（agent 编排深度）
11. **Federation 信任分公式**：`0.4×success + 0.2×uptime + 0.2×threat + 0.2×integrity` · 行为驱动信任升降级
12. **GOAP A\* 替代 CoT**：自然语言 → 状态空间显式可视化 → 失败重 plan 而非重启对话

## 关键格式互通（这是金矿）

**Warp `.agents/skills/` 跟 Anthropic `anthropics/skills/skills/` 用一模一样的 SKILL.md 格式**：
```
---
name: kebab-case-name           # ≤64 字符 · [a-z0-9-]+
description: 做什么 + 何时用 + 关键词    # ≤1024 字符
allowed-tools: Bash(git:*) Read   # 可选 · skill 级权限
---

正文（≤500 行）
```
→ 现有 179 个 skill 直接用这个 spec **审计合规** + **跨工具复用**（Claude Code / Warp / 任何按 spec 实现的 agent）。

## 与现有 11 库 DNA 的互补点（不重叠的纯增量）

| 增量来源 | 内容 | 用法 |
|---|---|---|
| anthropics/skills | spec 长度+正则约束 / eval 协议 / allowed-tools | 给 `skillify` `skill-stocktake` 加合规审计闸门 |
| warp | Block-as-object / spec-PR / feature flag 三档 | RTK 可加 `rtk replay <id>` · 大改动强制 spec-PR |
| ruflo | Federation / AgentDB / GOAP planner / 签名验证 | 跨机器 agent 协作时整套移植 |

**已被覆盖（不必再吸）**：
- skill 创建（已有 `skillify` / `writing-skills`）
- 文档/前端 skill（已有 `pptx-pro / docx-pro / frontend-design`）
- agent 编排（已有 `dispatching-parallel-agents` / oh-my-claudecode）
- progressive disclosure 三级 ≈ Karpathy 律 2 + memory-optimization 三层访问

## 项目相关性

- **project-a** 弱相关（H5/Flutter 主导，不需要 agent federation）
- **project-b** 中相关（GOAP planner 可用于交易决策状态机；Federation 不必）
- **project-c** 弱相关（C 端产品，agent 编排在自家 Spring Boot，不需要 ruflo）
- **RTK** 强相关（Warp Block-as-object 直接可偷给 RTK · `rtk replay <block_id>`）
- **Claude Code 工作流自身** 强相关（anthropics/skills spec 给 179 skill 立标准）

## 一句话压缩

> **anthropics/skills = 规范层（写 skill 必读）· warp = agent UI/工程模式金矿（命令块 + spec-PR + flag 三档）· ruflo = agent 编排工业化天花板（Federation + AgentDB + GOAP）。** 三库不重叠 · 各占一格 · 命中信号词再 Read 对应 deep ref · 平时只看这一页就够。
