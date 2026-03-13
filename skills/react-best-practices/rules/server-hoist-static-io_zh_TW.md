---
title: 將靜態 I/O 提升至模組層級
impact: HIGH
impactDescription: 避免每次請求重複進行檔案或網路 I/O
tags: server, io, performance, next.js, route-handlers, og-image
---

[English Version](./server-hoist-static-io.md)

## 將靜態 I/O 提升至模組層級

**影響：高 (避免每次請求重複進行檔案或網路 I/O)**

在路由處理常式（route handlers）或伺服器函式中載入靜態資產（如字型、標誌、圖片、設定檔）時，請將 I/O 操作提升（hoist）到模組層級。模組層級的程式碼在模組首次被匯入時僅會執行一次，而非在每次請求時都執行。這消除了在每次調用時都會執行的冗餘檔案系統讀取或網路擷取。

**不正確：每次請求都讀取字型檔案**

```typescript
// app/api/og/route.tsx
import { ImageResponse } from 'next/og'

export async function GET(request: Request) {
  // 每次請求都會執行 —— 開銷很大！
  const fontData = await fetch(
    new URL('./fonts/Inter.ttf', import.meta.url)
  ).then(res => res.arrayBuffer())
  
  const logoData = await fetch(
    new URL('./images/logo.png', import.meta.url)
  ).then(res => res.arrayBuffer())

  return new ImageResponse(
    <div style={{ fontFamily: 'Inter' }}>
      <img src={logoData} />
      Hello World
    </div>,
    { fonts: [{ name: 'Inter', data: fontData }] }
  )
}
```

**正確：在模組初始化時載入一次**

```typescript
// app/api/og/route.tsx
import { ImageResponse } from 'next/og'

// 模組層級：在模組首次被匯入時僅執行一次
const fontData = fetch(
  new URL('./fonts/Inter.ttf', import.meta.url)
).then(res => res.arrayBuffer())

const logoData = fetch(
  new URL('./images/logo.png', import.meta.url)
).then(res => res.arrayBuffer())

export async function GET(request: Request) {
  // 等待已經啟動的 Promise
  const [font, logo] = await Promise.all([fontData, logoData])

  return new ImageResponse(
    <div style={{ fontFamily: 'Inter' }}>
      <img src={logo} />
      Hello World
    </div>,
    { fonts: [{ name: 'Inter', data: font }] }
  )
}
```

**替代方案：使用 Node.js fs 進行同步檔案讀取**

```typescript
// app/api/og/route.tsx
import { ImageResponse } from 'next/og'
import { readFileSync } from 'fs'
import { join } from 'path'

// 在模組層級進行同步讀取 —— 僅在模組初始化期間阻塞
const fontData = readFileSync(
  join(process.cwd(), 'public/fonts/Inter.ttf')
)

const logoData = readFileSync(
  join(process.cwd(), 'public/images/logo.png')
)

export async function GET(request: Request) {
  return new ImageResponse(
    <div style={{ fontFamily: 'Inter' }}>
      <img src={logoData} />
      Hello World
    </div>,
    { fonts: [{ name: 'Inter', data: fontData }] }
  )
}
```

**通用 Node.js 範例：載入設定或範本**

```typescript
// 不正確：每次調用時都讀取設定
export async function processRequest(data: Data) {
  const config = JSON.parse(
    await fs.readFile('./config.json', 'utf-8')
  )
  const template = await fs.readFile('./template.html', 'utf-8')
  
  return render(template, data, config)
}

// 正確：在模組層級載入一次
const configPromise = fs.readFile('./config.json', 'utf-8')
  .then(JSON.parse)
const templatePromise = fs.readFile('./template.html', 'utf-8')

export async function processRequest(data: Data) {
  const [config, template] = await Promise.all([
    configPromise,
    templatePromise
  ])
  
  return render(template, data, config)
}
```

**何時使用此模式：**

- 載入用於生成 OG 圖片的字型
- 載入靜態標誌、圖示或浮水印
- 讀取在執行期間不會變動的設定檔
- 載入電子郵件範本或其他靜態範本
- 任何在所有請求中都相同的靜態資產

**何時不該使用此模式：**

- 隨請求或使用者而異的資產
- 在執行期間可能變動的檔案（請改用具備 TTL 的快取）
- 保持載入狀態會消耗過多記憶體的大型檔案
- 不應持久存在於記憶體中的敏感資料

**搭配 Vercel 的 [Fluid Compute](https://vercel.com/docs/fluid-compute)：** 模組層級的快取特別有效，因為多個並行請求共享同一個函式實例。靜態資產會跨請求保持在記憶體載入狀態，沒有冷啟動（cold start）的效能處罰。

**在傳統的無伺服器（serverless）環境中：** 每次冷啟動都會重新執行模組層級的程式碼，但後續的暖啟動（warm invocations）會重複使用已載入的資產，直到實例被回收為止。
