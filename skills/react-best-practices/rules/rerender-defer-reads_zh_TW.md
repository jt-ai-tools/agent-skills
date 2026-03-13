---
title: 延遲狀態讀取至使用點
impact: MEDIUM
impactDescription: 避免不必要的訂閱
tags: rerender, searchParams, localStorage, optimization
---

[English Version](./rerender-defer-reads.md)

## 延遲狀態讀取至使用點

如果您僅在回呼（callbacks）中讀取動態狀態（searchParams, localStorage），請不要訂閱它。

**不正確（訂閱所有 searchParams 的變更）：**

```tsx
function ShareButton({ chatId }: { chatId: string }) {
  const searchParams = useSearchParams()

  const handleShare = () => {
    const ref = searchParams.get('ref')
    shareChat(chatId, { ref })
  }

  return <button onClick={handleShare}>Share</button>
}
```

**正確（按需讀取，不訂閱）：**

```tsx
function ShareButton({ chatId }: { chatId: string }) {
  const handleShare = () => {
    const params = new URLSearchParams(window.location.search)
    const ref = params.get('ref')
    shareChat(chatId, { ref })
  }

  return <button onClick={handleShare}>Share</button>
}
```
