---
name: vercel-composition-patterns
description:
  可擴展的 React 組合模式。在重構具有布林屬性激增的元件、建立具彈性的元件庫或設計可重複使用的 API 時使用。適用於涉及複合元件、render props、context providers 或元件架構的任務。包含 React 19 API 變更。
license: MIT
metadata:
  author: vercel
  version: '1.0.0'
---

# React 組合模式 (React Composition Patterns)

[English Version](./SKILL.md)

用於建立具彈性、可維護的 React 元件的組合模式。透過使用複合元件、提升狀態與組合內部結構，避免布林屬性 (boolean prop) 的激增。這些模式使得程式碼庫在擴展時，對人類與 AI 代理人而言都更容易處理。

## 何時適用

在以下情況參考這些指南：

- 重構具有許多布林屬性的元件
- 建立可重複使用的元件庫
- 設計具彈性的元件 API
- 審查元件架構
- 處理複合元件或 context providers

## 依優先順序排序的規則類別

| 優先順序 | 類別 | 影響程度 | 前綴 |
| -------- | ----------------------- | ------ | --------------- |
| 1 | 元件架構 (Component Architecture) | 高 (HIGH) | `architecture-` |
| 2 | 狀態管理 (State Management) | 中 (MEDIUM) | `state-` |
| 3 | 實作模式 (Implementation Patterns) | 中 (MEDIUM) | `patterns-` |
| 4 | React 19 API | 中 (MEDIUM) | `react19-` |

## 快速參考

### 1. 元件架構 (HIGH)

- `architecture-avoid-boolean-props` - 不要添加布林屬性來客製化行為；請使用組合模式
- `architecture-compound-components` - 使用共享 Context 結構化複雜元件

### 2. 狀態管理 (MEDIUM)

- `state-decouple-implementation` - Provider 是唯一知道如何管理狀態的地方
- `state-context-interface` - 定義包含 state、actions、meta 的通用介面以進行相依注入
- `state-lift-state` - 將狀態移至 Provider 元件中以供同層元件存取

### 3. 實作模式 (MEDIUM)

- `patterns-explicit-variants` - 建立明確的變體元件，而非布林模式
- `patterns-children-over-render-props` - 使用 children 進行組合，而非 renderX 屬性

### 4. React 19 API (MEDIUM)

> **⚠️ 僅限 React 19+。** 如果使用的是 React 18 或更早版本，請跳過此章節。

- `react19-no-forwardref` - 不要使用 `forwardRef`；使用 `use()` 代替 `useContext()`

## 如何使用

閱讀各別規則檔案以獲取詳細說明與程式碼範例：

```
rules/architecture-avoid-boolean-props_zh_TW.md
rules/state-context-interface_zh_TW.md
```

每個規則檔案包含：

- 說明其重要性的簡述
- 錯誤的程式碼範例與說明
- 正確的程式碼範例與說明
- 額外的上下文與參考資料

## 完整彙編文件

關於包含所有擴展規則的完整指南：`AGENTS_zh_TW.md`
