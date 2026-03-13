---
title: 從設計系統資料夾匯入
impact: LOW
impactDescription: 實現全域變更並簡化重構
tags: imports, architecture, design-system
---

[English Version](./imports-design-system-folder.md)

## 從設計系統資料夾匯入

將依賴項從設計系統資料夾重新匯出 (re-export)。應用程式代碼從該處匯入，而不是直接從套件匯入。這使得全域變更和重構變得更加容易。

**錯誤做法 (直接從套件匯入):**

```tsx
import { View, Text } from 'react-native'
import { Button } from '@ui/button'

function Profile() {
  return (
    <View>
      <Text>Hello</Text>
      <Button>Save</Button>
    </View>
  )
}
```

**正確做法 (從設計系統匯入):**

```tsx
// components/view.tsx
import { View as RNView } from 'react-native'

// 理想做法：挑選你實際會用到的 props 來控制實作
export function View(
  props: Pick<React.ComponentProps<typeof RNView>, 'style' | 'children'>
) {
  return <RNView {...props} />
}
```

```tsx
// components/text.tsx
export { Text } from 'react-native'
```

```tsx
// components/button.tsx
export { Button } from '@ui/button'
```

```tsx
import { View } from '@/components/view'
import { Text } from '@/components/text'
import { Button } from '@/components/button'

function Profile() {
  return (
    <View>
      <Text>Hello</Text>
      <Button>Save</Button>
    </View>
  )
}
```

從簡單的重新匯出開始。日後可以在不更改應用程式代碼的情況下進行自定義。
