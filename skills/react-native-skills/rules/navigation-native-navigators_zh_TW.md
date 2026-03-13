---
title: 使用原生導航器進行導航
impact: HIGH
impactDescription: 原生效能、符合平台規範的 UI
tags: navigation, react-navigation, expo-router, native-stack, tabs
---

[English Version](./navigation-native-navigators.md)

## 使用原生導航器進行導航

始終使用原生導航器（native navigators）而非基於 JS 的導航器。原生導航器使用平台 API（iOS 上的 UINavigationController，Android 上的 Fragment）以獲得更好的效能和原生行為。

**對於 Stack（堆疊）：** 使用 `@react-navigation/native-stack` 或 expo-router 的預設 stack（它本身就使用 native-stack）。避免使用 `@react-navigation/stack`。

**對於 Tab（分頁）：** 使用 `react-native-bottom-tabs`（原生）或 expo-router 的原生 tabs。當原生感（native feel）很重要時，避免使用 `@react-navigation/bottom-tabs`。

### Stack 導航 (Stack Navigation)

**錯誤（JS stack 導航器）：**

```tsx
import { createStackNavigator } from '@react-navigation/stack'

const Stack = createStackNavigator()

function App() {
  return (
    <Stack.Navigator>
      <Stack.Screen name='Home' component={HomeScreen} />
      <Stack.Screen name='Details' component={DetailsScreen} />
    </Stack.Navigator>
  )
}
```

**正確（使用 react-navigation 的原生 stack）：**

```tsx
import { createNativeStackNavigator } from '@react-navigation/native-stack'

const Stack = createNativeStackNavigator()

function App() {
  return (
    <Stack.Navigator>
      <Stack.Screen name='Home' component={HomeScreen} />
      <Stack.Screen name='Details' component={DetailsScreen} />
    </Stack.Navigator>
  )
}
```

**正確（expo-router 預設使用原生 stack）：**

```tsx
// app/_layout.tsx
import { Stack } from 'expo-router'

export default function Layout() {
  return <Stack />
}
```

### Tab 導航 (Tab Navigation)

**錯誤（JS 底部分頁）：**

```tsx
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs'

const Tab = createBottomTabNavigator()

function App() {
  return (
    <Tab.Navigator>
      <Tab.Screen name='Home' component={HomeScreen} />
      <Tab.Screen name='Settings' component={SettingsScreen} />
    </Tab.Navigator>
  )
}
```

**正確（使用 react-navigation 的原生底部分頁）：**

```tsx
import { createNativeBottomTabNavigator } from '@bottom-tabs/react-navigation'

const Tab = createNativeBottomTabNavigator()

function App() {
  return (
    <Tab.Navigator>
      <Tab.Screen
        name='Home'
        component={HomeScreen}
        options={{
          tabBarIcon: () => ({ sfSymbol: 'house' }),
        }}
      />
      <Tab.Screen
        name='Settings'
        component={SettingsScreen}
        options={{
          tabBarIcon: () => ({ sfSymbol: 'gear' }),
        }}
      />
    </Tab.Navigator>
  )
}
```

**正確（expo-router 原生分頁）：**

```tsx
// app/(tabs)/_layout.tsx
import { NativeTabs } from 'expo-router/unstable-native-tabs'

export default function TabLayout() {
  return (
    <NativeTabs>
      <NativeTabs.Trigger name='index'>
        <NativeTabs.Trigger.Label>首頁</NativeTabs.Trigger.Label>
        <NativeTabs.Trigger.Icon sf='house.fill' md='home' />
      </NativeTabs.Trigger>
      <NativeTabs.Trigger name='settings'>
        <NativeTabs.Trigger.Label>設定</NativeTabs.Trigger.Label>
        <NativeTabs.Trigger.Icon sf='gear' md='settings' />
      </NativeTabs.Trigger>
    </NativeTabs>
  )
}
```

在 iOS 上，原生分頁會自動在每個分頁畫面根部的第一個 `ScrollView` 上啟用 `contentInsetAdjustmentBehavior`，因此內容可以正確地在半透明的分頁列後方滾動。如果您需要停用此功能，請在 trigger 上使用 `disableAutomaticContentInsets`。

### 優先使用原生 Header 選項而非自定義組件

**錯誤（自定義 header 組件）：**

```tsx
<Stack.Screen
  name='Profile'
  component={ProfileScreen}
  options={{
    header: () => <CustomHeader title='Profile' />,
  }}
/>
```

**正確（原生 header 選項）：**

```tsx
<Stack.Screen
  name='Profile'
  component={ProfileScreen}
  options={{
    title: '個人資料',
    headerLargeTitleEnabled: true,
    headerSearchBarOptions: {
      placeholder: '搜尋',
    },
  }}
/>
```

原生 header 自動支援 iOS 大標題 (large titles)、搜尋列、模糊效果以及正確的安全區域 (safe area) 處理。

### 為什麼選擇原生導航器

- **效能**：原生轉換和手勢在 UI 執行緒上運行
- **平台行為**：自動支援 iOS 大標題、Android Material Design
- **系統整合**：點擊分頁標籤可捲動至頂部、避免 PiP (畫中畫)、正確的安全區域
- **無障礙功能**：自動支援平台的無障礙功能

參考資料：

- [React Navigation Native Stack](https://reactnavigation.org/docs/native-stack-navigator)
- [React Navigation Native Bottom Tabs](https://oss.callstack.com/react-native-bottom-tabs/docs/guides/usage-with-react-navigation)
- [Expo Router Native Tabs](https://docs.expo.dev/router/advanced/native-tabs)
