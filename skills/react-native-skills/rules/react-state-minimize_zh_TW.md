---
title: 極小化狀態變數並使用衍生值
impact: MEDIUM
impactDescription: 更少的重新渲染，減少狀態不同步
tags: state, derived-state, hooks, optimization
---

[English Version](./react-state-minimize.md)

## 極小化狀態變數並使用衍生值

使用儘可能少的狀態變數。如果一個值可以從現有的狀態或 props 計算出來，請在渲染期間衍生它，而不是將其存儲在狀態中。冗餘的狀態會導致不必要的重新渲染，並且可能會發生狀態不同步的情況。

**錯誤（冗餘狀態）：**

```tsx
function Cart({ items }: { items: Item[] }) {
  const [total, setTotal] = useState(0)
  const [itemCount, setItemCount] = useState(0)

  useEffect(() => {
    setTotal(items.reduce((sum, item) => sum + item.price, 0))
    setItemCount(items.length)
  }, [items])

  return (
    <View>
      <Text>{itemCount} 項目</Text>
      <Text>總計: ${total}</Text>
    </View>
  )
}
```

**正確（衍生值）：**

```tsx
function Cart({ items }: { items: Item[] }) {
  const total = items.reduce((sum, item) => sum + item.price, 0)
  const itemCount = items.length

  return (
    <View>
      <Text>{itemCount} 項目</Text>
      <Text>總計: ${total}</Text>
    </View>
  )
}
```

**另一個例子：**

```tsx
// 錯誤：同時存儲 firstName, lastName, 以及 fullName
const [firstName, setFirstName] = useState('')
const [lastName, setLastName] = useState('')
const [fullName, setFullName] = useState('')

// 正確：衍生出 fullName
const [firstName, setFirstName] = useState('')
const [lastName, setLastName] = useState('')
const fullName = `${firstName} ${lastName}`
```

狀態應該是最小的真理來源（Source of Truth）。其餘的一切都是衍生的。

參考資料：[Choosing the State Structure](https://react.dev/learn/choosing-the-state-structure)
