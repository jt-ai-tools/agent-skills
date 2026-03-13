---
title: 使用 React DOM 資源提示 (Use React DOM Resource Hints)
impact: HIGH
impactDescription: 減少關鍵資源的載入時間
tags: rendering, preload, preconnect, prefetch, resource-hints
---

[English Version](./rendering-resource-hints.md)

## 使用 React DOM 資源提示 (Use React DOM Resource Hints)

**影響程度：高 (減少關鍵資源的載入時間)**

React DOM 提供的 API 可以提示瀏覽器即將需要的資源。這些 API 在伺服器組件 (Server Components) 中特別有用，可以在客戶端接收到 HTML 之前就開始載入資源。

- **`prefetchDNS(href)`**: 為預期會連接的網域解析 DNS。
- **`preconnect(href)`**: 與伺服器建立連接（DNS + TCP + TLS）。
- **`preload(href, options)`**: 擷取即將使用的資源（樣式表、字體、腳本、圖片）。
- **`preloadModule(href)`**: 擷取即將使用的 ES 模組。
- **`preinit(href, options)`**: 擷取並執行樣式表或腳本。
- **`preinitModule(href)`**: 擷取並執行 ES 模組。

**範例 (預先連接到第三方 API)：**

```tsx
import { preconnect, prefetchDNS } from 'react-dom'

export default function App() {
  prefetchDNS('https://analytics.example.com')
  preconnect('https://api.example.com')

  return <main>{/* content */}</main>
}
```

**範例 (預載關鍵字體和樣式)：**

```tsx
import { preload, preinit } from 'react-dom'

export default function RootLayout({ children }) {
  // 預載字體檔案
  preload('/fonts/inter.woff2', { as: 'font', type: 'font/woff2', crossOrigin: 'anonymous' })

  // 立即擷取並套用關鍵樣式表
  preinit('/styles/critical.css', { as: 'style' })

  return (
    <html>
      <body>{children}</body>
    </html>
  )
}
```

**範例 (為程式碼拆分的路由預載模組)：**

```tsx
import { preloadModule, preinitModule } from 'react-dom'

function Navigation() {
  const preloadDashboard = () => {
    preloadModule('/dashboard.js', { as: 'script' })
  }

  return (
    <nav>
      <a href="/dashboard" onMouseEnter={preloadDashboard}>
        Dashboard
      </a>
    </nav>
  )
}
```

**何時使用各個 API：**

| API | 使用情境 |
|-----|----------|
| `prefetchDNS` | 稍後會連接的第三方網域 |
| `preconnect` | 會立即從中擷取資料的 API 或 CDN |
| `preload` | 目前頁面所需的關鍵資源 |
| `preloadModule` | 可能的下一次導航所需的 JS 模組 |
| `preinit` | 必須儘早執行的樣式表/腳本 |
| `preinitModule` | 必須儘早執行的 ES 模組 |

參考資料：[React DOM 資源預載 API (Resource Preloading APIs)](https://react.dev/reference/react-dom#resource-preloading-apis)
