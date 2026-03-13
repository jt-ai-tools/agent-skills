---
title: 快取重複的函式呼叫
impact: MEDIUM
impactDescription: 避免多餘的運算
tags: javascript, cache, memoization, performance
---

[English Version](./js-cache-function-results.md)

## 快取重複的函式呼叫

當同一個函式在渲染期間使用相同的輸入被重複呼叫時，使用模組級別（module-level）的 Map 來快取函式結果。

**錯誤做法（多餘的運算）：**

```typescript
function ProjectList({ projects }: { projects: Project[] }) {
  return (
    <div>
      {projects.map(project => {
        // 對於相同的專案名稱，slugify() 會被呼叫 100 次以上
        const slug = slugify(project.name)
        
        return <ProjectCard key={project.id} slug={slug} />
      })}
    </div>
  )
}
```

**正確做法（快取結果）：**

```typescript
// 模組級別快取
const slugifyCache = new Map<string, string>()

function cachedSlugify(text: string): string {
  if (slugifyCache.has(text)) {
    return slugifyCache.get(text)!
  }
  const result = slugify(text)
  slugifyCache.set(text, result)
  return result
}

function ProjectList({ projects }: { projects: Project[] }) {
  return (
    <div>
      {projects.map(project => {
        // 每個唯一的專案名稱僅計算一次
        const slug = cachedSlugify(project.name)
        
        return <ProjectCard key={project.id} slug={slug} />
      })}
    </div>
  )
}
```

**單值函式的更簡單模式：**

```typescript
let isLoggedInCache: boolean | null = null

function isLoggedIn(): boolean {
  if (isLoggedInCache !== null) {
    return isLoggedInCache
  }
  
  isLoggedInCache = document.cookie.includes('auth=')
  return isLoggedInCache
}

// 當認證狀態變更時清除快取
function onAuthChange() {
  isLoggedInCache = null
}
```

使用 Map（而非 Hook），使其在任何地方都能運作：工具函式、事件處理器，而不僅限於 React 元件。

參考資料：[How we made the Vercel Dashboard twice as fast](https://vercel.com/blog/how-we-made-the-vercel-dashboard-twice-as-fast)
