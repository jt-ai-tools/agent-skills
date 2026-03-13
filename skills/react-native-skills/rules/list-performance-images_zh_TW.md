---
title: 在列表中使用壓縮過的圖片
impact: HIGH
impactDescription: 更快的載入速度、更少的記憶體佔用
tags: lists, images, performance, optimization
---

[English Version](./list-performance-images.md)

## 在列表中使用壓縮過的圖片

在列表中務必載入經過壓縮且尺寸合適的圖片。全解析度的圖片會消耗過多記憶體並導致捲動卡頓。請向您的伺服器請求縮圖，或使用具有調整尺寸參數的圖片 CDN。

**錯誤做法 (全解析度圖片):**

```tsx
function ProductItem({ product }: { product: Product }) {
  return (
    <View>
      {/* 為 100x100 的縮圖載入了 4000x3000 的圖片 */}
      <Image
        source={{ uri: product.imageUrl }}
        style={{ width: 100, height: 100 }}
      />
      <Text>{product.name}</Text>
    </View>
  )
}
```

**正確做法 (請求尺寸合適的圖片):**

```tsx
function ProductItem({ product }: { product: Product }) {
  // 請求 200x200 的圖片 (2x 以應對 retina 螢幕)
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

使用具有內建快取和佔位圖支援的優化圖片組件，例如 `expo-image` 或 `SolitoImage` (後者底層使用 `expo-image`)。針對 retina 螢幕，請請求 2 倍於顯示尺寸的圖片。
