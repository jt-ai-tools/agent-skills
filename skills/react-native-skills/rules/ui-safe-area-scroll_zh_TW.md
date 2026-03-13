---
title: 使用 contentInsetAdjustmentBehavior 處理安全區域 (Safe Areas)
impact: MEDIUM
impactDescription: 原生安全區域處理，無佈局偏移
tags: safe-area, scrollview, layout
---

[English Version](./ui-safe-area-scroll.md)

## 使用 contentInsetAdjustmentBehavior 處理安全區域 (Safe Areas)

在根部的 ScrollView 上使用 `contentInsetAdjustmentBehavior="automatic"`，而不是用 SafeAreaView 包裹內容或手動設置 padding。這可以讓 iOS 以正確的滾動行為原生處理安全區域的縮進 (insets)。

**錯誤 (SafeAreaView 包裹層):**

```tsx
import { SafeAreaView, ScrollView, View, Text } from 'react-native'

function MyScreen() {
  return (
    <SafeAreaView style={{ flex: 1 }}>
      <ScrollView>
        <View>
          <Text>Content</Text>
        </View>
      </ScrollView>
    </SafeAreaView>
  )
}
```

**錯誤 (手動安全區域 padding):**

```tsx
import { ScrollView, View, Text } from 'react-native'
import { useSafeAreaInsets } from 'react-native-safe-area-context'

function MyScreen() {
  const insets = useSafeAreaInsets()

  return (
    <ScrollView contentContainerStyle={{ paddingTop: insets.top }}>
      <View>
        <Text>Content</Text>
      </View>
    </ScrollView>
  )
}
```

**正確 (原生內容縮進調整):**

```tsx
import { ScrollView, View, Text } from 'react-native'

function MyScreen() {
  return (
    <ScrollView contentInsetAdjustmentBehavior='automatic'>
      <View>
        <Text>Content</Text>
      </View>
    </ScrollView>
  )
}
```

原生方法可以處理動態安全區域（如鍵盤、工具欄），並允許內容自然地滾動到狀態欄後方。
