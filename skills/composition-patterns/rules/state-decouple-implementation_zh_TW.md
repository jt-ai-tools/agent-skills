---
title: 將狀態管理與 UI 解耦 (Decouple State Management from UI)
impact: MEDIUM
impactDescription: 可以在不更改 UI 的情況下更換狀態實作
tags: composition, state, architecture
---

[English Version](./state-decouple-implementation.md)

## 將狀態管理與 UI 解耦

Provider 元件應該是唯一知道狀態如何管理的地方。UI 元件消費 Context 介面——它們不知道狀態是來自 `useState`、Zustand 還是伺服器同步。

**不正確（UI 與狀態實作耦合）：**

```tsx
function ChannelComposer({ channelId }: { channelId: string }) {
  // UI 元件知道全域狀態的實作方式
  const state = useGlobalChannelState(channelId)
  const { submit, updateInput } = useChannelSync(channelId)

  return (
    <Composer.Frame>
      <Composer.Input
        value={state.input}
        onChange={(text) => sync.updateInput(text)}
      />
      <Composer.Submit onPress={() => sync.submit()} />
    </Composer.Frame>
  )
}
```

**正確（狀態管理被隔離在 Provider 中）：**

```tsx
// Provider 處理所有狀態管理的細節
function ChannelProvider({
  channelId,
  children,
}: {
  channelId: string
  children: React.ReactNode
}) {
  const { state, update, submit } = useGlobalChannel(channelId)
  const inputRef = useRef(null)

  return (
    <Composer.Provider
      state={state}
      actions={{ update, submit }}
      meta={{ inputRef }}
    >
      {children}
    </Composer.Provider>
  )
}

// UI 元件只知道 Context 介面
function ChannelComposer() {
  return (
    <Composer.Frame>
      <Composer.Header />
      <Composer.Input />
      <Composer.Footer>
        <Composer.Submit />
      </Composer.Footer>
    </Composer.Frame>
  )
}

// 使用方式
function Channel({ channelId }: { channelId: string }) {
  return (
    <ChannelProvider channelId={channelId}>
      <ChannelComposer />
    </ChannelProvider>
  )
}
```

**不同的 Provider，相同的 UI：**

```tsx
// 用於臨時表單的本地狀態
function ForwardMessageProvider({ children }) {
  const [state, setState] = useState(initialState)
  const forwardMessage = useForwardMessage()

  return (
    <Composer.Provider
      state={state}
      actions={{ update: setState, submit: forwardMessage }}
    >
      {children}
    </Composer.Provider>
  )
}

// 用於頻道的全域同步狀態
function ChannelProvider({ channelId, children }) {
  const { state, update, submit } = useGlobalChannel(channelId)

  return (
    <Composer.Provider state={state} actions={{ update, submit }}>
      {children}
    </Composer.Provider>
  )
}
```

同一個 `Composer.Input` 元件可以與這兩個 Provider 協作，因為它只依賴於 Context 介面，而非具體實作。
