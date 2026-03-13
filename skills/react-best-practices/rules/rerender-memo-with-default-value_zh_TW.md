---
title: 將被 Memo 組件的非主型態預設參數值提取為常數 (Extract Default Non-primitive Parameter Value from Memoized Component to Constant)
impact: MEDIUM
impactDescription: 透過使用常數作為預設值來恢復 memoization (restores memoization by using a constant for default value)
tags: rerender, memo, optimization
---

[English Version](./rerender-memo-with-default-value.md)

## 將被 Memo 組件的非主型態預設參數值提取為常數 (Extract Default Non-primitive Parameter Value from Memoized Component to Constant)

當經 `memo` 處理的組件對某些非主型態 (non-primitive) 的選擇性參數（例如陣列、函式或物件）設有預設值時，如果在呼叫該組件時未提供該參數，將會導致 memoization 失效。這是因為每次重新渲染時都會建立新的數值實例，而這些實例在 `memo()` 的嚴格相等比較中無法通過。

要解決此問題，請將預設值提取為常數。

**錯誤範例 (`onClick` 在每次重新渲染時都有不同的值)：**

```tsx
const UserAvatar = memo(function UserAvatar({ onClick = () => {} }: { onClick?: () => void }) {
  // ...
})

// 使用時未提供選擇性的 onClick
<UserAvatar />
```

**正確範例 (穩定的預設值)：**

```tsx
const NOOP = () => {};

const UserAvatar = memo(function UserAvatar({ onClick = NOOP }: { onClick?: () => void }) {
  // ...
})

// 使用時未提供選擇性的 onClick
<UserAvatar />
```
