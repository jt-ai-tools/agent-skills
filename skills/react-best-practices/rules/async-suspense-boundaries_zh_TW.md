---
title: 策略性 Suspense 邊界
impact: HIGH
impactDescription: 更快的首次繪製 (initial paint)
tags: async, suspense, streaming, layout-shift
---

[English Version](./async-suspense-boundaries.md)

## 策略性 Suspense 邊界 (Strategic Suspense Boundaries)

與其在非同步組件中等待資料後才返回 JSX，不如使用 Suspense 邊界，在資料載入時更快地顯示外層 UI。

**錯誤範例 (外層 UI 被資料獲取阻塞)：**

```tsx
async function Page() {
  const data = await fetchData() // 阻塞整個頁面
  
  return (
    <div>
      <div>Sidebar</div>
      <div>Header</div>
      <div>
        <DataDisplay data={data} />
      </div>
      <div>Footer</div>
    </div>
  )
}
```

即使只有中間部分需要資料，整個佈局仍會等待資料獲取。

**正確範例 (外層 UI 立即顯示，資料以串流方式載入)：**

```tsx
function Page() {
  return (
    <div>
      <div>Sidebar</div>
      <div>Header</div>
      <div>
        <Suspense fallback={<Skeleton />}>
          <DataDisplay />
        </Suspense>
      </div>
      <div>Footer</div>
    </div>
  )
}

async function DataDisplay() {
  const data = await fetchData() // 僅阻塞此組件
  return <div>{data.content}</div>
}
```

Sidebar、Header 和 Footer 會立即渲染。只有 DataDisplay 會等待資料。

**替代方案 (在組件間共享 Promise)：**

```tsx
function Page() {
  // 立即開始獲取，但不使用 await
  const dataPromise = fetchData()
  
  return (
    <div>
      <div>Sidebar</div>
      <div>Header</div>
      <Suspense fallback={<Skeleton />}>
        <DataDisplay dataPromise={dataPromise} />
        <DataSummary dataPromise={dataPromise} />
      </Suspense>
      <div>Footer</div>
    </div>
  )
}

function DataDisplay({ dataPromise }: { dataPromise: Promise<Data> }) {
  const data = use(dataPromise) // 解析 Promise
  return <div>{data.content}</div>
}

function DataSummary({ dataPromise }: { dataPromise: Promise<Data> }) {
  const data = use(dataPromise) // 重用同一個 Promise
  return <div>{data.summary}</div>
}
```

兩個組件共享同一個 Promise，因此只會執行一次獲取。佈局會立即渲染，而兩個組件則會一起等待。

**何時「不」使用此模式：**

- 佈局決策所需的關鍵資料 (影響位置)
- 首屏 (above the fold) 對 SEO 至關重要的內容
- 小型、快速的查詢，Suspense 的額外開銷不划算時
- 當您想避免佈局抖動 (從載入中跳轉到內容) 時

**權衡：** 更快的首次繪製 vs. 潛在的佈局抖動。請根據您的 UX 優先級進行選擇。
