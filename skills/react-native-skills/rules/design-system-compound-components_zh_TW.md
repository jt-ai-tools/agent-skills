---
title: 優先使用複合組件而非多型子元素
impact: MEDIUM
impactDescription: 彈性的組合方式，更清晰的 API
tags: design-system, components, composition
---

[English Version](./design-system-compound-components.md)

## 優先使用複合組件（Compound Components）而非多型子元素

如果一個組件不是文字節點（text node），請不要將其設計為可接收字串。如果組件需要接收字串子元素，則必須是一個專門的 `*Text` 組件。對於像按鈕這樣同時包含 View（或 Pressable）與文字的組件，應使用複合組件，例如 `Button`、`ButtonText` 和 `ButtonIcon`。

**不正確（多型子元素）：**

```tsx
import { Pressable, Text } from 'react-native'

type ButtonProps = {
  children: string | React.ReactNode
  icon?: React.ReactNode
}

function Button({ children, icon }: ButtonProps) {
  return (
    <Pressable>
      {icon}
      {typeof children === 'string' ? <Text>{children}</Text> : children}
    </Pressable>
  )
}

// 用法模糊不清
<Button icon={<Icon />}>Save</Button>
<Button><CustomText>Save</CustomText></Button>
```

**正確（複合組件）：**

```tsx
import { Pressable, Text } from 'react-native'

function Button({ children }: { children: React.ReactNode }) {
  return <Pressable>{children}</Pressable>
}

function ButtonText({ children }: { children: React.ReactNode }) {
  return <Text>{children}</Text>
}

function ButtonIcon({ children }: { children: React.ReactNode }) {
  return <>{children}</>
}

// 用法明確且具備組合性
<Button>
  <ButtonIcon><SaveIcon /></ButtonIcon>
  <ButtonText>Save</ButtonText>
</Button>

<Button>
  <ButtonText>Cancel</ButtonText>
</Button>
```
