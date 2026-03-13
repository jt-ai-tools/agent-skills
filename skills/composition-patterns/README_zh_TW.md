# React 組合模式 (React Composition Patterns)

[English Version](./README.md)

這是一個結構化的儲存庫，收錄了可擴展的 React 組合模式。這些模式透過使用複合元件、提升狀態與組合內部結構，協助避免布林屬性 (boolean prop) 的激增。

## 結構

- `rules/` - 各別的規則檔案（每個檔案一條規則）
  - `_sections.md` - 章節中繼資料（標題、影響程度、描述）
  - `_template.md` - 建立新規則的模板
  - `area-description.md` - 各別的規則檔案
- `metadata.json` - 文件中繼資料（版本、組織、摘要）
- **`AGENTS_zh_TW.md`** - 編譯後的輸出（產生的繁體中文版）

## 規則 (Rules)

### 元件架構 (Component Architecture) (關鍵 CRITICAL)

- `architecture-avoid-boolean-props_zh_TW.md` - 不要添加布林屬性來客製化行為
- `architecture-compound-components_zh_TW.md` - 將結構化為具共享 Context 的複合元件

### 狀態管理 (State Management) (高 HIGH)

- `state-lift-state_zh_TW.md` - 將狀態提升至 Provider 元件
- `state-context-interface_zh_TW.md` - 定義清晰的 Context 介面 (state/actions/meta)
- `state-decouple-implementation_zh_TW.md` - 將狀態管理與 UI 解耦

### 實作模式 (Implementation Patterns) (中 MEDIUM)

- `patterns-children-over-render-props_zh_TW.md` - 偏好 Children 而非 renderX 屬性
- `patterns-explicit-variants_zh_TW.md` - 建立明確的元件變體

## 核心原則

1. **組合優於配置 (Composition over configuration)** — 與其增加屬性，不如讓使用者自行組合。
2. **提升您的狀態 (Lift your state)** — 將狀態放在 Provider 中，而不是困在元件內部。
3. **組合您的內部結構 (Compose your internals)** — 子元件應存取 Context，而非 Props。
4. **明確的變體 (Explicit variants)** — 建立 ThreadComposer、EditComposer，而不是帶有 isThread 的 Composer。

## 建立新規則

1. 將 `rules/_template.md` 複製到 `rules/area-description.md`
2. 選擇適當的領域前綴：
   - `architecture-` 用於元件架構
   - `state-` 用於狀態管理
   - `patterns-` 用於實作模式
3. 填寫 frontmatter 與內容
4. 確保有清晰的範例與說明

## 影響程度 (Impact Levels)

- `CRITICAL` (關鍵) - 基礎模式，防止產生難以維護的程式碼。
- `HIGH` (高) - 顯著提升可維護性。
- `MEDIUM` (中) - 讓程式碼更簡潔的優良實踐。
