# PageIndex 精华 · 自动加载（决策器 + 4 偷模式速查）

> 完整文档（API 签名 / 5 阶段 PDF 管线 / 30 行 demo / 安装坑）：`~/.claude/references/pageindex-vectorless-rag.md` · 想动手前 Read 一次。

## 是什么（一句话）

LLM 把文档建成层级树（像目录）→ 检索时让 LLM 在树上推理搜索 → **没有向量库 / cosine / chunking**。FinanceBench 98.7%。

## 何时用（命中即触发完整版 Read）

| 场景 | 信号词 | 是否用 |
|---|---|---|
| 领域文档 QA（金融 / 法律 / 论文 / 技术规范） | "解析年报" / "查合同条款" / "PDF 问答" | ✅ |
| Agent + 长文档（>50 页 PDF） | "Agent 读 PDF" / "处理 100 页文档" | ✅ |
| 多次问同一文档 | "知识库问答" / "重复查询同一份资料" | ✅ |
| 一次性 / 短文档 | "总结这一段" / "<10 页" | ❌ 直接喂 context |
| 海量异构文档纯相似召回 | "千万级搜索" / "推荐相似" | ❌ 还是用向量 |

**project-b 项目强相关**：金融研报 / 公告解析。project-a 弱相关。project-c 无关。

## 4 个可偷工程模式（不必上 PageIndex 本体也能偷）

| 模式 | 一句话 | 适用 |
|---|---|---|
| **A · Mode 偏移** | N 对 (逻辑, 物理) → 取**差值众数**（不是 mean/median）作为全局 offset | 任何「逻辑↔物理」对齐：日志行号 / 字幕时间戳 / git diff |
| **B · 锚点标签 > JSON** | 让 LLM 就地插 `<physical_index_5>` 而非返回 `{page:5}` JSON | 任何让 LLM 指代长文位置：行号 / 区间 / 关键句 |
| **C · 多阶段 fallback + 准确率门限** | Stage1→verify→若 acc<0.6→Stage2→... 共享同一 verify 函数 | 任何「主路径+备选+兜底」处理流 |
| **D · Sandwich-bound 重试** | 错位 item[i] 用 [item[i-1].upper, item[i+1].lower] 限定范围重试 | 顺序处理后定位错位项 + 已知前后正确 |

## 安装陷阱（一定别踩）

`pip install pageindex` = SaaS SDK（调付费 API）**不是** GitHub 那个 self-hosted 引擎。GitHub 版**没 setup.py**，必须 `git clone` 后 `PYTHONPATH=` 用，或在仓库根目录跑。

## 核心 API 锚点（要写代码再 Read 完整版）

```python
from pageindex import PageIndexClient
client = PageIndexClient(workspace="./ws", model="gpt-4o-2024-11-20")
doc_id = client.index("doc.pdf", mode="auto")        # str
client.get_document(doc_id)                          # JSON: meta
client.get_document_structure(doc_id)                # JSON: tree (text 剥离)
client.get_page_content(doc_id, "5-7")               # JSON: {page,content}[]
```

3 个 retrieve 函数即 Agent 工具集（注册给 OpenAI Agents / Anthropic tools）。
