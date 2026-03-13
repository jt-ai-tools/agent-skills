---
title: 優化 SVG 精度 (Optimize SVG Precision)
impact: LOW
impactDescription: 減少檔案大小
tags: rendering, svg, optimization, svgo
---

[English Version](./rendering-svg-precision.md)

## 優化 SVG 精度 (Optimize SVG Precision)

**影響程度：低 (減少檔案大小)**

減少 SVG 的坐標精度以縮減檔案大小。最佳精度取決於 `viewBox` 的大小，但通常應考慮減少精度。

**不正確 (過度精確)：**

```svg
<path d="M 10.293847 20.847362 L 30.938472 40.192837" />
```

**正確 (保留 1 位小數)：**

```svg
<path d="M 10.3 20.8 L 30.9 40.2" />
```

**使用 SVGO 自動化：**

```bash
npx svgo --precision=1 --multipass icon.svg
```
