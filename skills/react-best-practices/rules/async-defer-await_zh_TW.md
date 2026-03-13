---
title: 延遲 Await 直到需要時
impact: HIGH
impactDescription: 避免阻塞未使用的代碼路徑
tags: async, await, conditional, optimization
---

[English Version](./async-defer-await.md)

## 延遲 Await 直到需要時 (Defer Await Until Needed)

將 `await` 操作移至實際使用的分支中，以避免阻塞不需要這些操作的代碼路徑。

**錯誤範例 (阻塞了兩個分支)：**

```typescript
async function handleRequest(userId: string, skipProcessing: boolean) {
  const userData = await fetchUserData(userId)
  
  if (skipProcessing) {
    // 立即返回，但仍然等待了 userData
    return { skipped: true }
  }
  
  // 只有這個分支使用 userData
  return processUserData(userData)
}
```

**正確範例 (僅在需要時阻塞)：**

```typescript
async function handleRequest(userId: string, skipProcessing: boolean) {
  if (skipProcessing) {
    // 立即返回，不進行等待
    return { skipped: true }
  }
  
  // 僅在需要時獲取資料
  const userData = await fetchUserData(userId)
  return processUserData(userData)
}
```

**另一個例子 (提早返回優化)：**

```typescript
// 錯誤：總是獲取權限
async function updateResource(resourceId: string, userId: string) {
  const permissions = await fetchPermissions(userId)
  const resource = await getResource(resourceId)
  
  if (!resource) {
    return { error: 'Not found' }
  }
  
  if (!permissions.canEdit) {
    return { error: 'Forbidden' }
  }
  
  return await updateResourceData(resource, permissions)
}

// 正確：僅在需要時獲取
async function updateResource(resourceId: string, userId: string) {
  const resource = await getResource(resourceId)
  
  if (!resource) {
    return { error: 'Not found' }
  }
  
  const permissions = await fetchPermissions(userId)
  
  if (!permissions.canEdit) {
    return { error: 'Forbidden' }
  }
  
  return await updateResourceData(resource, permissions)
}
```

當跳過的分支經常被執行，或延遲的操作開銷較大時，這種優化特別有價值。
