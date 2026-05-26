<div align="center">

# Claude Code DNA

**Claude Code agent 的行为操作系统。**

不是又一个 awesome-list。一套经过实战检验的规则、记忆架构、工具链 —
从 11 个精读的库（179 skill + 99 agent + Karpathy 反模式 + 记忆研究）里提炼出来，
塑造 agent *如何* 思考、决策、记忆。

[30 秒安装](#安装) · [为什么需要](#为什么) · [包含什么](#包含什么) · [English](README.md)

[![Stars](https://img.shields.io/github/stars/huangji6693-max/claude-code-dna?style=social)](https://github.com/huangji6693-max/claude-code-dna)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

</div>

---

## 问题

装了 200 个 skill、100 个 agent，`~/.claude/` 一堆半残配置。agent 还是：

- 没验证就喊 *"完成！"*
- 50 行能搞定的功能写 200 行
- "顺手重构一下" 把 diff 搞乱
- 跨会话忘记你的偏好
- 把上下文烧在不相关的记忆上

问题不是 skill 不够多。问题是 agent **没有一致的 DNA** —
没有内化的反射：*什么时候该想*、*什么时候该验证*、*该记什么*、*该忽略什么*。

## 这是什么

一个 184KB 的 drop-in 包，给 Claude Code：

| 层 | 作用 |
|---|---|
| **🧬 规则**（8 文件 ~50KB） | 行为反射 — Karpathy 4 律、15 条操作直觉、验证门、调试纪律 |
| **🧠 记忆系统** | mem0 + langmem + GraphRAG 启发的架构，跨会话持久化但不污染上下文 |
| **🛠 脚本**（3 个工具） | `memory-health`（审计）、`memory-search`（BM25 风格本地检索）、`skill-spec-audit`（agentskills.io 合规） |
| **📚 目录**（CSV） | 194 skill + 99 agent 的分类、关键词、合规评分索引 |
| **📖 文档** | 哲学、决策路由表、生产环境反模式 |

**零密钥。零项目数据。100% drop-in。**

## 安装

```bash
git clone https://github.com/huangji6693-max/claude-code-dna.git
cd claude-code-dna
./install.sh
```

安装器会：
1. 复制 `rules/` 到 `~/.claude/rules/`（不覆盖 — 先备份）
2. 把 `scripts/` 软链到 `~/.claude/scripts/`
3. 打印一行片段，让你贴到 `CLAUDE.md` 自动加载
4. 跑 `memory-health.sh` 烟测

## 包含什么

### 1. Karpathy 4 律（写代码前的日常清单）

```
律 1 — Think Before Coding   : 暴露假设，不要默默挑一个解读
律 2 — Simplicity First       : 200 行能 50 行就重写
律 3 — Surgical Changes       : 每行 diff 都能追溯到原始请求
律 4 — Goal-Driven Execution  : 弱目标 = 必失败；转化为可验证 success criteria
```

这四条变成反射。agent 不再为琐事请示，反而会在请求模糊时推回。

### 2. 15 条操作直觉（验证门、TDD、根因纪律）

从真实事故学来的硬规则：
- 任何 "done" 声明前必经**验证门**（禁止软化词：*should*、*probably*、*seems*、*Great!*）
- **根因先于修复**（4 阶段调试 — 读 → 重现 → 假设 → 修）
- **TDD red-green-refactor**（没有失败测试不写生产代码）
- **两阶段审查**（先 Spec 合规、再代码质量 — 永不反过来）
- ...还有 11 条

### 3. 记忆架构（杀手锏）

大多数团队默认 "把所有东西塞记忆里" → 上下文爆炸。

本 DNA 用 3 层访问模式：

```
SessionStart 注入   →  MEMORY.md 顶层索引（≤200 行，始终加载）
关键词命中           →  scope 专属 INDEX.md（按需加载）
跨记忆查询           →  全文件扫描（仅当用户喊"复盘"）
```

加上 mem0 v3、langmem、GraphRAG、Karpathy KB-not-vector 哲学的 8 条硬规则。
结果：agent 行为跨会话持久，但每次对话上下文不膨胀。

### 4. 三个每周都用的脚本

```bash
# 审计记忆健康度（坏链接、孤儿、陈旧文件、frontmatter 合规）
$ ./scripts/memory-health.sh

# 本地 BM25 风格检索 — <1000 文件无需向量库
$ ./scripts/memory-search.sh -s project-b "止损 复现性"

# 按 agentskills.io spec 审计 skill（name 格式、行数、frontmatter）
$ ./scripts/skill-spec-audit.sh ~/.claude/skills
```

### 5. Skill + Agent 目录

`catalog/skills.csv` 和 `catalog/agents.csv` — 分类、关键词、合规审计的索引。
用来：
- 决定装哪些 skill（**本仓库不分发 skill 源码** — 见[哲学](#哲学)）
- 通过关键词找对的 agent
- 审计自己收藏夹的冗余

## 哲学

**本仓库刻意不重新分发** 上游项目（anthropics/skills、forrestchang/karpathy-skills、ECC 等）的 skill / agent 源码。

原因：许可证复杂、归因债、目录索引真实上游比快照快照更有价值。

**我们交付的是原创**：跨库精读综合的 DNA 规则、记忆架构、审计工具、精选索引。

要 skill 本身？目录指向每个的家。

## 兼容性

- **Claude Code**（主要目标）
- **Cursor** — 规则是 markdown，丢进 `.cursorrules` 或 `.cursor/rules/`
- **Codex / Gemini CLI / 任何 agent 框架** — 规则模型无关，记忆脚本只用 `bash + awk + python3`
- **Warp** — `agentskills.io` spec Anthropic / Warp 完全一致

## 致谢

本 DNA 综合自 11 个精读库：

- [anthropics/skills](https://github.com/anthropics/skills) — agentskills.io spec 权威
- [obra/superpowers](https://github.com/obra/superpowers) — 验证 + TDD 反射
- [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) — 反模式
- [mem0ai/mem0](https://github.com/mem0ai/mem0) — ADD-only 记忆
- [langchain-ai/langmem](https://github.com/langchain-ai/langmem) — 3 类型 × 2 时机
- [microsoft/graphrag](https://github.com/microsoft/graphrag) — 社区摘要索引
- [ruvnet/claude-flow](https://github.com/ruvnet/claude-flow) — agent 编排
- [warpdotdev/warp](https://github.com/warpdotdev/warp) — block-as-object + spec-PR
- [VectifyAI/PageIndex](https://github.com/VectifyAI/PageIndex) — vectorless RAG
- 以及若干私人收藏蒸馏出的可公开版本

如果某条规则可识别出自你的工作但未归因，开 issue —
会立即修正归因。

## 许可

MIT — 见 [LICENSE](LICENSE)。商用自由。

## 贡献

PR 欢迎：
- 翻译（中→英、其他语言）
- 新库的决策路由表
- 更好的目录评分方法
- 真实的 `examples/` CLAUDE.md 集成

见 [CONTRIBUTING.md](CONTRIBUTING.md)。

---

<div align="center">

**如果它省你一次烂决策，给个 star。**
**省你二十次？[告诉别人](https://twitter.com/intent/tweet?text=%E5%88%9A%E5%8F%91%E7%8E%B0%20claude-code-dna%20%E2%80%94%20Claude%20Code%20%E7%BC%BA%E7%9A%84%E8%A1%8C%E4%B8%BA%E6%93%8D%E4%BD%9C%E7%B3%BB%E7%BB%9F&url=https://github.com/huangji6693-max/claude-code-dna)。**

</div>
