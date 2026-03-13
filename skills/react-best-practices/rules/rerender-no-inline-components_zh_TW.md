---
title: 不要在元件內部定義元件
impact: HIGH
impactDescription: 避免每次渲染時重新掛載
tags: rerender, components, remount, performance
---

[English Version](./rerender-no-inline-components.md)

## 不要在元件內部定義元件

**影響：高（避免每次渲染時重新掛載）**

在另一個元件內部定義元件，會在每次渲染時建立一個新的元件類型。React 每次都會看到一個不同的元件並將其完全重新掛載（remount），從而銷毀所有狀態和 DOM。

開發者這樣做的一個常見原因是為了在不傳遞 props 的情況下存取父元件的變數。請務必改為傳遞 props。

**錯誤（每次渲染時重新掛載）：**

```tsx
function UserProfile({ user, theme }) {
  // 在內部定義以存取 `theme` - 錯誤
  const Avatar = () => (
    <img
      src={user.avatarUrl}
      className={theme === 'dark' ? 'avatar-dark' : 'avatar-light'}
    />
  )

  // 在內部定義以存取 `user` - 錯誤
  const Stats = () => (
    <div>
      <span>{user.followers} followers</span>
      <span>{user.posts} posts</span>
    </div>
  )

  return (
    <div>
      <Avatar />
      <Stats />
    </div>
  )
}
```

每當 `UserProfile` 渲染時，`Avatar` 和 `Stats` 都是新的元件類型。React 會卸載舊的實例並掛載新的實例，導致遺失任何內部狀態、重新執行 Effect 並重新建立 DOM 節點。

**正確（改為傳遞 props）：**

```tsx
function Avatar({ src, theme }: { src: string; theme: string }) {
  return (
    <img
      src={src}
      className={theme === 'dark' ? 'avatar-dark' : 'avatar-light'}
    />
  )
}

function Stats({ followers, posts }: { followers: number; posts: number }) {
  return (
    <div>
      <span>{followers} followers</span>
      <span>{posts} posts</span>
    </div>
  )
}

function UserProfile({ user, theme }) {
  return (
    <div>
      <Avatar src={user.avatarUrl} theme={theme} />
      <Stats followers={user.followers} posts={user.posts} />
    </div>
  )
}
```

**此錯誤的徵兆：**
- 輸入框在每次敲擊鍵盤時都會失去焦點
- 動畫意外地重新開始
- `useEffect` 的清除/設置函式在每次父元件渲染時執行
- 元件內部的捲動位置重置
