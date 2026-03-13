---
title: 使用 Galeria 製作圖片庫和燈箱 (Lightbox)
impact: MEDIUM
impactDescription: 原生共享元素過渡、捏合縮放 (pinch-to-zoom)、平移關閉 (pan-to-close)
tags: images, gallery, lightbox, expo-image, ui
---

[English Version](./ui-image-gallery.md)

## 使用 Galeria 製作圖片庫和燈箱 (Lightbox)

對於需要燈箱效果（點擊全屏顯示）的圖片庫，請使用 `@nandorojo/galeria`。它提供原生的共享元素過渡 (shared element transitions)，並支持捏合縮放 (pinch-to-zoom)、雙擊縮放以及平移關閉。它可以與任何圖片組件（包括 `expo-image`）配合使用。

**錯誤示範 (自定義 Modal 實現)：**

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

**正確示範 (Galeria 配合 expo-image)：**

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

**單張圖片：**

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

**低解析度縮略圖配合高解析度全屏圖：**

```tsx
<Galeria urls={highResUrls}>
  {lowResUrls.map((url, index) => (
    <Galeria.Image index={index} key={url}>
      <Image source={{ uri: url }} style={styles.thumbnail} />
    </Galeria.Image>
  ))}
</Galeria>
```

**配合 FlashList 使用：**

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

適用於 `expo-image`、`SolitoImage`、`react-native` 原生 Image 或任何圖片組件。

參考資料：[Galeria](https://github.com/nandorojo/galeria)
