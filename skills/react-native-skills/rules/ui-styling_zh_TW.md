---
title: 現代化 React Native 樣式模式
impact: MEDIUM
impactDescription: 一致的設計、更流暢的圓角、更簡潔的佈局
tags: styling, css, layout, shadows, gradients
---

[English Version](./ui-styling.md)

## 現代化 React Native 樣式模式

遵循以下樣式模式，以編寫更簡潔、更一致的 React Native 代碼。

**在設置 `borderRadius` 時，務必搭配使用 `borderCurve: 'continuous'`：**

```tsx
// 錯誤
{ borderRadius: 12 }

// 正確 – 更流暢的 iOS 風格圓角
{ borderRadius: 12, borderCurve: 'continuous' }
```

**使用 `gap` 代替 margin 來設置元素之間的間距：**

```tsx
// 錯誤 – 在子元素上設置 margin
<View>
  <Text style={{ marginBottom: 8 }}>Title</Text>
  <Text style={{ marginBottom: 8 }}>Subtitle</Text>
</View>

// 正確 – 在父元素上設置 gap
<View style={{ gap: 8 }}>
  <Text>Title</Text>
  <Text>Subtitle</Text>
</View>
```

**使用 `padding` 設置內部間距，使用 `gap` 設置元素間的間距：**

```tsx
<View style={{ padding: 16, gap: 12 }}>
  <Text>First</Text>
  <Text>Second</Text>
</View>
```

**使用 `experimental_backgroundImage` 處理線性漸變：**

```tsx
// 錯誤 – 使用第三方漸變函式庫
<LinearGradient colors={['#000', '#fff']} />

// 正確 – 使用原生 CSS 漸變語法
<View
  style={{
    experimental_backgroundImage: 'linear-gradient(to bottom, #000, #fff)',
  }}
/>
```

**使用 CSS `boxShadow` 字串語法設置陰影：**

```tsx
// 錯誤 – 舊版陰影對象或 elevation
{ shadowColor: '#000', shadowOffset: { width: 0, height: 2 }, shadowOpacity: 0.1 }
{ elevation: 4 }

// 正確 – CSS box-shadow 語法
{ boxShadow: '0 2px 8px rgba(0, 0, 0, 0.1)' }
```

**避免使用多種字體大小 – 使用字重和顏色來強調層次：**

```tsx
// 錯誤 – 使用不同的字體大小來區分層次
<Text style={{ fontSize: 18 }}>Title</Text>
<Text style={{ fontSize: 14 }}>Subtitle</Text>
<Text style={{ fontSize: 12 }}>Caption</Text>

// 正確 – 保持一致的大小，通過字重和顏色進行區分
<Text style={{ fontWeight: '600' }}>Title</Text>
<Text style={{ color: '#666' }}>Subtitle</Text>
<Text style={{ color: '#999' }}>Caption</Text>
```

限制字體大小的種類可以營造視覺上的一致性。請改用 `fontWeight` (bold/semibold) 和灰階顏色來建立層次結構。
