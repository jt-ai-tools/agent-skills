---
title: 傳遞原始型別給列表項以實現 Memoization
impact: HIGH
impactDescription: 啟用有效的 memo() 比較
tags: lists, performance, memo, primitives
---

[English Version](./list-performance-item-memo.md)

## 傳遞原始型別給列表項以實現 Memoization

盡可能只將原始型別 (primitives，如字串、數字、布林值) 作為 prop 傳遞給列表項組件。原始型別可以讓 `memo()` 中的淺層比較 (shallow comparison) 正常運作，從而在值未更改時跳過重新渲染。

**錯誤做法 (物件 prop 需要深層比較):**

```tsx
type User = { id: string; name: string; email: string; avatar: string }

const UserRow = memo(function UserRow({ user }: { user: User }) {
  // memo() 按引用 (reference) 而非按值 (value) 比較 user
  // 如果父組件建立了新的 user 物件，即使數據相同，這也會重新渲染
  return <Text>{user.name}</Text>
})

renderItem={({ item }) => <UserRow user={item} />}
```

雖然仍可優化，但要正確實現 memoize 會比較困難。

**正確做法 (原始型別 prop 啟用了淺層比較):**

```tsx
const UserRow = memo(function UserRow({
  id,
  name,
  email,
}: {
  id: string
  name: string
  email: string
}) {
  // memo() 直接比較每個原始型別
  // 僅在 id、name 或 email 確實更改時才重新渲染
  return <Text>{name}</Text>
})

renderItem={({ item }) => (
  <UserRow id={item.id} name={item.name} email={item.email} />
)}
```

**只傳遞您需要的內容：**

```tsx
// 錯誤做法：只需要 name 時卻傳遞了整個 item
<UserRow user={item} />

// 正確做法：僅傳遞組件使用的欄位
<UserRow name={item.name} avatarUrl={item.avatar} />
```

**對於回呼函式，請提升位置或使用項目 ID：**

```tsx
// 錯誤做法：行內函式建立了新的引用
<UserRow name={item.name} onPress={() => handlePress(item.id)} />

// 正確做法：傳遞 ID，在子組件中處理
<UserRow id={item.id} name={item.name} />

const UserRow = memo(function UserRow({ id, name }: Props) {
  const handlePress = useCallback(() => {
    // 在此處使用 id
  }, [id])
  return <Pressable onPress={handlePress}><Text>{name}</Text></Pressable>
})
```

原始型別 prop 使得 memoization 變得可預測且有效。

**注意：** 如果您啟用了 React Compiler，則不需要使用 `memo()` 或 `useCallback()`，但物件引用的規則仍然適用。
