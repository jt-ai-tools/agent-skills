---
title: 跨請求的 LRU 快取
impact: HIGH
impactDescription: 跨請求快取資料
tags: server, cache, lru, cross-request
---

[English Version](./server-cache-lru.md)

## 跨請求的 LRU 快取

`React.cache()` 僅在單次請求內有效。若要在連續請求之間共享資料（例如使用者點擊按鈕 A 後再點擊按鈕 B），請使用 LRU 快取。

**實作方式：**

```typescript
import { LRUCache } from 'lru-cache'

const cache = new LRUCache<string, any>({
  max: 1000,
  ttl: 5 * 60 * 1000  // 5 分鐘
})

export async function getUser(id: string) {
  const cached = cache.get(id)
  if (cached) return cached

  const user = await db.user.findUnique({ where: { id } })
  cache.set(id, user)
  return user
}

// 請求 1：資料庫查詢，快取結果
// 請求 2：快取命中，無需資料庫查詢
```

適用於使用者連續執行操作，且在幾秒鐘內觸發多個需要相同資料的端點時。

**搭配 Vercel 的 [Fluid Compute](https://vercel.com/docs/fluid-compute)：** LRU 快取特別有效，因為多個並行請求可以共享同一個函式實例與快取。這意味著快取可以在請求之間持續存在，而不需要像 Redis 這樣的外部儲存。

**在傳統的無伺服器（serverless）環境中：** 每次調用都是隔離運行的，因此請考慮使用 Redis 進行跨行程快取。

參考資料：[https://github.com/isaacs/node-lru-cache](https://github.com/isaacs/node-lru-cache)
