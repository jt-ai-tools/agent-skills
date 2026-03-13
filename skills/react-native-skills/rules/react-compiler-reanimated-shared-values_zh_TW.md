---
title: 在 Reanimated Shared Values 中使用 .get() 和 .set() (而非 .value)
impact: LOW
impactDescription: React Compiler 相容性所需
tags: reanimated, react-compiler, shared-values
---

[English Version](./react-compiler-reanimated-shared-values.md)

## 在 React Compiler 中使用 .get() 和 .set() 處理 Shared Values

在啟用 React Compiler 的情況下，請使用 `.get()` 和 `.set()`，而非直接在 Reanimated shared values 上讀取或寫入 `.value`。編譯器無法追蹤屬性存取——明確的方法呼叫可確保行為正確。

**錯誤（會破壞 React Compiler）：**

```tsx
import { useSharedValue } from 'react-native-reanimated'

function Counter() {
  const count = useSharedValue(0)

  const increment = () => {
    count.value = count.value + 1 // 會使 React Compiler 失效
  }

  return <Button onPress={increment} title={`Count: ${count.value}`} />
}
```

**正確（相容於 React Compiler）：**

```tsx
import { useSharedValue } from 'react-native-reanimated'

function Counter() {
  const count = useSharedValue(0)

  const increment = () => {
    count.set(count.get() + 1)
  }

  return <Button onPress={increment} title={`Count: ${count.get()}`} />
}
```

更多資訊請參閱 [Reanimated 文件](https://docs.swmansion.com/react-native-reanimated/docs/core/useSharedValue/#react-compiler-support)。
