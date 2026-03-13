---
title: 使用被動事件監聽器提升滾動效能
impact: MEDIUM
impactDescription: 消除由事件監聽器引起的滾動延遲
tags: client, event-listeners, scrolling, performance, touch, wheel
---

[English Version](./client-passive-event-listeners.md)

## 使用被動事件監聽器提升滾動效能

在觸控（touch）和滾輪（wheel）事件監聽器中加入 `{ passive: true }` 以啟用立即滾動。瀏覽器通常會等待監聽器執行完畢以檢查是否呼叫了 `preventDefault()`，這會導致滾動延遲。

**錯誤做法：**

```typescript
useEffect(() => {
  const handleTouch = (e: TouchEvent) => console.log(e.touches[0].clientX)
  const handleWheel = (e: WheelEvent) => console.log(e.deltaY)
  
  document.addEventListener('touchstart', handleTouch)
  document.addEventListener('wheel', handleWheel)
  
  return () => {
    document.removeEventListener('touchstart', handleTouch)
    document.removeEventListener('wheel', handleWheel)
  }
}, [])
```

**正確做法：**

```typescript
useEffect(() => {
  const handleTouch = (e: TouchEvent) => console.log(e.touches[0].clientX)
  const handleWheel = (e: WheelEvent) => console.log(e.deltaY)
  
  document.addEventListener('touchstart', handleTouch, { passive: true })
  document.addEventListener('wheel', handleWheel, { passive: true })
  
  return () => {
    document.removeEventListener('touchstart', handleTouch)
    document.removeEventListener('wheel', handleWheel)
  }
}, [])
```

**在以下情況使用被動（passive）：** 追蹤/數據分析、日誌記錄，任何不呼叫 `preventDefault()` 的監聽器。

**不要在以下情況使用被動（passive）：** 實作自定義滑動手勢、自定義縮放控制，或任何需要 `preventDefault()` 的監聽器。
