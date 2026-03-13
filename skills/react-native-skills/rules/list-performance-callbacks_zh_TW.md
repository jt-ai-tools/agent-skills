---
title: 將回呼函式提升至列表根部
impact: MEDIUM
impactDescription: 減少重新渲染並提升列表速度
tags: tag1, tag2
---

[English Version](./list-performance-callbacks.md)

## 列表效能：回呼函式 (Callbacks)

**影響程度：高 (減少重新渲染並提升列表速度)**

當傳遞回呼函式 (callback functions) 給列表項時，請在列表的根部建立回呼函式的單一實例。列表項接著應使用唯一的識別碼來呼叫它。

**錯誤做法 (每次 render 都建立新的回呼函式):**

```typescript
return (
  <LegendList
    renderItem={({ item }) => {
      // 錯誤：每次 render 都會建立新的回呼函式
      const onPress = () => handlePress(item.id)
      return <Item key={item.id} item={item} onPress={onPress} />
    }}
  />
)
```

**正確做法 (傳遞單一函式實例給每個列表項):**

```typescript
const onPress = useCallback((id: string) => handlePress(id), [handlePress])

return (
  <LegendList
    renderItem={({ item }) => (
      <Item key={item.id} item={item} onPress={onPress} />
    )}
  />
)
```

參考資料：[連結至文件或資源](https://example.com)
