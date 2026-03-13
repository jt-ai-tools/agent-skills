---
title: 函式提早回傳 (Early Return from Functions)
impact: LOW-MEDIUM
impactDescription: 避免不必要的計算 (avoids unnecessary computation)
tags: javascript, functions, optimization, early-return
---

[English Version](./js-early-exit.md)

## 函式提早回傳 (Early Return from Functions)

當結果已確定時提早回傳，以跳過不必要的後續處理。

**不正確 (即使已找到答案，仍處理所有項目)：**

```typescript
function validateUsers(users: User[]) {
  let hasError = false
  let errorMessage = ''
  
  for (const user of users) {
    if (!user.email) {
      hasError = true
      errorMessage = 'Email required'
    }
    if (!user.name) {
      hasError = true
      errorMessage = 'Name required'
    }
    // 即使已發現錯誤，仍繼續檢查所有使用者
  }
  
  return hasError ? { valid: false, error: errorMessage } : { valid: true }
}
```

**正確 (在發現第一個錯誤時立即回傳)：**

```typescript
function validateUsers(users: User[]) {
  for (const user of users) {
    if (!user.email) {
      return { valid: false, error: 'Email required' }
    }
    if (!user.name) {
      return { valid: false, error: 'Name required' }
    }
  }

  return { valid: true }
}
```
