---
title: 防止 API 路由中的瀑布流鏈 (Prevent Waterfall Chains in API Routes)
impact: CRITICAL
impactDescription: 2-10 倍的性能提升
tags: api-routes, server-actions, waterfalls, parallelization
---

[English Version](./async-api-routes.md)

## 防止 API 路由中的瀑布流鏈 (Prevent Waterfall Chains in API Routes)

在 API 路由和 Server Actions 中，應立即啟動獨立的操作，即使您尚未 `await` 它們。

**錯誤範例 (config 等待 auth，data 等待兩者)：**

```typescript
export async function GET(request: Request) {
  const session = await auth()
  const config = await fetchConfig()
  const data = await fetchData(session.user.id)
  return Response.json({ data, config })
}
```

**正確範例 (auth 和 config 立即啟動)：**

```typescript
export async function GET(request: Request) {
  const sessionPromise = auth()
  const configPromise = fetchConfig()
  const session = await sessionPromise
  const [config, data] = await Promise.all([
    configPromise,
    fetchData(session.user.id)
  ])
  return Response.json({ data, config })
}
```

對於具有更複雜依賴鏈的操作，請使用 `better-all` 來自動最大化並行性 (參見「基於依賴的並行化」)。
