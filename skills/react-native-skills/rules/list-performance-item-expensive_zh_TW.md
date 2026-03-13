---
title: 保持列表項輕量化
impact: HIGH
impactDescription: 減少捲動時可見項目的渲染時間
tags: lists, performance, virtualization, hooks
---

[English Version](./list-performance-item-expensive.md)

## 保持列表項輕量化

列表項 (List items) 的渲染應盡可能地節省資源。減少 Hook 的使用、避免進行查詢 (queries)，並限制對 React Context 的存取。虛擬化列表在捲動時會渲染許多項目 — 昂貴的項目會導致卡頓。

**錯誤做法 (過重的列表項):**

```tsx
function ProductRow({ id }: { id: string }) {
  // 錯誤：在列表項中進行查詢
  const { data: product } = useQuery(['product', id], () => fetchProduct(id))
  // 錯誤：多次存取 Context
  const theme = useContext(ThemeContext)
  const user = useContext(UserContext)
  const cart = useContext(CartContext)
  // 錯誤：昂貴的計算
  const recommendations = useMemo(
    () => computeRecommendations(product),
    [product]
  )

  return <View>{/* ... */}</View>
}
```

**正確做法 (輕量化的列表項):**

```tsx
function ProductRow({ name, price, imageUrl }: Props) {
  // 正確：僅接收原始型別，極少量的 Hook
  return (
    <View>
      <Image source={{ uri: imageUrl }} />
      <Text>{name}</Text>
      <Text>{price}</Text>
    </View>
  )
}
```

**將數據獲取移至父組件：**

```tsx
// 父組件一次性獲取所有數據
function ProductList() {
  const { data: products } = useQuery(['products'], fetchProducts)

  return (
    <LegendList
      data={products}
      renderItem={({ item }) => (
        <ProductRow name={item.name} price={item.price} imageUrl={item.image} />
      )}
    />
  )
}
```

**對於共享值，使用 Zustand selector 代替 Context：**

```tsx
// 錯誤做法：當 cart 的任何值發生變化時，Context 都會導致重新渲染
function ProductRow({ id, name }: Props) {
  const { items } = useContext(CartContext)
  const inCart = items.includes(id)
  // ...
}

// 正確做法：Zustand selector 僅在該特定值更改時才觸發重新渲染
function ProductRow({ id, name }: Props) {
  // 使用 Set.has (在根部建立一次) 代替 Array.includes()
  const inCart = useCartStore((s) => s.items.has(id))
  // ...
}
```

**列表項準則：**

- 不進行查詢或數據獲取
- 不進行昂貴的計算 (移至父組件或在父組件層級進行 memoize)
- 優先使用 Zustand selector 而非 React Context
- 盡量減少 useState/useEffect Hook 的使用
- 以 prop 形式傳遞預先計算好的值

目標：列表項應該是簡單的渲染函式，接收 props 並回傳 JSX。
