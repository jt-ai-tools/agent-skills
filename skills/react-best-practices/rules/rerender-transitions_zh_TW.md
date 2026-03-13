---
title: 對非緊急更新使用 Transition
impact: MEDIUM
impactDescription: 保持 UI 響應性
tags: rerender, transitions, startTransition, performance
---

[English Version](./rerender-transitions.md)

## 對非緊急更新使用 Transition

將頻繁且非緊急的狀態更新標記為 Transition，以保持 UI 的響應性。

**錯誤（每次捲動時都會阻塞 UI）：**

```tsx
function ScrollTracker() {
  const [scrollY, setScrollY] = useState(0)
  useEffect(() => {
    const handler = () => setScrollY(window.scrollY)
    window.addEventListener('scroll', handler, { passive: true })
    return () => window.removeEventListener('scroll', handler)
  }, [])
}
```

**正確（非阻塞更新）：**

```tsx
import { startTransition } from 'react'

function ScrollTracker() {
  const [scrollY, setScrollY] = useState(0)
  useEffect(() => {
    const handler = () => {
      startTransition(() => setScrollY(window.scrollY))
    }
    window.addEventListener('scroll', handler, { passive: true })
    return () => window.removeEventListener('scroll', handler)
  }, [])
}
```
