---
title: React 19 API 變更 (React 19 API Changes)
impact: MEDIUM
impactDescription: 更簡潔的元件定義與 Context 使用方式
tags: react19, refs, context, hooks
---

[English Version](./react19-no-forwardref.md)

## React 19 API 變更

> **⚠️ 僅限 React 19+。** 如果你使用的是 React 18 或更早版本，請跳過此部分。

在 React 19 中，`ref` 現在是一個普通的屬性（不再需要 `forwardRef` 包裝器），且 `use()` 取代了 `useContext()`。

**不正確（在 React 19 中使用 forwardRef）：**

```tsx
const ComposerInput = forwardRef<TextInput, Props>((props, ref) => {
  return <TextInput ref={ref} {...props} />
})
```

**正確（將 ref 作為普通屬性）：**

```tsx
function ComposerInput({ ref, ...props }: Props & { ref?: React.Ref<TextInput> }) {
  return <TextInput ref={ref} {...props} />
}
```

**不正確（在 React 19 中使用 useContext）：**

```tsx
const value = useContext(MyContext)
```

**正確（使用 use 取代 useContext）：**

```tsx
const value = use(MyContext)
```

與 `useContext()` 不同，`use()` 也可以在條件判斷中呼叫。
