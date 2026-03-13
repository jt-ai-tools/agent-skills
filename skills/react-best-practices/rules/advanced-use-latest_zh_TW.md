---
title: 使用 useEffectEvent 獲得穩定的回呼 Ref
impact: LOW
impactDescription: 防止 Effect 重新運行
tags: advanced, hooks, useEffectEvent, refs, optimization
---

[English Version](./advanced-use-latest.md)

## 使用 useEffectEvent 獲得穩定的回呼 Ref (useEffectEvent for Stable Callback Refs)

在不將回呼函數加入依賴數組的情況下，於回呼中訪問最新值。這可以防止 Effect 重新運行，同時避免閉包過時 (stale closures)。

**錯誤範例 (Effect 在每次回呼變動時都會重新運行)：**

```tsx
function SearchInput({ onSearch }: { onSearch: (q: string) => void }) {
  const [query, setQuery] = useState('')

  useEffect(() => {
    const timeout = setTimeout(() => onSearch(query), 300)
    return () => clearTimeout(timeout)
  }, [query, onSearch])
}
```

**正確範例 (使用 React 的 useEffectEvent)：**

```tsx
import { useEffectEvent } from 'react';

function SearchInput({ onSearch }: { onSearch: (q: string) => void }) {
  const [query, setQuery] = useState('')
  const onSearchEvent = useEffectEvent(onSearch)

  useEffect(() => {
    const timeout = setTimeout(() => onSearchEvent(query), 300)
    return () => clearTimeout(timeout)
  }, [query])
}
```
