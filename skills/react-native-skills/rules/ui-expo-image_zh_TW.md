---
title: 使用 expo-image 優化圖片
impact: HIGH
impactDescription: 內存效率、緩存、blurhash 佔位符、漸進式加載
tags: images, performance, expo-image, ui
---

[English Version](./ui-expo-image.md)

## 使用 expo-image 優化圖片

請使用 `expo-image` 代替 React Native 原生的 `Image`。它提供高效的內存緩存、blurhash 佔位符、漸進式加載，並且在列表中具有更好的性能。

**錯誤示範 (使用 React Native 原生 Image)：**

```tsx
import { Image } from 'react-native'

function Avatar({ url }: { url: string }) {
  return <Image source={{ uri: url }} style={styles.avatar} />
}
```

**正確示範 (使用 expo-image)：**

```tsx
import { Image } from 'expo-image'

function Avatar({ url }: { url: string }) {
  return <Image source={{ uri: url }} style={styles.avatar} />
}
```

**配合 blurhash 佔位符：**

```tsx
<Image
  source={{ uri: url }}
  placeholder={{ blurhash: 'LGF5]+Yk^6#M@-5c,1J5@[or[Q6.' }}
  contentFit="cover"
  transition={200}
  style={styles.image}
/>
```

**配合優先級和緩存策略：**

```tsx
<Image
  source={{ uri: url }}
  priority="high"
  cachePolicy="memory-disk"
  style={styles.hero}
/>
```

**關鍵屬性 (Props)：**

- `placeholder` — 加載時顯示的 Blurhash 或縮略圖。
- `contentFit` — `cover` (覆蓋), `contain` (包含), `fill` (填充), `scale-down` (等比例縮小)。
- `transition` — 淡入動畫持續時間（毫秒）。
- `priority` — `low` (低), `normal` (正常), `high` (高)。
- `cachePolicy` — `memory` (內存), `disk` (磁盤), `memory-disk` (內存與磁盤), `none` (不緩存)。
- `recyclingKey` — 用於列表回收的唯一鍵。

對於跨平台（Web + Native），請使用 `solito/image` 中的 `SolitoImage`，其底層封裝了 `expo-image`。

參考資料：[expo-image](https://docs.expo.dev/versions/latest/sdk/image/)
