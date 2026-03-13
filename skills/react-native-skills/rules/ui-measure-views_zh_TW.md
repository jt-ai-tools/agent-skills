---
title: 測量 View 的尺寸
impact: MEDIUM
impactDescription: 同步測量，避免不必要的重新渲染
tags: layout, measurement, onLayout, useLayoutEffect
---

[English Version](./ui-measure-views.md)

## 測量 View 的尺寸

同時使用 `useLayoutEffect`（同步）和 `onLayout`（用於更新）。同步測量可以讓你立即獲得初始尺寸；`onLayout` 則在 View 發生變化時保持尺寸最新。對於非基本類型 (non-primitive) 的狀態，請使用 dispatch updater（函數式更新）來比較數值，以避免不必要的重新渲染。

**僅測量高度：**

```tsx
import { useLayoutEffect, useRef, useState } from 'react'
import { View, LayoutChangeEvent } from 'react-native'

function MeasuredBox({ children }: { children: React.ReactNode }) {
  const ref = useRef<View>(null)
  const [height, setHeight] = useState<number | undefined>(undefined)

  useLayoutEffect(() => {
    // 掛載時的同步測量 (RN 0.82+)
    const rect = ref.current?.getBoundingClientRect()
    if (rect) setHeight(rect.height)
    // 0.82 版本之前：ref.current?.measure((x, y, w, h) => setHeight(h))
  }, [])

  const onLayout = (e: LayoutChangeEvent) => {
    setHeight(e.nativeEvent.layout.height)
  }

  return (
    <View ref={ref} onLayout={onLayout}>
      {children}
    </View>
  )
}
```

**測量寬度與高度：**

```tsx
import { useLayoutEffect, useRef, useState } from 'react'
import { View, LayoutChangeEvent } from 'react-native'

type Size = { width: number; height: number }

function MeasuredBox({ children }: { children: React.ReactNode }) {
  const ref = useRef<View>(null)
  const [size, setSize] = useState<Size | undefined>(undefined)

  useLayoutEffect(() => {
    const rect = ref.current?.getBoundingClientRect()
    if (rect) setSize({ width: rect.width, height: rect.height })
  }, [])

  const onLayout = (e: LayoutChangeEvent) => {
    const { width, height } = e.nativeEvent.layout
    setSize((prev) => {
      // 對於非基本類型的狀態，在觸發重新渲染前比較數值
      if (prev?.width === width && prev?.height === height) return prev
      return { width, height }
    })
  }

  return (
    <View ref={ref} onLayout={onLayout}>
      {children}
    </View>
  )
}
```

請使用函數式 `setState` 進行比較——不要在回調函數中直接讀取狀態。
