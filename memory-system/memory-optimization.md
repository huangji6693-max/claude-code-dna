# 记忆系统优化（Memory Optimization）

> 融合自 mem0 v3（ADD-only）、langmem（3 类型 × 2 时机）、GraphRAG（社区摘要索引）、Karpathy LLM KB（文件+index 胜过向量）、dream-skill（consolidation）、claude-memory-compiler（SessionEnd 归档）。所有对话自动加载。

---

## 一、核心原则（8 条铁律）

### 1. Memory 存事实，Rules 存行为

- `~/.claude/projects/<proj>/memory/*.md` → **事实**（user / feedback / project / reference）
- `~/.claude/rules/**/*.md` → **行为规则**（procedural，如"不许给用户留 TODO"）
- 搞错归属是最常见污染：把行为规则塞进 memory → 200 行 MEMORY.md 炸穿，且其他会话吃不到
- **判定**：如果内容是"以后要 X / 不要 Y"→ rules；如果是"事情本身是 X"→ memory

### 2. 三类型 × 两时机（langmem）

| 类型 | 内容 | 写入时机 |
|---|---|---|
| **semantic** | 事实、偏好、项目元数据 | hot-path（当场明确表达立即写） |
| **episodic** | 一次成功/失败案例 | 任务结束后写，文件名含日期 |
| **procedural** | 以后该怎么做 | **不写 memory，写 rules** |

hot-path 只做**加法**，禁止归并/去重（会卡对话）。归并放 background。

### 3. ADD-only 优于 UPDATE（mem0 v3）

- 旧记忆错了 → **新写一条带日期的修正**，在 MEMORY.md 里把旧链接降级到 `~~strikethrough~~`
- 理由：保留决策时间线 + 防止 LLM 误删
- 每月 review 一次再批量归档（删除 strikethrough）
- 例外：纯 typo / 路径变更可以直接 Edit

### 4. Index = 社区摘要（GraphRAG + Karpathy KB）

`MEMORY.md` 每行 hook 必须回答 3 件事：**是什么 / 何时用 / 当前状态**。

```
❌ 差：- [project-b lessons](feedback_project-b_lessons.md) — 交易教训
✅ 好：- [⭐ 交易血泪教训](feedback_project-b_lessons.md) — 不逆势/不加分/WEL/atomic write · 每次下单前必读
```

信息密度 5 倍差距。

### 5. 显式淘汰规则（自创补空）

每个 memory frontmatter 必须能回答"什么时候可以删"。建议字段：

```yaml
expires_when: project_archived    # 项目归档后删
expires_when: superseded_by: <file>  # 被新文件取代
expires_when: never               # 用户身份/铁律，永不删
expires_when: 30d_unused          # 30 天没被引用就降级
```

没写 `expires_when` 的记忆默认按 `30d_unused` 处理。

### 6. 冲突解决顺序

两条 memory 冲突时按顺序裁决：

1. 更窄 scope 胜（project-specific > common）
2. 更新时间胜（frontmatter `updated:` 字段）
3. ⭐⭐⭐ 高优先级标记胜
4. 都不满足 → 写一条 `conflict_<topic>.md` 列两边，下次问用户

### 7. 纯文件 + index > 向量库（Karpathy）

- 个人量级（<1000 条）：markdown + frontmatter + MEMORY.md index 完全够用
- 检索靠 LLM 读 index 一次性命中，不上 Chroma/SQLite
- 文件名即索引：`<type>_<scope>_<topic>.md`（如 `feedback_project-b_lessons.md`）
- **超过 1000 条**再考虑向量化，目前 project-a+project-b+project-c 加起来远未到

### 8. 读记忆的三层访问

```
启动时注入（SessionStart）:  MEMORY.md 顶层 index（必读 · ≤200 行）
关键词命中:                    对应 feedback_*.md 全文（按需）
跨记忆推理:                    用户喊"复盘"才扫多文件
```

**禁止**把所有 `feedback_*.md` 全 import 到 CLAUDE.md → 爆 200 行红线。

---

## 二、写入前检查清单（写 memory 前必问）

- [ ] 这是事实还是行为规则？（行为规则 → 去 `~/.claude/rules/`）
- [ ] MEMORY.md 或同 type 文件里是否已有重叠条目？（grep 关键词 → 有就 Edit 合并而非 Write 新建）
- [ ] 文件名是否遵循 `<type>_<scope>_<topic>.md` 模板？
- [ ] frontmatter 是否含 `name / description / type / expires_when`？
- [ ] 相对日期（"昨天 / 上周"）是否已转成绝对日期？
- [ ] MEMORY.md 索引行的 hook 是否能答 "是什么 / 何时用 / 状态"？

---

## 三、反模式（踩过的坑）

| 反模式 | 为什么错 | 正确做法 |
|---|---|---|
| 在 memory 里记代码模式/架构/路径 | 代码是第一真相源，memory 会 rot | 读代码 / git blame |
| 把行为规则塞 memory/feedback_*.md | 其他项目会话吃不到 | 放 `rules/common/` |
| 每个小偏好都写一条 memory | MEMORY.md 爆 200 行红线 | 合并同主题到一个文件 |
| 在 hot-path 做归并/去重 | 卡对话 | background hook 异步处理 |
| 上 Chroma/SQLite 向量库 | <1000 条规模过度工程 | markdown + index 就够 |
| 用相对日期"昨天" | 几周后全部失效 | 写绝对日期 `2026-04-20` |
| MEMORY.md 里只留 link 没 hook | 命中率暴跌 | 每行必须有信息密度 hook |
| 会话结束自动写大量 memory | 噪声污染 | SessionEnd 只做 marker，consolidation 人类确认 |

---

## 四、Compact 幸存清单

context compact 后最容易丢的铁律（各会话 SessionStart 时主动检查这些是否还在记忆里；丢了就从 `operating-instincts.md` 恢复）：

- 不动手先 4 问 / 没失败测试不写代码 / 没验证不说 done / 3 次修复失败停手
- 不许给用户留 TODO · 完成给 done 清单
- SSH heredoc 必须 `set -o pipefail`
- 演示永远用 `agent.example.com` · 不给 `trycloudflare`
- APK/build/ffmpeg/推理 全去 VPS · 本机别跑
- 中文回答 · 不用 emoji 装饰 · 不 PUA 腔调

---

## 五、项目隔离加载策略（2026-04-20 v2 已实施）

用户明确要求："不要让不同聊天框的具体项目记忆混淆"。
Claude Code auto-memory 机制会把 `MEMORY.md` 全量注入每条对话的系统上下文 —— 如果顶层 MEMORY.md 列出所有项目的具体 hook，会把 project-a / project-b / project-c / tools 的细节互相污染。

### 当前结构

```
~/.claude/projects/-root/memory/
├── MEMORY.md                 # 顶层索引：只含 _global 全量 + 项目路由表（不展开项目具体 hook）
├── _global/                  # 跨项目通用（用户偏好、SOP、9 库笔记、工具链）· 始终加载
├── project-a/
│   ├── _INDEX.md             # project-a 专属索引 · 按需加载
│   └── <project-a-scoped>.md
├── project-b/
│   ├── _INDEX.md             # project-b 专属索引 · 按需加载
│   └── <project-b-scoped>.md
├── project-c/
│   └── _INDEX.md + scoped
└── tools/
    └── _INDEX.md + scoped
```

### 读取规则（每次会话开始默认行为）

1. **Auto-load 只吃 `MEMORY.md`** → 上下文只有 `_global/` 全量索引 + 4 个项目路由表条目（不暴露项目具体文件 hook）
2. **对话出现 scope 关键词** → 主动 `Read <scope>/_INDEX.md`，再按 index 命中再读具体文件
3. **scope 关键词映射示例**（按你的项目自定义）：
   - `project-a / <product-name> / <stack>` → project-a
   - `project-b / <product-name> / <stack>` → project-b
   - `project-c / <product-name> / <stack>` → project-c
   - `tools-pack / <utility-name>` → tools
4. **跨项目请求分别加载**：同时聊 project-a + project-b 才同时读两个 INDEX，不要默认全灌进来
5. **决策时互不引用**：处理 project-a 问题时，不要用 project-b 的 session handoff / bug 记录作为依据（反之亦然）

### 未来方向：cwd hash 真隔离（需用户授权）

Claude Code 原生 auto-memory 按 cwd-hash 路由（`~/.claude/projects/<cwd-hash>/memory/`）。目前所有 session 都从 `/root` 启动，所以全部落在 `-root` 下。

彻底隔离方案：
- project-a 会话在 `/root/projects/project-a` 启动 → auto-memory 自动切到独立目录
- `_global` 内容通过 SessionStart hook 软链或 include 到每个项目目录
- 需要用户决定项目工作目录结构

当前 v2 结构（MEMORY.md 瘦身 + 子目录 INDEX 懒加载）已经做到了"context 不混淆"的主要目标，未做 cwd 切换的原因是不改变用户的启动习惯。

---

## 六、相关文件

- `~/.claude/projects/*/memory/MEMORY.md` — 每项目 memory 索引
- `~/.claude/rules/common/operating-instincts.md` — 15 条操作铁律（procedural 主力）
- `~/.claude/rules/10libs-dna-v2.md` — 场景路由表（procedural）
- CLAUDE.md auto memory 章节 — 记忆系统使用说明

修改此文件 = 修改全局行为，谨慎。
