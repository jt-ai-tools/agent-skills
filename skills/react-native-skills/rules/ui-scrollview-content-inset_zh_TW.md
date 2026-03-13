---
title: 使用 contentInset 處理動態 ScrollView 間距
impact: LOW
impactDescription: 更新更流暢，無需重新計算佈局
tags: scrollview, layout, contentInset, performance
---

[English Version](./ui-scrollview-content-inset.md)

## 使用 contentInset 處理動態 ScrollView 間距

當需要為 ScrollView 的頂部或底部添加可能發生變化的間距（如鍵盤、工具欄、動態內容）時，請使用 `contentInset` 而不是 padding。更改 `contentInset` 不會觸發佈局重新計算——它只是調整滾動區域而不會重新渲染內容。

**錯誤 (padding 會導致重新計算佈局):**

```tsx
function Feed({ bottomOffset }: { bottomOffset: number }) {
  return (
    <ScrollView contentContainerStyle={{ paddingBottom: bottomOffset }}>
      {children}
    </ScrollView>
  )
}
// 更改 bottomOffset 會觸發完整的佈局重新計算
```

**正確 (使用 contentInset 處理動態間距):**

```tsx
function Feed({ bottomOffset }: { bottomOffset: number }) {
  return (
    <ScrollView
      contentInset={{ bottom: bottomOffset }}
      scrollIndicatorInsets={{ bottom: bottomOffset }}
    >
      {children}
    </ScrollView>
  )
}
// 更改 bottomOffset 僅調整滾動範圍
```

請同時使用 `scrollIndicatorInsets` 和 `contentInset`，以保持滾動指示器（scroll indicator）對齊。對於永不改變的靜態間距，使用 padding 即可。
