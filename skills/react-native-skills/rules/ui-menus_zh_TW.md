---
title: 使用原生菜單製作下拉列表和上下文菜單
impact: HIGH
impactDescription: 原生無障礙支持、各平台一致的用戶體驗
tags: user-interface, menus, context-menus, zeego, accessibility
---

[English Version](./ui-menus.md)

## 使用原生菜單製作下拉列表和上下文菜單

請使用各平台的原生菜單，而不是自定義的 JS 實現。原生菜單提供內置的無障礙支持 (accessibility)、一致的平台用戶體驗 (UX) 以及更好的性能。請使用 [zeego](https://zeego.dev) 來實現跨平台的原生菜單。

**錯誤示範 (自定義 JS 菜單)：**

```tsx
import { useState } from 'react'
import { View, Pressable, Text } from 'react-native'

function MyMenu() {
  const [open, setOpen] = useState(false)

  return (
    <View>
      <Pressable onPress={() => setOpen(!open)}>
        <Text>打開菜單</Text>
      </Pressable>
      {open && (
        <View style={{ position: 'absolute', top: 40 }}>
          <Pressable onPress={() => console.log('edit')}>
            <Text>編輯</Text>
          </Pressable>
          <Pressable onPress={() => console.log('delete')}>
            <Text>刪除</Text>
          </Pressable>
        </View>
      )}
    </View>
  )
}
```

**正確示範 (使用 zeego 實現原生菜單)：**

```tsx
import * as DropdownMenu from 'zeego/dropdown-menu'

function MyMenu() {
  return (
    <DropdownMenu.Root>
      <DropdownMenu.Trigger>
        <Pressable>
          <Text>打開菜單</Text>
        </Pressable>
      </DropdownMenu.Trigger>

      <DropdownMenu.Content>
        <DropdownMenu.Item key='edit' onSelect={() => console.log('edit')}>
          <DropdownMenu.ItemTitle>編輯</DropdownMenu.ItemTitle>
        </DropdownMenu.Item>

        <DropdownMenu.Item
          key='delete'
          destructive
          onSelect={() => console.log('delete')}
        >
          <DropdownMenu.ItemTitle>刪除</DropdownMenu.ItemTitle>
        </DropdownMenu.Item>
      </DropdownMenu.Content>
    </DropdownMenu.Root>
  )
}
```

**上下文菜單 (長按觸發)：**

```tsx
import * as ContextMenu from 'zeego/context-menu'

function MyContextMenu() {
  return (
    <ContextMenu.Root>
      <ContextMenu.Trigger>
        <View style={{ padding: 20 }}>
          <Text>長按我</Text>
        </View>
      </ContextMenu.Trigger>

      <ContextMenu.Content>
        <ContextMenu.Item key='copy' onSelect={() => console.log('copy')}>
          <ContextMenu.ItemTitle>複製</ContextMenu.ItemTitle>
        </ContextMenu.Item>

        <ContextMenu.Item key='paste' onSelect={() => console.log('paste')}>
          <ContextMenu.ItemTitle>粘貼</ContextMenu.ItemTitle>
        </ContextMenu.Item>
      </ContextMenu.Content>
    </ContextMenu.Root>
  )
}
```

**複選框項目 (Checkbox items)：**

```tsx
import * as DropdownMenu from 'zeego/dropdown-menu'

function SettingsMenu() {
  const [notifications, setNotifications] = useState(true)

  return (
    <DropdownMenu.Root>
      <DropdownMenu.Trigger>
        <Pressable>
          <Text>設置</Text>
        </Pressable>
      </DropdownMenu.Trigger>

      <DropdownMenu.Content>
        <DropdownMenu.CheckboxItem
          key='notifications'
          value={notifications}
          onValueChange={() => setNotifications((prev) => !prev)}
        >
          <DropdownMenu.ItemIndicator />
          <DropdownMenu.ItemTitle>通知</DropdownMenu.ItemTitle>
        </DropdownMenu.CheckboxItem>
      </DropdownMenu.Content>
    </DropdownMenu.Root>
  )
}
```

**子菜單 (Submenus)：**

```tsx
import * as DropdownMenu from 'zeego/dropdown-menu'

function MenuWithSubmenu() {
  return (
    <DropdownMenu.Root>
      <DropdownMenu.Trigger>
        <Pressable>
          <Text>選項</Text>
        </Pressable>
      </DropdownMenu.Trigger>

      <DropdownMenu.Content>
        <DropdownMenu.Item key='home' onSelect={() => console.log('home')}>
          <DropdownMenu.ItemTitle>首頁</DropdownMenu.ItemTitle>
        </DropdownMenu.Item>

        <DropdownMenu.Sub>
          <DropdownMenu.SubTrigger key='more'>
            <DropdownMenu.ItemTitle>更多選項</DropdownMenu.ItemTitle>
          </DropdownMenu.SubTrigger>

          <DropdownMenu.SubContent>
            <DropdownMenu.Item key='settings'>
              <DropdownMenu.ItemTitle>設置</DropdownMenu.ItemTitle>
            </DropdownMenu.Item>

            <DropdownMenu.Item key='help'>
              <DropdownMenu.ItemTitle>幫助</DropdownMenu.ItemTitle>
            </DropdownMenu.Item>
          </DropdownMenu.SubContent>
        </DropdownMenu.Sub>
      </DropdownMenu.Content>
    </DropdownMenu.Root>
  )
}
```

參考資料：[Zeego 文件](https://zeego.dev/components/dropdown-menu)
