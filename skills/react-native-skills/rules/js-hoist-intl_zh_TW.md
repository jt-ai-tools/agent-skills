---
title: 提升 Intl 格式化器的建立位置
impact: LOW-MEDIUM
impactDescription: 避免重複建立昂貴的物件
tags: javascript, intl, optimization, memoization
---

[English Version](./js-hoist-intl.md)

## 提升 Intl 格式化器的建立位置

不要在 render 函式或迴圈中建立 `Intl.DateTimeFormat`、`Intl.NumberFormat` 或 `Intl.RelativeTimeFormat`。這些物件的實例化過程非常耗時。當語系 (locale) 或選項是靜態時，請將其提升 (hoist) 到模組作用域。

**錯誤做法 (每次 render 都建立新的格式化器):**

```tsx
function Price({ amount }: { amount: number }) {
  const formatter = new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
  })
  return <Text>{formatter.format(amount)}</Text>
}
```

**正確做法 (提升到模組作用域):**

```tsx
const currencyFormatter = new Intl.NumberFormat('en-US', {
  style: 'currency',
  currency: 'USD',
})

function Price({ amount }: { amount: number }) {
  return <Text>{currencyFormatter.format(amount)}</Text>
}
```

**對於動態語系，請使用 memoize:**

```tsx
const dateFormatter = useMemo(
  () => new Intl.DateTimeFormat(locale, { dateStyle: 'medium' }),
  [locale]
)
```

**常見的提升格式化器範例:**

```tsx
// 模組層級的格式化器
const dateFormatter = new Intl.DateTimeFormat('en-US', { dateStyle: 'medium' })
const timeFormatter = new Intl.DateTimeFormat('en-US', { timeStyle: 'short' })
const percentFormatter = new Intl.NumberFormat('en-US', { style: 'percent' })
const relativeFormatter = new Intl.RelativeTimeFormat('en-US', {
  numeric: 'auto',
})
```

建立 `Intl` 物件比建立 `RegExp` 或普通物件要昂貴得多 — 每次實例化都會解析語系數據並構建內部查找表。
