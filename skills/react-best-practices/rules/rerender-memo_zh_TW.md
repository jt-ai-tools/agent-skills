---
title: 提取為經 Memo 處理的組件 (Extract to Memoized Components)
impact: MEDIUM
impactDescription: 實現提早回傳 (enables early returns)
tags: rerender, memo, useMemo, optimization
---

[English Version](./rerender-memo.md)

## 提取為經 Memo 處理的組件 (Extract to Memoized Components)

將開銷較大的工作提取到經 `memo` 處理的組件中，以便在計算之前實現提早回傳 (early returns)。

**錯誤範例 (即使在載入中也會計算 avatar)：**

```tsx
function Profile({ user, loading }: Props) {
  const avatar = useMemo(() => {
    const id = computeAvatarId(user)
    return <Avatar id={id} />
  }, [user])

  if (loading) return <Skeleton />
  return <div>{avatar}</div>
}
```

**正確範例 (在載入中跳過計算)：**

```tsx
const UserAvatar = memo(function UserAvatar({ user }: { user: User }) {
  const id = useMemo(() => computeAvatarId(user), [user])
  return <Avatar id={id} />
})

function Profile({ user, loading }: Props) {
  if (loading) return <Skeleton />
  return (
    <div>
      <UserAvatar user={user} />
    </div>
  )
}
```

**注意：** 如果您的專案啟用了 [React Compiler](https://react.dev/learn/react-compiler)，則不需要手動使用 `memo()` 和 `useMemo()` 進行 memoization。編譯器會自動優化重新渲染。
