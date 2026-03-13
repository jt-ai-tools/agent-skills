---
title: 將狀態提升至 Provider 元件 (Lift State into Provider Components)
impact: HIGH
impactDescription: 實現元件邊界外的狀態共享
tags: composition, state, context, providers
---

# 將狀態提升至 Provider 元件 (Lift State into Provider Components)

[English Version](./state-lift-state.md)

將狀態管理移至專用的 Provider 元件中。這允許主 UI 之外的同層元件存取並修改狀態，而無需屬性鑽取 (prop drilling) 或彆扭的 Ref。

**錯誤示例 (狀態困在元件內部)：**

```tsx
function ForwardMessageComposer() {
  const [state, setState] = useState(initialState)
  const forwardMessage = useForwardMessage()

  return (
    <Composer.Frame>
      <Composer.Input />
      <Composer.Footer />
    </Composer.Frame>
  )
}

// 問題：此按鈕如何存取編輯器的狀態？
function ForwardMessageDialog() {
  return (
    <Dialog>
      <ForwardMessageComposer />
      <MessagePreview /> {/* 需要編輯器狀態 */}
      <DialogActions>
        <CancelButton />
        <ForwardButton /> {/* 需要呼叫提交 (submit) */}
      </DialogActions>
    </Dialog>
  )
}
```

**錯誤示例 (使用 useEffect 同步狀態)：**

```tsx
function ForwardMessageDialog() {
  const [input, setInput] = useState('')
  return (
    <Dialog>
      <ForwardMessageComposer onInputChange={setInput} />
      <MessagePreview input={input} />
    </Dialog>
  )
}

function ForwardMessageComposer({ onInputChange }) {
  const [state, setState] = useState(initialState)
  useEffect(() => {
    onInputChange(state.input) // 每次變更都同步 😬
  }, [state.input])
}
```

**錯誤示例 (在提交時從 Ref 讀取狀態)：**

```tsx
function ForwardMessageDialog() {
  const stateRef = useRef(null)
  return (
    <Dialog>
      <ForwardMessageComposer stateRef={stateRef} />
      <ForwardButton onPress={() => submit(stateRef.current)} />
    </Dialog>
  )
}
```

**正確示例 (狀態提升至 Provider)：**

```tsx
function ForwardMessageProvider({ children }: { children: React.ReactNode }) {
  const [state, setState] = useState(initialState)
  const forwardMessage = useForwardMessage()
  const inputRef = useRef(null)

  return (
    <Composer.Provider
      state={state}
      actions={{ update: setState, submit: forwardMessage }}
      meta={{ inputRef }}
    >
      {children}
    </Composer.Provider>
  )
}

function ForwardMessageDialog() {
  return (
    <ForwardMessageProvider>
      <Dialog>
        <ForwardMessageComposer />
        <MessagePreview /> {/* 自定義元件可以存取狀態與動作 */}
        <DialogActions>
          <CancelButton />
          <ForwardButton /> {/* 自定義元件可以存取狀態與動作 */}
        </DialogActions>
      </Dialog>
    </ForwardMessageProvider>
  )
}

function ForwardButton() {
  const { actions } = use(Composer.Context)
  return <Button onPress={actions.submit}>轉傳</Button>
}
```

`ForwardButton` 位於 `Composer.Frame` 之外，但由於它在 Provider 內，因此仍可存取提交動作。即便它是個一次性的元件，它仍能從 UI 本身之外存取編輯器的狀態與動作。

**關鍵見解：**需要共享狀態的元件不一定要在視覺上互相嵌套 —— 它們只需要在同一個 Provider 內即可。
