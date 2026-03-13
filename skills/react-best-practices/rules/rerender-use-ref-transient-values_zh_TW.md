---
title: 對暫存值使用 useRef
impact: MEDIUM
impactDescription: 避免頻繁更新時不必要的重新渲染
tags: rerender, useref, state, performance
---

[English Version](./rerender-use-ref-transient-values.md)

## 對暫存值使用 useRef

當一個值頻繁變更，且你不希望每次更新都觸發重新渲染時（例如：滑鼠追蹤器、計時器、暫存標記），請將其儲存在 `useRef` 而不是 `useState` 中。元件狀態應保留給 UI；對於與 DOM 相關的臨時值，請使用 Ref。更新 Ref 不會觸發重新渲染。

**錯誤（每次更新都會渲染）：**

```tsx
function Tracker() {
  const [lastX, setLastX] = useState(0)

  useEffect(() => {
    const onMove = (e: MouseEvent) => setLastX(e.clientX)
    window.addEventListener('mousemove', onMove)
    return () => window.removeEventListener('mousemove', onMove)
  }, [])

  return (
    <div
      style={{
        position: 'fixed',
        top: 0,
        left: lastX,
        width: 8,
        height: 8,
        background: 'black',
      }}
    />
  )
}
```

**正確（追蹤時不會重新渲染）：**

```tsx
function Tracker() {
  const lastXRef = useRef(0)
  const dotRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    const onMove = (e: MouseEvent) => {
      lastXRef.current = e.clientX
      const node = dotRef.current
      if (node) {
        node.style.transform = `translateX(${e.clientX}px)`
      }
    }
    window.addEventListener('mousemove', onMove)
    return () => window.removeEventListener('mousemove', onMove)
  }, [])

  return (
    <div
      ref={dotRef}
      style={{
        position: 'fixed',
        top: 0,
        left: 0,
        width: 8,
        height: 8,
        background: 'black',
        transform: 'translateX(0px)',
      }}
    />
  )
}
```
