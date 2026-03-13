---
title: 陣列比較時優先進行長度檢查 (Early Length Check for Array Comparisons)
impact: MEDIUM-HIGH
impactDescription: 當長度不同時避免昂貴的操作 (avoids expensive operations when lengths differ)
tags: javascript, arrays, performance, optimization, comparison
---

[English Version](./js-length-check-first.md)

## 陣列比較時優先進行長度檢查 (Early Length Check for Array Comparisons)

當使用昂貴的操作 (排序、深層比較、序列化) 比較陣列時，應先檢查長度。如果長度不同，陣列絕對不相等。

在實際應用中，當比較邏輯運行在熱點路徑 (hot paths) (如事件處理器、渲染迴圈) 時，此優化尤其有價值。

**不正確 (總是執行昂貴的比較)：**

```typescript
function hasChanges(current: string[], original: string[]) {
  // 即使長度不同，也總是進行排序與合併 (join)
  return current.sort().join() !== original.sort().join()
}
```

即使 `current.length` 為 5 且 `original.length` 為 100，仍會執行兩次 O(n log n) 的排序。此外還有合併陣列與比較字串的開銷。

**正確 (優先進行 O(1) 的長度檢查)：**

```typescript
function hasChanges(current: string[], original: string[]) {
  // 如果長度不同，立即回傳
  if (current.length !== original.length) {
    return true
  }
  // 僅在長度相符時才進行排序
  const currentSorted = current.toSorted()
  const originalSorted = original.toSorted()
  for (let i = 0; i < currentSorted.length; i++) {
    if (currentSorted[i] !== originalSorted[i]) {
      return true
    }
  }
  return false
}
```

這種新方法更有效率，因為：
- 避免了當長度不同時排序與合併陣列的開銷
- 避免了為合併字串而消耗記憶體 (這對大陣列尤為重要)
- 避免了變動 (mutate) 原始陣列
- 在發現差異時立即回傳
