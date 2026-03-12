<p align="center">
  <img src="assets/banner.svg" alt="GEO-SEO Claude Code Skill" width="900"/>
</p>

<p align="center">
  <strong>GEO 優先，SEO 為輔。</strong> 針對 AI 驅動的搜尋引擎（ChatGPT, Claude, Perplexity, Gemini, Google AI Overviews）優化網站，同時維持傳統 SEO 基礎。
</p>

<p align="center">
  AI 搜尋正在吞噬傳統搜尋。本工具針對流量的未來趨勢進行優化，而非過去。
</p>

---

## 為什麼 GEO 在 2026 年至關重要？

| 指標 | 數值 |
|--------|-------|
| GEO 服務市場 | 8.5 億美元以上（預計 2031 年達 73 億美元） |
| AI 推薦流量增長 | 年增率 +527% |
| AI 流量轉化率 vs 有機搜尋 | 高出 4.4 倍 |
| Gartner 預測：2028 年搜尋流量將下降 | -50% |
| AI 搜尋中的品牌提及 vs 反向連結 | 相關性強 3 倍 |
| 投資於 GEO 的行銷人員 | 僅 23% |

---

## 快速開始

### 一鍵安裝 (macOS/Linux)

```bash
curl -fsSL https://raw.githubusercontent.com/zubair-trabzada/geo-seo-claude/main/install.sh | bash
```

針對特定的 CLI 目標安裝：

```bash
# Claude (預設)
./install.sh --cli claude

# Gemini CLI
./install.sh --cli gemini
```

> 注意：Gemini CLI 支援包括專門的 **Agent Skills** 和 **自定義指令 (Custom Command)** 快捷鍵。

### 手動安裝

```bash
git clone https://github.com/zubair-trabzada/geo-seo-claude.git
cd geo-seo-claude
./install.sh
```

### 需求環境

- Python 3.8+
- Claude CLI / Gemini CLI
- Git
- 選配：Playwright（用於截圖）

---

## 指令說明

開啟您選擇的 AI CLI 並使用以下指令：

| 指標 | 功能說明 |
|---------|-------------|
| `/geo audit <url>` | 使用平行子代理進行完整的 GEO + SEO 審核 |
| `/geo quick <url>` | 60 秒 GEO 可見性快照 |
| `/geo citability <url>` | 為內容的 AI 引用就緒度評分 |
| `/geo crawlers <url>` | 檢查 AI 爬蟲存取權限 (robots.txt) |
| `/geo llmstxt <url>` | 分析或生成 llms.txt |
| `/geo brands <url>` | 在 AI 引用的平台中掃描品牌提及 |
| `/geo platforms <url>` | 平台特定優化建議 |
| `/geo schema <url>` | 結構化資料分析與生成 |
| `/geo technical <url>` | 技術性 SEO 審核 |
| `/geo content <url>` | 內容品質與 E-E-A-T 評估 |
| `/geo report <url>` | 生成客戶端 GEO 報告 |
| `/geo report-pdf` | 生成帶有圖表與視覺化的專業 PDF 報告 |

---

### Gemini CLI 使用方式 (進階強化)

Gemini CLI 使用者可以利用 **Agent Skills** 和 **自定義指令 (Custom Command)** 快捷鍵：

1. **Agent Skills (直接提問)**：Gemini CLI 利用 Agent Skills 進行複雜的編配。您可以利用 `@` 符號直接餵入網址或檔案內容：
   - 「幫我對 `@https://example.com` 做完整的 GEO Audit。」
   - 「分析一下 `@README.md` 的 AI 引用就緒度。」
   - 「這份 `@GEO-AUDIT-REPORT.md` 有什麼改進建議嗎？」

2. **自定義指令 (快捷鍵)**：
   安裝程式會自動設定命名空間的自定義指令。輸入 `/geo:` 即可看到選項：
   - `/geo:audit <url>` — 完整 GEO + SEO 審核
   - `/geo:quick <url>` — 60 秒快照
   - `/geo:crawlers <url>` — AI 爬蟲存取檢查
   - `/geo:citability <url>` — 引用就緒度評分
   - `/geo:report <url>` — 客戶端報告

---

## 架構設計

```
geo-seo-claude/
├── geo/                          # 主要 Skill 編配器
│   └── SKILL.md                  # 包含指令與路由的主要 Skill 檔案
├── skills/                       # 11 個專業子 Skill
│   ├── geo-audit/                # 完整審核編配與評分
│   ├── geo-citability/           # AI 引用就緒度評分
│   ├── geo-crawlers/             # AI 爬蟲存取分析
│   ├── geo-llmstxt/              # llms.txt 標準分析與生成
│   ├── geo-brand-mentions/       # 品牌在 AI 引用平台上的存在感
│   ├── geo-platform-optimizer/   # 特定 AI 搜尋平台優化
│   ├── geo-schema/               # AI 發現能力的結構化資料
│   ├── geo-technical/            # 技術性 SEO 基礎
│   ├── geo-content/              # 內容品質與 E-E-A-T
│   ├── geo-report/               # 客戶端 Markdown 報告生成
│   └── geo-report-pdf/           # 帶有圖表的專業 PDF 報告
├── agents/                       # 5 個平行運作的子代理
│   ├── geo-ai-visibility.md      # GEO 審核、引用性、爬蟲、品牌
│   ├── geo-platform-analysis.md  # 平台特定優化
│   ├── geo-technical.md          # 技術性 SEO 分析
│   ├── geo-content.md            # 內容與 E-E-A-T 分析
│   └── geo-schema.md             # Schema 標記分析
├── scripts/                      # Python 工具程式
│   ├── fetch_page.py             # 頁面擷取與解析
│   ├── citability_scorer.py      # AI 引用評分引擎
│   ├── brand_scanner.py          # 品牌提及偵測
│   ├── llmstxt_generator.py      # llms.txt 驗證與生成
│   └── generate_pdf_report.py    # PDF 報告生成器 (ReportLab)
├── schema/                       # JSON-LD 模板
│   ├── organization.json         # 組織 Schema (含 sameAs)
│   ├── local-business.json       # 在地企業 Schema
│   ├── article-author.json       # 文章 + 人物 Schema (E-E-A-T)
│   ├── software-saas.json        # 軟體應用程式 Schema
│   ├── product-ecommerce.json    # 帶有報價的產品 Schema
│   └── website-searchaction.json # 網站 + 搜尋動作 Schema
├── install.sh                    # 一鍵安裝腳本
├── uninstall.sh                  # 卸載腳本
├── requirements.txt              # Python 依賴項
└── README.md                     # 此檔案
```

---

## 運作原理

### 完整審核流程

當您執行 `/geo audit https://example.com` 時：

1. **探索 (Discovery)** — 擷取首頁 HTML，偵測業務類型，爬取網站地圖。
2. **平行分析 (Parallel Analysis)** — 同時啟動 5 個子代理：
   - AI 可見性 (引用性, 爬蟲, llms.txt, 品牌提及)
   - 平台分析 (ChatGPT, Perplexity, Google AIO 就緒度)
   - 技術性 SEO (核心網頁指標, SSR, 安全性, 行動裝置)
   - 內容品質 (E-E-A-T, 易讀性, 新鮮度)
   - Schema 標記 (偵測, 驗證, 生成)
3. **綜合匯整 (Synthesis)** — 匯總評分，生成綜合 GEO 分數 (0-100)。
4. **報告 (Report)** — 輸出帶有優先順序的行動計畫與快速見效建議。

### 評分機制

| 類別 | 權重 |
|----------|--------|
| AI 引用性與可見性 | 25% |
| 品牌權威信號 | 20% |
| 內容品質與 E-E-A-T | 20% |
| 技術基礎 | 15% |
| 結構化資料 | 10% |
| 平台優化 | 10% |

---

## 關鍵特色

### 引用性評分 (Citability Scoring)
分析內容區塊的 AI 引用就緒度。最佳的 AI 引用段落長度為 134-167 字，內容獨立完整，包含豐富事實並直接回答問題。

### AI 爬蟲分析 (AI Crawler Analysis)
檢查 robots.txt 是否允許 14 種以上的 AI 爬蟲（GPTBot, ClaudeBot, PerplexityBot 等），並提供具體的允許/封鎖建議。

### 品牌提及掃描 (Brand Mention Scanning)
品牌提及與 AI 可見性的相關性比反向連結強 3 倍。本工具掃描 YouTube, Reddit, Wikipedia, LinkedIn 及其他 7 個以上的平台。

### 平台特定優化 (Platform-Specific Optimization)
僅 11% 的網域在同一個查詢中同時被 ChatGPT 和 Google AI Overviews 引用。本工具針對各平台提供量身定制的建議。

### llms.txt 生成
生成新興的 llms.txt 標準檔案，協助 AI 爬蟲理解您的網站結構。

### 客戶端報告
生成 Markdown 或 PDF 格式的專業 GEO 報告。PDF 報告包含分數指針圖、長條圖、平台就緒度視覺化、顏色標記表格及優先行動計畫 —— 可直接交付給客戶。

---

## 使用情境

- **GEO 代理商** — 執行客戶審核並交付成果。
- **行銷團隊** — 監控並提升 AI 搜尋可見性。
- **內容創作者** — 優化內容以利 AI 引用。
- **在地企業** — 讓 AI 助理更容易發現您。
- **SaaS 公司** — 提升在各個 AI 平台上的實體辨識度。
- **電子商務** — 優化產品頁面以利 AI 購物建議。

---

## 卸載

```bash
./uninstall.sh

# 或針對特定 CLI 目錄
./uninstall.sh --cli gemini
```

或手動卸載：
```bash
rm -rf ~/.claude/skills/geo ~/.claude/skills/geo-* ~/.claude/agents/geo-*.md
rm -rf ~/.gemini/skills/geo ~/.gemini/skills/geo-* ~/.gemini/agents/geo-*.md
```

---

## 想把這變成一門生意嗎？

本工具是免費的，學習如何變現才是社群的價值所在。

**[加入 AI Workshop 社群 →](https://skool.com/aiworkshop)**

在社群中您將獲得：
- **影片教學** — 逐步設定、執行審核、解讀結果。
- **客戶獲取教戰手冊** — 如何尋找潛在客戶、推銷 GEO 服務並達成交易。
- **線上問答** — 帶著您的審核結果來獲取直接協助。
- **GEO 代理商定價與模板** — 提案企劃書、開發信、客戶導入流程。

GEO 代理商每月收費 2,000 至 12,000 美元。本工具負責審核，社群教您如何銷售。

---

## 授權協議

MIT 授權

---

## 貢獻指南

歡迎貢獻！在提交 PR 之前，請閱讀 `docs/CONTRIBUTING.md` 中的貢獻指南。

---

為 AI 搜尋時代而生。
