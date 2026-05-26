# SEO + GEO Essentials Workflow · Auto-loaded (decision matrix + 5-step quick reference)

> Full engineering patterns / code snippets / case studies / anti-patterns: `~/.claude/references/seo-geo-deep.md` · Read once before coding.
> Sources: production work on a consumer-facing project (2026-04-30 · llms.txt + JSON-LD 4 entities + IndexNow + sitemap) + GitHub research (thedaviddias/llms-txt-hub · google/schema-dts · gego · renfei/Indexing) + 7 real-world cases (Stripe / Vercel / Anthropic / Cloudflare / Trigger.dev / Character.AI / Doubao).

---

## 1 · Core Distinction (GEO ≠ SEO · essential post-2026)

| Dimension | SEO (classic search) | GEO (Generative Engine Optimization) |
|---|---|---|
| **Optimization target** | Google/Baidu ranking | ChatGPT/Perplexity/Claude **citation rate** |
| **Crawlers** | Googlebot / Baiduspider | GPTBot / ClaudeBot / PerplexityBot / Bytespider / Google-Extended |
| **Key files** | sitemap.xml + robots.txt | **llms.txt + llms-full.txt** (llmstxt.org standard) |
| **Structured data** | JSON-LD Schema.org | JSON-LD + natural-language FAQ + anchor tags |
| **Signals** | Backlinks + page quality + Core Web Vitals | Content authority + citation clarity + Reddit/Wiki/GitHub mentions |
| **Feedback loop** | Weeks to months | LLM training-data refresh / Perplexity real-time index (faster) |

**Insight**: in 2026 the AI-engine win is **being cited**, not ranking. Perplexity weighs Reddit + Wikipedia, ChatGPT relies on training data + browse, Claude relies on web search.

---

## 2 · When to trigger (hit → read the full doc)

| Scenario | Signal words | Run it? |
|---|---|---|
| New product launch / public exposure | "do SEO" / "promote" / "not searchable" / "Google indexing" | ✅ Full Phase A |
| Existing site optimization | "improve ranking" / "AI citations" / "Perplexity citation" | ✅ Phase B/C |
| Internal tool / dashboard | "internal use" / "login required" | ❌ Skip |
| Mature product (>6 months) | "further optimization" | ✅ Phase C only |

**Strong fit**: any consumer-facing product. **Weak fit**: social/live-streaming apps (search isn't the main entry). **No fit**: internal tools.

---

## 3 · 5-Step Workflow (Phase A is a 12-20h MVP)

### Phase A · Infrastructure (one-shot · required)

```
Step 1  llms.txt + llms-full.txt (llmstxt.org standard)
        Location: root domain /llms.txt (NOT in a subdirectory)
        Content: product positioning + core scenarios + doc entry points

Step 2  robots.txt (33 UAs · GEO-friendly)
        Must Allow: GPTBot / ClaudeBot / PerplexityBot / Bytespider / Doubao / KimiBot / Google-Extended / Applebot-Extended / CCBot

Step 3  sitemap.xml + JSON-LD @graph
        sitemap: real URLs only — no hash routes
        JSON-LD: SoftwareApplication + Organization + WebSite + FAQPage (4 entities)

Step 4  OG / Twitter / WeChat itemprop
        og:image must be 1200×630 · prefer PNG · width/height/alt all set

Step 5  IndexNow + Search Console
        IndexNow: ping Bing / Yandex / IndexNow.org (202 = accepted)
        Search Console: requires the user to verify the site (can't auto)
```

### Phase B · Content + Backlinks (ongoing)

```
6  Backlink building
   - Public GitHub repos (README + topics + homepage URL)
   - Cross-link your own sites (cross-promote same-owner products)
   - Submit to awesome-lists (e.g. awesome-ai-companions)
   - Product directories (Toolify / TAFTA / AlternativeTo)

7  Earned media
   - Long-form posts on Zhihu / Xiaohongshu / V2EX (or Reddit / HN / Indie Hackers)
   - Twitter/X threads / community feeds

8  Chinese-search specifics (renfei/Indexing style)
   - Baidu Webmaster sitemap push API
   - Verify on Shenma / Sogou / 360
```

### Phase C · Monitoring + Iteration (recurring)

```
9  GEO citation-rate monitoring (gego tool)
   - Automated tests across ChatGPT / Perplexity / Claude / Doubao / Kimi
   - Keyword → citation rate → content-optimization feedback loop

10 Lighthouse SEO CI (GitHub Actions)
   - Run SEO + Performance + Best Practices on every deploy
   - Block regressions at PR time
```

---

## 4 · Schema.org Selection (AI products)

| Product type | Primary @type | What goes wrong if you pick the wrong one |
|---|---|---|
| AI companion / Roleplay | `SoftwareApplication` + `applicationCategory: "SocialNetworkingApplication"` | Picking `ChatApplication` causes Perplexity to misclassify |
| AI tool / SaaS | `SoftwareApplication` + `WebApplication` | — |
| AI assistant (ChatGPT-like) | `SoftwareApplication` + `applicationCategory: "BusinessApplication"` | — |
| Knowledge base / docs | `Article` + `TechArticle` | — |
| Course / education | `Course` + `LearningResource` | — |

**Recommended for every AI product**: `FAQPage` (heavily cited in Google AI Overview) + `Organization` (boosts E-E-A-T) + `BreadcrumbList` (shows breadcrumbs in search results).

---

## 5 · Anti-patterns (observed failure modes)

1. **❌ robots.txt blocks AI crawlers by default** → ✅ must `Allow: /` for GPTBot/ClaudeBot/PerplexityBot
2. **❌ Sitemap contains hash URLs** `#/page` → Google won't index, wastes crawl budget
3. **❌ llms.txt in a subdirectory** `/docs/llms.txt` → LLM crawlers only read root `/llms.txt`
4. **❌ Wrong Schema.org @type** → AI-companion picking ChatApplication gets misclassified
5. **❌ OG/JSON-LD pushed past 2KB into the `<head>`** → Perplexity won't read it
6. **❌ Single sitemap >50MB / >50k URLs** → Google skips it — split into a sitemap index
7. **❌ nginx location-level `add_header` overrides server-level** → security headers vanish (seen in production · fix with snippet + include)
8. **❌ Flutter SPA hash routes + sitemap** → Googlebot can't crawl SPA internal routes — needs SSR/static rendering
9. **❌ Brand keyword competes in a red ocean** → must add long-tails ("<product> + AI / tool / alternative / comparison")

---

## 6 · Reusable Automation Assets

| Asset | Path | Purpose |
|---|---|---|
| llms.txt template | `~/your-project/seo/llms.txt` | LLM short summary |
| robots.txt (33 UAs) | `~/your-project/seo/robots.txt` | GEO-friendly crawler allowlist |
| OG-image generator | `/tmp/gen_og_cover.py` | PIL · 1200×630 · Chinese-font support |
| nginx SEO block | VPS `/etc/nginx/sites-enabled/<site>.conf` | 4 location aliases |
| security-headers snippet | VPS `/etc/nginx/snippets/security-headers.conf` | Location-level include to fix override loss |
| IndexNow submission | `curl -X POST https://api.indexnow.org/IndexNow` | Bing / Yandex / IndexNow.org all three |

---

## 7 · External Signals Requiring User Action (can't auto)

| Task | What the user needs to do |
|---|---|
| Google Search Console | Verify the site at search.google.com/search-console (meta tag / DNS / HTML file) and pass the token — I'll inject it into the page |
| Baidu Webmaster | Verify at ziyuan.baidu.com and pass the token — I'll wire up the sitemap-push script |
| Bing Webmaster | Verify at www.bing.com/webmasters (IndexNow already auto-pings, but Webmaster gives you analytics) |
| Post on Zhihu / Xiaohongshu / V2EX (or Reddit / HN) | User has the account — I'll draft the copy, user posts |
| Public brand GitHub repo | I'll prep the README — user says "create it" and I push |

---

## 8 · Phase D Advanced (hit → Read full doc, Chapter 11)

### 8.1 Required for Flutter / SPA projects

| Red line | Check | Fix |
|---|---|---|
| **Canvas, no DOM** | curl the SPA path → text <5KB? | Separate static landing page + Jaspr SSR + Dynamic Rendering |
| GPTBot/PerplexityBot don't execute JS | View page source — no content? | Puppeteer/Playwright snapshots at build time |
| Schema is in JS | JSON-LD must live in initial HTML | Server-side inject / static render |

### 8.2 GEO monitoring tools (Phase C)

- Sight AI / Peec AI (enterprise) · LPagery (Perplexity-focused) · HubSpot AEO Grader (free baseline)
- A/B sample sizes: ≥10% delta → 500-1000 prompts · ≥5% delta → 3000+ · 3-4 week cycle

### 8.3 5 layers to enter training data (ROI ranking)

⭐⭐⭐⭐⭐ **CommonCrawl** — allow CCBot/2.0 → +30-50% citation rate
⭐⭐⭐⭐⭐ **GitHub stars** — 5000 = mainstream LLM inclusion · 50000 = industry standard
⭐⭐⭐ Reddit/HN high-upvote comments · 6-12 month reputation buildup
⭐⭐⭐ Wikipedia 3-5 independent third-party references (70% AI-generated deletion rate)
⭐⭐ arXiv / top-conf papers · long cycle

**Revolutionary insight**: a 5000-star open-source tool > 100 SEO articles.

### 8.4 Key engine behaviors

- **Perplexity ≠ self-built index** → calls Google/Bing API in real time → classic SEO is a prerequisite
- **Google AI Overview** → FAQ/HowTo/Rating Schema are key
- **ChatGPT/Claude** → Reddit/GitHub weight > general web pages

### 8.5 Web Vitals power tools

- LCP <1s: preload + fetchpriority="high" trio
- INP <100ms: `scheduler.yield()` — every 100 long-task units, yield
- CLS=0: `@capsizecss/core` font-metric-override
- Lighthouse CI: `treosh/lighthouse-ci-action@v10` PR gate

### 8.6 Sample roadmap for a consumer AI product

P0 immediate: standalone static landing + IndexNow + nginx fix
P0 evaluate: pSEO over content corpus (Astro subsite, 1000+ pages)
P1 within a week: ASO title/screenshot/video optimization · LCP <1s
P2 within a month: INP <100ms · CommonCrawl ingestion verified
P3 long-term: GitHub 5000-stars strategy · Cloudflare Worker bot detection

---

## One-line compression

> **SEO is for Google; GEO is for ChatGPT/Perplexity. Post-2026 you need both for a complete answer.**
> Phase A is a one-day infrastructure setup → Phase B is ongoing backlinks + earned media → Phase C measures citations with gego and feeds back into content → Phase D pushes SPA / pSEO / ASO / Web Vitals to the limit.
> **Revolutionary insight**: a 5000-star open-source tool beats 100 SEO articles. The GEO era is a product-led competition.
