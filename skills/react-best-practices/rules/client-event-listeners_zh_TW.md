---
title: 去重全域事件監聽器
impact: LOW
impactDescription: 為 N 個元件提供單一監聽器
tags: client, swr, event-listeners, subscription
---

[English Version](./client-event-listeners.md)

## 去重全域事件監聽器

使用 `useSWRSubscription()` 在元件實例之間共享全域事件監聽器。

**不正確（N 個實例 = N 個監聽器）：**

```tsx
function useKeyboardShortcut(key: string, callback: () => void) {
  useEffect(() => {
    const handler = (e: KeyboardEvent) => {
      if (e.metaKey && e.key === key) {
        callback()
      }
    }
    window.addEventListener('keydown', handler)
    return () => window.removeEventListener('keydown', handler)
  }, [key, callback])
}
```

當多次使用 `useKeyboardShortcut` hook 時，每個實例都會註冊一個新的監聽器。

**正確（N 個實例 = 1 個監聽器）：**

```tsx
import useSWRSubscription from 'swr/subscription'

// 模組級別的 Map，用於追蹤每個按鍵的回調函式
const keyCallbacks = new Map<string, Set<() => void>>()

function useKeyboardShortcut(key: string, callback: () => void) {
  // 在 Map 中註冊此回調函式
  useEffect(() => {
    if (!keyCallbacks.has(key)) {
      keyCallbacks.set(key, new Set())
    }
    keyCallbacks.get(key)!.add(callback)

    return () => {
      const set = keyCallbacks.get(key)
      if (set) {
        set.delete(callback)
        if (set.size === 0) {
          keyCallbacks.delete(key)
        }
      }
    }
  }, [key, callback])

  useSWRSubscription('global-keydown', () => {
    const handler = (e: KeyboardEvent) => {
      if (e.metaKey && keyCallbacks.has(e.key)) {
        keyCallbacks.get(e.key)!.forEach(cb => cb())
      }
    }
    window.addEventListener('keydown', handler)
    return () => window.removeEventListener('keydown', handler)
  })
}

function Profile() {
  // 多個快捷鍵將共享同一個監聽器
  useKeyboardShortcut('p', () => { /* ... */ }) 
  useKeyboardShortcut('k', () => { /* ... */ })
  // ...
}
```
