---
title: 使用 toSorted() 代替 sort() 以確保不可變性 (Use toSorted() Instead of sort() for Immutability)
impact: MEDIUM-HIGH
impactDescription: 防止 React 狀態中的變動 Bug (prevents mutation bugs in React state)
tags: javascript, arrays, immutability, react, state, mutation
---

[English Version](./js-tosorted-immutable.md)

## 使用 toSorted() 代替 sort() 以確保不可變性 (Use toSorted() Instead of sort() for Immutability)

`.sort()` 會直接修改 (mutate) 原始陣列，這可能會導致 React 狀態 (state) 和屬性 (props) 出現 Bug。應使用 `.toSorted()` 來建立一個新的排序陣列，而不改動原始資料。

**不正確 (修改了原始陣列)：**

```typescript
function UserList({ users }: { users: User[] }) {
  // 修改了 users 屬性陣列！
  const sorted = useMemo(
    () => users.sort((a, b) => a.name.localeCompare(b.name)),
    [users]
  )
  return <div>{sorted.map(renderUser)}</div>
}
```

**正確 (建立新陣列)：**

```typescript
function UserList({ users }: { users: User[] }) {
  // 建立新的排序陣列，原始資料保持不變
  const sorted = useMemo(
    () => users.toSorted((a, b) => a.name.localeCompare(b.name)),
    [users]
  )
  return <div>{sorted.map(renderUser)}</div>
}
```

**為什麼這在 React 中很重要：**

1. 屬性 (Props) / 狀態 (State) 的變動會破壞 React 的不可變模型 (Immutability model) —— React 期望將屬性和狀態視為唯讀。
2. 導致過時閉包 (Stale closure) Bug —— 在閉包 (回呼函式、effect) 內部修改陣列可能會導致非預期的行為。

**瀏覽器支援 (舊版瀏覽器的備案)：**

`.toSorted()` 已在所有現代瀏覽器中提供 (Chrome 110+, Safari 16+, Firefox 115+, Node.js 20+)。對於舊版環境，請使用展開運算子：

```typescript
// 舊版瀏覽器的備案
const sorted = [...items].sort((a, b) => a.value - b.value)
```

**其他不可變陣列方法：**

- `.toSorted()` - 不可變排序
- `.toReversed()` - 不可變反轉
- `.toSpliced()` - 不可變拼接 (splice)
- `.with()` - 不可變元素替換
