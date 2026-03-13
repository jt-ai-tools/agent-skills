---
title: 使用 React.cache() 進行單次請求內的重複資料刪除
impact: MEDIUM
impactDescription: 在請求內刪除重複操作
tags: server, cache, react-cache, deduplication
---

[English Version](./server-cache-react.md)

## 使用 React.cache() 進行單次請求內的重複資料刪除

使用 `React.cache()` 進行伺服器端的請求重複資料刪除（deduplication）。身分驗證與資料庫查詢從中獲益最多。

**用法：**

```typescript
import { cache } from 'react'

export const getCurrentUser = cache(async () => {
  const session = await auth()
  if (!session?.user?.id) return null
  return await db.user.findUnique({
    where: { id: session.user.id }
  })
})
```

在單次請求中，多次調用 `getCurrentUser()` 只會執行一次查詢。

**避免使用行內物件（inline objects）作為參數：**

`React.cache()` 使用淺層比較（`Object.is`）來判斷快取是否命中。行內物件在每次調用時都會建立新的引用，進而導致快取失效。

**不正確（總是快取失效）：**

```typescript
const getUser = cache(async (params: { uid: number }) => {
  return await db.user.findUnique({ where: { id: params.uid } })
})

// 每次調用都會建立新物件，永遠無法命中快取
getUser({ uid: 1 })
getUser({ uid: 1 })  // 快取失效，再次執行查詢
```

**正確（快取命中）：**

```typescript
const getUser = cache(async (uid: number) => {
  return await db.user.findUnique({ where: { id: uid } })
})

// 原生型別（Primitive）參數使用數值比較
getUser(1)
getUser(1)  // 快取命中，回傳快取結果
```

若必須傳遞物件，請傳遞相同的引用：

```typescript
const params = { uid: 1 }
getUser(params)  // 執行查詢
getUser(params)  // 快取命中（相同的引用）
```

**Next.js 說明：**

在 Next.js 中，`fetch` API 已自動擴充了請求記憶化（request memoization）功能。具有相同 URL 與選項的請求會在單次請求中自動刪除重複，因此您不需要對 `fetch` 調用使用 `React.cache()`。然而，對於其他非同步任務，`React.cache()` 仍然至關重要：

- 資料庫查詢（Prisma, Drizzle 等）
- 高運算量的計算
- 身分驗證檢查
- 檔案系統操作
- 任何非 fetch 的非同步工作

使用 `React.cache()` 在您的元件樹中刪除這些操作的重複。

參考資料：[React.cache 官方文件](https://react.dev/reference/react/cache)
