---
title: 訂閱衍生狀態 (Subscribe to Derived State)
impact: MEDIUM
impactDescription: 減少重新渲染頻率 (reduces re-render frequency)
tags: rerender, derived-state, media-query, optimization
---

[English Version](./rerender-derived-state.md)

## 訂閱衍生狀態 (Subscribe to Derived State)

訂閱衍生的布林狀態而非連續變動的數值，以減少重新渲染的頻率。

**錯誤範例 (在每次像素變動時都會重新渲染)：**

```tsx
function Sidebar() {
  const width = useWindowWidth()  // 持續更新
  const isMobile = width < 768
  return <nav className={isMobile ? 'mobile' : 'desktop'} />
}
```

**正確範例 (僅在布林值變動時重新渲染)：**

```tsx
function Sidebar() {
  const isMobile = useMediaQuery('(max-width: 767px)')
  return <nav className={isMobile ? 'mobile' : 'desktop'} />
}
```
