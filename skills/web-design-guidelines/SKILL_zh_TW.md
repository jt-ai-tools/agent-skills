---
name: web-design-guidelines
description: 審查 UI 程式碼是否符合網頁介面指南。當被要求「審查我的 UI」、「檢查無障礙性」、「稽核設計」、「審查 UX」或「根據最佳實踐檢查我的網站」時使用。
metadata:
  author: vercel
  version: "1.0.0"
  argument-hint: <檔案或模式>
---

# 網頁介面指南 (Web Interface Guidelines)

[English Version](./SKILL.md)

審查檔案是否符合網頁介面指南。

## 運作方式

1. 從下方的來源 URL 獲取最新的指南
2. 讀取指定的檔案（或提示使用者提供檔案/模式）
3. 根據獲取指南中的所有規則進行檢查
4. 以簡潔的 `file:line` 格式輸出結果

## 指南來源

每次審查前請獲取最新的指南：

```
https://raw.githubusercontent.com/vercel-labs/web-interface-guidelines/main/command.md
```

使用 WebFetch 檢索最新的規則。獲取的內容包含所有規則及輸出格式指令。

## 用法

當使用者提供檔案或模式引數時：
1. 從上方的來源 URL 獲取指南
2. 讀取指定的檔案
3. 應用獲取指南中的所有規則
4. 使用指南中指定的格式輸出結果

如果未指定檔案，請詢問使用者要審查哪些檔案。
