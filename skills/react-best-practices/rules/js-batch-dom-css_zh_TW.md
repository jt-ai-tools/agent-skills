---
title: 避免佈局抖動 (Layout Thrashing)
impact: MEDIUM
impactDescription: 防止強制的同步佈局並減少效能瓶頸
tags: javascript, dom, css, performance, reflow, layout-thrashing
---

[English Version](./js-batch-dom-css.md)

## 避免佈局抖動 (Layout Thrashing)

避免將樣式寫入與佈局讀取交替進行。當你在樣式變更之間讀取佈局屬性（例如 `offsetWidth`、`getBoundingClientRect()` 或 `getComputedStyle()`）時，瀏覽器會被迫觸發同步重排（reflow）。

**這沒問題（瀏覽器會批次處理樣式變更）：**
```typescript
function updateElementStyles(element: HTMLElement) {
  // 每行都會使樣式失效，但瀏覽器會批次進行重新計算
  element.style.width = '100px'
  element.style.height = '200px'
  element.style.backgroundColor = 'blue'
  element.style.border = '1px solid black'
}
```

**錯誤做法（交替讀取和寫入會強制觸發重排）：**
```typescript
function layoutThrashing(element: HTMLElement) {
  element.style.width = '100px'
  const width = element.offsetWidth  // 強制觸發重排
  element.style.height = '200px'
  const height = element.offsetHeight  // 再次強制觸發重排
}
```

**正確做法（批次寫入，然後讀取一次）：**
```typescript
function updateElementStyles(element: HTMLElement) {
  // 將所有寫入批次放在一起
  element.style.width = '100px'
  element.style.height = '200px'
  element.style.backgroundColor = 'blue'
  element.style.border = '1px solid black'
  
  // 在所有寫入完成後讀取（單次重排）
  const { width, height } = element.getBoundingClientRect()
}
```

**正確做法（批次讀取，然後寫入）：**
```typescript
function avoidThrashing(element: HTMLElement) {
  // 讀取階段 - 先進行所有佈局查詢
  const rect1 = element.getBoundingClientRect()
  const offsetWidth = element.offsetWidth
  const offsetHeight = element.offsetHeight
  
  // 寫入階段 - 之後再進行所有樣式變更
  element.style.width = '100px'
  element.style.height = '200px'
}
```

**更好：使用 CSS 類別（classes）**
```css
.highlighted-box {
  width: 100px;
  height: 200px;
  background-color: blue;
  border: 1px solid black;
}
```
```typescript
function updateElementStyles(element: HTMLElement) {
  element.classList.add('highlighted-box')
  
  const { width, height } = element.getBoundingClientRect()
}
```

**React 範例：**
```tsx
// 錯誤做法：將樣式變更與佈局查詢交替進行
function Box({ isHighlighted }: { isHighlighted: boolean }) {
  const ref = useRef<HTMLDivElement>(null)
  
  useEffect(() => {
    if (ref.current && isHighlighted) {
      ref.current.style.width = '100px'
      const width = ref.current.offsetWidth // 強制觸發佈局
      ref.current.style.height = '200px'
    }
  }, [isHighlighted])
  
  return <div ref={ref}>Content</div>
}

// 正確做法：切換類別
function Box({ isHighlighted }: { isHighlighted: boolean }) {
  return (
    <div className={isHighlighted ? 'highlighted-box' : ''}>
      Content
    </div>
  )
}
```

儘可能優先使用 CSS 類別而非行內樣式（inline styles）。CSS 檔案會被瀏覽器快取，且類別提供了更好的關注點分離，更易於維護。

欲了解更多關於強制佈局操作的資訊，請參閱[此 gist](https://gist.github.com/paulirish/5d52fb081b3570c81e3a) 和 [CSS Triggers](https://csstriggers.com/)。
