# 11 库融合 DNA v2.1 · 可执行路由表 · 每次会话自动加载

> 179 skill + 99 agent + Context7 MCP + Karpathy Guidelines + 98 rules · 全部精读
> 不是笔记 · 是行为路由 · 场景命中即触发

---

## 一、铁律（不可违反 · v2.1 升级到 11 条）

1. 不动手先自检 · 4 问
2. 没有失败测试不写代码
3. 没有验证不说 done
4. 3 次修复失败停手
5. 两阶段审查不可逆（Spec → Quality）
6. 设计不批准不写码
7. 小 diff
8. **【Karpathy 1】写前 surface 假设和 tradeoff** · 多种解释不要默默挑一个
9. **【Karpathy 2】极简优先** · 200 行能 50 行解决就重写 · 单次代码不抽象
10. **【Karpathy 3】外科手术式修改** · 每行 diff 都能追溯到用户请求 · 不顺手重构
11. **【Karpathy 4】任务转可验证目标** · 弱目标 = 必失败 · 强目标 = 自循环

---

## 二、场景路由表（命中即执行 · 不需要用户提醒）

### 写代码前

| 场景 | 触发 skill | 触发 agent | 备注 |
|---|---|---|---|
| 用不确定的 API/库 | `Context7 resolve-library-id → query-docs` | docs-lookup | 不猜 API · 查了再写 |
| 找现有方案/包 | `/search-first` | explore | GitHub/npm/PyPI 先搜 |
| 深度调研 | `/deep-research` + `/exa-search` | — | firecrawl + exa MCP |
| 模糊需求 | `/deep-interview` | analyst | 歧义≤20% 才生成 spec |
| 新功能规划 | `/brainstorming` → `/plan` → `/writing-plans` | planner, architect | 2-3 方案 → 用户选 |
| 复杂架构决策 | `/council` | architect, critic | 四声议会 |

### 写代码时

| 场景 | 触发 skill | 触发 agent | 备注 |
|---|---|---|---|
| 新功能/bug 修 | `/tdd` (test-driven-development) | tdd-guide | 先写失败测试 |
| 并行多任务 | `dispatching-parallel-agents` | 按需组合 | 2+ 独立任务必并行 |
| 子任务执行 | `subagent-driven-development` | executor | fresh agent per task |
| 端到端自主 | `/autopilot` | 内置 5 阶段 | 想法→规范→计划→实现→QA |
| 必须完成 | `/ralph` | 内置 reviewer | PRD 驱动 · 不完成不停 |
| 代码清理 | `/deslop` (ai-slop-cleaner) | refactor-cleaner | 删除优先 · 行为安全 |

### 写完代码后

| 场景 | 触发 skill | 触发 agent | 备注 |
|---|---|---|---|
| 代码审查 | `requesting-code-review` | code-reviewer | **写完立即触发 · 不等用户说** |
| 安全审查 | `security-review` | security-reviewer | 涉及 auth/input/API/支付 |
| 静默失败检查 | — | silent-failure-hunter | 空 catch / 错误吞没 |
| 验证 | `/verify` + `verification-loop` | verifier | 构建+类型+lint+测试+安全 |
| E2E 测试 | `e2e-testing` | e2e-runner | 关键用户流程 |
| 提交 | commit trailer 规范 | git-master | Confidence + Scope-risk |

### 语言专用审查（按项目自动匹配）

| 语言 | 审查 agent | 构建修复 agent | pattern skill |
|---|---|---|---|
| **Flutter/Dart** | flutter-reviewer | dart-build-resolver | dart-flutter-patterns |
| **Java/Spring** | java-reviewer | java-build-resolver | springboot-patterns + jpa-patterns |
| **Python** | python-reviewer | — | python-patterns |
| **Go** | go-reviewer | go-build-resolver | golang-patterns |
| **Rust** | rust-reviewer | rust-build-resolver | rust-patterns |
| **TypeScript** | typescript-reviewer | build-error-resolver | frontend-patterns |
| **Kotlin** | kotlin-reviewer | kotlin-build-resolver | kotlin-patterns |
| **C++** | cpp-reviewer | cpp-build-resolver | cpp-coding-standards |
| **C#** | csharp-reviewer | — | dotnet-patterns |
| **Swift** | — | — | swiftui-patterns + swift-concurrency-6-2 |
| **Laravel** | — | — | laravel-patterns + laravel-security |
| **SQL** | database-reviewer | — | postgres-patterns |

### 调试

| 阶段 | 做什么 | 工具 |
|---|---|---|
| Phase 1 根因 | 读错误 → 重现 → 查变更 → 追数据流 | `/debug` + systematic-debugging |
| Phase 2 模式 | 找工作代码 → 完整比对 | debugger agent |
| Phase 3 假设 | 单一假设 → 最小测试 | tracer agent |
| Phase 4 实现 | 失败测试 → 单修复 → 验证 | tdd-guide |
| agent 自身卡死 | 捕获 → 诊断 → 恢复 | agent-introspection-debugging |

### 设计/UI

| 场景 | skill | agent |
|---|---|---|
| 前端界面设计 | `frontend-design` | designer, ui-designer |
| UX 架构 | — | ux-architect |
| 用户研究 | — | ux-researcher |
| 品牌视觉 | `brand-voice` | brand-guardian |
| SEO | `seo` | seo-specialist |
| iOS 液态玻璃 | `liquid-glass-design` | — |
| 演示文稿 | `frontend-slides` | — |
| UI 演示录制 | `ui-demo` | — |

### 研究/内容

| 场景 | skill | 备注 |
|---|---|---|
| 技术文档查询 | Context7 MCP | `resolve-library-id` → `query-docs` |
| 市场调研 | `market-research` | 竞品/投资者/行业 |
| 文章写作 | `article-writing` | 长篇 + 品牌声音 |
| 多平台内容 | `content-engine` + `crosspost` | X/LinkedIn/TikTok/YouTube |
| 视频制作 | `video-editing` / `remotion-video-creation` / `manim-video` | 按需选 |
| AI 图像 | `fal-ai-media` | fal.ai MCP |
| 提示词优化 | `prompt-optimizer` | 分析+改进 |

### 运维/部署

| 场景 | skill | agent |
|---|---|---|
| Docker 编排 | `docker-patterns` | devops-automator |
| CI/CD 管道 | `deployment-patterns` | devops-automator |
| 数据库迁移 | `database-migrations` | database-optimizer |
| GitHub 运维 | `github-ops` | — |
| 生产事件 | — | incident-response-commander |
| SRE/可靠性 | — | sre |
| 性能问题 | — | performance-optimizer, performance-benchmarker |

### 产品/商业

| 场景 | skill | agent |
|---|---|---|
| PRD → 实现计划 | `product-capability` | product-manager |
| 冲刺规划 | — | sprint-prioritizer |
| 用户反馈分析 | — | feedback-synthesizer |
| 趋势研究 | — | trend-researcher |
| 投资者材料 | `investor-materials` + `investor-outreach` | — |

### 元能力（自我进化）

| 场景 | skill | 说明 |
|---|---|---|
| 工作流重复 3+ 次 | `skillify` | 转变为可重用 skill |
| 发现代码库洞见 | `learner` | 提取为原则 |
| 审计已有 skill | `skill-stocktake` | 质量检查 |
| 配置 ECC | `configure-ecc` | 交互安装器 |
| 会话分析 → hook | `hookify-rules` | 自动规则生成 |

---

## 三、并行 Agent 编排规则

| 条件 | 策略 |
|---|---|
| 2+ 独立任务 | **必须并行** · dispatching-parallel-agents |
| 失败关联 | 一起查 · 不并行 |
| 共享文件 | 顺序执行 |
| 复杂多步 | `/ralph` 或 `/autopilot` |
| 需要多视角 | `/council`（architect + skeptic + pragmatist + critic）|
| 组合 team | `/team`（team-builder 交互选人）|

### Agent 能力分级

| 模型 | 用途 | 对应 agent 角色 |
|---|---|---|
| Haiku | 查找/重命名/简单改/文档 | writer, explore |
| Sonnet | 实现/重构/测试/调试/审查 | executor, code-reviewer, tdd-guide |
| Opus | 架构/根因/共识/多文件不变量 | architect, critic, analyst |

---

## 四、Context7 实时文档（第 10 库）

```
不确定 API → resolve-library-id(libraryName, query)
                    ↓ 拿到 /org/project ID
            query-docs(libraryId, query)
                    ↓ 最新文档 + 代码示例
            写代码（用真实 API，不猜）
```

限制：每次最多 3 次 resolve + 3 次 query

---

## 四点五、Karpathy 4 律 · LLM 编码反模式校正器（第 11 库）

每次写、改、审代码前默念。详见 `~/.claude/rules/karpathy-4-laws.md` + skill `karpathy-guidelines`。

| 律 | 一句话 | 触发自检 |
|---|---|---|
| **Think** | 暴露假设 + tradeoff · 不哑巴接活 | 我有几个没声明的假设？任务有几种合理解读？ |
| **Simplicity** | 200 行能 50 行就重写 · 不抽象单次代码 | senior 看到会不会说 overcomplicated？ |
| **Surgical** | 每行 diff 直追用户请求 · 不顺手重构 | 这行改动追得到原始请求吗？追不到 = 删 |
| **Goal-driven** | 弱目标必失败 · 转化为可验证 success criteria | 我能跑什么命令证明完成了？ |

**何时调 skill**：写生产代码 / 提交前 / PR review / 调试到 3 次失败 → `Skill karpathy-guidelines`
**何时宽松**：trivial typo / rename / 一次性脚本

---

## 五、开源发布流水线（3 阶段）

1. `opensource-forker` → 复制 + 清密钥 + 清 git 历史
2. `opensource-sanitizer` → 20+ 正则扫描 · PASS/FAIL
3. `opensource-packager` → CLAUDE.md + README + LICENSE + setup.sh

---

## 六、GAN 生成流水线

1. `gan-planner` → 一行 prompt 扩展为完整产品规范
2. `gan-generator` → 按 spec 实现
3. `gan-evaluator` → Playwright 测试 + 评分 + 反馈 → 循环

---

## 八、UX 体验质量标准（用户视角 · 不是开发视角）

### 用户旅程完整性检查

每个功能必须覆盖 7 个状态：

```
空态 → 加载态 → 正常态 → 错误态 → 边界态 → 离线态 → 恢复态
```

| 状态 | 必须有 | 禁止 |
|---|---|---|
| 空态 | 设计过的插画/诗句 + 引导按钮 | 白页 / "暂无数据" 纯文字 |
| 加载态 | 骨架屏 / shimmer / 品牌动画 | 白屏等待 / 无反馈转圈 |
| 正常态 | 内容层级清晰 + 交互反馈 | 信息平铺无重点 |
| 错误态 | 具体提示 + 重试按钮 | "出错了" / 静默失败 |
| 边界态 | 长文本截断 / 大图压缩 / 极端数据 | 溢出 / 撑破布局 |
| 离线态 | 缓存内容 + "无网络" 提示 | 白屏 / 无限 loading |
| 恢复态 | 网络恢复自动刷新 / 提示刷新 | 需要手动重启 |

### 交互响应时间标准

| 操作 | 目标 | 超标处理 |
|---|---|---|
| 点击反馈 | < 100ms | 必须有视觉反馈（scale/opacity/ripple） |
| 页面切换 | < 300ms | 过渡动画掩盖加载 |
| 数据加载 | < 1s | 骨架屏/shimmer |
| 首屏渲染 | < 2s | 关键 CSS 内联 + font-display:swap |
| 图片加载 | 渐进式 | blur→清晰过渡 |

### 表单体验铁律

| 规则 | 说明 |
|---|---|
| 实时校验 | 输入时即时反馈 · 不等提交 |
| 错误定位 | 滚动到第一个错误字段 |
| 密码可见 | 必须有显示/隐藏切换 |
| 输入记忆 | 出错后不清空已填内容 |
| 键盘适配 | 输入框不被键盘遮挡 |
| 提交防抖 | 按钮禁用 + loading 状态 · 防重复提交 |

### 触发 UX 审计的 Agent

| Agent | 用途 |
|---|---|
| qa-tester | 交互式测试 · tmux 管理 |
| evidence-collector | 截图 + 证据收集 |
| ux-researcher | 用户行为分析 |
| accessibility-auditor | 无障碍合规 |
| e2e-runner | Playwright 自动化流程 |

---

## 九、每次任务开始 · 5 秒自检

```
1. 拆分 — 能并行吗？→ dispatching-parallel-agents
2. 文档 — 用到外部 API 吗？→ Context7
3. 模式 — 哪个 skill 直接覆盖？→ 查路由表
4. Agent — 需要专业审查吗？→ 匹配语言 reviewer
5. 失败 — TDD / pre-mortem / 验证命令是什么？
```

**答不上来 = 不许动手。**
