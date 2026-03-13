---
title: 動畫化 SVG 包裝容器而非 SVG 元素本身
impact: LOW
impactDescription: 啟用硬體加速
tags: rendering, svg, css, animation, performance
---

[English Version](./rendering-animate-svg-wrapper.md)

## 動畫化 SVG 包裝容器而非 SVG 元素本身

許多瀏覽器對於 SVG 元素上的 CSS3 動畫沒有提供硬體加速。請將 SVG 包裹在一個 `<div>` 中，並對該包裝容器進行動畫處理。

**不正確（直接對 SVG 進行動畫處理 - 無硬體加速）：**

```tsx
function LoadingSpinner() {
  return (
    <svg 
      className="animate-spin"
      width="24" 
      height="24" 
      viewBox="0 0 24 24"
    >
      <circle cx="12" cy="12" r="10" stroke="currentColor" />
    </svg>
  )
}
```

**正確（對包裝容器 div 進行動畫處理 - 啟用硬體加速）：**

```tsx
function LoadingSpinner() {
  return (
    <div className="animate-spin">
      <svg 
        width="24" 
        height="24" 
        viewBox="0 0 24 24"
      >
        <circle cx="12" cy="12" r="10" stroke="currentColor" />
      </svg>
    </div>
  )
}
```

這適用於所有 CSS 轉換（transforms）和過渡（transitions），例如 `transform`、`opacity`、`translate`、`scale`、`rotate`。透過包裝容器 div，瀏覽器可以使用 GPU 加速，從而使動畫更加流暢。
