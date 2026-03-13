---
title: 為大型元件使用動態匯入
impact: CRITICAL
impactDescription: 直接影響 TTI 和 LCP
tags: bundle, dynamic-import, code-splitting, next-dynamic
---

[English Version](./bundle-dynamic-imports.md)

## 為大型元件使用動態匯入

使用 `next/dynamic` 來延遲載入在初始渲染時不需要的大型元件。

**不正確（Monaco 與主區塊打包，約 ~300KB）：**

```tsx
import { MonacoEditor } from './monaco-editor'

function CodePanel({ code }: { code: string }) {
  return <MonacoEditor value={code} />
}
```

**正確（Monaco 按需載入）：**

```tsx
import dynamic from 'next/dynamic'

const MonacoEditor = dynamic(
  () => import('./monaco-editor').then(m => m.MonacoEditor),
  { ssr: false }
)

function CodePanel({ code }: { code: string }) {
  return <MonacoEditor value={code} />
}
```
