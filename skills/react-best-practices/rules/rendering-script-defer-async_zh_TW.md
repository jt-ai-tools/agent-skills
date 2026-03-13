---
title: 在 Script 標籤中使用 defer 或 async (Use defer or async on Script Tags)
impact: HIGH
impactDescription: 消除渲染阻塞
tags: rendering, script, defer, async, performance
---

[English Version](./rendering-script-defer-async.md)

## 在 Script 標籤中使用 defer 或 async (Use defer or async on Script Tags)

**影響程度：高 (消除渲染阻塞)**

沒有 `defer` 或 `async` 的 Script 標籤會在下載和執行腳本時阻塞 HTML 解析。這會延遲首次內容繪製 (First Contentful Paint) 和可互動時間 (Time to Interactive)。

- **`defer`**: 平行下載，在 HTML 解析完成後執行，並維持執行順序。
- **`async`**: 平行下載，一旦準備就緒就立即執行，不保證順序。

對於依賴 DOM 或其他腳本的腳本，請使用 `defer`。對於獨立的腳本（如分析工具），請使用 `async`。

**不正確 (阻塞渲染)：**

```tsx
export default function Document() {
  return (
    <html>
      <head>
        <script src="https://example.com/analytics.js" />
        <script src="/scripts/utils.js" />
      </head>
      <body>{/* content */}</body>
    </html>
  )
}
```

**正確 (非阻塞)：**

```tsx
export default function Document() {
  return (
    <html>
      <head>
        {/* 獨立腳本 - 使用 async */}
        <script src="https://example.com/analytics.js" async />
        {/* 依賴 DOM 的腳本 - 使用 defer */}
        <script src="/scripts/utils.js" defer />
      </head>
      <body>{/* content */}</body>
    </html>
  )
}
```

**注意：** 在 Next.js 中，建議優先使用 `next/script` 組件及其 `strategy` 屬性，而不是原始的 script 標籤：

```tsx
import Script from 'next/script'

export default function Page() {
  return (
    <>
      <Script src="https://example.com/analytics.js" strategy="afterInteractive" />
      <Script src="/scripts/utils.js" strategy="beforeInteractive" />
    </>
  )
}
```

參考資料：[MDN - Script element](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/script#defer)
