---
title: 不要將結果為原始型別的簡單運算包裝在 useMemo 中
impact: LOW-MEDIUM
impactDescription: 每次渲染時浪費的計算資源
tags: rerender, useMemo, optimization
---

[English Version](./rerender-simple-expression-in-memo.md)

## 不要將結果為原始型別的簡單運算包裝在 useMemo 中

當運算很簡單（僅有少數邏輯或算術運算子）且結果為原始型別（boolean, number, string）時，不要將其包裝在 `useMemo` 中。
呼叫 `useMemo` 並比較 Hook 的相依性所消耗的資源，可能比運算本身還要多。

**錯誤：**

```tsx
function Header({ user, notifications }: Props) {
  const isLoading = useMemo(() => {
    return user.isLoading || notifications.isLoading
  }, [user.isLoading, notifications.isLoading])

  if (isLoading) return <Skeleton />
  // 回傳一些標記
}
```

**正確：**

```tsx
function Header({ user, notifications }: Props) {
  const isLoading = user.isLoading || notifications.isLoading

  if (isLoading) return <Skeleton />
  // 回傳一些標記
}
```
