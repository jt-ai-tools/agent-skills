---
title: 將互動邏輯放在事件處理函式中
impact: MEDIUM
impactDescription: 避免 Effect 重複執行與重複的副作用
tags: rerender, useEffect, events, side-effects, dependencies
---

[English Version](./rerender-move-effect-to-event.md)

## 將互動邏輯放在事件處理函式中

如果一個副作用是由特定的使用者操作（提交、點擊、拖拽）觸發的，請在該事件處理函式中執行它。不要將該操作建模為「狀態 + Effect」；這會導致 Effect 在無關的變更時重新執行，並可能導致操作被重複執行。

**錯誤（將事件建模為狀態 + Effect）：**

```tsx
function Form() {
  const [submitted, setSubmitted] = useState(false)
  const theme = useContext(ThemeContext)

  useEffect(() => {
    if (submitted) {
      post('/api/register')
      showToast('Registered', theme)
    }
  }, [submitted, theme])

  return <button onClick={() => setSubmitted(true)}>Submit</button>
}
```

**正確（在處理函式中執行）：**

```tsx
function Form() {
  const theme = useContext(ThemeContext)

  function handleSubmit() {
    post('/api/register')
    showToast('Registered', theme)
  }

  return <button onClick={handleSubmit}>Submit</button>
}
```

參考資料：[這段程式碼是否應該移至事件處理函式？ (Should this code move to an event handler?)](https://react.dev/learn/removing-effect-dependencies#should-this-code-move-to-an-event-handler)
