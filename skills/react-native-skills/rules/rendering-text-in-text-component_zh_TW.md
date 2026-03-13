---
title: 將字串包裝在 Text 組件中
impact: CRITICAL
impactDescription: 防止執行期崩潰
tags: rendering, text, core
---

[English Version](./rendering-text-in-text-component.md)

## 將字串包裝在 Text 組件中

字串必須在 `<Text>` 中渲染。如果字串是 `<View>` 的直接子代，React Native 會崩潰。

**錯誤（會崩潰）：**

```tsx
import { View } from 'react-native'

function Greeting({ name }: { name: string }) {
  return <View>你好, {name}!</View>
}
// 錯誤：文字字串必須在 <Text> 組件中渲染。
```

**正確：**

```tsx
import { View, Text } from 'react-native'

function Greeting({ name }: { name: string }) {
  return (
    <View>
      <Text>你好, {name}!</Text>
    </View>
  )
}
```
