---
title: 使用惰性狀態初始化 (Use Lazy State Initialization)
impact: MEDIUM
impactDescription: 避免在每次渲染時產生不必要的運算 (wasted computation on every render)
tags: react, hooks, useState, performance, initialization
---

[English Version](./rerender-lazy-state-init.md)

## 使用惰性狀態初始化 (Use Lazy State Initialization)

對於開銷較大的初始值，請向 `useState` 傳遞一個函式。如果不使用函式形式，初始化程式會在每次渲染時執行，即使該值僅在初始時使用一次。

**錯誤範例 (每次渲染時都會執行)：**

```tsx
function FilteredList({ items }: { items: Item[] }) {
  // buildSearchIndex() 在每次渲染時都會執行，即使在初始化之後也是如此
  const [searchIndex, setSearchIndex] = useState(buildSearchIndex(items))
  const [query, setQuery] = useState('')
  
  // 當 query 變動時，buildSearchIndex 會不必要地再次執行
  return <SearchResults index={searchIndex} query={query} />
}

function UserProfile() {
  // JSON.parse 在每次渲染時都會執行
  const [settings, setSettings] = useState(
    JSON.parse(localStorage.getItem('settings') || '{}')
  )
  
  return <SettingsForm settings={settings} onChange={setSettings} />
}
```

**正確範例 (僅執行一次)：**

```tsx
function FilteredList({ items }: { items: Item[] }) {
  // buildSearchIndex() 僅在初始渲染時執行
  const [searchIndex, setSearchIndex] = useState(() => buildSearchIndex(items))
  const [query, setQuery] = useState('')
  
  return <SearchResults index={searchIndex} query={query} />
}

function UserProfile() {
  // JSON.parse 僅在初始渲染時執行
  const [settings, setSettings] = useState(() => {
    const stored = localStorage.getItem('settings')
    return stored ? JSON.parse(stored) : {}
  })
  
  return <SettingsForm settings={settings} onChange={setSettings} />
}
```

當從 localStorage/sessionStorage 計算初始值、建立資料結構 (索引、Map)、從 DOM 讀取或執行繁重的轉換時，請使用惰性初始化。

對於簡單的主型態 (`useState(0)`)、直接引用 (`useState(props.value)`) 或開銷較小的實值 (`useState({})`)，則不需要使用函式形式。
