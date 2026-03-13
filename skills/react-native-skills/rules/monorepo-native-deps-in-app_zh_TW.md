---
title: Install Native Dependencies in App Directory
impact: CRITICAL
impactDescription: required for autolinking to work
tags: monorepo, native, autolinking, installation
---

[English Version](./monorepo-native-deps-in-app.md)

## 在應用程式目錄中安裝原生依賴項目 (Native Dependencies)

在 monorepo 中，具有原生程式碼的套件必須直接安裝在原生應用程式的目錄中。自動連結 (Autolinking) 僅掃描應用程式的 `node_modules`——它不會找到安裝在其他套件中的原生依賴項目。

**不正確（僅在共享套件中包含原生依賴）：**

```
packages/
  ui/
    package.json  # 包含 react-native-reanimated
  app/
    package.json  # 缺少 react-native-reanimated
```

自動連結失敗——原生程式碼未被連結。

**正確（在應用程式目錄中包含原生依賴）：**

```
packages/
  ui/
    package.json  # 包含 react-native-reanimated
  app/
    package.json  # 同樣包含 react-native-reanimated
```

```json
// packages/app/package.json
{
  "dependencies": {
    "react-native-reanimated": "3.16.1"
  }
}
```

即使共享套件使用了原生依賴項目，應用程式也必須列出它，以便自動連結偵測並連結原生程式碼。
