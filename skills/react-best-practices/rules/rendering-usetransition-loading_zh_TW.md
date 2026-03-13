---
title: 使用 useTransition 取代手動載入狀態
impact: LOW
impactDescription: 減少重複渲染並提升程式碼清晰度
tags: rendering, transitions, useTransition, loading, state
---

[English Version](./rendering-usetransition-loading.md)

## 使用 useTransition 取代手動載入狀態

使用 `useTransition` 而不是手動使用 `useState` 來處理載入狀態。這提供了內建的 `isPending` 狀態並自動管理轉換。

**不正確（手動載入狀態）：**

```tsx
function SearchResults() {
  const [query, setQuery] = useState('')
  const [results, setResults] = useState([])
  const [isLoading, setIsLoading] = useState(false)

  const handleSearch = async (value: string) => {
    setIsLoading(true)
    setQuery(value)
    const data = await fetchResults(value)
    setResults(data)
    setIsLoading(false)
  }

  return (
    <>
      <input onChange={(e) => handleSearch(e.target.value)} />
      {isLoading && <Spinner />}
      <ResultsList results={results} />
    </>
  )
}
```

**正確（使用具備內建 pending 狀態的 useTransition）：**

```tsx
import { useTransition, useState } from 'react'

function SearchResults() {
  const [query, setQuery] = useState('')
  const [results, setResults] = useState([])
  const [isPending, startTransition] = useTransition()

  const handleSearch = (value: string) => {
    setQuery(value) // 立即更新輸入
    
    startTransition(async () => {
      // 獲取並更新結果
      const data = await fetchResults(value)
      setResults(data)
    })
  }

  return (
    <>
      <input onChange={(e) => handleSearch(e.target.value)} />
      {isPending && <Spinner />}
      <ResultsList results={results} />
    </>
  )
}
```

**優點：**

- **自動 pending 狀態**：無需手動管理 `setIsLoading(true/false)`
- **錯誤恢復能力**：即使轉換過程拋出錯誤，pending 狀態也會正確重置
- **更好的回應性**：在更新期間保持 UI 的回應性
- **中斷處理**：新的轉換會自動取消掛起中的轉換

參考資料：[useTransition](https://react.dev/reference/react/useTransition)
