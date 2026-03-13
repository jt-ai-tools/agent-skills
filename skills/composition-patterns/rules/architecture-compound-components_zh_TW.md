---
title: 使用複合元件 (Compound Components)
impact: HIGH
impactDescription: 實現靈活組合，避免屬性鑽取 (prop drilling)
tags: 組合, 複合元件, 架構
---

[English Version](./architecture-compound-components.md)

## 使用複合元件 (Use Compound Components)

將複雜的元件結構設計為具有共享上下文 (context) 的複合元件 (compound components)。每個子元件透過上下文存取共享狀態，而不是透過屬性 (props)。使用者可以根據需求組合所需的片段。

**不正確的做法 (使用渲染屬性的單一龐大元件)：**

```tsx
function Composer({
  renderHeader,
  renderFooter,
  renderActions,
  showAttachments,
  showFormatting,
  showEmojis,
}: Props) {
  return (
    <form>
      {renderHeader?.()}
      <Input />
      {showAttachments && <Attachments />}
      {renderFooter ? (
        renderFooter()
      ) : (
        <Footer>
          {showFormatting && <Formatting />}
          {showEmojis && <Emojis />}
          {renderActions?.()}
        </Footer>
      )}
    </form>
  )
}
```

**正確的做法 (具有共享上下文的複合元件)：**

```tsx
const ComposerContext = createContext<ComposerContextValue | null>(null)

function ComposerProvider({ children, state, actions, meta }: ProviderProps) {
  return (
    <ComposerContext value={{ state, actions, meta }}>
      {children}
    </ComposerContext>
  )
}

function ComposerFrame({ children }: { children: React.ReactNode }) {
  return <form>{children}</form>
}

function ComposerInput() {
  const {
    state,
    actions: { update },
    meta: { inputRef },
  } = use(ComposerContext)
  return (
    <TextInput
      ref={inputRef}
      value={state.input}
      onChangeText={(text) => update((s) => ({ ...s, input: text }))}
    />
  )
}

function ComposerSubmit() {
  const {
    actions: { submit },
  } = use(ComposerContext)
  return <Button onPress={submit}>發送</Button>
}

// 作為複合元件匯出
const Composer = {
  Provider: ComposerProvider,
  Frame: ComposerFrame,
  Input: ComposerInput,
  Submit: ComposerSubmit,
  Header: ComposerHeader,
  Footer: ComposerFooter,
  Attachments: ComposerAttachments,
  Formatting: ComposerFormatting,
  Emojis: ComposerEmojis,
}
```

**用法：**

```tsx
<Composer.Provider state={state} actions={actions} meta={meta}>
  <Composer.Frame>
    <Composer.Header />
    <Composer.Input />
    <Composer.Footer>
      <Composer.Formatting />
      <Composer.Submit />
    </Composer.Footer>
  </Composer.Frame>
</Composer.Provider>
```

使用者可以明確地組合他們確切需要的內容，沒有隱藏的條件判斷。此外，狀態 (state)、操作 (actions) 和元數據 (meta) 是由父層供應者 (provider) 進行依賴注入的，這使得相同的元件結構可以被多次使用。
