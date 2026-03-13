---
title: 使用 GestureDetector 處理動畫按壓狀態
impact: MEDIUM
impactDescription: UI 執行緒動畫，更流暢的按壓回饋
tags: animation, gestures, press, reanimated
---

[English Version](./animation-gesture-detector-press.md)

## 使用 GestureDetector 處理動畫按壓狀態

對於動畫按壓狀態（按壓時的縮放、透明度），應使用 `GestureDetector` 搭配 `Gesture.Tap()` 和共用值（shared values），而不是使用 Pressable 的 `onPressIn`/`onPressOut`。手勢回呼（callback）作為 worklets 在 UI 執行緒上執行，按壓動畫無需經過 JS 執行緒的來回傳遞。

**不正確（使用 JS 執行緒回呼的 Pressable）：**

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

**正確（使用 UI 執行緒 worklets 的 GestureDetector）：**

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
  // 儲存按壓狀態（0 = 未按壓，1 = 已按壓）
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

  // 從狀態推導視覺數值
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

儲存按壓**狀態**（0 或 1），然後透過 `interpolate` 推導縮放比例。這能保持共用值作為單一事實來源。使用 `runOnJS` 從 worklets 呼叫 JS 函數。使用 `.set()` 和 `.get()` 以確保與 React Compiler 相容。

參考資料：
[Gesture Handler Tap Gesture](https://docs.swmansion.com/react-native-gesture-handler/docs/gestures/tap-gesture)
