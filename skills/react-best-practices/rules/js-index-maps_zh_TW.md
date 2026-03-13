---
title: 為重複查詢建立索引映射 (Build Index Maps for Repeated Lookups)
impact: LOW-MEDIUM
impactDescription: 從 1M 次操作降至 2K 次操作 (1M ops to 2K ops)
tags: javascript, map, indexing, optimization, performance
---

[English Version](./js-index-maps.md)

## 為重複查詢建立索引映射 (Build Index Maps for Repeated Lookups)

針對相同鍵 (key) 的多次 `.find()` 呼叫應改用 Map。

**不正確 (每次查詢的時間複雜度為 O(n))：**

```typescript
function processOrders(orders: Order[], users: User[]) {
  return orders.map(order => ({
    ...order,
    user: users.find(u => u.id === order.userId)
  }))
}
```

**正確 (每次查詢的時間複雜度為 O(1))：**

```typescript
function processOrders(orders: Order[], users: User[]) {
  const userById = new Map(users.map(u => [u.id, u]))

  return orders.map(order => ({
    ...order,
    user: userById.get(order.userId)
  }))
}
```

建立一次 Map (O(n))，之後的所有查詢都是 O(1)。
對於 1000 個訂單 × 1000 個使用者：運算量從 1M 次降至 2K 次。
