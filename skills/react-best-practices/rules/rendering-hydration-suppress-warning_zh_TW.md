---
title: 抑制預期的水合不匹配警告 (Suppress Expected Hydration Mismatches)
impact: LOW-MEDIUM
impactDescription: 避免針對已知差異產生的水合警告噪音
tags: rendering, hydration, ssr, nextjs
---

[English Version](./rendering-hydration-suppress-warning.md)

## 抑制預期的水合不匹配警告 (Suppress Expected Hydration Mismatches)

在 SSR 框架（如 Next.js）中，某些值在伺服器端與客戶端之間是有意設計成不同的（例如隨機 ID、日期、地區/時區格式化）。對於這些 *預期中* 的不匹配，請在包含動態文字的元素上使用 `suppressHydrationWarning` 屬性，以防止產生干擾的警告。請勿使用此屬性來隱藏真正的程式錯誤 (Bugs)，且不要過度使用它。

**不正確的寫法 (會產生已知的不匹配警告)：**

```tsx
function Timestamp() {
  return <span>{new Date().toLocaleString()}</span>
}
```

**正確的寫法 (僅抑制預期的不匹配)：**

```tsx
function Timestamp() {
  return (
    <span suppressHydrationWarning>
      {new Date().toLocaleString()}
    </span>
  )
}
```
