---
title: Use a List Virtualizer for Any List
impact: HIGH
impactDescription: reduced memory, faster mounts
tags: lists, performance, virtualization, scrollview
---

[English Version](./list-performance-virtualize.md)

## 針對任何列表使用列表虛擬化 (List Virtualizer)

即使是短列表，也請使用像 LegendList 或 FlashList 這樣的列表虛擬化工具，而不是使用帶有對應子元件的 ScrollView。虛擬化工具只會渲染可見項目，從而減少記憶體使用量和掛載時間。ScrollView 會預先渲染所有子元件，這會很快變得昂貴。

**不正確（ScrollView 一次渲染所有項目）：**

```tsx
function Feed({ items }: { items: Item[] }) {
  return (
    <ScrollView>
      {items.map((item) => (
        <ItemCard key={item.id} item={item} />
      ))}
    </ScrollView>
  )
}
// 50 個項目 = 50 個元件被掛載，即使只有 10 個可見
```

**正確（虛擬化工具僅渲染可見項目）：**

```tsx
import { LegendList } from '@legendapp/list'

function Feed({ items }: { items: Item[] }) {
  return (
    <LegendList
      data={items}
      // 如果您不使用 React Compiler，請使用 useCallback 包裝這些函式
      renderItem={({ item }) => <ItemCard item={item} />}
      keyExtractor={(item) => item.id}
      estimatedItemSize={80}
    />
  )
}
// 同時僅掛載約 10-15 個可見項目
```

**替代方案 (FlashList)：**

```tsx
import { FlashList } from '@shopify/flash-list'

function Feed({ items }: { items: Item[] }) {
  return (
    <FlashList
      data={items}
      // 如果您不使用 React Compiler，請使用 useCallback 包裝這些函式
      renderItem={({ item }) => <ItemCard item={item} />}
      keyExtractor={(item) => item.id}
    />
  )
}
```

這些優點適用於任何具有可捲動內容的螢幕——個人資料、設定、動態訊息、搜尋結果。預設使用虛擬化。
