---
title: 使用 flatMap 一次完成映射與過濾 (Use flatMap to Map and Filter in One Pass)
impact: LOW-MEDIUM
impactDescription: 消除中間陣列 (eliminates intermediate array)
tags: javascript, arrays, flatMap, filter, performance
---

[English Version](./js-flatmap-filter.md)

## 使用 flatMap 一次完成映射與過濾 (Use flatMap to Map and Filter in One Pass)

**影響：低-中 (消除中間陣列)**

鏈式呼叫 `.map().filter(Boolean)` 會建立一個中間陣列並迭代兩次。使用 `.flatMap()` 可以在單次處理中同時完成轉換與過濾。

**不正確 (2 次迭代，產生中間陣列)：**

```typescript
const userNames = users
  .map(user => user.isActive ? user.name : null)
  .filter(Boolean)
```

**正確 (1 次迭代，無中間陣列)：**

```typescript
const userNames = users.flatMap(user =>
  user.isActive ? [user.name] : []
)
```

**更多範例：**

```typescript
// 從回應中提取有效電子郵件
// 之前
const emails = responses
  .map(r => r.success ? r.data.email : null)
  .filter(Boolean)

// 之後
const emails = responses.flatMap(r =>
  r.success ? [r.data.email] : []
)

// 解析並過濾有效數字
// 之前
const numbers = strings
  .map(s => parseInt(s, 10))
  .filter(n => !isNaN(n))

// 之後
const numbers = strings.flatMap(s => {
  const n = parseInt(s, 10)
  return isNaN(n) ? [] : [n]
})
```

**何時使用：**
- 在轉換項目的同時過濾掉某些項目
- 條件式映射 (Conditional mapping)，其中某些輸入不產生輸出
- 解析/驗證，應跳過無效輸入的情況
