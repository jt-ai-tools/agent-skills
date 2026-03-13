# 章節 (Sections)

[English Version](./_sections.md)

此文件定義了所有章節、其排序、影響層級以及說明。
章節 ID（括號內）是用於對規則進行分組的文件名前綴。

---

## 1. 核心渲染 (rendering)

**影響層級:** 關鍵 (CRITICAL)  
**說明:** React Native 核心渲染規則。違反這些規則會導致運行時崩潰或 UI 異常。

## 2. 列表效能 (list-performance)

**影響層級:** 高 (HIGH)  
**說明:** 優化虛擬化列表（FlatList, LegendList, FlashList），以實現流暢的滾動和快速更新。

## 3. 動畫 (animation)

**影響層級:** 高 (HIGH)  
**說明:** GPU 加速動畫、Reanimated 模式，以及避免在手勢操作期間產生渲染抖動 (render thrashing)。

## 4. 滾動效能 (scroll)

**影響層級:** 高 (HIGH)  
**說明:** 在不引起渲染抖動的情況下追蹤滾動位置。

## 5. 導覽 (navigation)

**影響層級:** 高 (HIGH)  
**說明:** 使用原生導覽器 (native navigators) 處理 stack 和 tab 導覽，而不是基於 JS 的替代方案。

## 6. React 狀態 (react-state)

**影響層級:** 中 (MEDIUM)  
**說明:** 管理 React 狀態的模式，以避免過時的閉包 (stale closures) 和不必要的重新渲染。

## 7. 狀態架構 (state)

**影響層級:** 中 (MEDIUM)  
**說明:** 狀態變數和衍生值 (derived values) 的唯一事實來源 (ground truth) 原則。

## 8. React 編譯器 (react-compiler)

**影響層級:** 中 (MEDIUM)  
**說明:** React 編譯器 (React Compiler) 與 React Native 及 Reanimated 的兼容性模式。

## 9. 使用者介面 (ui)

**影響層級:** 中 (MEDIUM)  
**說明:** 用於圖片、選單、Modal、樣式以及平台一致性介面的原生 UI 模式。

## 10. 設計系統 (design-system)

**影響層級:** 中 (MEDIUM)  
**說明:** 構建可維護組件庫的架構模式。

## 11. Monorepo (monorepo)

**影響層級:** 低 (LOW)  
**說明:** Monorepo 中的依賴管理和原生模組配置。

## 12. 第三方依賴 (imports)

**影響層級:** 低 (LOW)  
**說明:** 封裝並重新導出第三方依賴，以提高可維護性。

## 13. JavaScript (js)

**影響層級:** 低 (LOW)  
**說明:** 微優化 (Micro-optimizations)，例如提升 (hoisting) 高開銷對象的創建。

## 14. 字體 (fonts)

**影響層級:** 低 (LOW)  
**說明:** 原生字體加載，以提升效能。
