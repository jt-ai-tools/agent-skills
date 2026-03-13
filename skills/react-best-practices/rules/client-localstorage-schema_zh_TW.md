---
title: 為 localStorage 數據進行版本控制與最小化
impact: MEDIUM
impactDescription: 防止架構衝突，減少儲存體積
tags: client, localStorage, storage, versioning, data-minimization
---

[English Version](./client-localstorage-schema.md)

## 為 localStorage 數據進行版本控制與最小化

為鍵值 (keys) 添加版本前綴，且僅儲存需要的欄位。這可以防止架構衝突並避免意外儲存敏感數據。

**不正確：**

```typescript
// 沒有版本控制，儲存所有內容，沒有錯誤處理
localStorage.setItem('userConfig', JSON.stringify(fullUserObject))
const data = localStorage.getItem('userConfig')
```

**正確：**

```typescript
const VERSION = 'v2'

function saveConfig(config: { theme: string; language: string }) {
  try {
    localStorage.setItem(`userConfig:${VERSION}`, JSON.stringify(config))
  } catch {
    // 在無痕/私密瀏覽、超過配額或被停用時會拋出錯誤
  }
}

function loadConfig() {
  try {
    const data = localStorage.getItem(`userConfig:${VERSION}`)
    return data ? JSON.parse(data) : null
  } catch {
    return null
  }
}

// 從 v1 遷移到 v2
function migrate() {
  try {
    const v1 = localStorage.getItem('userConfig:v1')
    if (v1) {
      const old = JSON.parse(v1)
      saveConfig({ theme: old.darkMode ? 'dark' : 'light', language: old.lang })
      localStorage.removeItem('userConfig:v1')
    }
  } catch {}
}
```

**僅儲存伺服器回應中的最小欄位：**

```typescript
// User 物件有 20 多個欄位，僅儲存 UI 需要的內容
function cachePrefs(user: FullUser) {
  try {
    localStorage.setItem('prefs:v1', JSON.stringify({
      theme: user.preferences.theme,
      notifications: user.preferences.notifications
    }))
  } catch {}
}
```

**務必包裹在 try-catch 中：** `getItem()` 和 `setItem()` 在無痕/私密瀏覽（Safari, Firefox）、超過配額或被停用時會拋出錯誤。

**優點：** 透過版本控制進行架構演進、減少儲存體積、防止儲存 token/PII/內部標記。
