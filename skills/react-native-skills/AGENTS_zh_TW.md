[繁體中文版本](./AGENTS_zh_TW.md)

# React Native 技巧 (React Native Skills)

**版本 1.0.0**  
工程團隊  
2026 年 1 月

> **注意：**  
> 本文件主要供 AI 代理 (Agents) 和大型語言模型 (LLMs) 在維護、生成或重構 React Native 代碼庫時遵循。人類開發者也可能會發現它很有用，但這裡的指導方針是針對 AI 輔助工作流程的自動化和一致性進行優化的。

---

## 摘要 (Abstract)

本文件是為 AI 代理和 LLMs 設計的 React Native 應用程序全面性能優化指南。包含 13 個類別中的 35 多條規則，按影響力排序，從關鍵（核心渲染、列表性能）到漸進式（字體、導入）。每條規則都包含詳細說明、比較錯誤與正確實現的實際範例，以及具體的影響指標，以指導自動化重構和代碼生成。

---

## 目錄 (Table of Contents)

1. [核心渲染 (Core Rendering)](#1-core-rendering) — **關鍵 (CRITICAL)**
   - 1.1 [切勿將 && 用於潛在的虛值](#11-never-use--with-potentially-falsy-values)
   - 1.2 [將字串包裹在 Text 組件中](#12-wrap-strings-in-text-components)
2. [列表性能 (List Performance)](#2-list-performance) — **高 (HIGH)**
   - 2.1 [避免在 renderItem 中使用內聯對象](#21-avoid-inline-objects-in-renderitem)
   - 2.2 [將回調函數提升到列表的根部](#22-hoist-callbacks-to-the-root-of-lists)
   - 2.3 [保持列表項目輕量化](#23-keep-list-items-lightweight)
   - 2.4 [使用穩定的對象引用優化列表性能](#24-optimize-list-performance-with-stable-object-references)
   - 2.5 [向列表項目傳遞原始值以便進行 Memoization](#25-pass-primitives-to-list-items-for-memoization)
   - 2.6 [為任何列表使用列表虛擬化](#26-use-a-list-virtualizer-for-any-list)
   - 2.7 [在列表中使用壓縮圖像](#27-use-compressed-images-in-lists)
   - 2.8 [為異構列表使用項目類型](#28-use-item-types-for-heterogeneous-lists)
3. [動畫 (Animation)](#3-animation) — **高 (HIGH)**
   - 3.1 [動畫化 Transform 和 Opacity 而不是佈局屬性](#31-animate-transform-and-opacity-instead-of-layout-properties)
   - 3.2 [優先使用 useDerivedValue 而不是 useAnimatedReaction](#32-prefer-usederivedvalue-over-useanimatedreaction)
   - 3.3 [為動畫按壓狀態使用 GestureDetector](#33-use-gesturedetector-for-animated-press-states)
4. [滾動性能 (Scroll Performance)](#4-scroll-performance) — **高 (HIGH)**
   - 4.1 [切勿在 useState 中追蹤滾動位置](#41-never-track-scroll-position-in-usestate)
5. [導航 (Navigation)](#5-navigation) — **高 (HIGH)**
   - 5.1 [為導航使用原生導航器](#51-use-native-navigators-for-navigation)
6. [React 狀態 (React State)](#6-react-state) — **中 (MEDIUM)**
   - 6.1 [最小化狀態變量並推導值](#61-minimize-state-variables-and-derive-values)
   - 6.2 [使用回退狀態 (fallback state) 而不是 initialState](#62-use-fallback-state-instead-of-initialstate)
   - 6.3 [對於依賴當前值的狀態使用 useState Dispatch Updaters](#63-usestate-dispatch-updaters-for-state-that-depends-on-current-value)
7. [狀態架構 (State Architecture)](#7-state-architecture) — **中 (MEDIUM)**
   - 7.1 [狀態必須代表事實真相 (Ground Truth)](#71-state-must-represent-ground-truth)
8. [React 編譯器 (React Compiler)](#8-react-compiler) — **中 (MEDIUM)**
   - 8.1 [在渲染作用域早期解構函數 (React 編譯器)](#81-destructure-functions-early-in-render-react-compiler)
   - 8.2 [為 Reanimated 共享值使用 .get() 和 .set()（而不是 .value）](#82-use-get-and-set-for-reanimated-shared-values-not-value)
9. [用戶介面 (User Interface)](#9-user-interface) — **中 (MEDIUM)**
   - 9.1 [測量視圖尺寸](#91-measuring-view-dimensions)
   - 9.2 [現代 React Native 樣式模式](#92-modern-react-native-styling-patterns)
   - 9.3 [為動態 ScrollView 間距使用 contentInset](#93-use-contentinset-for-dynamic-scrollview-spacing)
   - 9.4 [為安全區域使用 contentInsetAdjustmentBehavior](#94-use-contentinsetadjustmentbehavior-for-safe-areas)
   - 9.5 [為優化後的圖像使用 expo-image](#95-use-expo-image-for-optimized-images)
   - 9.6 [為圖像畫廊和燈箱效果使用 Galeria](#96-use-galeria-for-image-galleries-and-lightbox)
   - 9.7 [為下拉菜單和上下文菜單使用原生菜單](#97-use-native-menus-for-dropdowns-and-context-menus)
   - 9.8 [優先使用原生 Modal 而非基於 JS 的 Bottom Sheets](#98-use-native-modals-over-js-based-bottom-sheets)
   - 9.9 [使用 Pressable 代替 Touchable 組件](#99-use-pressable-instead-of-touchable-components)
10. [設計系統 (Design System)](#10-design-system) — **中 (MEDIUM)**
   - 10.1 [使用組合組件優於多態子組件](#101-use-compound-components-over-polymorphic-children)
11. [Monorepo](#11-monorepo) — **低 (LOW)**
   - 11.1 [在 App 目錄中安裝原生依賴](#111-install-native-dependencies-in-app-directory)
   - 11.2 [在整個 Monorepo 中使用單一依賴版本](#112-use-single-dependency-versions-across-monorepo)
12. [第三方依賴 (Third-Party Dependencies)](#12-third-party-dependencies) — **低 (LOW)**
   - 12.1 [從設計系統文件夾導入](#121-import-from-design-system-folder)
13. [JavaScript](#13-javascript) — **低 (LOW)**
   - 13.1 [提升 Intl Formatter 的創建](#131-hoist-intl-formatter-creation)
14. [字體 (Fonts)](#14-fonts) — **低 (LOW)**
   - 14.1 [在構建時原生加載字體](#141-load-fonts-natively-at-build-time)

---

## 1. 核心渲染 (Core Rendering)

**影響：關鍵 (CRITICAL)**

基礎的 React Native 渲染規則。違反這些規則會導致運行時崩潰或 UI 損壞。

### 1.1 切勿將 && 用於潛在的虛值 (Falsy Values)

**影響：關鍵 (預防生產環境崩潰)**

當 `value` 可能為空字串或 `0` 時，切勿使用 `{value && <Component />}`。這些值雖然是虛值 (falsy)，但卻是可以渲染的 JSX——React Native 會嘗試將它們作為文字渲染在 `<Text>` 組件之外，這會導致生產環境中的嚴重崩潰。

**錯誤：如果 count 為 0 或 name 為 "" 則會崩潰**

```tsx
function Profile({ name, count }: { name: string; count: number }) {
  return (
    <View>
      {name && <Text>{name}</Text>}
      {count && <Text>{count} items</Text>}
    </View>
  )
}
// 如果 name="" 或 count=0，渲染虛值 → 崩潰
```

**正確：使用三元運算符搭配 null**

```tsx
function Profile({ name, count }: { name: string; count: number }) {
  return (
    <View>
      {name ? <Text>{name}</Text> : null}
      {count ? <Text>{count} items</Text> : null}
    </View>
  )
}
```

**正確：顯式的布林值強制轉換**

```tsx
function Profile({ name, count }: { name: string; count: number }) {
  return (
    <View>
      {!!name && <Text>{name}</Text>}
      {!!count && <Text>{count} items</Text>}
    </View>
  )
}
```

**最佳方案：提前返回 (Early Return)**

```tsx
function Profile({ name, count }: { name: string; count: number }) {
  if (!name) return null

  return (
    <View>
      <Text>{name}</Text>
      {count > 0 ? <Text>{count} items</Text> : null}
    </View>
  )
}
```

提前返回是最清晰的。當在行內使用條件判斷時，優先使用三元運算符或顯式的布林值檢查。

**Lint 規則：** 啟用來自 [eslint-plugin-react](https://github.com/jsx-eslint/eslint-plugin-react/blob/master/docs/rules/jsx-no-leaked-render.md) 的 `react/jsx-no-leaked-render` 來自動捕捉此問題。

### 1.2 將字串包裹在 Text 組件中

**影響：關鍵 (預防運行時崩潰)**

字串必須在 `<Text>` 內渲染。如果字串是 `<View>` 的直接子代，React Native 會崩潰。

**錯誤：會崩潰**

```tsx
import { View } from 'react-native'

function Greeting({ name }: { name: string }) {
  return <View>Hello, {name}!</View>
}
// 錯誤：文字字串必須在 <Text> 組件中渲染。
```

**正確：**

```tsx
import { View, Text } from 'react-native'

function Greeting({ name }: { name: string }) {
  return (
    <View>
      <Text>Hello, {name}!</Text>
    </View>
  )
}
```

---

## 2. 列表性能 (List Performance)

**影響：高 (HIGH)**

優化虛擬化列表（FlatList, LegendList, FlashList）以實現流暢的滾動和快速更新。

### 2.1 避免在 renderItem 中使用內聯對象 (Inline Objects)

**影響：高 (預防被 Memoized 的列表項目發生不必要的重新渲染)**

不要在 `renderItem` 內部創建新對象作為 props 傳遞。內聯對象在每次渲染時都會創建新的引用，從而破壞了 Memoization。請直接從 `item` 傳遞原始值。

**錯誤：內聯對象破壞了 Memoization**

```tsx
function UserList({ users }: { users: User[] }) {
  return (
    <LegendList
      data={users}
      renderItem={({ item }) => (
        <UserRow
          // 錯誤：每次渲染都會創建新對象
          user={{ id: item.id, name: item.name, avatar: item.avatar }}
        />
      )}
    />
  )
}
```

**錯誤：內聯樣式對象**

```tsx
renderItem={({ item }) => (
  <UserRow
    name={item.name}
    // 錯誤：每次渲染都會創建新樣式對象
    style={{ backgroundColor: item.isActive ? 'green' : 'gray' }}
  />
)}
```

**正確：直接傳遞項目或原始值**

```tsx
function UserList({ users }: { users: User[] }) {
  return (
    <LegendList
      data={users}
      renderItem={({ item }) => (
        // 正確：直接傳遞項目
        <UserRow user={item} />
      )}
    />
  )
}
```

**正確：傳遞原始值，在子組件內部推導**

```tsx
renderItem={({ item }) => (
  <UserRow
    id={item.id}
    name={item.name}
    isActive={item.isActive}
  />
)}

const UserRow = memo(function UserRow({ id, name, isActive }: Props) {
  // 正確：在被 Memoized 的組件內部推導樣式
  const backgroundColor = isActive ? 'green' : 'gray'
  return <View style={[styles.row, { backgroundColor }]}>{/* ... */}</View>
})
```

**正確：在模組作用域中提升靜態樣式**

```tsx
const activeStyle = { backgroundColor: 'green' }
const inactiveStyle = { backgroundColor: 'gray' }

renderItem={({ item }) => (
  <UserRow
    name={item.name}
    // 正確：穩定的引用
    style={item.isActive ? activeStyle : inactiveStyle}
  />
)}
```

傳遞原始值或穩定的引用可以讓 `memo()` 在實際值未更改時跳過重新渲染。

**注意：** 如果您啟用了 React 編譯器 (React Compiler)，它會自動處理 Memoization，這些手動優化將變得不再那麼關鍵。

### 2.2 將回調函數提升到列表的根部

**影響：中 (減少重新渲染並提升列表速度)**

向列表項目傳遞回調函數時，請在列表的根部創建回調函數的單個實例。然後，項目應使用唯一標識符來調用它。

**錯誤：每次渲染都會創建一個新的回調函數**

```typescript
return (
  <LegendList
    renderItem={({ item }) => {
      // 錯誤：每次渲染都會創建一個新的回調函數
      const onPress = () => handlePress(item.id)
      return <Item key={item.id} item={item} onPress={onPress} />
    }}
  />
)
```

**正確：傳遞給每個項目的單個函數實例**

```typescript
const onPress = useCallback(() => handlePress(item.id), [handlePress, item.id])

return (
  <LegendList
    renderItem={({ item }) => (
      <Item key={item.id} item={item} onPress={onPress} />
    )}
  />
)
```

參考資料：[https://example.com](https://example.com)

### 2.3 保持列表項目輕量化

**影響：高 (減少滾動期間可見項目的渲染時間)**

列表項目的渲染成本應盡可能低。盡量減少 Hook 的使用，避免查詢，並限制 React Context 的訪問。虛擬化列表在滾動期間會渲染許多項目——昂貴的項目會導致卡頓。

**錯誤：笨重的列表項目**

```tsx
function ProductRow({ id }: { id: string }) {
  // 錯誤：在列表項目內部進行查詢
  const { data: product } = useQuery(['product', id], () => fetchProduct(id))
  // 錯誤：多次訪問 Context
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

**正確：輕量級列表項目**

```tsx
function ProductRow({ name, price, imageUrl }: Props) {
  // 正確：僅接收原始值，最少的 Hook
  return (
    <View>
      <Image source={{ uri: imageUrl }} />
      <Text>{name}</Text>
      <Text>{price}</Text>
    </View>
  )
}
```

**將數據獲取移動到父組件：**

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

**對於共享值，使用 Zustand Selectors 代替 Context：**

```tsx
// 錯誤：當任何購物車值更改時，Context 都會導致重新渲染
function ProductRow({ id, name }: Props) {
  const { items } = useContext(CartContext)
  const inCart = items.includes(id)
  // ...
}

// 正確：Zustand Selector 僅在特定值更改時才重新渲染
function ProductRow({ id, name }: Props) {
  // 使用 Set.has（在根部創建一次）而不是 Array.includes()
  const inCart = useCartStore((s) => s.items.has(id))
  // ...
}
```

**列表項目的指南：**

- 不進行查詢或數據獲取

- 不進行昂貴的計算（移動到父組件或在父組件級別進行 Memoize）

- 優先使用 Zustand Selectors 而不是 React Context

- 盡量減少 useState/useEffect Hook 的使用

- 將預先計算好的值作為 props 傳遞

目標：列表項目應該是簡單的渲染函數，接收 props 並返回 JSX。

### 2.4 使用穩定的對象引用優化列表性能

**影響：關鍵 (虛擬化依賴於引用的穩定性)**

傳遞給虛擬化列表之前，不要對數據進行 map 或 filter。虛擬化依賴於對象引用的穩定性來判斷哪些內容發生了更改——新的引用會導致所有可見項目全量重新渲染。嘗試在列表父組件級別防止頻繁渲染。

在需要的地方，在列表項目內部使用 Context Selectors。

**錯誤：每次按鍵都會創建新的對象引用**

```tsx
function DomainSearch() {
  const { keyword, setKeyword } = useKeywordZustandState()
  const { data: tlds } = useTlds()

  // 錯誤：每次渲染都會創建新對象，每次按鍵都會重新渲染整個列表
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

**正確：穩定的引用，在項目內部轉換**

```tsx
const renderItem = ({ item }) => <DomainItem tld={item} />

function DomainSearch() {
  const { data: tlds } = useTlds()

  return (
    <LegendList
      // 正確：只要數據是穩定的，LegendList 就不會重新渲染整個列表
      data={tlds}
      renderItem={renderItem}
    />
  )
}

function DomainItem({ tld }: { tld: Tld }) {
  // 正確：在項目內部轉換，且不要將動態數據作為 prop 傳遞
  // 正確：使用來自 Zustand 的 Selector 函數來接收穩定的字串
  const domain = useKeywordZustandState((s) => s.keyword + '.' + tld.name)
  return <Text>{domain}</Text>
}
```

**更新父數組引用：**

```tsx
// 正確：創建一個新的數組實例而不變更內部對象
// 正確：父數組引用不受打字和更新 "keyword" 的影響
const sortedTlds = tlds.toSorted((a, b) => a.name.localeCompare(b.name))

return <LegendList data={sortedTlds} renderItem={renderItem} />
```

創建一個新的數組實例是可以的，只要其內部的對象引用是穩定的。例如，如果您對對象列表進行排序：

即使這創建了一個新的數組實例 `sortedTlds`，內部的對象引用也是穩定的。

**搭配 Zustand 處理動態數據：避免父組件重新渲染**

```tsx
function DomainItemFavoriteButton({ tld }: { tld: Tld }) {
  const isFavorited = useFavoritesStore((s) => s.favorites.has(tld.id))
  return <TldFavoriteButton isFavorited={isFavorited} />
}
```

現在，打字時虛擬化可以跳過未更改的項目。每次按鍵僅重新渲染可見項目（約 20 個），而不是父組件。

**在列表項目內部根據父組件數據派生狀態（避免父組件重新渲染）：**

對於數據取決於父組件狀態的組件，這種模式更為重要。例如，如果您正在檢查一個項目是否已被收藏，如果項目本身負責訪問狀態而不是父組件，那麼切換收藏狀態僅會重新渲染一個組件：

注意：如果您正在使用 React 編譯器，您可以直接在列表項目內部讀取 React Context 值。儘管在大多數情況下這比使用 Zustand Selector 稍慢，但影響可能微乎其微。

### 2.5 向列表項目傳遞原始值以便進行 Memoization

**影響：高 (使 memo() 比較生效)**

儘可能僅將原始值（字串、數字、布林值）作為 props 傳遞給列表項目組件。原始值可以讓 `memo()` 中的淺層比較 (Shallow Comparison) 正常工作，從而在值未更改時跳過重新渲染。

**錯誤：對象 prop 需要深層比較**

```tsx
type User = { id: string; name: string; email: string; avatar: string }

const UserRow = memo(function UserRow({ user }: { user: User }) {
  // memo() 通過引用而非值來比較用戶
  // 如果父組件創建了新的用戶對象，即使數據相同，這也會重新渲染
  return <Text>{user.name}</Text>
})

renderItem={({ item }) => <UserRow user={item} />}
```

這仍然可以優化，但很難正確地進行 Memoize。

**正確：原始值 props 啟用淺層比較**

```tsx
const UserRow = memo(function UserRow({
  id,
  name,
  email,
}: {
  id: string
  name: string
  email: string
}) {
  // memo() 直接比較每個原始值
  // 僅當 id、name 或 email 實際發生更改時才重新渲染
  return <Text>{name}</Text>
})

renderItem={({ item }) => (
  <UserRow id={item.id} name={item.name} email={item.email} />
)}
```

**僅傳遞您需要的內容：**

```tsx
// 錯誤：當您只需要姓名時傳遞了整個項目
<UserRow user={item} />

// 正確：僅傳遞組件使用的字段
<UserRow name={item.name} avatarUrl={item.avatar} />
```

**對於回調函數，請提升或使用項目 ID：**

```tsx
// 錯誤：內聯函數創建了新的引用
<UserRow name={item.name} onPress={() => handlePress(item.id)} />

// 正確：傳遞 ID，在子組件中處理
<UserRow id={item.id} name={item.name} />

const UserRow = memo(function UserRow({ id, name }: Props) {
  const handlePress = useCallback(() => {
    // 這裡使用 id
  }, [id])
  return <Pressable onPress={handlePress}><Text>{name}</Text></Pressable>
})
```

原始值 props 使 Memoization 變得可預測且有效。

**注意：** 如果您啟用了 React 編譯器，則無需使用 `memo()` 或 `useCallback()`，但對象引用的原則仍然適用。

### 2.6 為任何列表使用列表虛擬化

**影響：高 (減少記憶體佔用，加快掛載速度)**

即使對於短列表，也要使用列表虛擬化工具（如 LegendList 或 FlashList），而不是使用帶有 map 子項的 ScrollView。虛擬化工具僅渲染可見項目，從而減少記憶體使用量和掛載時間。ScrollView 會預先渲染所有子項，這會很快變得昂貴。

**錯誤：ScrollView 一次性渲染所有項目**

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
// 50 個項目 = 掛載 50 個組件，即使只有 10 個可見
```

**正確：虛擬化工具僅渲染可見項目**

```tsx
import { LegendList } from '@legendapp/list'

function Feed({ items }: { items: Item[] }) {
  return (
    <LegendList
      data={items}
      // 如果您不使用 React 編譯器，請使用 useCallback 包裹這些內容
      renderItem={({ item }) => <ItemCard item={item} />}
      keyExtractor={(item) => item.id}
      estimatedItemSize={80}
    />
  )
}
// 同時掛載的組件僅有約 10-15 個可見項目
```

**替代方案：FlashList**

```tsx
import { FlashList } from '@shopify/flash-list'

function Feed({ items }: { items: Item[] }) {
  return (
    <FlashList
      data={items}
      // 如果您不使用 React 編譯器，請使用 useCallback 包裹這些內容
      renderItem={({ item }) => <ItemCard item={item} />}
      keyExtractor={(item) => item.id}
    />
  )
}
```

這些好處適用於任何具有可滾動內容的屏幕——個人資料、設置、動態、搜索結果。請預設使用虛擬化。

### 2.7 在列表中使用壓縮圖像

**影響：高 (加載速度更快，佔用記憶體更少)**

在列表中始終加載壓縮且尺寸適中的圖像。全解析度圖像會消耗過多記憶體並導致滾動卡頓。請從您的服務器請求縮圖，或使用具有調整大小參數的圖像 CDN。

**錯誤：全解析度圖像**

```tsx
function ProductItem({ product }: { product: Product }) {
  return (
    <View>
      {/* 為 100x100 的縮圖加載了 4000x3000 的圖像 */}
      <Image
        source={{ uri: product.imageUrl }}
        style={{ width: 100, height: 100 }}
      />
      <Text>{product.name}</Text>
    </View>
  )
}
```

**正確：請求尺寸適中的圖像**

```tsx
function ProductItem({ product }: { product: Product }) {
  // 請求 200x200 的圖像（Retina 屏幕為 2x）
  const thumbnailUrl = `${product.imageUrl}?w=200&h=200&fit=cover`

  return (
    <View>
      <Image
        source={{ uri: thumbnailUrl }}
        style={{ width: 100, height: 100 }}
        contentFit='cover'
      />
      <Text>{product.name}</Text>
    </View>
  )
}
```

使用具有內建緩存和佔位符支持的優化圖像組件，例如 `expo-image` 或 `SolitoImage`（其在底層使用了 `expo-image`）。為 Retina 屏幕請求 2 倍顯示尺寸的圖像。

### 2.8 為異構列表使用項目類型

**影響：高 (高效回收，減少佈局抖動)**

當列表具有不同的項目佈局（消息、圖像、標題等）時，請在每個項目上使用 `type` 字段，並向列表提供 `getItemType`。這會將項目放入單獨的回收池，因此消息組件永遠不會被回收為圖像組件。

[LegendList getItemType](https://legendapp.com/open-source/list/api/props/#getitemtype-v2)

**錯誤：單個帶有條件判斷的組件**

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

**正確：具有單獨組件的分類型項目**

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

- **回收效率**：具有相同類型的項目共享同一個回收池

- **無佈局抖動**：標題永遠不會回收為圖像單元格

- **類型安全**：TypeScript 可以在每個分支中細化項目類型

- **更好的尺寸估算**：結合 `itemType` 使用 `getEstimatedItemSize` 以實現每個類型的準確估算

---

## 3. 動畫 (Animation)

**影響：高 (HIGH)**

GPU 加速的動畫、Reanimated 模式，以及避免在手勢期間發生渲染抖動。

### 3.1 動畫化 Transform 和 Opacity 而不是佈局屬性

**影響：高 (GPU 加速動畫，無需重新計算佈局)**

避免動畫化 `width`、`height`、`top`、`left`、`margin` 或 `padding`。這些屬性在每一幀都會觸發佈局重新計算。相反，請使用 `transform`（縮放、平移）和 `opacity`，它們在 GPU 上運行而不會觸發佈局。

**錯誤：動畫化高度，每一幀都觸發佈局**

```tsx
import Animated, { useAnimatedStyle, withTiming } from 'react-native-reanimated'

function CollapsiblePanel({ expanded }: { expanded: boolean }) {
  const animatedStyle = useAnimatedStyle(() => ({
    height: withTiming(expanded ? 200 : 0), // 每一幀都觸發佈局
    overflow: 'hidden',
  }))

  return <Animated.View style={animatedStyle}>{children}</Animated.View>
}
```

**正確：動畫化 scaleY，GPU 加速**

```tsx
import Animated, { useAnimatedStyle, withTiming } from 'react-native-reanimated'

function CollapsiblePanel({ expanded }: { expanded: boolean }) {
  const animatedStyle = useAnimatedStyle(() => ({
    transform: [
      { scaleY: withTiming(expanded ? 1 : 0) },
    ],
    opacity: withTiming(expanded ? 1 : 0),
  }))

  return (
    <Animated.View style={[{ height: 200, transformOrigin: 'top' }, animatedStyle]}>
      {children}
    </Animated.View>
  )
}
```

**正確：在滑動動畫中使用 translateY**

```tsx
import Animated, { useAnimatedStyle, withTiming } from 'react-native-reanimated'

function SlideIn({ visible }: { visible: boolean }) {
  const animatedStyle = useAnimatedStyle(() => ({
    transform: [
      { translateY: withTiming(visible ? 0 : 100) },
    ],
    opacity: withTiming(visible ? 1 : 0),
  }))

  return <Animated.View style={animatedStyle}>{children}</Animated.View>
}
```

GPU 加速屬性：`transform`（平移、縮放、旋轉）、`opacity`。除此之外的其他屬性都會觸發佈局。

### 3.2 優先使用 useDerivedValue 而不是 useAnimatedReaction

**影響：中 (更簡潔的代碼，自動追蹤依賴)**

當根據一個共享值推導另一個共享值時，請使用 `useDerivedValue` 而不是 `useAnimatedReaction`。推導值是聲明式的，會自動追蹤依賴項，並返回一個您可以直接使用的值。動畫反應 (Animated Reactions) 是用於副作用，而不是用於推導。

[Reanimated useDerivedValue](https://docs.swmansion.com/react-native-reanimated/docs/core/useDerivedValue)

**錯誤：將 useAnimatedReaction 用於推導**

```tsx
import { useSharedValue, useAnimatedReaction } from 'react-native-reanimated'

function MyComponent() {
  const progress = useSharedValue(0)
  const opacity = useSharedValue(1)

  useAnimatedReaction(
    () => progress.value,
    (current) => {
      opacity.value = 1 - current
    }
  )

  // ...
}
```

**正確：useDerivedValue**

```tsx
import { useSharedValue, useDerivedValue } from 'react-native-reanimated'

function MyComponent() {
  const progress = useSharedValue(0)

  const opacity = useDerivedValue(() => 1 - progress.get())

  // ...
}
```

僅將 `useAnimatedReaction` 用於不產生值的副作用（例如：觸發觸覺回饋、記錄日誌、調用 `runOnJS`）。

### 3.3 為動畫按壓狀態使用 GestureDetector

**影響：中 (UI 線程動畫，更流暢的按壓回饋)**

對於動畫按壓狀態（按壓時的縮放、透明度變化），請使用 `GestureDetector` 搭配 `Gesture.Tap()` 和共享值，而不是 Pressable 的 `onPressIn`/`onPressOut`。手勢回調函數作為 Worklets 在 UI 線程上運行——按壓動畫無需與 JS 線程進行來回通信。

[Gesture Handler Tap Gesture](https://docs.swmansion.com/react-native-gesture-handler/docs/gestures/tap-gesture)

**錯誤：使用 JS 線程回調函數的 Pressable**

```tsx
import { Pressable } from 'react-native'
import Animated, {
  useSharedValue,
  useAnimatedStyle,
  withTiming,
} from 'react-native-reanimated'

function AnimatedButton({ onPress }: { onPress: () => void }) {
  const scale = useSharedValue(1)

  const animatedStyle = useAnimatedStyle(() => ({
    transform: [{ scale: scale.value }],
  }))

  return (
    <Pressable
      onPress={onPress}
      onPressIn={() => (scale.value = withTiming(0.95))}
      onPressOut={() => (scale.value = withTiming(1))}
    >
      <Animated.View style={animatedStyle}>
        <Text>Press me</Text>
      </Animated.View>
    </Pressable>
  )
}
```

**正確：GestureDetector 搭配 UI 線程 Worklets**

```tsx
import { Gesture, GestureDetector } from 'react-native-gesture-handler'
import Animated, {
  useSharedValue,
  useAnimatedStyle,
  withTiming,
  interpolate,
  runOnJS,
} from 'react-native-reanimated'

function AnimatedButton({ onPress }: { onPress: () => void }) {
  // 存儲按壓狀態 (0 = 未按壓, 1 = 已按壓)
  const pressed = useSharedValue(0)

  const tap = Gesture.Tap()
    .onBegin(() => {
      pressed.set(withTiming(1))
    })
    .onFinalize(() => {
      pressed.set(withTiming(0))
    })
    .onEnd(() => {
      runOnJS(onPress)()
    })

  // 根據狀態派生視覺數值
  const animatedStyle = useAnimatedStyle(() => ({
    transform: [
      { scale: interpolate(withTiming(pressed.get()), [0, 1], [1, 0.95]) },
    ],
  }))

  return (
    <GestureDetector gesture={tap}>
      <Animated.View style={animatedStyle}>
        <Text>Press me</Text>
      </Animated.View>
    </GestureDetector>
  )
}
```

存儲按壓**狀態** (0 或 1)，然後通過 `interpolate` 派生縮放比例。這使得共享值保持為事實真相戶。使用 `runOnJS` 從 Worklets 調用 JS 函數。使用 `.set()` 和 `.get()` 以實現 React 編譯器兼容性。

---

## 4. 滾動性能 (Scroll Performance)

**影響：高 (HIGH)**

追蹤滾動位置而不引起渲染抖動。

### 4.1 切勿在 useState 中追蹤滾動位置

**影響：高 (預防滾動期間發生渲染抖動)**

切勿將滾動位置存儲在 `useState` 中。滾動事件觸發頻率極高——狀態更新會導致渲染抖動和掉幀。對於動畫，請使用 Reanimated 共享值；對於非響應式追蹤，請使用 ref。

**錯誤：useState 導致卡頓**

```tsx
import { useState } from 'react'
import {
  ScrollView,
  NativeSyntheticEvent,
  NativeScrollEvent,
} from 'react-native'

function Feed() {
  const [scrollY, setScrollY] = useState(0)

  const onScroll = (e: NativeSyntheticEvent<NativeScrollEvent>) => {
    setScrollY(e.nativeEvent.contentOffset.y) // 每一幀都會重新渲染
  }

  return <ScrollView onScroll={onScroll} scrollEventThrottle={16} />
}
```

**正確：使用 Reanimated 處理動畫**

```tsx
import Animated, {
  useSharedValue,
  useAnimatedScrollHandler,
} from 'react-native-reanimated'

function Feed() {
  const scrollY = useSharedValue(0)

  const onScroll = useAnimatedScrollHandler({
    onScroll: (e) => {
      scrollY.value = e.contentOffset.y // 在 UI 線程上運行，不重新渲染
    },
  })

  return (
    <Animated.ScrollView
      onScroll={onScroll}
      // 數字越高，性能越好，但觸發頻率越低。
      // 如果您需要更高精度而非性能，請取消設置此項。
      scrollEventThrottle={16}
    />
  )
}
```

**正確：使用 ref 進行非響應式追蹤**

```tsx
import { useRef } from 'react'
import {
  ScrollView,
  NativeSyntheticEvent,
  NativeScrollEvent,
} from 'react-native'

function Feed() {
  const scrollY = useRef(0)

  const onScroll = (e: NativeSyntheticEvent<NativeScrollEvent>) => {
    scrollY.current = e.nativeEvent.contentOffset.y // 不重新渲染
  }

  return <ScrollView onScroll={onScroll} scrollEventThrottle={16} />
}
```

---

## 5. 導航 (Navigation)

**影響：高 (HIGH)**

為棧導航 (Stack) 和標籤導航 (Tab) 使用原生導航器，而不是基於 JS 的替代方案。

### 5.1 為導航使用原生導航器

**影響：高 (原生性能、平台適宜的 UI)**

始終使用原生導航器而不是基於 JS 的導航器。原生導航器使用平台 API（iOS 上的 UINavigationController，Android 上的 Fragment）以獲得更好的性能和原生行為。

**對於 Stack 導航**：使用 `@react-navigation/native-stack` 或 expo-router 的默認 stack（其底層使用 native-stack）。避免使用 `@react-navigation/stack`。

**對於 Tab 導航**：使用 `react-native-bottom-tabs`（原生）或 expo-router 的原生標籤。當原生感官至關重要時，避免使用 `@react-navigation/bottom-tabs`。

- [React Navigation Native Stack](https://reactnavigation.org/docs/native-stack-navigator)

- [React Native Bottom Tabs with React Navigation](https://oss.callstack.com/react-native-bottom-tabs/docs/guides/usage-with-react-navigation)

- [React Native Bottom Tabs with Expo Router](https://oss.callstack.com/react-native-bottom-tabs/docs/guides/usage-with-expo-router)

- [Expo Router Native Tabs](https://docs.expo.dev/router/advanced/native-tabs)

**錯誤：JS Stack 導航器**

```tsx
import { createStackNavigator } from '@react-navigation/stack'

const Stack = createStackNavigator()

function App() {
  return (
    <Stack.Navigator>
      <Stack.Screen name='Home' component={HomeScreen} />
      <Stack.Screen name='Details' component={DetailsScreen} />
    </Stack.Navigator>
  )
}
```

**正確：使用 react-navigation 的原生 Stack**

```tsx
import { createNativeStackNavigator } from '@react-navigation/native-stack'

const Stack = createNativeStackNavigator()

function App() {
  return (
    <Stack.Navigator>
      <Stack.Screen name='Home' component={HomeScreen} />
      <Stack.Screen name='Details' component={DetailsScreen} />
    </Stack.Navigator>
  )
}
```

**正確：expo-router 默認使用原生 Stack**

```tsx
// app/_layout.tsx
import { Stack } from 'expo-router'

export default function Layout() {
  return <Stack />
}
```

**錯誤：JS Bottom Tabs**

```tsx
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs'

const Tab = createBottomTabNavigator()

function App() {
  return (
    <Tab.Navigator>
      <Tab.Screen name='Home' component={HomeScreen} />
      <Tab.Screen name='Settings' component={SettingsScreen} />
    </Tab.Navigator>
  )
}
```

**正確：使用 react-navigation 的原生 Bottom Tabs**

```tsx
import { createNativeBottomTabNavigator } from '@bottom-tabs/react-navigation'

const Tab = createNativeBottomTabNavigator()

function App() {
  return (
    <Tab.Navigator>
      <Tab.Screen
        name='Home'
        component={HomeScreen}
        options={{
          tabBarIcon: () => ({ sfSymbol: 'house' }),
        }}
      />
      <Tab.Screen
        name='Settings'
        component={SettingsScreen}
        options={{
          tabBarIcon: () => ({ sfSymbol: 'gear' }),
        }}
      />
    </Tab.Navigator>
  )
}
```

**正確：expo-router 原生標籤**

```tsx
// app/(tabs)/_layout.tsx
import { NativeTabs } from 'expo-router/unstable-native-tabs'

export default function TabLayout() {
  return (
    <NativeTabs>
      <NativeTabs.Trigger name='index'>
        <NativeTabs.Trigger.Label>Home</NativeTabs.Trigger.Label>
        <NativeTabs.Trigger.Icon sf='house.fill' md='home' />
      </NativeTabs.Trigger>
      <NativeTabs.Trigger name='settings'>
        <NativeTabs.Trigger.Label>Settings</NativeTabs.Trigger.Label>
        <NativeTabs.Trigger.Icon sf='gear' md='settings' />
      </NativeTabs.Trigger>
    </NativeTabs>
  )
}
```

在 iOS 上，原生標籤會自動在每個標籤屏幕根部的第一個 `ScrollView` 上啟用 `contentInsetAdjustmentBehavior`，因此內容可以正確地在半透明標籤欄後方滾動。如果您需要禁用此功能，請在觸發器上使用 `disableAutomaticContentInsets`。

**錯誤：自定義標頭組件 (Header Component)**

```tsx
<Stack.Screen
  name='Profile'
  component={ProfileScreen}
  options={{
    header: () => <CustomHeader title='Profile' />,
  }}
/>
```

**正確：原生標頭選項**

```tsx
<Stack.Screen
  name='Profile'
  component={ProfileScreen}
  options={{
    title: 'Profile',
    headerLargeTitleEnabled: true,
    headerSearchBarOptions: {
      placeholder: 'Search',
    },
  }}
/>
```

原生標頭自動支持 iOS 大標題、搜索欄、模糊效果以及正確的安全區域處理。

- **性能**：原生過渡和手勢在 UI 線程上運行

- **平台行為**：自動支持 iOS 大標題、Android Material Design

- **系統集成**：點擊標籤時自動滾動到頂部、避開畫中畫 (PiP)、正確的安全區域

- **無障礙功能**：平台無障礙功能自動生效

---

## 6. React 狀態 (React State)

**影響：中 (MEDIUM)**

管理 React 狀態的模式，以避免過時的閉包和不必要的重新渲染。

### 6.1 最小化狀態變量並推導值

**影響：中 (更少的重新渲染，更少的狀態偏移)**

使用儘可能少的狀態變量。如果一個數值可以從現有的狀態或 Props 中計算得出，請在渲染期間對其進行推導，而不是將其存儲在狀態中。冗餘狀態會導致不必要的重新渲染，並且可能會發生不同步的偏移。

**錯誤：冗餘狀態**

```tsx
function Cart({ items }: { items: Item[] }) {
  const [total, setTotal] = useState(0)
  const [itemCount, setItemCount] = useState(0)

  useEffect(() => {
    setTotal(items.reduce((sum, item) => sum + item.price, 0))
    setItemCount(items.length)
  }, [items])

  return (
    <View>
      <Text>{itemCount} items</Text>
      <Text>Total: ${total}</Text>
    </View>
  )
}
```

**正確：派生值 (Derived Values)**

```tsx
function Cart({ items }: { items: Item[] }) {
  const total = items.reduce((sum, item) => sum + item.price, 0)
  const itemCount = items.length

  return (
    <View>
      <Text>{itemCount} items</Text>
      <Text>Total: ${total}</Text>
    </View>
  )
}
```

**另一個例子：**

```tsx
// 錯誤：同時存儲 firstName、lastName 和 fullName
const [firstName, setFirstName] = useState('')
const [lastName, setLastName] = useState('')
const [fullName, setFullName] = useState('')

// 正確：推導 fullName
const [firstName, setFirstName] = useState('')
const [lastName, setLastName] = useState('')
const fullName = `${firstName} ${lastName}`
```

狀態應該是最小的事實來源。其他一切都是派生的。

參考資料：[https://react.dev/learn/choosing-the-state-structure](https://react.dev/learn/choosing-the-state-structure)

### 6.2 使用回退狀態 (Fallback State) 而不是 initialState

**影響：中 (無需同步的響應式回退)**

使用 `undefined` 作為初始狀態，並使用空值合併運算符 (`??`) 來回退到父級或服務器數值。狀態僅代表用戶意圖——`undefined` 表示「用戶尚未選擇」。這啟用了響應式回退，當源數據更改時，組件會隨之更新，而不僅僅是在初始渲染時。

**錯誤：同步狀態，失去響應性**

```tsx
type Props = { fallbackEnabled: boolean }

function Toggle({ fallbackEnabled }: Props) {
  const [enabled, setEnabled] = useState(defaultEnabled)
  // If fallbackEnabled changes, state is stale
  // State mixes user intent with default value

  return <Switch value={enabled} onValueChange={setEnabled} />
}
```

**正確：狀態代表用戶意圖，響應式回退**

```tsx
type Props = { fallbackEnabled: boolean }

function Toggle({ fallbackEnabled }: Props) {
  const [_enabled, setEnabled] = useState<boolean | undefined>(undefined)
  const enabled = _enabled ?? defaultEnabled
  // undefined = 用戶尚未觸摸，回退到 Prop
  // 如果 defaultEnabled 更改，組件會反映出來
  // 用戶一旦交互，他們的選擇就會持久化

  return <Switch value={enabled} onValueChange={setEnabled} />
}
```

**配合服務器數據：**

```tsx
function ProfileForm({ data }: { data: User }) {
  const [_theme, setTheme] = useState<string | undefined>(undefined)
  const theme = _theme ?? data.theme
  // 在用戶覆蓋之前顯示服務器數值
  // 服務器重新獲取數據會自動更新回退值

  return <ThemePicker value={theme} onChange={setTheme} />
}
```

### 6.3 對於依賴當前值的狀態使用 useState Dispatch Updaters

**影響：中 (避免過時閉包，預防不必要的重新渲染)**

當下一個狀態取決於當前狀態時，請使用調度更新器 (`setState(prev => ...)`)，而不是在回調函數中直接讀取狀態變量。這可以避免過時的閉包，並確保您是與最新數值進行比較。

**錯誤：直接讀取狀態**

```tsx
const [size, setSize] = useState<Size | undefined>(undefined)

const onLayout = (e: LayoutChangeEvent) => {
  const { width, height } = e.nativeEvent.layout
  // size 在此閉包中可能已過時
  if (size?.width !== width || size?.height !== height) {
    setSize({ width, height })
  }
}
```

**正確：調度更新器**

```tsx
const [size, setSize] = useState<Size | undefined>(undefined)

const onLayout = (e: LayoutChangeEvent) => {
  const { width, height } = e.nativeEvent.layout
  setSize((prev) => {
    if (prev?.width === width && prev?.height === height) return prev
    return { width, height }
  })
}
```

從更新器返回上一個值會跳過重新渲染。

對於原始類型狀態，您無需在觸發重新渲染之前比較數值。

**錯誤：為原始類型狀態進行不必要的比較**

```tsx
const [size, setSize] = useState<Size | undefined>(undefined)

const onLayout = (e: LayoutChangeEvent) => {
  const { width, height } = e.nativeEvent.layout
  setSize((prev) => (prev === width ? prev : width))
}
```

**正確：直接設置原始類型狀態**

```tsx
const [size, setSize] = useState<Size | undefined>(undefined)

const onLayout = (e: LayoutChangeEvent) => {
  const { width, height } = e.nativeEvent.layout
  setSize(width)
}
```

然而，如果下一個狀態取決於當前狀態，您仍然應該使用調度更新器。

**錯誤：直接從回調函數中讀取狀態**

```tsx
const [count, setCount] = useState(0)

const onTap = () => {
  setCount(count + 1)
}
```

**正確：調度更新器**

```tsx
const [count, setCount] = useState(0)

const onTap = () => {
  setCount((prev) => prev + 1)
}
```

---

## 7. 狀態架構 (State Architecture)

**影響：中 (MEDIUM)**

狀態變量和派生值的真相來源 (Ground Truth) 原則。

### 7.1 狀態必須代表事實真相 (Ground Truth)

**影響：高 (更清晰的邏輯、更容易調試、單一事實來源)**

狀態變量——無論是 React 的 `useState` 還是 Reanimated 的共享值——都應該代表事物的實際狀態（例如：`pressed`、`progress`、`isOpen`），而不是派生出來的視覺數值（例如：`scale`、`opacity`、`translateY`）。請通過計算或插值從狀態中派生出視覺數值。

**錯誤：存儲視覺輸出**

```tsx
const scale = useSharedValue(1)

const tap = Gesture.Tap()
  .onBegin(() => {
    scale.set(withTiming(0.95))
  })
  .onFinalize(() => {
    scale.set(withTiming(1))
  })

const animatedStyle = useAnimatedStyle(() => ({
  transform: [{ scale: scale.get() }],
}))
```

**正確：存儲狀態，派生視覺**

```tsx
const pressed = useSharedValue(0) // 0 = 未按壓, 1 = 已按壓

const tap = Gesture.Tap()
  .onBegin(() => {
    pressed.set(withTiming(1))
  })
  .onFinalize(() => {
    pressed.set(withTiming(0))
  })

const animatedStyle = useAnimatedStyle(() => ({
  transform: [{ scale: interpolate(pressed.get(), [0, 1], [1, 0.95]) }],
}))
```

**為什麼這很重要：**

狀態變量應該代表真實的「狀態」，而不一定是預期的最終結果。

1. **單一事實來源** —— 狀態 (`pressed`) 描述了正在發生什麼；視覺效果是派生出來的。

2. **更容易擴展** —— 添加透明度、旋轉或其他效果僅需要基於同一狀態進行更多插值。

3. **調試** —— 檢查 `pressed = 1` 比檢查 `scale = 0.95` 更清晰。

4. **可重用邏輯** —— 同一個 `pressed` 數值可以驅動多個視覺屬性。

**React 狀態也遵循同樣的原則：**

```tsx
// 錯誤：存儲派生值
const [isExpanded, setIsExpanded] = useState(false)
const [height, setHeight] = useState(0)

useEffect(() => {
  setHeight(isExpanded ? 200 : 0)
}, [isExpanded])

// 正確：從狀態推導
const [isExpanded, setIsExpanded] = useState(false)
const height = isExpanded ? 200 : 0
```

狀態是最小的事實來源。其他一切都是派生的。

---

## 8. React 編譯器 (React Compiler)

**影響：中 (MEDIUM)**

React 編譯器與 React Native 及 Reanimated 的兼容模式。

### 8.1 在渲染作用域早期解構函數 (React 編譯器)

**影響：高 (穩定的引用，更少的重新渲染)**

此規則僅適用於您正在使用 React 編譯器的情況。

在渲染作用域的頂部從 Hook 中解構出函數。切勿通過點運算符 (`.`) 訪問對象來調用函數。解構出的函數是穩定的引用；使用點運算符會創建新的引用並破壞 Memoization。

**錯誤：通過點運算符訪問對象**

```tsx
import { useRouter } from 'expo-router'

function SaveButton(props) {
  const router = useRouter()

  // 錯誤：React 編譯器將緩存鍵設置在 "props" 和 "router" 上，而這些對象在每次渲染時都會更改
  const handlePress = () => {
    props.onSave()
    router.push('/success') // 不穩定的引用
  }

  return <Button onPress={handlePress}>Save</Button>
}
```

**正確：早期解構**

```tsx
import { useRouter } from 'expo-router'

function SaveButton({ onSave }) {
  const { push } = useRouter()

  // 正確：React 編譯器將緩存鍵設置在 push 和 onSave 上
  const handlePress = () => {
    onSave()
    push('/success') // 穩定的引用
  }

  return <Button onPress={handlePress}>Save</Button>
}
```

### 8.2 為 Reanimated 共享值使用 .get() 和 .set()（而不是 .value）

**影響：低 (React 編譯器兼容性所需)**

啟用了 React 編譯器後，請使用 `.get()` 和 `.set()`，而不是直接讀取或寫入 Reanimated 共享值的 `.value`。編譯器無法追蹤屬性訪問——顯式的方法確保了正確的行為。

**錯誤：在 React 編譯器下會失效**

```tsx
import { useSharedValue } from 'react-native-reanimated'

function Counter() {
  const count = useSharedValue(0)

  const increment = () => {
    count.value = count.value + 1 // 避開了 React 編譯器
  }

  return <Button onPress={increment} title={`Count: ${count.value}`} />
}
```

**正確：兼容 React 編譯器**

```tsx
import { useSharedValue } from 'react-native-reanimated'

function Counter() {
  const count = useSharedValue(0)

  const increment = () => {
    count.set(count.get() + 1)
  }

  return <Button onPress={increment} title={`Count: ${count.get()}`} />
}
```

更多信息請參閱 [Reanimated 文檔](https://docs.swmansion.com/react-native-reanimated/docs/core/useSharedValue/#react-compiler-support)。

---

## 9. 用戶介面 (User Interface)

**影響：中 (MEDIUM)**

用於圖像、菜單、Modal、樣式以及平台一致性接口的原生 UI 模式。

### 9.1 測量視圖尺寸

**影響：中 (同步測量，避免不必要的重新渲染)**

同時使用 `useLayoutEffect`（同步）和 `onLayout`（用於更新）。同步測量讓您能立即獲得初始尺寸；`onLayout` 則在視圖更改時保持尺寸最新。對於非原始類型狀態，請使用調度更新器來比較數值，避免不必要的重新渲染。

**僅高度：**

```tsx
import { useLayoutEffect, useRef, useState } from 'react'
import { View, LayoutChangeEvent } from 'react-native'

function MeasuredBox({ children }: { children: React.ReactNode }) {
  const ref = useRef<View>(null)
  const [height, setHeight] = useState<number | undefined>(undefined)

  useLayoutEffect(() => {
    // 掛載時的同步測量 (RN 0.82+)
    const rect = ref.current?.getBoundingClientRect()
    if (rect) setHeight(rect.height)
    // 0.82 之前版本：ref.current?.measure((x, y, w, h) => setHeight(h))
  }, [])

  const onLayout = (e: LayoutChangeEvent) => {
    setHeight(e.nativeEvent.layout.height)
  }

  return (
    <View ref={ref} onLayout={onLayout}>
      {children}
    </View>
  )
}
```

**兩個維度：**

```tsx
import { useLayoutEffect, useRef, useState } from 'react'
import { View, LayoutChangeEvent } from 'react-native'

type Size = { width: number; height: number }

function MeasuredBox({ children }: { children: React.ReactNode }) {
  const ref = useRef<View>(null)
  const [size, setSize] = useState<Size | undefined>(undefined)

  useLayoutEffect(() => {
    const rect = ref.current?.getBoundingClientRect()
    if (rect) setSize({ width: rect.width, height: rect.height })
  }, [])

  const onLayout = (e: LayoutChangeEvent) => {
    const { width, height } = e.nativeEvent.layout
    setSize((prev) => {
      // 對於非原始類型狀態，在觸發重新渲染之前比較數值
      if (prev?.width === width && prev?.height === height) return prev
      return { width, height }
    })
  }

  return (
    <View ref={ref} onLayout={onLayout}>
      {children}
    </View>
  )
}
```

使用函數式 setState 進行比較——不要在回調函數中直接讀取狀態。

### 9.2 現代 React Native 樣式模式

**影響：中 (一致的設計、更流暢的邊框、更簡潔的佈局)**

遵循這些樣式模式，以編寫更簡潔、更一致的 React Native 代碼。

**始終將 `borderCurve: 'continuous'` 與 `borderRadius` 搭配使用：**

**使用 `gap` 代替外邊距 (Margin) 來處理元素間的間距：**

```tsx
// 錯誤 – 在子元素上使用 margin
<View>
  <Text style={{ marginBottom: 8 }}>Title</Text>
  <Text style={{ marginBottom: 8 }}>Subtitle</Text>
</View>

// 正確 – 在父元素上使用 gap
<View style={{ gap: 8 }}>
  <Text>Title</Text>
  <Text>Subtitle</Text>
</View>
```

**使用 `padding` 處理內部空間，`gap` 處理元素間空間：**

```tsx
<View style={{ padding: 16, gap: 12 }}>
  <Text>First</Text>
  <Text>Second</Text>
</View>
```

**使用 `experimental_backgroundImage` 處理線性漸變：**

```tsx
// 錯誤 – 第三方漸變庫
<LinearGradient colors={['#000', '#fff']} />

// 正確 – 原生 CSS 漸變語法
<View
  style={{
    experimental_backgroundImage: 'linear-gradient(to bottom, #000, #fff)',
  }}
/>
```

**使用 CSS `boxShadow` 字串語法處理陰影：**

```tsx
// 錯誤 – 舊有的陰影對象或 elevation
{ shadowColor: '#000', shadowOffset: { width: 0, height: 2 }, shadowOpacity: 0.1 }
{ elevation: 4 }

// 正確 – CSS box-shadow 語法
{ boxShadow: '0 2px 8px rgba(0, 0, 0, 0.1)' }
```

**避免使用多種字體大小 – 使用字重和顏色來強調層次：**

```tsx
// 錯誤 – 使用不同的字體大小來體現層次
<Text style={{ fontSize: 18 }}>Title</Text>
<Text style={{ fontSize: 14 }}>Subtitle</Text>
<Text style={{ fontSize: 12 }}>Caption</Text>

// 正確 – 保持字體大小一致，通過改變字重和顏色來體現層次
<Text style={{ fontWeight: '600' }}>Title</Text>
<Text style={{ color: '#666' }}>Subtitle</Text>
<Text style={{ color: '#999' }}>Caption</Text>
```

限制字體大小可以營造視覺一致性。取而代之，使用 `fontWeight`（粗體/半粗體）和灰色調來體現層次。

### 9.3 為動態 ScrollView 間距使用 contentInset

**影響：低 (更流暢的更新，無需重新計算佈局)**

當向可能會發生變化的 ScrollView（鍵盤、工具欄、動態內容）頂部或底部添加空間時，請使用 `contentInset` 而不是 Padding. 更改 `contentInset` 不會觸發佈局重新計算——它會調整滾動區域而不重新渲染內容。

**錯誤：Padding 導致佈局重新計算**

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

**正確：使用 contentInset 處理動態間距**

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
// 更改 bottomOffset 僅調整滾動邊界
```

同時使用 `scrollIndicatorInsets` 與 `contentInset` 以保持滾動指示器對齊。對於永遠不會更改的靜態間距，使用 Padding 是可以的。

### 9.4 為安全區域使用 contentInsetAdjustmentBehavior

**影響：中 (原生安全區域處理，無佈局偏移)**

在根部 ScrollView 上使用 `contentInsetAdjustmentBehavior="automatic"`，而不是用 SafeAreaView 包裹內容或手動設置 Padding。這讓 iOS 能原生處理安全區域內邊距，並提供正確的滾動行為。

**錯誤：SafeAreaView 包裹器**

```tsx
import { SafeAreaView, ScrollView, View, Text } from 'react-native'

function MyScreen() {
  return (
    <SafeAreaView style={{ flex: 1 }}>
      <ScrollView>
        <View>
          <Text>Content</Text>
        </View>
      </ScrollView>
    </SafeAreaView>
  )
}
```

**錯誤：手動安全區域內邊距**

```tsx
import { ScrollView, View, Text } from 'react-native'
import { useSafeAreaInsets } from 'react-native-safe-area-context'

function MyScreen() {
  const insets = useSafeAreaInsets()

  return (
    <ScrollView contentContainerStyle={{ paddingTop: insets.top }}>
      <View>
        <Text>Content</Text>
      </View>
    </ScrollView>
  )
}
```

**正確：原生內容內置調整行為**

```tsx
import { ScrollView, View, Text } from 'react-native'

function MyScreen() {
  return (
    <ScrollView contentInsetAdjustmentBehavior='automatic'>
      <View>
        <Text>Content</Text>
      </View>
    </ScrollView>
  )
}
```

原生方法處理動態安全區域（鍵盤、工具欄）並允許內容自然地滾動到狀態欄後方。

### 9.5 使用 expo-image 進行優化後的圖像處理

**影響：高 (記憶體效率、緩存、blurhash 佔位符、漸進式加載)**

使用 `expo-image` 代替 React Native 的 `Image`。它提供記憶體效率高的緩存、blurhash 佔位符、漸進式加載以及更好的列表性能。

**錯誤：React Native Image**

```tsx
import { Image } from 'react-native'

function Avatar({ url }: { url: string }) {
  return <Image source={{ uri: url }} style={styles.avatar} />
}
```

**正確：expo-image**

```tsx
import { Image } from 'expo-image'

function Avatar({ url }: { url: string }) {
  return <Image source={{ uri: url }} style={styles.avatar} />
}
```

**使用 blurhash 佔位符：**

```tsx
<Image
  source={{ uri: url }}
  placeholder={{ blurhash: 'LGF5]+Yk^6#M@-5c,1J5@[or[Q6.' }}
  contentFit="cover"
  transition={200}
  style={styles.image}
/>
```

**使用優先級和緩存：**

```tsx
<Image
  source={{ uri: url }}
  priority="high"
  cachePolicy="memory-disk"
  style={styles.hero}
/>
```

**關鍵 Props：**

- `placeholder` — 加載時的 Blurhash 或縮圖

- `contentFit` — `cover`, `contain`, `fill`, `scale-down`

- `transition` — 淡入持續時間 (ms)

- `priority` — `low`, `normal`, `high`

- `cachePolicy` — `memory`, `disk`, `memory-disk`, `none`

- `recyclingKey` — 列表回收的唯一鍵

對於跨平台（Web + 原生），使用 `SolitoImage` (來自 `solito/image`)，它在底層使用了 `expo-image`。

參考資料：[https://docs.expo.dev/versions/latest/sdk/image/](https://docs.expo.dev/versions/latest/sdk/image/)

### 9.6 使用 Galeria 進行圖像畫廊和燈箱效果

**影響：中**

對於帶有燈箱效果（點擊全螢幕）的圖像畫廊，請使用 `@nandorojo/galeria`。

它提供具有捏合縮放、雙擊縮放和滑動關閉功能的原生共享元素過渡。適用於任何圖像組件，包括 `expo-image`。

**錯誤：自定義 Modal 實現**

```tsx
function ImageGallery({ urls }: { urls: string[] }) {
  const [selected, setSelected] = useState<string | null>(null)

  return (
    <>
      {urls.map((url) => (
        <Pressable key={url} onPress={() => setSelected(url)}>
          <Image source={{ uri: url }} style={styles.thumbnail} />
        </Pressable>
      ))}
      <Modal visible={!!selected} onRequestClose={() => setSelected(null)}>
        <Image source={{ uri: selected! }} style={styles.fullscreen} />
      </Modal>
    </>
  )
}
```

**正確：Galeria 搭配 expo-image**

```tsx
import { Galeria } from '@nandorojo/galeria'
import { Image } from 'expo-image'

function ImageGallery({ urls }: { urls: string[] }) {
  return (
    <Galeria urls={urls}>
      {urls.map((url, index) => (
        <Galeria.Image index={index} key={url}>
          <Image source={{ uri: url }} style={styles.thumbnail} />
        </Galeria.Image>
      ))}
    </Galeria>
  )
}
```

**單個圖像：**

```tsx
import { Galeria } from '@nandorojo/galeria'
import { Image } from 'expo-image'

function Avatar({ url }: { url: string }) {
  return (
    <Galeria urls={[url]}>
      <Galeria.Image>
        <Image source={{ uri: url }} style={styles.avatar} />
      </Galeria.Image>
    </Galeria>
  )
}
```

**使用低解析度縮圖和高解析度全螢幕圖像：**

```tsx
<Galeria urls={highResUrls}>
  {lowResUrls.map((url, index) => (
    <Galeria.Image index={index} key={url}>
      <Image source={{ uri: url }} style={styles.thumbnail} />
    </Galeria.Image>
  ))}
</Galeria>
```

**搭配 FlashList：**

```tsx
<Galeria urls={urls}>
  <FlashList
    data={urls}
    renderItem={({ item, index }) => (
      <Galeria.Image index={index}>
        <Image source={{ uri: item }} style={styles.thumbnail} />
      </Galeria.Image>
    )}
    numColumns={3}
    estimatedItemSize={100}
  />
</Galeria>
```

適用於 `expo-image`、`SolitoImage`、`react-native` Image 或任何圖像組件。

參考資料：[https://github.com/nandorojo/galeria](https://github.com/nandorojo/galeria)

### 9.7 使用原生菜單進行下拉菜單和上下文菜單

**影響：高 (原生無障礙功能、平台一致的 UX)**

使用原生平台菜單，而不是自定義 JS 實現。原生菜單提供內建的無障礙功能、一致的平台體驗和更好的性能。

使用 [zeego](https://zeego.dev) 實現跨平台原生菜單。

**錯誤：自定義 JS 菜單**

```tsx
import { useState } from 'react'
import { View, Pressable, Text } from 'react-native'

function MyMenu() {
  const [open, setOpen] = useState(false)

  return (
    <View>
      <Pressable onPress={() => setOpen(!open)}>
        <Text>Open Menu</Text>
      </Pressable>
      {open && (
        <View style={{ position: 'absolute', top: 40 }}>
          <Pressable onPress={() => console.log('edit')}>
            <Text>Edit</Text>
          </Pressable>
          <Pressable onPress={() => console.log('delete')}>
            <Text>Delete</Text>
          </Pressable>
        </View>
      )}
    </View>
  )
}
```

**正確：使用 zeego 的原生菜單**

```tsx
import * as DropdownMenu from 'zeego/dropdown-menu'

function MyMenu() {
  return (
    <DropdownMenu.Root>
      <DropdownMenu.Trigger>
        <Pressable>
          <Text>Open Menu</Text>
        </Pressable>
      </DropdownMenu.Trigger>

      <DropdownMenu.Content>
        <DropdownMenu.Item key='edit' onSelect={() => console.log('edit')}>
          <DropdownMenu.ItemTitle>Edit</DropdownMenu.ItemTitle>
        </DropdownMenu.Item>

        <DropdownMenu.Item
          key='delete'
          destructive
          onSelect={() => console.log('delete')}
        >
          <DropdownMenu.ItemTitle>Delete</DropdownMenu.ItemTitle>
        </DropdownMenu.Item>
      </DropdownMenu.Content>
    </DropdownMenu.Root>
  )
}
```

**上下文菜單：長按**

```tsx
import * as ContextMenu from 'zeego/context-menu'

function MyContextMenu() {
  return (
    <ContextMenu.Root>
      <ContextMenu.Trigger>
        <View style={{ padding: 20 }}>
          <Text>Long press me</Text>
        </View>
      </ContextMenu.Trigger>

      <ContextMenu.Content>
        <ContextMenu.Item key='copy' onSelect={() => console.log('copy')}>
          <ContextMenu.ItemTitle>Copy</ContextMenu.ItemTitle>
        </ContextMenu.Item>

        <ContextMenu.Item key='paste' onSelect={() => console.log('paste')}>
          <ContextMenu.ItemTitle>Paste</ContextMenu.ItemTitle>
        </ContextMenu.Item>
      </ContextMenu.Content>
    </ContextMenu.Root>
  )
}
```

**複選框項目：**

```tsx
import * as DropdownMenu from 'zeego/dropdown-menu'

function SettingsMenu() {
  const [notifications, setNotifications] = useState(true)

  return (
    <DropdownMenu.Root>
      <DropdownMenu.Trigger>
        <Pressable>
          <Text>Settings</Text>
        </Pressable>
      </DropdownMenu.Trigger>

      <DropdownMenu.Content>
        <DropdownMenu.CheckboxItem
          key='notifications'
          value={notifications}
          onValueChange={() => setNotifications((prev) => !prev)}
        >
          <DropdownMenu.ItemIndicator />
          <DropdownMenu.ItemTitle>Notifications</DropdownMenu.ItemTitle>
        </DropdownMenu.CheckboxItem>
      </DropdownMenu.Content>
    </DropdownMenu.Root>
  )
}
```

**子菜單：**

```tsx
import * as DropdownMenu from 'zeego/dropdown-menu'

function MenuWithSubmenu() {
  return (
    <DropdownMenu.Root>
      <DropdownMenu.Trigger>
        <Pressable>
          <Text>Options</Text>
        </Pressable>
      </DropdownMenu.Trigger>

      <DropdownMenu.Content>
        <DropdownMenu.Item key='home' onSelect={() => console.log('home')}>
          <DropdownMenu.ItemTitle>Home</DropdownMenu.ItemTitle>
        </DropdownMenu.Item>

        <DropdownMenu.Sub>
          <DropdownMenu.SubTrigger key='more'>
            <DropdownMenu.ItemTitle>More Options</DropdownMenu.ItemTitle>
          </DropdownMenu.SubTrigger>

          <DropdownMenu.SubContent>
            <DropdownMenu.Item key='settings'>
              <DropdownMenu.ItemTitle>Settings</DropdownMenu.ItemTitle>
            </DropdownMenu.Item>

            <DropdownMenu.Item key='help'>
              <DropdownMenu.ItemTitle>Help</DropdownMenu.ItemTitle>
            </DropdownMenu.Item>
          </DropdownMenu.SubContent>
        </DropdownMenu.Sub>
      </DropdownMenu.Content>
    </DropdownMenu.Root>
  )
}
```

參考資料：[https://zeego.dev/components/dropdown-menu](https://zeego.dev/components/dropdown-menu)

### 9.8 優先使用原生 Modal 而非基於 JS 的 Bottom Sheets

**影響：高 (原生性能、手勢、無障礙功能)**

優先使用具有 `presentationStyle="formSheet"` 的原生 `<Modal>` 或 React Navigation v7 的原生 form sheet，而不是基於 JS 的 bottom sheet 庫。原生 Modal 具有內建手勢、無障礙功能和更好的性能。對於低階基礎組件，請依賴原生 UI。

**錯誤：基於 JS 的 bottom sheet**

```tsx
import BottomSheet from 'custom-js-bottom-sheet'

function MyScreen() {
  const sheetRef = useRef<BottomSheet>(null)

  return (
    <View style={{ flex: 1 }}>
      <Button onPress={() => sheetRef.current?.expand()} title='Open' />
      <BottomSheet ref={sheetRef} snapPoints={['50%', '90%']}>
        <View>
          <Text>Sheet content</Text>
        </View>
      </BottomSheet>
    </View>
  )
}
```

**正確：使用 formSheet 的原生 Modal**

```tsx
import { Modal, View, Text, Button } from 'react-native'

function MyScreen() {
  const [visible, setVisible] = useState(false)

  return (
    <View style={{ flex: 1 }}>
      <Button onPress={() => setVisible(true)} title='Open' />
      <Modal
        visible={visible}
        presentationStyle='formSheet'
        animationType='slide'
        onRequestClose={() => setVisible(false)}
      >
        <View>
          <Text>Sheet content</Text>
        </View>
      </Modal>
    </View>
  )
}
```

**正確：React Navigation v7 原生 form sheet**

```tsx
// 在您的 navigator 中
<Stack.Screen
  name='Details'
  component={DetailsScreen}
  options={{
    presentation: 'formSheet',
    sheetAllowedDetents: 'fitToContents',
  }}
/>
```

原生 Modal 提供了開箱即用的滑動關閉、正確的鍵盤避讓和無障礙功能。

### 9.9 使用 Pressable 代替 Touchable 組件

**影響：低 (現代 API，更靈活)**

永遠不要使用 `TouchableOpacity` 或 `TouchableHighlight`。請使用 `react-native` 或 `react-native-gesture-handler` 中的 `Pressable` 代替。

**錯誤：舊版 Touchable 組件**

```tsx
import { TouchableOpacity } from 'react-native'

function MyButton({ onPress }: { onPress: () => void }) {
  return (
    <TouchableOpacity onPress={onPress} activeOpacity={0.7}>
      <Text>Press me</Text>
    </TouchableOpacity>
  )
}
```

**正確：Pressable**

```tsx
import { Pressable } from 'react-native'

function MyButton({ onPress }: { onPress: () => void }) {
  return (
    <Pressable onPress={onPress}>
      <Text>Press me</Text>
    </Pressable>
  )
}
```

**正確：來自 gesture handler 的 Pressable（用於列表）**

```tsx
import { Pressable } from 'react-native-gesture-handler'

function ListItem({ onPress }: { onPress: () => void }) {
  return (
    <Pressable onPress={onPress}>
      <Text>Item</Text>
    </Pressable>
  )
}
```

在可滾動列表中使用 `react-native-gesture-handler` 的 Pressable 以獲得更好的手勢協調性，前提是您也使用了來自 `react-native-gesture-handler` 的 ScrollView。

**對於動畫按壓狀態（縮放、透明度變化）：** 使用 `GestureDetector` 搭配 Reanimated 共享值，而不是 Pressable 的樣式回調。請參閱 `animation-gesture-detector-press` 規則。

---

## 10. 設計系統

**影響：中**

用於構建可維護組件庫的架構模式。

### 10.1 使用組合組件 (Compound Components) 優於多態子組件

**影響：中 (靈活的組合、更清晰的 API)**

不要創建可以接收字串但又不是文字節點的組件。如果一個組件可以接收字串子組件，它必須是一個專用的 `*Text` 組件。對於像按鈕這樣可以同時擁有 View（或 Pressable）和文字的組件，請使用組合組件，例如 `Button`、`ButtonText` 和 `ButtonIcon`。

**錯誤：多態子組件**

```tsx
import { Pressable, Text } from 'react-native'

type ButtonProps = {
  children: string | React.ReactNode
  icon?: React.ReactNode
}

function Button({ children, icon }: ButtonProps) {
  return (
    <Pressable>
      {icon}
      {typeof children === 'string' ? <Text>{children}</Text> : children}
    </Pressable>
  )
}

// 用法模糊
<Button icon={<Icon />}>Save</Button>
<Button><CustomText>Save</CustomText></Button>
```

**正確：組合組件**

```tsx
import { Pressable, Text } from 'react-native'

function Button({ children }: { children: React.ReactNode }) {
  return <Pressable>{children}</Pressable>
}

function ButtonText({ children }: { children: React.ReactNode }) {
  return <Text>{children}</Text>
}

function ButtonIcon({ children }: { children: React.ReactNode }) {
  return <>{children}</>
}

// 用法明確且可組合
<Button>
  <ButtonIcon><SaveIcon /></ButtonIcon>
  <ButtonText>Save</ButtonText>
</Button>

<Button>
  <ButtonText>Cancel</ButtonText>
</Button>
```

---

## 11. Monorepo

**影響：低**

Monorepo 中的依賴管理和原生模組配置。

### 11.1 在 App 目錄中安裝原生依賴

**影響：關鍵 (自動鏈接生效所必需)**

在 Monorepo 中，包含原生程式碼的套件必須直接安裝在原生應用程式的目錄中。自動鏈接 (Autolinking) 僅掃描應用程式的 `node_modules`——它不會找到安裝在其他套件中的原生依賴。

**錯誤：原生依賴僅在共享套件中**

```typescript
packages/
  ui/
    package.json  # 包含 react-native-reanimated
  app/
    package.json  # 缺少 react-native-reanimated
```

自動鏈接失敗——原生程式碼未連結。

**正確：App 目錄中包含原生依賴**

```json
// packages/app/package.json
{
  "dependencies": {
    "react-native-reanimated": "3.16.1"
  }
}
```

即使共享套件使用了該原生依賴，應用程式也必須列出它，以便自動鏈接檢測並連結原生程式碼。

### 11.2 在整個 Monorepo 中使用單一依賴版本

**影響：中 (避免重複打包、版本衝突)**

在 Monorepo 的所有套件中對每個依賴使用單一版本。優先使用精確版本而非範圍。多個版本會導致打包中出現重複程式碼、運行時衝突以及各套件間行為不一致。

使用像 syncpack 這樣的工具來強制執行此操作。作為最後手段，請使用 yarn resolutions 或 npm overrides。

**錯誤：版本範圍、多個版本**

```json
// packages/app/package.json
{
  "dependencies": {
    "react-native-reanimated": "^3.0.0"
  }
}

// packages/ui/package.json
{
  "dependencies": {
    "react-native-reanimated": "^3.5.0"
  }
}
```

**正確：精確版本、單一事實來源**

```json
// package.json (root)
{
  "pnpm": {
    "overrides": {
      "react-native-reanimated": "3.16.1"
    }
  }
}

// packages/app/package.json
{
  "dependencies": {
    "react-native-reanimated": "3.16.1"
  }
}

// packages/ui/package.json
{
  "dependencies": {
    "react-native-reanimated": "3.16.1"
  }
}
```

使用套件管理器的 override/resolution 功能在根目錄強制執行版本。添加依賴時，指定不帶 `^` 或 `~` 的精確版本。

---

## 12. 第三方依賴

**影響：低**

為了維護性而包裝和重新匯出第三方依賴。

### 12.1 從設計系統文件夾導入

**影響：低 (實現全域更改和輕鬆重構)**

從設計系統文件夾重新匯出依賴。應用程式程式碼從那裡導入，而不是直接從套件導入。這實現了全域更改和輕鬆重構。

**錯誤：直接從套件導入**

```tsx
import { View, Text } from 'react-native'
import { Button } from '@ui/button'

function Profile() {
  return (
    <View>
      <Text>Hello</Text>
      <Button>Save</Button>
    </View>
  )
}
```

**正確：從設計系統導入**

```tsx
import { View } from '@/components/view'
import { Text } from '@/components/text'
import { Button } from '@/components/button'

function Profile() {
  return (
    <View>
      <Text>Hello</Text>
      <Button>Save</Button>
    </View>
  )
}
```

從簡單的重新匯出開始。稍後進行自定義而無需更改應用程式程式碼。

---

## 13. JavaScript

**影響：低**

微優化，例如提升昂貴對象的創建。

### 13.1 提升 Intl Formatter 的創建

**影響：低-中 (避免重複創建昂貴對象)**

不要在渲染或循環內部創建 `Intl.DateTimeFormat`、`Intl.NumberFormat` 或 `Intl.RelativeTimeFormat`。這些實例化非常昂貴。當區域設定 (locale)/選項是靜態時，將其提升到模組作用域。

**錯誤：每次渲染都創建新的格式化器**

```tsx
function Price({ amount }: { amount: number }) {
  const formatter = new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
  })
  return <Text>{formatter.format(amount)}</Text>
}
```

**正確：提升到模組作用域**

```tsx
const currencyFormatter = new Intl.NumberFormat('en-US', {
  style: 'currency',
  currency: 'USD',
})

function Price({ amount }: { amount: number }) {
  return <Text>{currencyFormatter.format(amount)}</Text>
}
```

**對於動態區域設定，使用 memoize：**

```tsx
const dateFormatter = useMemo(
  () => new Intl.DateTimeFormat(locale, { dateStyle: 'medium' }),
  [locale]
)
```

**常見的提升格式化器：**

```tsx
// 模組級別的格式化器
const dateFormatter = new Intl.DateTimeFormat('en-US', { dateStyle: 'medium' })
const timeFormatter = new Intl.DateTimeFormat('en-US', { timeStyle: 'short' })
const percentFormatter = new Intl.NumberFormat('en-US', { style: 'percent' })
const relativeFormatter = new Intl.RelativeTimeFormat('en-US', {
  numeric: 'auto',
})
```

創建 `Intl` 對象比 `RegExp` 或普通對象昂貴得多——每次實例化都會解析區域資料並構建內部查找表。

---

## 14. 字體

**影響：低**

原生字體加載以提高性能。

### 14.1 在構建時原生加載字體

**影響：低 (字體在啟動時可用，無需異步加載)**

使用 `expo-font` 配置插件在構建時嵌入字體，而不是使用 `useFonts` 或 `Font.loadAsync`。嵌入的字體更有效率。

[Expo 字體文件](https://docs.expo.dev/versions/latest/sdk/font/)

**錯誤：異步字體加載**

```tsx
import { useFonts } from 'expo-font'
import { Text, View } from 'react-native'

function App() {
  const [fontsLoaded] = useFonts({
    'Geist-Bold': require('./assets/fonts/Geist-Bold.otf'),
  })

  if (!fontsLoaded) {
    return null
  }

  return (
    <View>
      <Text style={{ fontFamily: 'Geist-Bold' }}>Hello</Text>
    </View>
  )
}
```

**正確：配置插件，字體在構建時嵌入**

```tsx
import { Text, View } from 'react-native'

function App() {
  // 不需要加載狀態——字體已經可用
  return (
    <View>
      <Text style={{ fontFamily: 'Geist-Bold' }}>Hello</Text>
    </View>
  )
}
```

將字體添加到配置插件後，運行 `npx expo prebuild` 並重新構建原生應用程式。

---

## 參考資料

1. [https://react.dev](https://react.dev)
2. [https://reactnative.dev](https://reactnative.dev)
3. [https://docs.swmansion.com/react-native-reanimated](https://docs.swmansion.com/react-native-reanimated)
4. [https://docs.swmansion.com/react-native-gesture-handler](https://docs.swmansion.com/react-native-gesture-handler)
5. [https://docs.expo.dev](https://docs.expo.dev)
6. [https://legendapp.com/open-source/legend-list](https://legendapp.com/open-source/legend-list)
7. [https://github.com/nandorojo/galeria](https://github.com/nandorojo/galeria)
8. [https://zeego.dev](https://zeego.dev)
