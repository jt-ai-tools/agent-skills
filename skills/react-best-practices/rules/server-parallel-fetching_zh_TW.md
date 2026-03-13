---
title: 透過元件組合進行並行資料擷取
impact: CRITICAL
impactDescription: 消除伺服器端的瀑布流效能問題
tags: server, rsc, parallel-fetching, composition
---

[English Version](./server-parallel-fetching.md)

## 透過元件組合進行並行資料擷取

React Server Components（RSC）在元件樹中是循序執行的。請透過元件組合（composition）重構架構，以實現資料擷取的並行化。

**不正確（Sidebar 必須等待 Page 的擷取完成）：**

```tsx
export default async function Page() {
  const header = await fetchHeader()
  return (
    <div>
      <div>{header}</div>
      <Sidebar />
    </div>
  )
}

async function Sidebar() {
  const items = await fetchSidebarItems()
  return <nav>{items.map(renderItem)}</nav>
}
```

**正確（兩者同時擷取）：**

```tsx
async function Header() {
  const data = await fetchHeader()
  return <div>{data}</div>
}

async function Sidebar() {
  const items = await fetchSidebarItems()
  return <nav>{items.map(renderItem)}</nav>
}

export default function Page() {
  return (
    <div>
      <Header />
      <Sidebar />
    </div>
  )
}
```

**使用 children prop 的替代方案：**

```tsx
async function Header() {
  const data = await fetchHeader()
  return <div>{data}</div>
}

async function Sidebar() {
  const items = await fetchSidebarItems()
  return <nav>{items.map(renderItem)}</nav>
}

function Layout({ children }: { children: ReactNode }) {
  return (
    <div>
      <Header />
      {children}
    </div>
  )
}

export default function Page() {
  return (
    <Layout>
      <Sidebar />
    </Layout>
  )
}
```
