---
title: 在建置時原生載入字型
impact: LOW
impactDescription: 啟動時即可使用字型，無需非同步載入
tags: fonts, expo, performance, config-plugin
---

[English Version](./fonts-config-plugin.md)

## 使用 Expo Config Plugin 進行字型載入

使用 `expo-font` 設定插件 (config plugin) 在建置時嵌入字型，而不是使用 `useFonts` 或 `Font.loadAsync`。嵌入的字型效率更高。

**錯誤做法 (非同步字型載入):**

```tsx
import { useFonts } from 'expo-font'
import { Text, View } from 'react-native'

function App() {
  const [fontsLoaded] = useFonts({
    'Geist-Bold': require('./assets/fonts/Geist-Bold.otf'),
  })

  if (!fontsLoaded) {
    return null
  }

  return (
    <View>
      <Text style={{ fontFamily: 'Geist-Bold' }}>Hello</Text>
    </View>
  )
}
```

**正確做法 (設定插件，字型在建置時嵌入):**

```json
// app.json
{
  "expo": {
    "plugins": [
      [
        "expo-font",
        {
          "fonts": ["./assets/fonts/Geist-Bold.otf"]
        }
      ]
    ]
  }
}
```

```tsx
import { Text, View } from 'react-native'

function App() {
  // 不需要載入狀態 — 字型已經可以使用
  return (
    <View>
      <Text style={{ fontFamily: 'Geist-Bold' }}>Hello</Text>
    </View>
  )
}
```

在設定插件中加入字型後，請執行 `npx expo prebuild` 並重新建置原生應用程式。

參考資料：
[Expo Font Documentation](https://docs.expo.dev/versions/latest/sdk/font/)
