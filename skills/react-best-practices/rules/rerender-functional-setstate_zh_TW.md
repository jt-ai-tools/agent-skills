---
title: 使用函式形式的 setState 更新 (Use Functional setState Updates)
impact: MEDIUM
impactDescription: 防止過時的閉包及不必要的回呼函式重建 (prevents stale closures and unnecessary callback recreations)
tags: react, hooks, useState, useCallback, callbacks, closures
---

[English Version](./rerender-functional-setstate.md)

## 使用函式形式的 setState 更新 (Use Functional setState Updates)

當基於當前狀態更新狀態時，請使用 setState 的函式更新形式，而不是直接引用狀態變數。這可以防止過時的閉包 (stale closures)，消除不必要的依賴項，並建立穩定的回呼引用。

**錯誤範例 (需要 state 作為依賴項)：**

```tsx
function TodoList() {
  const [items, setItems] = useState(initialItems)
  
  // 回呼函式必須依賴 items，每次 items 變動時都會重建
  const addItems = useCallback((newItems: Item[]) => {
    setItems([...items, ...newItems])
  }, [items])  // ❌ items 依賴項導致重新建立
  
  // 如果忘記依賴項，則有過時閉包的風險
  const removeItem = useCallback((id: string) => {
    setItems(items.filter(item => item.id !== id))
  }, [])  // ❌ 缺少 items 依賴項 - 將使用舊的 items！
  
  return <ItemsEditor items={items} onAdd={addItems} onRemove={removeItem} />
}
```

第一個回呼函式在每次 `items` 變動時都會重新建立，這可能導致子組件不必要地重新渲染。第二個回呼函式有過時閉包的臭蟲——它將始終引用初始的 `items` 值。

**正確範例 (穩定的回呼函式，無過時閉包)：**

```tsx
function TodoList() {
  const [items, setItems] = useState(initialItems)
  
  // 穩定的回呼函式，永不重新建立
  const addItems = useCallback((newItems: Item[]) => {
    setItems(curr => [...curr, ...newItems])
  }, [])  // ✅ 不需要依賴項
  
  // 始終使用最新的狀態，無過時閉包風險
  const removeItem = useCallback((id: string) => {
    setItems(curr => curr.filter(item => item.id !== id))
  }, [])  // ✅ 安全且穩定
  
  return <ItemsEditor items={items} onAdd={addItems} onRemove={removeItem} />
}
```

**好處：**

1. **穩定的回呼引用** - 當狀態變動時，回呼函式不需要重新建立。
2. **無過時閉包** - 始終操作最新的狀態值。
3. **更少的依賴項** - 簡化了依賴項陣列並減少記憶體洩漏。
4. **防止臭蟲** - 消除 React 閉包臭蟲最常見的來源。

**何時使用函式更新：**

- 任何依賴於當前狀態值的 setState。
- 在需要狀態的 useCallback/useMemo 內部。
- 引用狀態的事件處理器。
- 更新狀態的非同步操作。

**何時直接更新即可：**

- 將狀態設置為靜態值：`setCount(0)`。
- 僅根據 props/引數設置狀態：`setName(newName)`。
- 狀態不依賴於前一個值。

**注意：** 如果您的專案啟用了 [React Compiler](https://react.dev/learn/react-compiler)，編譯器可以自動優化某些情況，但為了正確性以及防止過時閉包臭蟲，仍然建議使用函式更新。
