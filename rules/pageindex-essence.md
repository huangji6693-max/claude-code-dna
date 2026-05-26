# PageIndex Essentials · Auto-loaded (decision matrix + 4 stealable patterns)

> Full doc (API signatures / 5-stage PDF pipeline / 30-line demo / install gotchas): `~/.claude/references/pageindex-vectorless-rag.md` · Read once before implementing.

## What it is (one line)

The LLM turns a document into a hierarchical tree (like a table of contents) → at retrieval time, the LLM reasons over the tree → **no vector DB / no cosine / no chunking**. FinanceBench 98.7%.

## When to use it (hit → trigger a full Read)

| Scenario | Signal words | Use it? |
|---|---|---|
| Domain document QA (finance / legal / papers / technical specs) | "parse annual report" / "look up contract clause" / "PDF QA" | ✅ |
| Agent + long document (>50-page PDF) | "agent reads PDF" / "process 100-page document" | ✅ |
| Repeated queries against the same document | "knowledge-base QA" / "query the same source multiple times" | ✅ |
| One-shot / short document | "summarize this section" / "<10 pages" | ❌ Just feed it into context |
| Massive heterogeneous corpus, pure similarity recall | "10M-scale search" / "find similar items" | ❌ Stick with vectors |

**Strong fit**: financial-research / legal / regulatory document parsing. Weak fit: consumer-app QA. No fit: code assistants.

## 4 stealable engineering patterns (you don't even need PageIndex itself)

| Pattern | One-liner | Where it fits |
|---|---|---|
| **A · Mode-based offset** | Given N (logical, physical) pairs → take the **mode of the differences** (not mean / median) as the global offset | Any "logical ↔ physical" alignment: log line numbers / subtitle timestamps / git diff |
| **B · Anchor tags beat JSON** | Have the LLM inline `<physical_index_5>` instead of returning `{page:5}` JSON | Any time the LLM has to point at locations in long text: line numbers / ranges / key sentences |
| **C · Multi-stage fallback with accuracy threshold** | Stage1 → verify → if acc<0.6 → Stage2 → ... all sharing the same verify function | Any "primary path + fallback + safety net" processing pipeline |
| **D · Sandwich-bounded retry** | Mislocated item[i] → retry within `[item[i-1].upper, item[i+1].lower]` | Sequential processing where one item is misplaced but the neighbors are correct |

## Install gotcha (don't step on this)

`pip install pageindex` = the SaaS SDK (calls a paid API). It is **not** the self-hosted engine on GitHub. The GitHub version has **no setup.py** — you must `git clone` and either use `PYTHONPATH=` or run from the repo root.

## Core API anchors (Read the full doc before coding)

```python
from pageindex import PageIndexClient
client = PageIndexClient(workspace="./ws", model="gpt-4o-2024-11-20")
doc_id = client.index("doc.pdf", mode="auto")        # str
client.get_document(doc_id)                          # JSON: metadata
client.get_document_structure(doc_id)                # JSON: tree (text stripped)
client.get_page_content(doc_id, "5-7")               # JSON: {page, content}[]
```

The 3 retrieve functions form the agent's toolset (register them with OpenAI Agents / Anthropic tools).
