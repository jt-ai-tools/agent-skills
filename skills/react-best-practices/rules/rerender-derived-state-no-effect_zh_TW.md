---
title: 在渲染期間計算衍生狀態
impact: MEDIUM
impactDescription: 避免多餘的渲染和狀態偏移
tags: rerender, derived-state, useEffect, state
---

[English Version](./rerender-derived-state-no-effect.md)

## 在渲染期間計算衍生狀態

如果一個值可以從當前的 props/state 中計算出來，請不要將其儲存在 state 中或在 effect 中更新它。在渲染期間進行衍生計算，以避免額外的渲染和狀態偏移。不要僅僅為了回應 prop 的變更而在 effect 中設定 state；請優先使用衍生值或透過 key 進行重置。

**不正確（多餘的 state 和 effect）：**

```tsx
function Form() {
  const [firstName, setFirstName] = useState('First')
  const [lastName, setLastName] = useState('Last')
  const [fullName, setFullName] = useState('')

  useEffect(() => {
    setFullName(firstName + ' ' + lastName)
  }, [firstName, lastName])

  return <p>{fullName}</p>
}
```

**正確（在渲染期間衍生計算）：**

```tsx
function Form() {
  const [firstName, setFirstName] = useState('First')
  const [lastName, setLastName] = useState('Last')
  const fullName = firstName + ' ' + lastName

  return <p>{fullName}</p>
}
```

參考資料：[You Might Not Need an Effect](https://react.dev/learn/you-might-not-need-an-effect)
