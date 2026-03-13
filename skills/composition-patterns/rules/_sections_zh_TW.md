# 章節 (Sections)

[English Version](./_sections.md)

本文件定義了所有章節、其排序、影響程度與描述。章節 ID（在括號中）是用於對規則進行分組的檔案名稱前綴。

---

## 1. 元件架構 (architecture)

**影響程度：** 高 (HIGH)  
**描述：** 用於結構化元件的基本模式，以避免屬性激增並實現彈性的組合。

## 2. 狀態管理 (state)

**影響程度：** 中 (MEDIUM)  
**描述：** 用於在組合元件中提升狀態與管理共享 Context 的模式。

## 3. 實作模式 (patterns)

**影響程度：** 中 (MEDIUM)  
**描述：** 實作複合元件與 Context Provider 的特定技術。

## 4. React 19 API (react19)

**影響程度：** 中 (MEDIUM)  
**描述：** 僅限 React 19+。不要使用 `forwardRef`；使用 `use()` 代替 `useContext()`。
