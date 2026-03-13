---
name: vercel-react-native-skills
description:
  用於建立高效能行動應用程式的 React Native 與 Expo 最佳實踐。在建立 React Native 元件、優化列表效能、實作動畫或處理原生模組時使用。適用於涉及 React Native、Expo、行動裝置效能或原生平台 API 的任務。
license: MIT
metadata:
  author: vercel
  version: '1.0.0'
---

# React Native 技能 (React Native Skills)

[English Version](./SKILL.md)

React Native 與 Expo 應用程式的全面最佳實踐。包含涵蓋效能、動畫、UI 模式與平台特定優化等多個類別的規則。

## 何時適用

在以下情況參考這些指南：

- 建立 React Native 或 Expo 應用程式
- 優化列表與滾動效能
- 使用 Reanimated 實作動畫
- 處理圖片與媒體
- 配置原生模組或字體
- 結構化具有原生依賴項的 monorepo 專案

## 依優先順序排序的規則類別

| 優先順序 | 類別 | 影響程度 | 前綴 |
| -------- | ---------------- | -------- | -------------------- |
| 1 | 列表效能 (List Performance) | 關鍵 (CRITICAL) | `list-performance-` |
| 2 | 動畫 (Animation) | 高 (HIGH) | `animation-` |
| 3 | 導覽 (Navigation) | 高 (HIGH) | `navigation-` |
| 4 | UI 模式 (UI Patterns) | 高 (HIGH) | `ui-` |
| 5 | 狀態管理 (State Management) | 中 (MEDIUM) | `react-state-` |
| 6 | 渲染 (Rendering) | 中 (MEDIUM) | `rendering-` |
| 7 | Monorepo | 中 (MEDIUM) | `monorepo-` |
| 8 | 配置 (Configuration) | 低 (LOW) | `fonts-`, `imports-` |

## 快速參考

### 1. 列表效能 (CRITICAL)

- `list-performance-virtualize` - 對大型列表使用 FlashList
- `list-performance-item-memo` - 記憶化 (memoize) 列表項目元件
- `list-performance-callbacks` - 穩定回呼函數的引用
- `list-performance-inline-objects` - 避免使用內聯樣式物件
- `list-performance-function-references` - 將函數提取到渲染邏輯之外
- `list-performance-images` - 優化列表中的圖片
- `list-performance-item-expensive` - 將耗時工作移出列表項目
- `list-performance-item-types` - 對異質列表使用項目類型 (item types)

### 2. 動畫 (HIGH)

- `animation-gpu-properties` - 僅對 transform 與 opacity 進行動畫化
- `animation-derived-value` - 對計算型動畫使用 useDerivedValue
- `animation-gesture-detector-press` - 使用 Gesture.Tap 代替 Pressable

### 3. 導覽 (HIGH)

- `navigation-native-navigators` - 偏好使用原生堆疊與原生標籤而非 JS 導覽器

### 4. UI 模式 (HIGH)

- `ui-expo-image` - 對所有圖片使用 expo-image
- `ui-image-gallery` - 使用 Galeria 實作圖片燈箱
- `ui-pressable` - 偏好使用 Pressable 而非 TouchableOpacity
- `ui-safe-area-scroll` - 在 ScrollViews 中處理安全區域 (safe areas)
- `ui-scrollview-content-inset` - 對頁首使用 contentInset
- `ui-menus` - 使用原生上下文選單
- `ui-native-modals` - 盡可能使用原生互動視窗 (modals)
- `ui-measure-views` - 使用 onLayout 而非 measure()
- `ui-styling` - 使用 StyleSheet.create 或 Nativewind

### 5. 狀態管理 (MEDIUM)

- `react-state-minimize` - 最小化狀態訂閱
- `react-state-dispatcher` - 對回呼函數使用 dispatcher 模式
- `react-state-fallback` - 在首次渲染時顯示後備 (fallback) 內容
- `react-compiler-destructure-functions` - 為 React 編譯器進行解構
- `react-compiler-reanimated-shared-values` - 使用編譯器處理共享值

### 6. 渲染 (MEDIUM)

- `rendering-text-in-text-component` - 將文本包裹在 Text 元件中
- `rendering-no-falsy-and` - 避免在條件渲染中使用會產生 falsy 值的 &&

### 7. Monorepo (MEDIUM)

- `monorepo-native-deps-in-app` - 將原生依賴項保留在 app 套件中
- `monorepo-single-dependency-versions` - 在各套件間使用單一版本

### 8. 配置 (LOW)

- `fonts-config-plugin` - 對自定義字體使用配置插件 (config plugins)
- `imports-design-system-folder` - 組織設計系統匯入路徑
- `js-hoist-intl` - 提升 Intl 物件的建立

## 如何使用

閱讀各別規則檔案以獲取詳細說明與程式碼範例：

```
rules/list-performance-virtualize_zh_TW.md
rules/animation-gpu-properties_zh_TW.md
```

每個規則檔案包含：

- 說明其重要性的簡述
- 錯誤的程式碼範例與說明
- 正確的程式碼範例與說明
- 額外的上下文與參考資料

## 完整彙編文件

關於包含所有擴展規則的完整指南：`AGENTS_zh_TW.md`
