---
title: 在依賴當前值的狀態中使用 useState Dispatch 更新函數
impact: MEDIUM
impactDescription: 避免過時閉包 (stale closures)，防止不必要的重新渲染
tags: state, hooks, useState, callbacks
---

[English Version](./react-state-dispatcher.md)

## 在依賴當前值的狀態中使用 Dispatch 更新函數

當下一個狀態依賴於當前狀態時，請使用 dispatch 更新函數 (`setState(prev => ...)`)，而不是在回呼函數 (callback) 中直接讀取狀態變數。這可以避免過時閉包，並確保您是與最新值進行比較。

**錯誤（直接讀取狀態）：**

```tsx
const [size, setSize] = useState<Size | undefined>(undefined)

const onLayout = (e: LayoutChangeEvent) => {
  const { width, height } = e.nativeEvent.layout
  // size 在此閉包中可能是過時的
  if (size?.width !== width || size?.height !== height) {
    setSize({ width, height })
  }
}
```

**正確（使用 dispatch 更新函數）：**

```tsx
const [size, setSize] = useState<Size | undefined>(undefined)

const onLayout = (e: LayoutChangeEvent) => {
  const { width, height } = e.nativeEvent.layout
  setSize((prev) => {
    if (prev?.width === width && prev?.height === height) return prev
    return { width, height }
  })
}
```

從更新函數中返回先前的值 (previous value) 會跳過重新渲染。

對於原始型別 (primitive) 狀態，在觸發重新渲染之前不需要手動比較值。

**錯誤（對原始型別狀態進行不必要的比較）：**

```tsx
const [size, setSize] = useState<Size | undefined>(undefined)

const onLayout = (e: LayoutChangeEvent) => {
  const { width, height } = e.nativeEvent.layout
  setSize((prev) => (prev === width ? prev : width))
}
```

**正確（直接設置原始型別狀態）：**

```tsx
const [size, setSize] = useState<Size | undefined>(undefined)

const onLayout = (e: LayoutChangeEvent) => {
  const { width, height } = e.nativeEvent.layout
  setSize(width)
}
```

然而，如果下一個狀態依賴於當前狀態，您仍然應該使用 dispatch 更新函數。

**錯誤（從回呼函數中直接讀取狀態）：**

```tsx
const [count, setCount] = useState(0)

const onTap = () => {
  setCount(count + 1)
}
```

**正確（使用 dispatch 更新函數）：**

```tsx
const [count, setCount] = useState(0)

const onTap = () => {
  setCount((prev) => prev + 1)
}
```
