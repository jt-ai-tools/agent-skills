---
title: 永遠不要在 useState 中追蹤捲動位置
impact: HIGH
impactDescription: 防止捲動期間的渲染抖動
tags: scroll, performance, reanimated, useRef
---

[English Version](./scroll-position-no-state.md)

## 永遠不要在 useState 中追蹤捲動位置

永遠不要將捲動位置存儲在 `useState` 中。捲動事件觸發非常頻繁——狀態更新會導致渲染抖動 (render thrashing) 和掉幀。請使用 Reanimated 的 shared value 進行動畫處理，或使用 ref 進行非響應式 (non-reactive) 追蹤。

**錯誤示範 (useState 導致卡頓)：**

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
    setScrollY(e.nativeEvent.contentOffset.y) // 每幀都會重新渲染
  }

  return <ScrollView onScroll={onScroll} scrollEventThrottle={16} />
}
```

**正確示範 (使用 Reanimated 處理動畫)：**

```tsx
import Animated, {
  useSharedValue,
  useAnimatedScrollHandler,
} from 'react-native-reanimated'

function Feed() {
  const scrollY = useSharedValue(0)

  const onScroll = useAnimatedScrollHandler({
    onScroll: (e) => {
      scrollY.value = e.contentOffset.y // 在 UI 線程運行，不會重新渲染
    },
  })

  return (
    <Animated.ScrollView
      onScroll={onScroll}
      // 較高的數值性能較好，但觸發頻率較低。
      // 如果你需要比性能更高的精度，請取消設置此項。
      scrollEventThrottle={16}
    />
  )
}
```

**正確示範 (使用 ref 進行非響應式追蹤)：**

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
    scrollY.current = e.nativeEvent.contentOffset.y // 不會重新渲染
  }

  return <ScrollView onScroll={onScroll} scrollEventThrottle={16} />
}
```
