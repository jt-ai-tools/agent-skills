---
title: 使用 Activity 組件控制顯示/隱藏
impact: MEDIUM
impactDescription: 保留狀態/DOM
tags: rendering, activity, visibility, state-preservation
---

[English Version](./rendering-activity.md)

## 使用 Activity 組件控制顯示/隱藏

使用 React 的 `<Activity>` 來保留那些需要頻繁切換可見性的昂貴組件的狀態和 DOM。

**用法：**

```tsx
import { Activity } from 'react'

function Dropdown({ isOpen }: Props) {
  return (
    <Activity mode={isOpen ? 'visible' : 'hidden'}>
      <ExpensiveMenu />
    </Activity>
  )
}
```

這可以避免昂貴的重新渲染和狀態丟失。
