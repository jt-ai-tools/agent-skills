---
title: 預防水合不匹配且避免閃爍 (Prevent Hydration Mismatch Without Flickering)
impact: MEDIUM
impactDescription: 避免視覺閃爍和水合錯誤 (Hydration Errors)
tags: rendering, ssr, hydration, localStorage, flicker
---

[English Version](./rendering-hydration-no-flicker.md)

## 預防水合不匹配且避免閃爍 (Prevent Hydration Mismatch Without Flickering)

在渲染依賴於客戶端儲存（如 localStorage、cookies）的內容時，為了避免 SSR 錯誤以及水合後的視覺閃爍，可以注入一段同步執行的腳本 (Synchronous Script)，在 React 進行水合 (Hydration) 之前先更新 DOM。

**不正確的寫法 (導致 SSR 錯誤)：**

```tsx
function ThemeWrapper({ children }: { children: ReactNode }) {
  // localStorage 在伺服器端不可用 - 會拋出錯誤
  const theme = localStorage.getItem('theme') || 'light'
  
  return (
    <div className={theme}>
      {children}
    </div>
  )
}
```

伺服器端渲染會失敗，因為 `localStorage` 是未定義的 (undefined)。

**不正確的寫法 (導致視覺閃爍)：**

```tsx
function ThemeWrapper({ children }: { children: ReactNode }) {
  const [theme, setTheme] = useState('light')
  
  useEffect(() => {
    // 在水合後執行 - 導致可見的閃爍
    const stored = localStorage.getItem('theme')
    if (stored) {
      setTheme(stored)
    }
  }, [])
  
  return (
    <div className={theme}>
      {children}
    </div>
  )
}
```

組件首先使用預設值 (`light`) 渲染，然後在水合後更新，導致不正確內容的可見閃爍。

**正確的寫法 (無閃爍，無水合不匹配)：**

```tsx
function ThemeWrapper({ children }: { children: ReactNode }) {
  return (
    <>
      <div id="theme-wrapper">
        {children}
      </div>
      <script
        dangerouslySetInnerHTML={{
          __html: `
            (function() {
              try {
                var theme = localStorage.getItem('theme') || 'light';
                var el = document.getElementById('theme-wrapper');
                if (el) el.className = theme;
              } catch (e) {}
            })();
          `,
        }}
      />
    </>
  )
}
```

內聯腳本 (Inline Script) 在顯示元素之前同步執行，確保 DOM 已經具有正確的值。沒有閃爍，也沒有水合不匹配的問題。

這種模式對於主題切換、使用者偏好、身份驗證狀態以及任何應立即渲染而不要閃爍預設值的客戶端專用數據特別有用。
