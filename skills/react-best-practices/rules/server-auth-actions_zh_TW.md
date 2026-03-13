---
title: 像處理 API 路由一樣驗證 Server Actions
impact: CRITICAL
impactDescription: 防止未經授權的伺服器端異動
tags: server, server-actions, authentication, security, authorization
---

[English Version](./server-auth-actions.md)

## 像處理 API 路由一樣驗證 Server Actions

**影響：嚴重 (防止未經授權的伺服器端異動)**

Server Actions（標有 `"use server"` 的函式）與 API 路由一樣，都是公開的端點。請務必在**每個** Server Action **內部**驗證身分驗證（authentication）與權限控管（authorization），切勿僅依賴中介軟體（middleware）、佈局守衛（layout guards）或頁面層級的檢查，因為 Server Actions 可以被直接調用。

Next.js 官方文件明確指出：「應以對待公開 API 端點的相同安全性考量來處理 Server Actions，並驗證使用者是否被允許執行異動（mutation）。」

**不正確（沒有身分驗證檢查）：**

```typescript
'use server'

export async function deleteUser(userId: string) {
  // 任何人都可以調用！沒有驗證檢查
  await db.user.delete({ where: { id: userId } })
  return { success: true }
}
```

**正確（在 Action 內部進行身分驗證）：**

```typescript
'use server'

import { verifySession } from '@/lib/auth'
import { unauthorized } from '@/lib/errors'

export async function deleteUser(userId: string) {
  // 務必在 Action 內部檢查身分驗證
  const session = await verifySession()
  
  if (!session) {
    throw unauthorized('必須先登入')
  }
  
  // 同時檢查權限控管
  if (session.user.role !== 'admin' && session.user.id !== userId) {
    throw unauthorized('無法刪除其他使用者')
  }
  
  await db.user.delete({ where: { id: userId } })
  return { success: true }
}
```

**搭配輸入驗證：**

```typescript
'use server'

import { verifySession } from '@/lib/auth'
import { z } from 'zod'

const updateProfileSchema = z.object({
  userId: z.string().uuid(),
  name: z.string().min(1).max(100),
  email: z.string().email()
})

export async function updateProfile(data: unknown) {
  // 先進行輸入驗證
  const validated = updateProfileSchema.parse(data)
  
  // 接著進行身分驗證
  const session = await verifySession()
  if (!session) {
    throw new Error('未授權')
  }
  
  // 接著進行權限控管
  if (session.user.id !== validated.userId) {
    throw new Error('只能更新自己的個人資料')
  }
  
  // 最後執行異動
  await db.user.update({
    where: { id: validated.userId },
    data: {
      name: validated.name,
      email: validated.email
    }
  })
  
  return { success: true }
}
```

參考資料：[https://nextjs.org/docs/app/guides/authentication](https://nextjs.org/docs/app/guides/authentication)
