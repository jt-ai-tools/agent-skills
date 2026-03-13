---
title: 動畫應使用 Transform 與 Opacity 而非佈局屬性
impact: HIGH
impactDescription: GPU 加速動畫，無需重新計算佈局
tags: animation, performance, reanimated, transform, opacity
---

[English Version](./animation-gpu-properties.md)

## 動畫應使用 Transform 與 Opacity 而非佈局屬性

避免對 `width`、`height`、`top`、`left`、`margin` 或 `padding` 進行動畫處理。這些屬性在每一影格（frame）都會觸發佈局重新計算。相反地，應使用 `transform`（縮放 scale、位移 translate）和 `opacity`，這些屬性在 GPU 上執行，不會觸發佈局變動。

**不正確（動畫處理 height，每一影格都觸發佈局）：**

```tsx
import Animated, { useAnimatedStyle, withTiming } from 'react-native-reanimated'

function CollapsiblePanel({ expanded }: { expanded: boolean }) {
  const animatedStyle = useAnimatedStyle(() => ({
    height: withTiming(expanded ? 200 : 0), // 每一影格都觸發佈局
    overflow: 'hidden',
  }))

  return <Animated.View style={animatedStyle}>{children}</Animated.View>
}
```

**正確（動畫處理 scaleY，GPU 加速）：**

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

**正確（動畫處理 translateY 進行滑動動畫）：**

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

GPU 加速屬性包括：`transform`（位移 translate、縮放 scale、旋轉 rotate）、`opacity`。其他所有屬性都會觸發佈局重新計算。
