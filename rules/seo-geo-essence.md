# SEO + GEO 精华工作流 · 自动加载（决策器 + 5 步速查）

> 完整工程模式 / 代码片段 / 案例研究 / 避坑清单：`~/.claude/references/seo-geo-deep.md` · 写代码前 Read 一次。
> 沉淀来源：project-c Phase A 实战（2026-04-30 · llms.txt + JSON-LD 4 实体 + IndexNow + sitemap） + GitHub 调研（thedaviddias/llms-txt-hub · google/schema-dts · gego · renfei/Indexing）+ 7 个真实案例（Stripe / Vercel / Anthropic / Cloudflare / Trigger.dev / Character.AI / 豆包）。

---

## 一、核心区别（GEO ≠ SEO · 2026 后必懂）

| 维度 | SEO（传统搜索） | GEO（生成式引擎优化） |
|---|---|---|
| **优化目标** | Google/百度排名 | ChatGPT/Perplexity/Claude **被引用率（citation rate）** |
| **爬虫** | Googlebot / Baiduspider | GPTBot / ClaudeBot / PerplexityBot / Bytespider / Google-Extended |
| **关键文件** | sitemap.xml + robots.txt | **llms.txt + llms-full.txt**（llmstxt.org 标准） |
| **结构化数据** | JSON-LD Schema.org | JSON-LD + 自然语言 FAQ + 锚点标签 |
| **信号** | backlink + 页面质量 + Core Web Vitals | 内容权威性 + 引用清晰度 + Reddit/Wiki/Github 提及 |
| **回报周期** | 几周到几月 | LLM 训练数据更新 / Perplexity 实时索引（更快） |

**洞察**：2026 年的 AI 引擎重点是**被引用**而非排名。Perplexity 重 Reddit + Wikipedia，ChatGPT 依赖训练数据 + browse，Claude 依赖 web search。

---

## 二、何时触发（命中即读完整版）

| 场景 | 信号词 | 是否上 |
|---|---|---|
| 新产品上线 / 对外曝光 | "做 SEO" / "推广" / "搜不到" / "Google 收录" | ✅ Phase A 全套 |
| 已有站点优化 | "提升排名" / "AI 引用" / "Perplexity citation" | ✅ Phase B/C |
| 内部工具 / Dashboard | "内部用" / "登录后" | ❌ 不需要 |
| 产品已成熟（>6 月）| "再优化" | ✅ 只做 Phase C |

**project-a 弱相关**（直播社区，主入口非搜索）。**project-b 无关**（自用工具）。**project-c 强相关**（C 端产品 ✅）。

---

## 三、5 步工作流（Phase A 12-20h MVP）

### Phase A · 基础设施（一次性 · 必做）

```
Step 1  llms.txt + llms-full.txt（llmstxt.org 标准）
        位置：根域 /llms.txt（不能在子目录）
        内容：产品定位 + 核心场景 + 文档入口
        
Step 2  robots.txt（33 UA · GEO 友好）
        必含 Allow：GPTBot / ClaudeBot / PerplexityBot / Bytespider / Doubao / KimiBot / Google-Extended / Applebot-Extended / CCBot
        
Step 3  sitemap.xml + JSON-LD @graph
        sitemap：只放真 URL，不放 hash 路由
        JSON-LD：SoftwareApplication + Organization + WebSite + FAQPage 4 实体
        
Step 4  OG / Twitter / WeChat itemprop
        og:image 必须 1200×630 · png 优先 · width/height/alt 齐全
        
Step 5  IndexNow + Search Console
        IndexNow：Bing / Yandex / IndexNow.org 三端 ping（202 = 接受）
        Search Console：需用户验证站点（无法 auto）
```

### Phase B · 内容 + 外链（持续）

```
6  Backlink 建设
   - GitHub 公开仓库（README + topics + homepage URL）
   - 自有站点 cross-link（同主体下产品互推）
   - awesome-list 提交（awesome-ai-companions 类）
   - Product directory（Toolify / TAFTA / AlternativeTo）

7  Earned media
   - 知乎长文 / 小红书种草 / V2EX 创造分享
   - 即刻动态 / Twitter 线程

8  中文搜索专项（renfei/Indexing 风格）
   - 百度站长 sitemap 主动推送 API
   - 神马 / 搜狗 / 360 验证
```

### Phase C · 监控 + 迭代（周期）

```
9  GEO 引用率监测（gego 工具）
   - 跨 ChatGPT / Perplexity / Claude / 豆包 / Kimi 自动测试
   - 关键词 → 引用率 → 内容优化反馈环
   
10 Lighthouse SEO CI（GitHub Actions）
   - 每次部署跑 SEO + Performance + Best Practices
   - PR 阶段 block 退步
```

---

## 四、Schema.org 选型速查（AI 产品）

| 产品类型 | 主 @type | 错选会怎样 |
|---|---|---|
| AI 陪伴 / Roleplay | `SoftwareApplication` + `applicationCategory: "SocialNetworkingApplication"` | 选 `ChatApplication` 会被 Perplexity 误分类 |
| AI 工具 / SaaS | `SoftwareApplication` + `WebApplication` | - |
| AI 助手（如 ChatGPT 类） | `SoftwareApplication` + `applicationCategory: "BusinessApplication"` | - |
| 知识库 / 文档 | `Article` + `TechArticle` | - |
| 课程 / 教学 | `Course` + `LearningResource` | - |

**所有 AI 产品都建议加**：`FAQPage`（被 Google AI Overview 大量引用）+ `Organization`（提升 E-E-A-T）+ `BreadcrumbList`（搜索结果展示面包屑）。

---

## 五、避坑铁律（实测失败模式）

1. **❌ robots.txt 默认 block AI 爬虫** → ✅ 必须 `Allow: /` for GPTBot/ClaudeBot/PerplexityBot
2. **❌ sitemap 放 hash URL** `#/page` → Google 完全不索引，浪费预算
3. **❌ llms.txt 放子目录** `/docs/llms.txt` → LLM 爬虫只读根 `/llms.txt`
4. **❌ Schema.org @type 选错** → AI 陪伴用 ChatApplication 会被错分类
5. **❌ OG/JSON-LD 放在 head 后 2KB+** → Perplexity 爬虫不读
6. **❌ 单个 sitemap >50MB / >50k URL** → Google 跳过，需拆 sitemap index
7. **❌ nginx location-level add_header 覆盖 server-level** → 安全 headers 丢失（project-c 踩过 · 用 snippet + include 修）
8. **❌ Flutter SPA hash 路由 + sitemap** → Googlebot 抓不到 SPA 内部路由，必须 SSR/静态化
9. **❌ 品牌词撞红海** → 必加长尾词（"产品名 + AI / 工具 / 替代品 / 对比"）

---

## 六、自动化资产（project-c 已沉淀 · 可复用）

| 资产 | 路径 | 用途 |
|---|---|---|
| llms.txt 模板 | `~/your-project/seo/llms.txt` | LLM 短摘要 |
| robots.txt 33UA | `~/your-project/seo/robots.txt` | GEO 友好爬虫白名单 |
| OG 图生成器 | `/tmp/gen_og_cover.py` | PIL · 1200×630 · 中文字体 |
| nginx SEO 块 | VPS `/etc/nginx/sites-enabled/project-a.conf` | 4 location alias |
| security-headers snippet | VPS `/etc/nginx/snippets/security-headers.conf` | location 级 include 修复 |
| IndexNow 提交 | `curl -X POST https://api.indexnow.org/IndexNow` | Bing/Yandex/IndexNow.org 三端 |

---

## 七、外部信号需用户配合（不能 auto）

| 任务 | 用户要做的 |
|---|---|
| Google Search Console | 在 search.google.com/search-console 添加站点 + 验证（meta tag / DNS / HTML 文件三选一），把 token 给我，我注入页面 |
| 百度站长 | 在 ziyuan.baidu.com 验证 + 拿 token，我做 sitemap 主动推送脚本 |
| Bing Webmaster | 在 www.bing.com/webmasters 验证（IndexNow 已自动 ping，但 Webmaster 可看分析） |
| 知乎/小红书/V2EX 发文 | 用户有账号 → 我出文案，用户贴 |
| GitHub 公开品牌仓库 | 我准备好 README，用户说一声"建吧"我即刻 push |

---

## 八、Phase D 高阶补充（命中即 Read 完整版第十一章）

### 8.1 Flutter / SPA 项目必读

| 红线 | 检查 | 修法 |
|---|---|---|
| **Canvas 无 DOM** | curl SPA 路径 → 文本 <5KB? | 独立静态 landing 页 + Jaspr SSR + Dynamic Rendering |
| GPTBot/PerplexityBot 不执行 JS | View page source 看不到内容 | Puppeteer/Playwright 构建时快照 |
| Schema 在 JS 里 | JSON-LD 必须在初始 HTML | 服务端注入 / 静态化 |

### 8.2 GEO 监测工具速查（Phase C）

- Sight AI / Peec AI（企业级）· LPagery（Perplexity 重点）· HubSpot AEO Grader（免费基线）
- A/B 样本量：差异 ≥10% → 500-1000 prompt · ≥5% → 3000+ · 周期 3-4 周

### 8.3 训练数据进入 5 层（ROI 排序）

⭐⭐⭐⭐⭐ **CommonCrawl** 允许 CCBot/2.0 → +30-50% 引用率
⭐⭐⭐⭐⭐ **GitHub Stars** 5000 = 主流 LLM 收录 · 50000 = 行业标准
⭐⭐⭐ Reddit/HN 高赞评论 · 6-12 月信誉积累
⭐⭐⭐ Wikipedia 3-5 条独立第三方报道（AI 生成 70% 删除率）
⭐⭐ arXiv/顶会论文 · 长周期

**革命洞察**：开源 5000 stars 工具 > 100 篇 SEO 文章。

### 8.4 关键引擎规律

- **Perplexity ≠ 自建索引** → 实时调 Google/Bing API → 传统 SEO 是前置
- **Google AI Overview** → FAQ/HowTo/Rating Schema 关键
- **ChatGPT/Claude** → Reddit/GitHub 权重 > 通用网页

### 8.5 Web Vitals 极限工具

- LCP <1s：preload + fetchpriority="high" 三件套
- INP <100ms：`scheduler.yield()` 长任务每 100 yield
- CLS=0：`@capsizecss/core` font-metric-override
- Lighthouse CI：`treosh/lighthouse-ci-action@v10` PR 门禁

### 8.6 project-c 实战路线图

P0 立即（已完成）：landing 独立静态 + IndexNow + nginx 修
P0 评估：178 角色 pSEO（Astro 子站，千级页面）
P1 一周内：ASO 标题/截图/视频优化 · LCP <1s
P2 一月内：INP <100ms · CommonCrawl 收录验证
P3 长期：GitHub 5000 stars 策略 · CF Worker bot 检测

---

## 一句话压缩

> **SEO 是给 Google 看的，GEO 是给 ChatGPT/Perplexity 看的，2026 后两者都做才是完整答案。**
> Phase A 一天搞定基础设施 → Phase B 持续做外链 + earned media → Phase C 用 gego 测引用率反馈优化 → Phase D（SPA/pSEO/ASO/Web Vitals 极限）。
> **革命洞察**：开源 5000 stars 工具 > 100 篇 SEO 文章。GEO 时代是产品化竞争。
