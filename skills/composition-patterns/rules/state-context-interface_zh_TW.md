---
title: 為依賴注入定義通用的 Context 介面 (Define Generic Context Interfaces for Dependency Injection)
impact: HIGH
impactDescription: 讓狀態可以在不同使用案例中進行依賴注入
tags: composition, context, state, typescript, dependency-injection
---

[English Version](./state-context-interface.md)

## 為依賴注入定義通用的 Context 介面

為你的元件 Context 定義一個**通用介面（generic interface）**，包含三個部分：`state`、`actions` 和 `meta`。這個介面是一個契約，任何 Provider 都可以實作它——這使得相同的 UI 元件可以與完全不同的狀態實作協作。

**核心原則：** 提升狀態（Lift state）、組合內部結構（compose internals）、使狀態可進行依賴注入（dependency-injectable）。

**不正確（UI 與特定的狀態實作耦合）：**

```tsx
function ComposerInput() {
  // 與特定的 hook 緊密耦合
  const { input, setInput } = useChannelComposerState()
  return <TextInput value={input} onChangeText={setInput} />
}
```

**正確（通用介面實現依賴注入）：**

```tsx
// 定義一個任何 Provider 都可以實作的通用介面
interface ComposerState {
  input: string
  attachments: Attachment[]
  isSubmitting: boolean
}

interface ComposerActions {
  update: (updater: (state: ComposerState) => ComposerState) => void
  submit: () => void
}

interface ComposerMeta {
  inputRef: React.RefObject<TextInput>
}

interface ComposerContextValue {
  state: ComposerState
  actions: ComposerActions
  meta: ComposerMeta
}

const ComposerContext = createContext<ComposerContextValue | null>(null)
```

**UI 元件消費介面，而非實作：**

```tsx
function ComposerInput() {
  const {
    state,
    actions: { update },
    meta,
  } = use(ComposerContext)

  // 此元件可與任何實作該介面的 Provider 協作
  return (
    <TextInput
      ref={meta.inputRef}
      value={state.input}
      onChangeText={(text) => update((s) => ({ ...s, input: text }))}
    />
  )
}
```

**不同的 Provider 實作相同的介面：**

```tsx
// Provider A：用於臨時表單的本地狀態
function ForwardMessageProvider({ children }: { children: React.ReactNode }) {
  const [state, setState] = useState(initialState)
  const inputRef = useRef(null)
  const submit = useForwardMessage()

  return (
    <ComposerContext
      value={{
        state,
        actions: { update: setState, submit },
        meta: { inputRef },
      }}
    >
      {children}
    </ComposerContext>
  )
}

// Provider B：用於頻道的全域同步狀態
function ChannelProvider({ channelId, children }: Props) {
  const { state, update, submit } = useGlobalChannel(channelId)
  const inputRef = useRef(null)

  return (
    <ComposerContext
      value={{
        state,
        actions: { update, submit },
        meta: { inputRef },
      }}
    >
      {children}
    </ComposerContext>
  )
}
```

**相同的組合 UI 可與兩者協作：**

```tsx
// 與 ForwardMessageProvider（本地狀態）協作
<ForwardMessageProvider>
  <Composer.Frame>
    <Composer.Input />
    <Composer.Submit />
  </Composer.Frame>
</ForwardMessageProvider>

// 與 ChannelProvider（全域同步狀態）協作
<ChannelProvider channelId="abc">
  <Composer.Frame>
    <Composer.Input />
    <Composer.Submit />
  </Composer.Frame>
</ChannelProvider>
```

**元件外部的自定義 UI 可以存取狀態和操作：**

Provider 的邊界才是關鍵——而不是視覺上的嵌套。需要共享狀態的元件不需要位在 `Composer.Frame` 內部。它們只需要位於 Provider 內部即可。

```tsx
function ForwardMessageDialog() {
  return (
    <ForwardMessageProvider>
      <Dialog>
        {/* Composer UI */}
        <Composer.Frame>
          <Composer.Input placeholder="Add a message, if you'd like." />
          <Composer.Footer>
            <Composer.Formatting />
            <Composer.Emojis />
          </Composer.Footer>
        </Composer.Frame>

        {/* 位於 Composer 外部，但在 Provider 內部的自定義 UI */}
        <MessagePreview />

        {/* 對話框底部的操作按鈕 */}
        <DialogActions>
          <CancelButton />
          <ForwardButton />
        </DialogActions>
      </Dialog>
    </ForwardMessageProvider>
  )
}

// 此按鈕位於 Composer.Frame 外部，但仍可根據其 Context 進行提交！
function ForwardButton() {
  const {
    actions: { submit },
  } = use(ComposerContext)
  return <Button onPress={submit}>Forward</Button>
}

// 此預覽位於 Composer.Frame 外部，但可以讀取 Composer 的狀態！
function MessagePreview() {
  const { state } = use(ComposerContext)
  return <Preview message={state.input} attachments={state.attachments} />
}
```

`ForwardButton` 和 `MessagePreview` 在視覺上並非位於 Composer 框內，但它們仍然可以存取其狀態和操作。這就是將狀態提升到 Provider 中的力量。

UI 是你組合在一起的可重用片段。狀態由 Provider 進行依賴注入。更換 Provider，保留 UI。
