# 章節 (Sections)

[English Version](./_sections.md)

本文件定義了所有章節、其排序、影響程度與描述。章節 ID（在括號中）是用於對規則進行分組的檔案名稱前綴。

---

## 1. 消除瀑布流 (Eliminating Waterfalls) (async)

**影響程度：** 關鍵 (CRITICAL)  
**描述：** 瀑布流是效能的第一殺手。每個接續的 await 都會增加完整的網路延遲。消除它們會帶來最大的收益。

## 2. Bundle 大小優化 (Bundle Size Optimization) (bundle)

**影響程度：** 關鍵 (CRITICAL)  
**描述：** 減少初始 bundle 大小可以改善可互動時間 (Time to Interactive) 與最大內容繪製 (Largest Contentful Paint)。

## 3. 伺服器端效能 (Server-Side Performance) (server)

**影響程度：** 高 (HIGH)  
**描述：** 優化伺服器端渲染與資料獲取可以消除伺服器端的瀑布流並減少回應時間。

## 4. 客戶端資料獲取 (Client-Side Data Fetching) (client)

**影響程度：** 中高 (MEDIUM-HIGH)  
**描述：** 自動去重與高效的資料獲取模式可以減少多餘的網路請求。

## 5. 重複渲染優化 (Re-render Optimization) (rerender)

**影響程度：** 中 (MEDIUM)  
**描述：** 減少不必要的重複渲染可以最小化浪費的運算並提高 UI 回應速度。

## 6. 渲染效能 (Rendering Performance) (rendering)

**影響程度：** 中 (MEDIUM)  
**描述：** 優化渲染過程可以減少瀏覽器需要執行的工作。

## 7. JavaScript 效能 (JavaScript Performance) (js)

**影響程度：** 低中 (LOW-MEDIUM)  
**描述：** 對熱點路徑 (hot paths) 進行微優化可以累積出有意義的改進。

## 8. 進階模式 (Advanced Patterns) (advanced)

**影響程度：** 低 (LOW)  
**描述：** 用於需要謹慎實作之特定案例的進階模式。
