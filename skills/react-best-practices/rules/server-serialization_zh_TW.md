---
title: 最小化 RSC 邊界的序列化 (Minimize Serialization at RSC Boundaries)
impact: HIGH
impactDescription: 減少資料傳輸大小
tags: server, rsc, serialization, props
---

# 最小化 RSC 邊界的序列化 (Minimize Serialization at RSC Boundaries)

[English Version](./server-serialization.md)

React Server/Client 邊界會將所有物件屬性序列化為字串，並嵌入到 HTML 回應及後續的 RSC 請求中。這些序列化資料會直接影響頁面大小與載入時間，因此**資料量的大小非常重要**。請僅傳遞客戶端實際使用的欄位。

**錯誤示例 (序列化了所有 50 個欄位)：**

```tsx
async function Page() {
  const user = await fetchUser()  // 包含 50 個欄位
  return <Profile user={user} />
}

'use client'
function Profile({ user }: { user: User }) {
  return <div>{user.name}</div>  // 僅使用了 1 個欄位
}
```

**正確示例 (僅序列化 1 個欄位)：**

```tsx
async function Page() {
  const user = await fetchUser()
  return <Profile name={user.name} />
}

'use client'
function Profile({ name }: { name: string }) {
  return <div>{name}</div>
}
```
