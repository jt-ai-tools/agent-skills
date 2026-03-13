---
title: 優先使用 useDerivedValue 而非 useAnimatedReaction
impact: MEDIUM
impactDescription: 程式碼更簡潔，自動追蹤依賴項
tags: animation, reanimated, derived-value
---

[English Version](./animation-derived-value.md)

## 優先使用 useDerivedValue 而非 useAnimatedReaction

當從一個共用值（shared value）推導出另一個值時，應使用 `useDerivedValue` 而不是 `useAnimatedReaction`。推導值是宣告式的，會自動追蹤依賴項，並返回一個可以直接使用的值。`useAnimatedReaction` 則適用於副作用，而非值推導。

**不正確（使用 useAnimatedReaction 進行推導）：**

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

**正確（使用 useDerivedValue）：**

```tsx
import { useSharedValue, useDerivedValue } from 'react-native-reanimated'

function MyComponent() {
  const progress = useSharedValue(0)

  const opacity = useDerivedValue(() => 1 - progress.get())

  // ...
}
```

僅在不產生值的副作用（例如：觸發觸覺回饋、記錄日誌、呼叫 `runOnJS`）時才使用 `useAnimatedReaction`。

參考資料：
[Reanimated useDerivedValue](https://docs.swmansion.com/react-native-reanimated/docs/core/useDerivedValue)
