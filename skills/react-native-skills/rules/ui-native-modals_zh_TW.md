---
title: 優先使用原生 Modal 而非 JS 底層表單 (Bottom Sheets)
impact: HIGH
impactDescription: 原生效能、手勢、無障礙功能
tags: modals, bottom-sheet, native, react-navigation
---

[English Version](./ui-native-modals.md)

## 優先使用原生 Modal 而非 JS 底層表單 (Bottom Sheets)

使用帶有 `presentationStyle="formSheet"` 的原生 `<Modal>` 或 React Navigation v7 的原生 form sheet，而不是基於 JS 的底層表單 (bottom sheet) 函式庫。原生 Modal 內建了手勢、無障礙功能以及更好的效能。在低階元件上應依賴原生 UI。

**錯誤 (基於 JS 的底層表單):**

```tsx
import BottomSheet from 'custom-js-bottom-sheet'

function MyScreen() {
  const sheetRef = useRef<BottomSheet>(null)

  return (
    <View style={{ flex: 1 }}>
      <Button onPress={() => sheetRef.current?.expand()} title='Open' />
      <BottomSheet ref={sheetRef} snapPoints={['50%', '90%']}>
        <View>
          <Text>Sheet content</Text>
        </View>
      </BottomSheet>
    </View>
  )
}
```

**正確 (帶有 formSheet 的原生 Modal):**

```tsx
import { Modal, View, Text, Button } from 'react-native'

function MyScreen() {
  const [visible, setVisible] = useState(false)

  return (
    <View style={{ flex: 1 }}>
      <Button onPress={() => setVisible(true)} title='Open' />
      <Modal
        visible={visible}
        presentationStyle='formSheet'
        animationType='slide'
        onRequestClose={() => setVisible(false)}
      >
        <View>
          <Text>Sheet content</Text>
        </View>
      </Modal>
    </View>
  )
}
```

**正確 (React Navigation v7 原生 form sheet):**

```tsx
// 在您的導覽器 (navigator) 中
<Stack.Screen
  name='Details'
  component={DetailsScreen}
  options={{
    presentation: 'formSheet',
    sheetAllowedDetents: 'fitToContents',
  }}
/>
```

原生 Modal 開箱即用，提供滑動關閉、正確的鍵盤避讓以及無障礙功能。
