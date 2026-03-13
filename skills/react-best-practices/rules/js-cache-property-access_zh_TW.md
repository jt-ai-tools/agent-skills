---
title: 在迴圈中快取屬性存取 (Cache Property Access in Loops)
impact: LOW-MEDIUM
impactDescription: 減少查詢次數 (reduces lookups)
tags: javascript, loops, optimization, caching
---

[English Version](./js-cache-property-access.md)

## 在迴圈中快取屬性存取 (Cache Property Access in Loops)

在熱點路徑 (hot paths) 中快取物件屬性查詢。

**不正確 (每輪迴圈進行 3 次查詢 × N 次迭代)：**

```typescript
for (let i = 0; i < arr.length; i++) {
  process(obj.config.settings.value)
}
```

**正確 (總共僅 1 次查詢)：**

```typescript
const value = obj.config.settings.value
const len = arr.length
for (let i = 0; i < len; i++) {
  process(value)
}
```
