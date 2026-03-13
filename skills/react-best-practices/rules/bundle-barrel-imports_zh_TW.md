---
title: 避免 Barrel 檔案匯入
impact: CRITICAL
impactDescription: 200-800ms 匯入成本，減慢建置速度
tags: bundle, imports, tree-shaking, barrel-files, performance
---

[English Version](./bundle-barrel-imports.md)

## 避免 Barrel 檔案匯入

直接從原始檔案匯入，而不是透過 Barrel 檔案，以避免載入數千個未使用的模組。**Barrel 檔案** 是重新導出多個模組的進入點（例如，`index.js` 執行 `export * from './module'`）。

熱門的圖示和元件庫在其進入點檔案中可能擁有 **多達 10,000 個重新導出**。對於許多 React 套件，**僅僅匯入它們就需要 200-800ms**，這會影響開發速度和生產環境的冷啟動 (cold starts)。

**為什麼搖樹優化 (tree-shaking) 沒有幫助：** 當一個函式庫被標記為外部 (external)（未打包）時，打包工具 (bundler) 無法對其進行優化。如果你為了啟用搖樹優化而將其打包，建置過程會因為分析整個模組圖而變得實質上更慢。

**不正確（匯入整個函式庫）：**

```tsx
import { Check, X, Menu } from 'lucide-react'
// 載入 1,583 個模組，在開發環境中額外增加約 2.8s
// 執行時成本：每次冷啟動 200-800ms

import { Button, TextField } from '@mui/material'
// 載入 2,225 個模組，在開發環境中額外增加約 4.2s
```

**正確（僅匯入您需要的內容）：**

```tsx
import Check from 'lucide-react/dist/esm/icons/check'
import X from 'lucide-react/dist/esm/icons/x'
import Menu from 'lucide-react/dist/esm/icons/menu'
// 僅載入 3 個模組 (~2KB vs ~1MB)

import Button from '@mui/material/Button'
import TextField from '@mui/material/TextField'
// 僅載入您使用的內容
```

**替代方案 (Next.js 13.5+)：**

```js
// next.config.js - 使用 optimizePackageImports
module.exports = {
  experimental: {
    optimizePackageImports: ['lucide-react', '@mui/material']
  }
}

// 接著您可以保留人體工學的 barrel 匯入：
import { Check, X, Menu } from 'lucide-react'
// 在建置時自動轉換為直接匯入
```

直接匯入可提供快 15-70% 的開發啟動速度、快 28% 的建置速度、快 40% 的冷啟動速度，以及顯著更快的 HMR。

通常受影響的函式庫：`lucide-react`, `@mui/material`, `@mui/icons-material`, `@tabler/icons-react`, `react-icons`, `@headlessui/react`, `@radix-ui/react-*`, `lodash`, `ramda`, `date-fns`, `rxjs`, `react-use`。

參考：[How we optimized package imports in Next.js](https://vercel.com/blog/how-we-optimized-package-imports-in-next-js)
