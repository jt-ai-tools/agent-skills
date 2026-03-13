---
title: 狀態必須代表事實真相 (Ground Truth)
impact: HIGH
impactDescription: 更清晰的邏輯、更容易調試、單一事實來源
tags: state, derived-state, reanimated, hooks
---

[English Version](./state-ground-truth.md)

## 狀態必須代表事實真相 (Ground Truth)

狀態變數——不論是 React 的 `useState` 還是 Reanimated 的 shared values——都應該代表某種事物的**實際狀態**（例如：`pressed`、`progress`、`isOpen`），而不是**派生的視覺數值**（例如：`scale`、`opacity`、`translateY`）。請透過計算或插值 (interpolation) 從狀態中派生視覺數值。

**錯誤示範 (存儲視覺輸出)：**

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

**正確示範 (存儲狀態，派生視覺數值)：**

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

狀態變數應該代表真實的「狀態」，而不一定是預期的最終結果。

1. **單一事實來源 (Single source of truth)** — 狀態 (`pressed`) 描述了正在發生的事情；視覺效果是派生出來的。
2. **易於擴展** — 添加不透明度、旋轉或其他效果，只需要從同一個狀態進行更多的插值。
3. **調試 (Debugging)** — 檢查 `pressed = 1` 比 `scale = 0.95` 更清晰。
4. **可重用邏輯** — 同一個 `pressed` 數值可以驅動多個視覺屬性。

**React 狀態的相同原則：**

```tsx
// 錯誤示範：存儲派生數值
const [isExpanded, setIsExpanded] = useState(false)
const [height, setHeight] = useState(0)

useEffect(() => {
  setHeight(isExpanded ? 200 : 0)
}, [isExpanded])

// 正確示範：從狀態中派生
const [isExpanded, setIsExpanded] = useState(false)
const height = isExpanded ? 200 : 0
```

狀態是最小的事實。其他一切都是派生出來的。
