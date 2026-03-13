---
title: 使用備用狀態而非 initialState
impact: MEDIUM
impactDescription: 無需同步的響應式備用方案
tags: state, hooks, derived-state, props, initialState
---

[English Version](./react-state-fallback.md)

## 使用備用狀態而非 initialState

使用 `undefined` 作為初始狀態，並利用空值合併運算子 (`??`) 備用到父組件或伺服器的值。狀態僅代表使用者的意圖 — `undefined` 意味著「使用者尚未選擇」。這可以實現響應式備用方案，當來源變更時會自動更新，而不僅僅是在初始渲染時。

**錯誤（同步狀態，失去響應性）：**

```tsx
type Props = { fallbackEnabled: boolean }

function Toggle({ fallbackEnabled }: Props) {
  const [enabled, setEnabled] = useState(defaultEnabled)
  // 如果 fallbackEnabled 變更，狀態會過時
  // 狀態混合了使用者意圖與預設值

  return <Switch value={enabled} onValueChange={setEnabled} />
}
```

**正確（狀態是使用者意圖，響應式備用）：**

```tsx
type Props = { fallbackEnabled: boolean }

function Toggle({ fallbackEnabled }: Props) {
  const [_enabled, setEnabled] = useState<boolean | undefined>(undefined)
  const enabled = _enabled ?? defaultEnabled
  // undefined = 使用者尚未更動，備用到 prop
  // 如果 defaultEnabled 變更，組件會反映出來
  // 一旦使用者進行互動，他們的選擇就會持久存在

  return <Switch value={enabled} onValueChange={setEnabled} />
}
```

**配合伺服器數據：**

```tsx
function ProfileForm({ data }: { data: User }) {
  const [_theme, setTheme] = useState<string | undefined>(undefined)
  const theme = _theme ?? data.theme
  // 在使用者覆寫之前顯示伺服器端的值
  // 伺服器重新抓取資料時會自動更新備用值

  return <ThemePicker value={theme} onChange={setTheme} />
}
```
