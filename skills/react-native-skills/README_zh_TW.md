# React Native 指南 (React Native Guidelines)

[English Version](./README.md)

這是一個結構化的儲存庫，用於建立與維護針對代理人與 LLM 優化的 React Native 最佳實踐。

## 結構

- `rules/` - 各別的規則檔案（每個檔案一條規則）
  - `_sections.md` - 章節中繼資料（標題、影響程度、描述）
  - `_template.md` - 建立新規則的模板
  - `area-description.md` - 各別的規則檔案
- `metadata.json` - 文件中繼資料（版本、組織、摘要）
- **`AGENTS_zh_TW.md`** - 編譯後的輸出（產生的繁體中文版）

## 規則 (Rules)

### 核心渲染 (Core Rendering) (關鍵 CRITICAL)

- `rendering-text-in-text-component_zh_TW.md` - 將字串包裹在 Text 元件中
- `rendering-no-falsy-and_zh_TW.md` - 避免在 JSX 中使用會產生 falsy 值的 && 運算子

### 列表效能 (List Performance) (高 HIGH)

- `list-performance-virtualize_zh_TW.md` - 使用虛擬化列表 (LegendList, FlashList)
- `list-performance-function-references_zh_TW.md` - 保持穩定的物件引用
- `list-performance-callbacks_zh_TW.md` - 將回呼函數提升到列表根部
- `list-performance-inline-objects_zh_TW.md` - 避免在 renderItem 中使用內聯物件
- `list-performance-item-memo_zh_TW.md` - 傳遞原始型別以利記憶化 (memoization)
- `list-performance-item-expensive_zh_TW.md` - 保持列表項目的輕量化
- `list-performance-images_zh_TW.md` - 在列表中使用壓縮過的圖片
- `list-performance-item-types_zh_TW.md` - 對異質列表使用項目類型 (item types)

### 動畫 (Animation) (高 HIGH)

- `animation-gpu-properties_zh_TW.md` - 動畫化 transform/opacity 而非佈局屬性
- `animation-gesture-detector-press_zh_TW.md` - 使用 GestureDetector 處理點擊動畫
- `animation-derived-value_zh_TW.md` - 偏好使用 useDerivedValue 而非 useAnimatedReaction

### 滾動效能 (Scroll Performance) (高 HIGH)

- `scroll-position-no-state_zh_TW.md` - 切勿在 useState 中追蹤滾動位置

### 導覽 (Navigation) (高 HIGH)

- `navigation-native-navigators_zh_TW.md` - 使用原生堆疊 (native stack) 與原生標籤 (native tabs)

### React 狀態 (React State) (中 MEDIUM)

- `react-state-dispatcher_zh_TW.md` - 使用函數式 setState 更新
- `react-state-fallback_zh_TW.md` - 狀態應僅代表使用者意圖
- `react-state-minimize_zh_TW.md` - 最小化狀態變數，使用衍生值

### 狀態架構 (State Architecture) (中 MEDIUM)

- `state-ground-truth_zh_TW.md` - 狀態必須代表單一事實來源 (ground truth)

### React 編譯器 (React Compiler) (中 MEDIUM)

- `react-compiler-destructure-functions_zh_TW.md` - 儘早解構函數
- `react-compiler-reanimated-shared-values_zh_TW.md` - 對共享值使用 .get()/.set()

### 使用者介面 (User Interface) (中 MEDIUM)

- `ui-expo-image_zh_TW.md` - 使用 expo-image 優化圖片
- `ui-image-gallery_zh_TW.md` - 使用 Galeria 處理燈箱/圖庫
- `ui-menus_zh_TW.md` - 使用 Zeego 實作原生下拉與上下文選單
- `ui-native-modals_zh_TW.md` - 使用具備 formSheet 的原生 Modal
- `ui-pressable_zh_TW.md` - 使用 Pressable 代替 TouchableOpacity
- `ui-measure-views_zh_TW.md` - 測量視圖尺寸
- `ui-safe-area-scroll_zh_TW.md` - 使用 contentInsetAdjustmentBehavior
- `ui-scrollview-content-inset_zh_TW.md` - 使用 contentInset 處理動態間距
- `ui-styling_zh_TW.md` - 現代化樣式模式 (gap, boxShadow, 漸層)

### 設計系統 (Design System) (中 MEDIUM)

- `design-system-compound-components_zh_TW.md` - 使用複合元件

### Monorepo (低 LOW)

- `monorepo-native-deps-in-app_zh_TW.md` - 在 app 目錄中安裝原生依賴
- `monorepo-single-dependency-versions_zh_TW.md` - 單一依賴版本

### 第三方依賴 (Third-Party Dependencies) (低 LOW)

- `imports-design-system-folder_zh_TW.md` - 從設計系統資料夾匯入

### JavaScript (低 LOW)

- `js-hoist-intl_zh_TW.md` - 提升 Intl 格式化器的建立

### 字體 (Fonts) (低 LOW)

- `fonts-config-plugin_zh_TW.md` - 在建置時以原生方式載入字體

## 建立新規則

1. 將 `rules/_template.md` 複製到 `rules/area-description.md`
2. 選擇適當的領域前綴：
   - `rendering-` 用於核心渲染
   - `list-performance-` 用於列表效能
   - `animation-` 用於動畫
   - `scroll-` 用於滾動效能
   - `navigation-` 用於導覽
   - `react-state-` 用於 React 狀態
   - `state-` 用於狀態架構
   - `react-compiler-` 用於 React 編譯器
   - `ui-` 用於使用者介面
   - `design-system-` 用於設計系統
   - `monorepo-` 用於 Monorepo
   - `imports-` 用於第三方依賴
   - `js-` 用於 JavaScript
   - `fonts-` 用於字體
3. 填寫 frontmatter 與內容
4. 確保有清晰的範例與說明

## 規則檔案結構

每個規則檔案應遵循以下結構：

````markdown
---
title: 在此輸入規則標題
impact: MEDIUM
impactDescription: 選填的描述
tags: tag1, tag2, tag3
---

## 在此輸入規則標題 (Rule Title Here)

簡要說明規則及其重要性。

**錯誤示例 (描述哪裡錯了)：**

```tsx
// 錯誤的程式碼範例
```
````

**正確示例 (描述哪裡對了)：**

```tsx
// 正確的程式碼範例
```

參考資料：[連結](https://example.com)

```

## 檔案命名慣例

- 以 `_` 開頭的檔案是特殊的（不包含在建置中）
- 規則檔案：`area-description.md` (例如：`animation-gpu-properties.md`)
- 章節會根據檔案名稱前綴自動推斷
- 規則在每個章節內按標題字母順序排序

## 影響程度 (Impact Levels)

- `CRITICAL` (關鍵) - 最高優先順序，會導致當機或 UI 損壞
- `HIGH` (高) - 顯著的效能改進
- `MEDIUM` (中) - 中等程度的效能改進
- `LOW` (低) - 增量改進
```
