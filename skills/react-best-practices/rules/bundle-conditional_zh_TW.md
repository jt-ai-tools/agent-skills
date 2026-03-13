---
title: 條件式模組載入
impact: HIGH
impactDescription: 僅在需要時載入大型數據
tags: bundle, conditional-loading, lazy-loading
---

[English Version](./bundle-conditional.md)

## 條件式模組載入

僅在功能被啟用時載入大型數據或模組。

**範例（延遲載入動畫幀）：**

```tsx
function AnimationPlayer({ enabled, setEnabled }: { enabled: boolean; setEnabled: React.Dispatch<React.SetStateAction<boolean>> }) {
  const [frames, setFrames] = useState<Frame[] | null>(null)

  useEffect(() => {
    if (enabled && !frames && typeof window !== 'undefined') {
      import('./animation-frames.js')
        .then(mod => setFrames(mod.frames))
        .catch(() => setEnabled(false))
    }
  }, [enabled, frames, setEnabled])

  if (!frames) return <Skeleton />
  return <Canvas frames={frames} />
}
```

`typeof window !== 'undefined'` 檢查可防止為 SSR 打包此模組，從而優化伺服器打包大小和建置速度。
