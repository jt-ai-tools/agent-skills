---
title: 將事件處理器存儲在 Ref 中 (Store Event Handlers in Refs)
impact: LOW
impactDescription: 穩定的訂閱 (stable subscriptions)
tags: advanced, hooks, refs, event-handlers, optimization
---

[English Version](./advanced-event-handler-refs.md)

## 將事件處理器存儲在 Ref 中 (Store Event Handlers in Refs)

當回呼函數 (callbacks) 用在不應因回呼變動而重新訂閱的 Effect 中時，請將其存儲在 Ref 中。

**錯誤範例 (每次渲染都會重新訂閱)：**

```tsx
function useWindowEvent(event: string, handler: (e) => void) {
  useEffect(() => {
    window.addEventListener(event, handler)
    return () => window.removeEventListener(event, handler)
  }, [event, handler])
}
```

**正確範例 (穩定的訂閱)：**

```tsx
function useWindowEvent(event: string, handler: (e) => void) {
  const handlerRef = useRef(handler)
  useEffect(() => {
    handlerRef.current = handler
  }, [handler])

  useEffect(() => {
    const listener = (e) => handlerRef.current(e)
    window.addEventListener(event, listener)
    return () => window.removeEventListener(event, listener)
  }, [event])
}
```

**替代方案：如果您使用的是最新版本的 React，請使用 `useEffectEvent`：**

```tsx
import { useEffectEvent } from 'react'

function useWindowEvent(event: string, handler: (e) => void) {
  const onEvent = useEffectEvent(handler)

  useEffect(() => {
    window.addEventListener(event, onEvent)
    return () => window.removeEventListener(event, onEvent)
  }, [event])
}
```

`useEffectEvent` 為相同的模式提供了更簡潔的 API：它創建了一個穩定的函數引用，且該引用始終調用最新版本的處理器。
