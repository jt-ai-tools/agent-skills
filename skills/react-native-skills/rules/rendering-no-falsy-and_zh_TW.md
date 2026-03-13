---
title: 絕不對可能為假的值使用 &&
impact: CRITICAL
impactDescription: 防止正式環境崩潰
tags: rendering, conditional, jsx, crash
---

[English Version](./rendering-no-falsy-and.md)

## 絕不對可能為假的值使用 &&

當 `value` 可能是空字串或 `0` 時，絕不要使用 `{value && <Component />}`。這些值在 JavaScript 中為假（falsy），但在 JSX 中是可渲染的 — React Native 會嘗試在 `<Text>` 組件之外渲染它們，這會導致正式環境發生嚴重的崩潰（crash）。

**錯誤（如果 count 為 0 或 name 為 "" 會崩潰）：**

```tsx
function Profile({ name, count }: { name: string; count: number }) {
  return (
    <View>
      {name && <Text>{name}</Text>}
      {count && <Text>{count} items</Text>}
    </View>
  )
}
// 如果 name="" 或 count=0，會渲染該假值 → 崩潰
```

**正確（三元運算子配合 null）：**

```tsx
function Profile({ name, count }: { name: string; count: number }) {
  return (
    <View>
      {name ? <Text>{name}</Text> : null}
      {count ? <Text>{count} items</Text> : null}
    </View>
  )
}
```

**正確（顯式布林強制轉換）：**

```tsx
function Profile({ name, count }: { name: string; count: number }) {
  return (
    <View>
      {!!name && <Text>{name}</Text>}
      {!!count && <Text>{count} items</Text>}
    </View>
  )
}
```

**最佳（提早回傳 Early Return）：**

```tsx
function Profile({ name, count }: { name: string; count: number }) {
  if (!name) return null

  return (
    <View>
      <Text>{name}</Text>
      {count > 0 ? <Text>{count} items</Text> : null}
    </View>
  )
}
```

提早回傳（Early returns）最為清晰。在行內使用條件判斷時，請優先使用三元運算子或顯式的布林檢查。

**Lint 規則：** 啟用 [eslint-plugin-react](https://github.com/jsx-eslint/eslint-plugin-react/blob/master/docs/rules/jsx-no-leaked-render.md) 中的 `react/jsx-no-leaked-render` 規則來自動捕捉此問題。
