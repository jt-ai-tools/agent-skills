---
title: 提升正規表達式 (RegExp) 的建立位置 (Hoist RegExp Creation)
impact: LOW-MEDIUM
impactDescription: 避免重複建立 (avoids recreation)
tags: javascript, regexp, optimization, memoization
---

[English Version](./js-hoist-regexp.md)

## 提升正規表達式 (RegExp) 的建立位置 (Hoist RegExp Creation)

不要在 render 函式內部建立正規表達式 (RegExp)。應將其提升 (Hoist) 到模組作用域，或使用 `useMemo()` 進行快取。

**不正確 (每次 render 都建立新的 RegExp)：**

```tsx
function Highlighter({ text, query }: Props) {
  const regex = new RegExp(`(${query})`, 'gi')
  const parts = text.split(regex)
  return <>{parts.map((part, i) => ...)}</>
}
```

**正確 (快取或提升)：**

```tsx
const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

function Highlighter({ text, query }: Props) {
  const regex = useMemo(
    () => new RegExp(`(${escapeRegex(query)})`, 'gi'),
    [query]
  )
  const parts = text.split(regex)
  return <>{parts.map((part, i) => ...)}</>
}
```

**警告 (全域正規表達式具有可變狀態)：**

全域正規表達式 (`/g`) 具有可變的 `lastIndex` 狀態：

```typescript
const regex = /foo/g
regex.test('foo')  // true, lastIndex = 3
regex.test('foo')  // false, lastIndex = 0
```
