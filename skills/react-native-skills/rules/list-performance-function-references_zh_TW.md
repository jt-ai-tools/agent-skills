---
title: 使用穩定的物件引用優化列表效能
impact: CRITICAL
impactDescription: 虛擬化依賴於引用的穩定性
tags: lists, performance, flatlist, virtualization
---

[English Version](./list-performance-function-references.md)

## 使用穩定的物件引用優化列表效能

在將數據傳遞給虛擬化列表 (Virtualized List) 之前，不要進行 map 或 filter。虛擬化依賴於物件引用的穩定性來判斷哪些內容發生了變化 — 新的引用會導致所有可見項目重新渲染。應儘量防止在列表父層級頻繁進行 render。

如果需要，請在列表項內使用 context selector。

**錯誤做法 (每次按鍵都會建立新的物件引用):**

```tsx
function DomainSearch() {
  const { keyword, setKeyword } = useKeywordZustandState()
  const { data: tlds } = useTlds()

  // 錯誤做法：每次 render 都會建立新的物件，導致每次按鍵都會重新掛載整個列表
  const domains = tlds.map((tld) => ({
    domain: `${keyword}.${tld.name}`,
    tld: tld.name,
    price: tld.price,
  }))

  return (
    <>
      <TextInput value={keyword} onChangeText={setKeyword} />
      <LegendList
        data={domains}
        renderItem={({ item }) => <DomainItem item={item} keyword={keyword} />}
      />
    </>
  )
}
```

**正確做法 (穩定的引用，在項目內部進行轉換):**

```tsx
const renderItem = ({ item }) => <DomainItem tld={item} />

function DomainSearch() {
  const { data: tlds } = useTlds()

  return (
    <LegendList
      // 正確做法：只要數據是穩定的，LegendList 就不會重新渲染整個列表
      data={tlds}
      renderItem={renderItem}
    />
  )
}

function DomainItem({ tld }: { tld: Tld }) {
  // 正確做法：在項目內部進行轉換，不要將動態數據作為 prop 傳遞
  // 正確做法：使用 zustand 的 selector 函式來獲取穩定的字串
  const domain = useKeywordZustandState((s) => s.keyword + '.' + tld.name)
  return <Text>{domain}</Text>
}
```

**更新父陣列引用：**

建立新的陣列實例是可以接受的，只要其內部的物件引用是穩定的。例如，如果您對物件列表進行排序：

```tsx
// 正確做法：建立新的陣列實例而不會變更內部的物件
// 正確做法：父陣列引用不受輸入和更新 "keyword" 的影響
const sortedTlds = tlds.toSorted((a, b) => a.name.localeCompare(b.name))

return <LegendList data={sortedTlds} renderItem={renderItem} />
```

即使這建立了新的陣列實例 `sortedTlds`，內部的物件引用仍然是穩定的。

**結合 Zustand 處理動態數據 (避免父組件重新渲染):**

```tsx
const useSearchStore = create<{ keyword: string }>(() => ({ keyword: '' }))

function DomainSearch() {
  const { data: tlds } = useTlds()

  return (
    <>
      <SearchInput />
      <LegendList
        data={tlds}
        // 如果您沒有使用 React Compiler，請用 useCallback 包裹 renderItem
        renderItem={({ item }) => <DomainItem tld={item} />}
      />
    </>
  )
}

function DomainItem({ tld }: { tld: Tld }) {
  // 僅選取您需要的內容 — 組件僅在 keyword 更改時重新渲染
  const keyword = useSearchStore((s) => s.keyword)
  const domain = `${keyword}.${tld.name}`
  return <Text>{domain}</Text>
}
```

虛擬化現在可以跳過在輸入時未更改的項目。每次按鍵僅重新渲染可見項目 (~20 個)，而不是重新渲染父組件。

**根據父數據在列表項內衍生狀態 (避免父組件重新渲染):**

對於數據取決於父狀態的組件，這種模式更為重要。例如，如果您正在檢查某個項目是否被收藏，如果由項目本身負責存取狀態而不是由父組件負責，那麼切換收藏狀態僅會重新渲染該項目組件：

```tsx
function DomainItemFavoriteButton({ tld }: { tld: Tld }) {
  const isFavorited = useFavoritesStore((s) => s.favorites.has(tld.id))
  return <TldFavoriteButton isFavorited={isFavorited} />
}
```

注意：如果您使用的是 React Compiler，可以直接在列表項中讀取 React Context 的值。雖然在大多數情況下這比使用 Zustand selector 稍慢，但影響可能微乎其微。
