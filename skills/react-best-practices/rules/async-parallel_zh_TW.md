---
title: 使用 Promise.all() 進行獨立操作
impact: CRITICAL
impactDescription: 2-10 倍的性能提升
tags: async, parallelization, promises, waterfalls
---

[English Version](./async-parallel.md)

## 使用 Promise.all() 進行獨立操作 (Promise.all() for Independent Operations)

當非同步操作之間沒有相互依賴關係時，請使用 `Promise.all()` 並行執行它們。

**錯誤範例 (順序執行，需 3 次來回通訊)：**

```typescript
const user = await fetchUser()
const posts = await fetchPosts()
const comments = await fetchComments()
```

**正確範例 (並行執行，僅需 1 次來回通訊)：**

```typescript
const [user, posts, comments] = await Promise.all([
  fetchUser(),
  fetchPosts(),
  fetchComments()
])
```
