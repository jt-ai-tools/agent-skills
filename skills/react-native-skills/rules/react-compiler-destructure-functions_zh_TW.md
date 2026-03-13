---
title: 在 Render 早期解構函數 (React Compiler)
impact: HIGH
impactDescription: 穩定引用、減少重新渲染
tags: rerender, hooks, performance, react-compiler
---

[English Version](./react-compiler-destructure-functions.md)

## 在 Render 早期解構函數

本規則僅適用於您正在使用 React Compiler 的情況。

在 render 作用域的最頂層從 hooks 中解構 (destructure) 函數。絕不要透過物件屬性點選 (dot into) 來呼叫函數。解構後的函數是穩定引用 (stable references)；透過點選方式呼叫會建立新的引用並破壞記憶化 (memoization)。

**錯誤（透過物件屬性點選）：**

```tsx
import { useRouter } from 'expo-router'

function SaveButton(props) {
  const router = useRouter()

  // 錯誤：react-compiler 會將快取鍵值設為 "props" 和 "router"，這些物件在每次 render 時都會改變
  const handlePress = () => {
    props.onSave()
    router.push('/success') // 不穩定引用
  }

  return <Button onPress={handlePress}>Save</Button>
}
```

**正確（儘早解構）：**

```tsx
import { useRouter } from 'expo-router'

function SaveButton({ onSave }) {
  const { push } = useRouter()

  // 正確：react-compiler 會將鍵值設為 push 和 onSave
  const handlePress = () => {
    onSave()
    push('/success') // 穩定引用
  }

  return <Button onPress={handlePress}>Save</Button>
}
```
