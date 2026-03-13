# React 最佳實踐 (React Best Practices)

[English Version](./README.md)

這是一個結構化的儲存庫，用於建立與維護針對代理人與 LLM 優化的 React 最佳實踐。

## 結構

- `rules/` - 各別的規則檔案（每個檔案一條規則）
  - `_sections.md` - 章節中繼資料（標題、影響程度、描述）
  - `_template.md` - 建立新規則的模板
  - `area-description.md` - 各別的規則檔案
- `src/` - 建置腳本與公用程式
- `metadata.json` - 文件中繼資料（版本、組織、摘要）
- __`AGENTS_zh_TW.md`__ - 編譯後的輸出（產生的繁體中文版）
- __`test-cases.json`__ - 用於 LLM 評估的測試案例（產生的）

## 入門指南

1. 安裝依賴項目：
   ```bash
   pnpm install
   ```

2. 從規則中建置 AGENTS_zh_TW.md：
   ```bash
   pnpm build
   ```

3. 驗證規則檔案：
   ```bash
   pnpm validate
   ```

4. 提取測試案例：
   ```bash
   pnpm extract-tests
   ```

## 建立新規則

1. 將 `rules/_template.md` 複製到 `rules/area-description.md`
2. 選擇適當的領域前綴：
   - `async-` 用於消除瀑布流 (第 1 節)
   - `bundle-` 用於 Bundle 大小優化 (第 2 節)
   - `server-` 用於伺服器端效能 (第 3 節)
   - `client-` 用於客戶端資料獲取 (第 4 節)
   - `rerender-` 用於重複渲染優化 (第 5 節)
   - `rendering-` 用於渲染效能 (第 6 節)
   - `js-` 用於 JavaScript 效能 (第 7 節)
   - `advanced-` 用於進階模式 (第 8 節)
3. 填寫 frontmatter 與內容
4. 確保有清晰的範例與說明
5. 執行 `pnpm build` 以重新產生 AGENTS_zh_TW.md 與 test-cases.json

## 規則檔案結構

每個規則檔案應遵循以下結構：

```markdown
---
title: 在此輸入規則標題
impact: MEDIUM
impactDescription: 選填的影響程度描述
tags: tag1, tag2, tag3
---

## 在此輸入規則標題 (Rule Title Here)

簡要說明規則及其重要性。

**錯誤示例 (描述哪裡錯了)：**

```typescript
// 錯誤的程式碼範例
```

**正確示例 (描述哪裡對了)：**

```typescript
// 正確的程式碼範例
```

範例後的可選說明文字。

參考資料：[連結](https://example.com)

## 檔案命名慣例

- 以 `_` 開頭的檔案是特殊的（不包含在建置中）
- 規則檔案：`area-description.md` (例如：`async-parallel.md`)
- 章節會根據檔案名稱前綴自動推斷
- 規則在每個章節內按標題字母順序排序
- ID (例如：1.1, 1.2) 在建置期間自動產生

## 影響程度 (Impact Levels)

- `CRITICAL` (關鍵) - 最高優先順序，重大的效能提升
- `HIGH` (高) - 顯著的效能改進
- `MEDIUM-HIGH` (中高) - 中高程度的提升
- `MEDIUM` (中) - 中等程度的效能改進
- `LOW-MEDIUM` (低中) - 低中程度的提升
- `LOW` (低) - 增量改進

## 腳本

- `pnpm build` - 將規則編譯成 AGENTS_zh_TW.md
- `pnpm validate` - 驗證所有規則檔案
- `pnpm extract-tests` - 提取用於 LLM 評估的測試案例
- `pnpm dev` - 建置並驗證

## 貢獻

新增或修改規則時：

1. 為您的章節使用正確的檔案名稱前綴
2. 遵循 `_template.md` 結構
3. 包含清晰的錯誤/正確範例與說明
4. 加入適當的標籤
5. 執行 `pnpm build` 以重新產生 AGENTS_zh_TW.md 與 test-cases.json
6. 規則會自動按標題排序 —— 無需手動管理編號！

## 致謝

最初由 [@shuding](https://x.com/shuding) 在 [Vercel](https://vercel.com) 建立。
