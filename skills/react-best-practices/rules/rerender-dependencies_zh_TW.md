---
title: 縮小 Effect 依賴範圍
impact: LOW
impactDescription: 最小化 Effect 的重複執行
tags: rerender, useEffect, dependencies, optimization
---

[English Version](./rerender-dependencies.md)

## 縮小 Effect 依賴範圍

指定原始型別（primitive）的依賴而不是物件，以最小化 Effect 的重複執行。

**不正確（在 user 的任何欄位變更時都會重複執行）：**

```tsx
useEffect(() => {
  console.log(user.id)
}, [user])
```

**正確（僅在 id 變更時重複執行）：**

```tsx
useEffect(() => {
  console.log(user.id)
}, [user.id])
```

**對於衍生狀態，請在 Effect 外部計算：**

```tsx
// 不正確：在 width 為 767, 766, 765... 時都會執行
useEffect(() => {
  if (width < 768) {
    enableMobileMode()
  }
}, [width])

// 正確：僅在布林值切換時執行
const isMobile = width < 768
useEffect(() => {
  if (isMobile) {
    enableMobileMode()
  }
}, [isMobile])
```
