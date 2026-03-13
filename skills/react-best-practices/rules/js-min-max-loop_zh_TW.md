---
title: 使用迴圈查找最小/最大值而非排序 (Use Loop for Min/Max Instead of Sort)
impact: LOW
impactDescription: O(n) 而非 O(n log n) (O(n) instead of O(n log n))
tags: javascript, arrays, performance, sorting, algorithms
---

[English Version](./js-min-max-loop.md)

## 使用迴圈查找最小/最大值而非排序 (Use Loop for Min/Max Instead of Sort)

尋找最小或最大的元素只需要對陣列進行單次掃描。排序既浪費資源又緩慢。

**不正確 (O(n log n) - 透過排序尋找最新項目)：**

```typescript
interface Project {
  id: string
  name: string
  updatedAt: number
}

function getLatestProject(projects: Project[]) {
  const sorted = [...projects].sort((a, b) => b.updatedAt - a.updatedAt)
  return sorted[0]
}
```

僅為了尋找最大值而對整個陣列進行排序。

**不正確 (O(n log n) - 透過排序尋找最舊與最新項目)：**

```typescript
function getOldestAndNewest(projects: Project[]) {
  const sorted = [...projects].sort((a, b) => a.updatedAt - b.updatedAt)
  return { oldest: sorted[0], newest: sorted[sorted.length - 1] }
}
```

當只需要最小/最大值時，仍然進行了不必要的排序。

**正確 (O(n) - 單次迴圈)：**

```typescript
function getLatestProject(projects: Project[]) {
  if (projects.length === 0) return null
  
  let latest = projects[0]
  
  for (let i = 1; i < projects.length; i++) {
    if (projects[i].updatedAt > latest.updatedAt) {
      latest = projects[i]
    }
  }
  
  return latest
}

function getOldestAndNewest(projects: Project[]) {
  if (projects.length === 0) return { oldest: null, newest: null }
  
  let oldest = projects[0]
  let newest = projects[0]
  
  for (let i = 1; i < projects.length; i++) {
    if (projects[i].updatedAt < oldest.updatedAt) oldest = projects[i]
    if (projects[i].updatedAt > newest.updatedAt) newest = projects[i]
  }
  
  return { oldest, newest }
}
```

對陣列進行單次掃描，無須複製，無須排序。

**替代方案 (對於小陣列使用 Math.min/Math.max)：**

```typescript
const numbers = [5, 2, 8, 1, 9]
const min = Math.min(...numbers)
const max = Math.max(...numbers)
```

這適用於小陣列，但對於非常大的陣列，由於展開運算子 (spread operator) 的限制，可能會變慢或直接拋出錯誤。Chrome 143 的最大陣列長度約為 124,000，Safari 18 約為 638,000；確切數值可能有所不同 - 請參閱 [此測試](https://jsfiddle.net/qw1jabsx/4/)。為了穩定性，請使用迴圈方法。
