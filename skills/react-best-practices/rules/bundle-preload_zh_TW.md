---
title: 根據使用者意圖進行預載
impact: MEDIUM
impactDescription: 降低感知延遲
tags: bundle, preload, user-intent, hover
---

[English Version](./bundle-preload.md)

## 根據使用者意圖進行預載

在需要之前預載大型打包檔案，以降低感知延遲。

**範例（在懸停/聚焦時預載）：**

```tsx
function EditorButton({ onClick }: { onClick: () => void }) {
  const preload = () => {
    if (typeof window !== 'undefined') {
      void import('./monaco-editor')
    }
  }

  return (
    <button
      onMouseEnter={preload}
      onFocus={preload}
      onClick={onClick}
    >
      Open Editor
    </button>
  )
}
```

**範例（在功能切換啟用時預載）：**

```tsx
function FlagsProvider({ children, flags }: Props) {
  useEffect(() => {
    if (flags.editorEnabled && typeof window !== 'undefined') {
      void import('./monaco-editor').then(mod => mod.init())
    }
  }, [flags.editorEnabled])

  return <FlagsContext.Provider value={flags}>
    {children}
  </FlagsContext.Provider>
}
```

`typeof window !== 'undefined'` 檢查可防止為 SSR 打包預載模組，從而優化伺服器打包大小和建置速度。
