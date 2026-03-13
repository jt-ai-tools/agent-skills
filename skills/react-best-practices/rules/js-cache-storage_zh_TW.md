---
title: 快取儲存 API 呼叫 (Cache Storage API Calls)
impact: LOW-MEDIUM
impactDescription: 減少昂貴的 I/O 操作 (reduces expensive I/O)
tags: javascript, localStorage, storage, caching, performance
---

[English Version](./js-cache-storage.md)

## 快取儲存 API 呼叫 (Cache Storage API Calls)

`localStorage`、`sessionStorage` 和 `document.cookie` 是同步且昂貴的操作。應在記憶體中快取讀取結果。

**不正確 (每次呼叫都讀取儲存空間)：**

```typescript
function getTheme() {
  return localStorage.getItem('theme') ?? 'light'
}
// 呼叫 10 次 = 10 次儲存空間讀取
```

**正確 (使用 Map 快取)：**

```typescript
const storageCache = new Map<string, string | null>()

function getLocalStorage(key: string) {
  if (!storageCache.has(key)) {
    storageCache.set(key, localStorage.getItem(key))
  }
  return storageCache.get(key)
}

function setLocalStorage(key: string, value: string) {
  localStorage.setItem(key, value)
  storageCache.set(key, value)  // 保持快取同步
}
```

使用 Map (而非 hook)，這樣它就能在任何地方運作：工具函式、事件處理器，而不僅僅是 React 元件。

**Cookie 快取：**

```typescript
let cookieCache: Record<string, string> | null = null

function getCookie(name: string) {
  if (!cookieCache) {
    cookieCache = Object.fromEntries(
      document.cookie.split('; ').map(c => c.split('='))
    )
  }
  return cookieCache[name]
}
```

**重要事項 (處理外部變更時的失效)：**

如果儲存空間可能從外部變更 (另一個分頁、伺服器設置的 cookie)，請使快取失效：

```typescript
window.addEventListener('storage', (e) => {
  if (e.key) storageCache.delete(e.key)
})

document.addEventListener('visibilitychange', () => {
  if (document.visibilityState === 'visible') {
    storageCache.clear()
  }
})
```
