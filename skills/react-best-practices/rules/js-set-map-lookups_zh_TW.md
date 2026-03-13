---
title: 使用 Set/Map 進行 O(1) 查詢 (Use Set/Map for O(1) Lookups)
impact: LOW-MEDIUM
impactDescription: 從 O(n) 降至 O(1) (O(n) to O(1))
tags: javascript, set, map, data-structures, performance
---

[English Version](./js-set-map-lookups.md)

## 使用 Set/Map 進行 O(1) 查詢 (Use Set/Map for O(1) Lookups)

將陣列轉換為 Set/Map 以進行重複的成員資格檢查 (membership checks)。

**不正確 (每次檢查的時間複雜度為 O(n))：**

```typescript
const allowedIds = ['a', 'b', 'c', ...]
items.filter(item => allowedIds.includes(item.id))
```

**正確 (每次檢查的時間複雜度為 O(1))：**

```typescript
const allowedIds = new Set(['a', 'b', 'c', ...])
items.filter(item => allowedIds.has(item.id))
```
