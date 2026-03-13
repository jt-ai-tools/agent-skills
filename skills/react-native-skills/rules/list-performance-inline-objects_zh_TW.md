---
title: 避免在 renderItem 中使用行內物件
impact: HIGH
impactDescription: 防止已 memoize 的列表項進行不必要的重新渲染
tags: lists, performance, flatlist, virtualization, memo
---

[English Version](./list-performance-inline-objects.md)

## 避免在 renderItem 中使用行內物件

不要在 `renderItem` 內部建立新物件並將其作為 prop 傳遞。行內物件 (inline objects) 在每次 render 時都會建立新的引用，這會破壞 memoization。請改為直接從 `item` 傳遞原始型別 (primitive) 的值。

**錯誤做法 (行內物件破壞了 memoization):**

```tsx
function UserList({ users }: { users: User[] }) {
  return (
    <LegendList
      data={users}
      renderItem={({ item }) => (
        <UserRow
          // 錯誤：每次 render 都會產生新物件
          user={{ id: item.id, name: item.name, avatar: item.avatar }}
        />
      )}
    />
  )
}
```

**錯誤做法 (行內樣式物件):**

```tsx
renderItem={({ item }) => (
  <UserRow
    name={item.name}
    // 錯誤：每次 render 都會產生新的樣式物件
    style={{ backgroundColor: item.isActive ? 'green' : 'gray' }}
  />
)}
```

**正確做法 (直接傳遞項目或原始型別):**

```tsx
function UserList({ users }: { users: User[] }) {
  return (
    <LegendList
      data={users}
      renderItem={({ item }) => (
        // 正確：直接傳遞項目
        <UserRow user={item} />
      )}
    />
  )
}
```

**正確做法 (傳遞原始型別，在子組件內部衍生):**

```tsx
renderItem={({ item }) => (
  <UserRow
    id={item.id}
    name={item.name}
    isActive={item.isActive}
  />
)}

const UserRow = memo(function UserRow({ id, name, isActive }: Props) {
  // 正確：在已 memoize 的組件內部衍生樣式
  const backgroundColor = isActive ? 'green' : 'gray'
  return <View style={[styles.row, { backgroundColor }]}>{/* ... */}</View>
})
```

**正確做法 (將靜態樣式提升至模組作用域):**

```tsx
const activeStyle = { backgroundColor: 'green' }
const inactiveStyle = { backgroundColor: 'gray' }

renderItem={({ item }) => (
  <UserRow
    name={item.name}
    // 正確：穩定的引用
    style={item.isActive ? activeStyle : inactiveStyle}
  />
)}
```

傳遞原始型別或穩定的引用可以讓 `memo()` 在實際值未更改時跳過重新渲染。

**注意：** 如果您啟用了 React Compiler，它會自動處理 memoization，這些手動優化將變得不再那麼關鍵。
