---
title: 初始化應用程序一次，而非每次掛載
impact: LOW-MEDIUM
impactDescription: 避免開發環境中的重複初始化
tags: initialization, useEffect, app-startup, side-effects
---

[English Version](./advanced-init-once.md)

## 初始化應用程序一次，而非每次掛載 (Initialize App Once, Not Per Mount)

不要將每次應用程序載入只需運行一次的全局初始化放在組件的 `useEffect([])` 中。組件可能會重新掛載，導致 Effect 重新運行。請改用模組級別的守衛 (module-level guard) 或在進入點模組中進行頂層初始化。

**錯誤範例 (在開發環境中運行兩次，且在重新掛載時重新運行)：**

```tsx
function Comp() {
  useEffect(() => {
    loadFromStorage()
    checkAuthToken()
  }, [])

  // ...
}
```

**正確範例 (每個應用程序載入僅一次)：**

```tsx
let didInit = false

function Comp() {
  useEffect(() => {
    if (didInit) return
    didInit = true
    loadFromStorage()
    checkAuthToken()
  }, [])

  // ...
}
```

參考資料：[初始化應用程序 (Initializing the application)](https://react.dev/learn/you-might-not-need-an-effect#initializing-the-application)
