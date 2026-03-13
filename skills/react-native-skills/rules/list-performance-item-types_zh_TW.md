---
title: Use Item Types for Heterogeneous Lists
impact: HIGH
impactDescription: efficient recycling, less layout thrashing
tags: list, performance, recycling, heterogeneous, LegendList
---

[English Version](./list-performance-item-types.md)

## 針對異構列表使用項目類型 (Item Types)

當一個列表具有不同的項目佈局（訊息、圖像、標題等）時，請在每個項目上使用 `type` 欄位，並為列表提供 `getItemType`。這會將項目放入單獨的回收池中，因此訊息元件永遠不會被回收成圖像元件。

**不正確（帶有條件判斷的單一元件）：**

```tsx
type Item = { id: string; text?: string; imageUrl?: string; isHeader?: boolean }

function ListItem({ item }: { item: Item }) {
  if (item.isHeader) {
    return <HeaderItem title={item.text} />
  }
  if (item.imageUrl) {
    return <ImageItem url={item.imageUrl} />
  }
  return <MessageItem text={item.text} />
}

function Feed({ items }: { items: Item[] }) {
  return (
    <LegendList
      data={items}
      renderItem={({ item }) => <ListItem item={item} />}
      recycleItems
    />
  )
}
```

**正確（具有獨立元件的類型化項目）：**

```tsx
type HeaderItem = { id: string; type: 'header'; title: string }
type MessageItem = { id: string; type: 'message'; text: string }
type ImageItem = { id: string; type: 'image'; url: string }
type FeedItem = HeaderItem | MessageItem | ImageItem

function Feed({ items }: { items: FeedItem[] }) {
  return (
    <LegendList
      data={items}
      keyExtractor={(item) => item.id}
      getItemType={(item) => item.type}
      renderItem={({ item }) => {
        switch (item.type) {
          case 'header':
            return <SectionHeader title={item.title} />
          case 'message':
            return <MessageRow text={item.text} />
          case 'image':
            return <ImageRow url={item.url} />
        }
      }}
      recycleItems
    />
  )
}
```

**為什麼這很重要：**

- **回收效率**：相同類型的項目共用一個回收池
- **無佈局抖動**：標題永遠不會回收成圖像儲存格
- **類型安全**：TypeScript 可以縮小每個分支中的項目類型
- **更好的尺寸估計**：使用 `getEstimatedItemSize` 搭配 `itemType` 進行各種類型的精確估計

```tsx
<LegendList
  data={items}
  keyExtractor={(item) => item.id}
  getItemType={(item) => item.type}
  getEstimatedItemSize={(index, item, itemType) => {
    switch (itemType) {
      case 'header':
        return 48
      case 'message':
        return 72
      case 'image':
        return 300
      default:
        return 72
    }
  }}
  renderItem={({ item }) => {
    /* ... */
  }}
  recycleItems
/>
```

參考資料：
[LegendList getItemType](https://legendapp.com/open-source/list/api/props/#getitemtype-v2)
