---
name: vercel-react-best-practices
description: 來自 Vercel 工程團隊的 React 與 Next.js 效能優化指南。此技能應在撰寫、審查或重構 React/Next.js 程式碼時使用，以確保最佳的效能模式。適用於涉及 React 元件、Next.js 頁面、資料獲取、bundle 優化或效能改進的任務。
license: MIT
metadata:
  author: vercel
  version: "1.0.0"
---

# Vercel React 最佳實踐 (Vercel React Best Practices)

[English Version](./SKILL.md)

由 Vercel 維護的 React 與 Next.js 應用程式全面效能優化指南。包含跨 8 個類別的 62 條規則，依影響程度排序，以引導自動化重構與程式碼產生。

## 何時適用

在以下情況參考這些指南：
- 撰寫新的 React 元件或 Next.js 頁面
- 實作資料獲取（客戶端或伺服器端）
- 審查程式碼的效能問題
- 重構現有的 React/Next.js 程式碼
- 優化 bundle 大小或載入時間

## 依優先順序排序的規則類別

| 優先順序 | 類別 | 影響程度 | 前綴 |
|----------|----------|--------|--------|
| 1 | 消除瀑布流 (Eliminating Waterfalls) | 關鍵 (CRITICAL) | `async-` |
| 2 | Bundle 大小優化 (Bundle Size Optimization) | 關鍵 (CRITICAL) | `bundle-` |
| 3 | 伺服器端效能 (Server-Side Performance) | 高 (HIGH) | `server-` |
| 4 | 客戶端資料獲取 (Client-Side Data Fetching) | 中高 (MEDIUM-HIGH) | `client-` |
| 5 | 重複渲染優化 (Re-render Optimization) | 中 (MEDIUM) | `rerender-` |
| 6 | 渲染效能 (Rendering Performance) | 中 (MEDIUM) | `rendering-` |
| 7 | JavaScript 效能 (JavaScript Performance) | 低中 (LOW-MEDIUM) | `js-` |
| 8 | 進階模式 (Advanced Patterns) | 低 (LOW) | `advanced-` |

## 快速參考

### 1. 消除瀑布流 (CRITICAL)

- `async-defer-await` - 將 await 移至實際使用的分支中
- `async-parallel` - 對獨立操作使用 Promise.all()
- `async-dependencies` - 對部分相依性使用 better-all
- `async-api-routes` - 在 API 路由中儘早啟動 Promise，延後使用 await
- `async-suspense-boundaries` - 使用 Suspense 串流內容

### 2. Bundle 大小優化 (CRITICAL)

- `bundle-barrel-imports` - 直接匯入，避免使用 barrel files (中繼導出檔案)
- `bundle-dynamic-imports` - 對重型元件使用 next/dynamic
- `bundle-defer-third-party` - 在 hydration 後載入分析/日誌工具
- `bundle-conditional` - 僅在功能啟用時載入模組
- `bundle-preload` - 在滑鼠懸停/聚焦時預先載入以提升感知速度

### 3. 伺服器端效能 (HIGH)

- `server-auth-actions` - 像 API 路由一樣對 Server Actions 進行身份驗證
- `server-cache-react` - 使用 React.cache() 進行單次請求去重
- `server-cache-lru` - 使用 LRU 快取進行跨請求快取
- `server-dedup-props` - 避免在 RSC 屬性中重複序列化
- `server-hoist-static-io` - 將靜態 I/O (字體、標誌) 提升至模組層級
- `server-serialization` - 最小化傳遞給客戶端元件的資料
- `server-parallel-fetching` - 重構元件以並行化獲取
- `server-after-nonblocking` - 對非阻塞操作使用 after()

### 4. 客戶端資料獲取 (MEDIUM-HIGH)

- `client-swr-dedup` - 使用 SWR 進行自動請求去重
- `client-event-listeners` - 去重全域事件監聽器
- `client-passive-event-listeners` - 對滾動使用 passive 監聽器
- `client-localstorage-schema` - 版本化並最小化 localStorage 資料

### 5. 重複渲染優化 (MEDIUM)

- `rerender-defer-reads` - 不要訂閱僅在回呼函式中使用的狀態
- `rerender-memo` - 將耗時工作提取到記憶化 (memoized) 元件中
- `rerender-memo-with-default-value` - 提升預設的非原始型別 (non-primitive) 屬性
- `rerender-dependencies` - 在 effect 中使用原始型別相依性
- `rerender-derived-state` - 訂閱衍生的布林值，而非原始數值
- `rerender-derived-state-no-effect` - 在渲染期間衍生狀態，而非在 effect 中
- `rerender-functional-setstate` - 對穩定的回呼使用函數式 setState
- `rerender-lazy-state-init` - 對高耗能初始值向 useState 傳遞函數
- `rerender-simple-expression-in-memo` - 避免對簡單的原始型別使用 memo
- `rerender-move-effect-to-event` - 將互動邏輯放在事件處理常式中
- `rerender-transitions` - 對非緊急更新使用 startTransition
- `rerender-use-ref-transient-values` - 對頻繁變動的暫存值使用 ref
- `rerender-no-inline-components` - 不要在元件內部定義元件

### 6. 渲染效能 (MEDIUM)

- `rendering-animate-svg-wrapper` - 動畫化 div 包裹層，而非 SVG 元素本身
- `rendering-content-visibility` - 對長列表使用 content-visibility
- `rendering-hoist-jsx` - 將靜態 JSX 提取到元件之外
- `rendering-svg-precision` - 降低 SVG 座標精確度
- `rendering-hydration-no-flicker` - 對僅限客戶端的資料使用內聯腳本
- `rendering-hydration-suppress-warning` - 隱藏預期中的 hydration 不匹配警告
- `rendering-activity` - 使用 Activity 元件進行顯示/隱藏
- `rendering-conditional-render` - 對條件句使用三元運算子而非 &&
- `rendering-usetransition-loading` - 偏好使用 useTransition 處理載入狀態
- `rendering-resource-hints` - 使用 React DOM 資源提示進行預先載入
- `rendering-script-defer-async` - 在腳本標籤上使用 defer 或 async

### 7. JavaScript 效能 (LOW-MEDIUM)

- `js-batch-dom-css` - 透過類別或 cssText 批量處理 CSS 變更
- `js-index-maps` - 為重複查表建立 Map
- `js-cache-property-access` - 在迴圈中快取物件屬性
- `js-cache-function-results` - 在模組層級 Map 中快取函數結果
- `js-cache-storage` - 快取 localStorage/sessionStorage 讀取結果
- `js-combine-iterations` - 將多個 filter/map 合併為單個迴圈
- `js-length-check-first` - 在進行高耗能比較前先檢查陣列長度
- `js-early-exit` - 從函數中儘早回傳
- `js-hoist-regexp` - 將 RegExp 建立提升到迴圈之外
- `js-min-max-loop` - 使用迴圈進行最小值/最大值計算，而非排序
- `js-set-map-lookups` - 使用 Set/Map 進行 O(1) 查表
- `js-tosorted-immutable` - 使用 toSorted() 保持不可變性
- `js-flatmap-filter` - 使用 flatMap 在單次遍歷中完成 map 與 filter

### 8. 進階模式 (LOW)

- `advanced-event-handler-refs` - 將事件處理常式存儲在 ref 中
- `advanced-init-once` - 每次應用程式載入時僅初始化一次
- `advanced-use-latest` - 對穩定的回呼 ref 使用 useLatest

## 如何使用

閱讀各別規則檔案以獲取詳細說明與程式碼範例：

```
rules/async-parallel_zh_TW.md
rules/bundle-barrel-imports_zh_TW.md
```

每個規則檔案包含：
- 說明其重要性的簡述
- 錯誤的程式碼範例與說明
- 正確的程式碼範例與說明
- 額外的上下文與參考資料

## 完整彙編文件

關於包含所有擴展規則的完整指南：`AGENTS_zh_TW.md`
