---
title: 提取靜態 JSX 元素 (Hoist Static JSX Elements)
impact: LOW
impactDescription: 避免重複建立元素
tags: rendering, jsx, static, optimization
---

[English Version](./rendering-hoist-jsx.md)

## 提取靜態 JSX 元素 (Hoist Static JSX Elements)

將靜態 JSX 提取至組件外部，以避免在每次渲染時重複建立元素。

**不正確的寫法 (每次渲染都會重新建立元素)：**

```tsx
function LoadingSkeleton() {
  return <div className="animate-pulse h-20 bg-gray-200" />
}

function Container() {
  return (
    <div>
      {loading && <LoadingSkeleton />}
    </div>
  )
}
```

**正確的寫法 (重複使用同一個元素)：**

```tsx
const loadingSkeleton = (
  <div className="animate-pulse h-20 bg-gray-200" />
)

function Container() {
  return (
    <div>
      {loading && loadingSkeleton}
    </div>
  )
}
```

這對於大型且靜態的 SVG 節點特別有用，因為在每次渲染時重新建立這些節點的開銷很大。

**注意：** 如果你的專案啟用了 [React Compiler](https://react.dev/learn/react-compiler)，編譯器會自動提取靜態 JSX 元素並優化組件重新渲染，因此不需要手動進行提取。
