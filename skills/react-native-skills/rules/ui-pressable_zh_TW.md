---
title: 優先使用 Pressable 而非 Touchable 元件
impact: LOW
impactDescription: 現代化 API，更具靈活性
tags: ui, pressable, touchable, gestures
---

[English Version](./ui-pressable.md)

## 優先使用 Pressable 而非 Touchable 元件

絕對不要使用 `TouchableOpacity` 或 `TouchableHighlight`。請改用 `react-native` 或 `react-native-gesture-handler` 提供的 `Pressable`。

**錯誤 (舊版 Touchable 元件):**

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

**正確 (Pressable):**

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

**正確 (來自 gesture handler 的 Pressable，用於列表):**

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

在可滾動列表內使用 `react-native-gesture-handler` 的 Pressable 可以獲得更好的手勢協調性，前提是您也使用了來自 `react-native-gesture-handler` 的 ScrollView。

**對於動畫按壓狀態 (縮放、透明度變化):** 使用 `GestureDetector` 搭配 Reanimated 的 shared values，而不是 Pressable 的 style 回呼函數。請參閱 `animation-gesture-detector-press` 規則。
