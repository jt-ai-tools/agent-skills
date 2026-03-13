---
title: 避免在 RSC Props 中重複序列化
impact: LOW
impactDescription: 透過避免重複序列化來減少網路傳輸量
tags: server, rsc, serialization, props, client-components
---

[English Version](./server-dedup-props.md)

## 避免在 RSC Props 中重複序列化

**影響：低 (透過避免重複序列化來減少網路傳輸量)**

從 RSC（React Server Components）傳輸到用戶端時，序列化的重複資料刪除（deduplication）是依據物件引用（reference）而非數值（value）。相同的引用僅會被序列化一次；新的引用則會被再次序列化。請在用戶端執行轉換操作（例如 `.toSorted()`、`.filter()`、`.map()`），而非伺服器端。

**不正確（重複陣列）：**

```tsx
// RSC：傳送 6 個字串（2 個陣列 × 3 個項目）
<ClientList usernames={usernames} usernamesOrdered={usernames.toSorted()} />
```

**正確（傳送 3 個字串）：**

```tsx
// RSC：傳送一次
<ClientList usernames={usernames} />

// 用戶端：在那裡進行轉換
'use client'
const sorted = useMemo(() => [...usernames].sort(), [usernames])
```

**巢狀重複資料刪除行為：**

重複資料刪除是以遞迴方式運作。影響程度依資料型別而異：

- `string[]`, `number[]`, `boolean[]`：**高影響** —— 陣列與所有原生型別都會被完全重複傳送
- `object[]`：**低影響** —— 陣列結構會重複，但巢狀物件會透過引用進行重複資料刪除

```tsx
// string[] —— 複製所有內容
usernames={['a','b']} sorted={usernames.toSorted()} // 傳送 4 個字串

// object[] —— 僅複製陣列結構
users={[{id:1},{id:2}]} sorted={users.toSorted()} // 傳送 2 個陣列 + 2 個不重複的物件（而非 4 個）
```

**會破壞重複資料刪除的操作（建立新的引用）：**

- 陣列：`.toSorted()`, `.filter()`, `.map()`, `.slice()`, `[...arr]`
- 物件：`{...obj}`, `Object.assign()`, `structuredClone()`, `JSON.parse(JSON.stringify())`

**更多範例：**

```tsx
// ❌ 錯誤
<C users={users} active={users.filter(u => u.active)} />
<C product={product} productName={product.name} />

// ✅ 正確
<C users={users} />
<C product={product} />
// 在用戶端進行過濾/解構
```

**例外情況：** 當轉換運算量很大，或者用戶端不需要原始資料時，請傳遞衍生資料。
