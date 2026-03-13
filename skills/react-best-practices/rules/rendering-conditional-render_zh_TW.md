---
title: 使用明確的條件渲染
impact: LOW
impactDescription: 防止渲染出 0 或 NaN
tags: rendering, conditional, jsx, falsy-values
---

[English Version](./rendering-conditional-render.md)

## 使用明確的條件渲染

當條件可能是 `0`、`NaN` 或其他會被渲染出來的虛值（falsy values）時，請使用明確的三元運算子（`? :`）來進行條件渲染，而不是使用 `&&`。

**不正確（當 count 為 0 時會渲染出 "0"）：**

```tsx
function Badge({ count }: { count: number }) {
  return (
    <div>
      {count && <span className="badge">{count}</span>}
    </div>
  )
}

// 當 count = 0 時，渲染結果：<div>0</div>
// 當 count = 5 時，渲染結果：<div><span class="badge">5</span></div>
```

**正確（當 count 為 0 時不渲染任何內容）：**

```tsx
function Badge({ count }: { count: number }) {
  return (
    <div>
      {count > 0 ? <span className="badge">{count}</span> : null}
    </div>
  )
}

// 當 count = 0 時，渲染結果：<div></div>
// 當 count = 5 時，渲染結果：<div><span class="badge">5</span></div>
```
