---
title: Use Single Dependency Versions Across Monorepo
impact: MEDIUM
impactDescription: avoids duplicate bundles, version conflicts
tags: monorepo, dependencies, installation
---

[English Version](./monorepo-single-dependency-versions.md)

## 在整個 Monorepo 中使用單一依賴項目版本

在 monorepo 的所有套件中，對每個依賴項目使用單一版本。優先使用確切版本 (exact versions) 而不是版本範圍 (ranges)。多個版本會導致 bundle 中出現重複程式碼、執行期衝突以及套件間的行為不一致。

使用像 syncpack 這樣的工具來強制執行此規則。作為最後的手段，請使用 yarn resolutions 或 npm overrides。

**不正確（版本範圍、多個版本）：**

```json
// packages/app/package.json
{
  "dependencies": {
    "react-native-reanimated": "^3.0.0"
  }
}

// packages/ui/package.json
{
  "dependencies": {
    "react-native-reanimated": "^3.5.0"
  }
}
```

**正確（確切版本、單一事實來源）：**

```json
// package.json (根目錄)
{
  "pnpm": {
    "overrides": {
      "react-native-reanimated": "3.16.1"
    }
  }
}

// packages/app/package.json
{
  "dependencies": {
    "react-native-reanimated": "3.16.1"
  }
}

// packages/ui/package.json
{
  "dependencies": {
    "react-native-reanimated": "3.16.1"
  }
}
```

使用套件管理器的 override/resolution 功能在根目錄中強制執行版本。新增依賴項目時，請指定確切版本，不要使用 `^` 或 `~`。
