# React 組合模式 (React Composition Patterns)

[English Version](./AGENTS.md)

**版本 1.0.0**  
工程團隊  
2026 年 1 月

> **注意：**  
> 本文件主要供代理人與 LLM 在使用組合模式維護、產生或重構 React 程式碼庫時遵循。人類也可能會發現其有用之處，但此處的指引針對 AI 輔助工作流程的自動化與一致性進行了優化。

---

## 摘要 (Abstract)

用於建立具彈性、可維護的 React 元件的組合模式。透過使用複合元件、提升狀態以及組合內部結構，避免布林屬性 (boolean prop) 的激增。這些模式使得程式碼庫在擴展時，對人類與 AI 代理人而言都更容易處理。

---

## 目錄

1. [元件架構](#1-元件架構) — **高 (HIGH)**
   - 1.1 [避免布林屬性激增](#11-避免布林屬性激增)
   - 1.2 [使用複合元件](#12-使用複合元件)
2. [狀態管理](#2-狀態管理) — **中 (MEDIUM)**
   - 2.1 [將狀態管理與 UI 解耦](#21-將狀態管理與-ui-解耦)
   - 2.2 [為相依注入定義通用的 Context 介面](#22-為相依注入定義通用的-context-介面)
   - 2.3 [將狀態提升至 Provider 元件](#23-將狀態提升至-provider-元件)
3. [實作模式](#3-實作模式) — **中 (MEDIUM)**
   - 3.1 [建立明確的元件變體](#31-建立明確的元件變體)
   - 3.2 [偏好組合 Children 而非 Render Props](#32-偏好組合-children-而非-render-props)
4. [React 19 API](#4-react-19-api) — **中 (MEDIUM)**
   - 4.1 [React 19 API 變更](#41-react-19-api-變更)

---

## 1. 元件架構

**影響程度：高 (HIGH)**

用於結構化元件的基本模式，以避免屬性激增並實現彈性的組合。

### 1.1 避免布林屬性激增

**影響程度：關鍵 (CRITICAL)（防止產生難以維護的元件變體）**

不要添加像 `isThread`、`isEditing`、`isDMThread` 這樣的布林屬性來客製化元件行為。每個布林值都會使可能的狀態增加一倍，並產生難以維護的條件邏輯。請改用組合模式。

**錯誤：布林屬性產生指數級的複雜度**

```tsx
function Composer({
  onSubmit,
  isThread,
  channelId,
  isDMThread,
  dmId,
  isEditing,
  isForwarding,
}: Props) {
  return (
    <form>
      <Header />
      <Input />
      {isDMThread ? (
        <AlsoSendToDMField id={dmId} />
      ) : isThread ? (
        <AlsoSendToChannelField id={channelId} />
      ) : null}
      {isEditing ? (
        <EditActions />
      ) : isForwarding ? (
        <ForwardActions />
      ) : (
        <DefaultActions />
      )}
      <Footer onSubmit={onSubmit} />
    </form>
  )
}
```

**正確：組合模式消除條件句**

```tsx
// 頻道編輯器 (Channel composer)
function ChannelComposer() {
  return (
    <Composer.Frame>
      <Composer.Header />
      <Composer.Input />
      <Composer.Footer>
        <Composer.Attachments />
        <Composer.Formatting />
        <Composer.Emojis />
        <Composer.Submit />
      </Composer.Footer>
    </Composer.Frame>
  )
}

// 討論串編輯器 (Thread composer) - 新增「同時傳送到頻道」欄位
function ThreadComposer({ channelId }: { channelId: string }) {
  return (
    <Composer.Frame>
      <Composer.Header />
      <Composer.Input />
      <AlsoSendToChannelField id={channelId} />
      <Composer.Footer>
        <Composer.Formatting />
        <Composer.Emojis />
        <Composer.Submit />
      </Composer.Footer>
    </Composer.Frame>
  )
}

// 編輯模式編輯器 (Edit composer) - 不同的頁尾動作
function EditComposer() {
  return (
    <Composer.Frame>
      <Composer.Input />
      <Composer.Footer>
        <Composer.Formatting />
        <Composer.Emojis />
        <Composer.CancelEdit />
        <Composer.SaveEdit />
      </Composer.Footer>
    </Composer.Frame>
  )
}
```

每個變體都明確表示其渲染的內容。我們可以共享內部元件，而無需共享單一的龐大父元件。

### 1.2 使用複合元件 (Compound Components)

**影響程度：高 (HIGH)（實現彈性的組合，無需屬性鑽取）**

將複雜元件結構化為具有共享 Context 的複合元件。每個子元件透過 Context 而非 Props 存取共享狀態。使用者可以組合其所需的片段。

**錯誤：帶有 render props 的單一龐大元件**

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

**正確：具共享 Context 的複合元件**

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
  return <Button onPress={submit}>傳送</Button>
}

// 作為複合元件導出
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

使用者明確組合其所需的內容，沒有隱藏的條件句。且狀態、動作 (actions) 與中繼資料 (meta) 由父 Provider 透過相依注入提供，允許在相同的元件結構下有多種用途。

---

## 2. 狀態管理

**影響程度：中 (MEDIUM)**

用於在組合元件中提升狀態與管理共享 Context 的模式。

### 2.1 將狀態管理與 UI 解耦

**影響程度：中 (MEDIUM)（允許在不更改 UI 的情況下更換狀態實作）**

Provider 元件應是唯一知道如何管理狀態的地方。UI 元件使用 Context 介面 —— 它們不需要知道狀態是來自 `useState`、Zustand 還是伺服器同步。

**錯誤：UI 與狀態實作耦合**

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

**正確：狀態管理在 Provider 中隔離**

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

// UI 元件僅知道 Context 介面
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

// 用法
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
// 用於暫存表單的區域狀態
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

同一個 `Composer.Input` 元件可以與這兩種 Provider 配合使用，因為它僅依賴於 Context 介面，而非其實作方式。

### 2.2 為相依注入定義通用的 Context 介面

**影響程度：高 (HIGH)（實現跨使用情境的可注入狀態）**

為您的元件 Context 定義一個**通用介面 (generic interface)**，包含三個部分：`state`、`actions` 與 `meta`。此介面是任何 Provider 都可以實作的契約 —— 使得相同的 UI 元件能夠與完全不同的狀態實作配合使用。

**核心原則：**提升狀態，組合內部結構，使狀態可被相依注入。

**錯誤：UI 與特定的狀態實作耦合**

```tsx
function ComposerInput() {
  // 緊密耦合到特定的 hook
  const { input, setInput } = useChannelComposerState()
  return <TextInput value={input} onChangeText={setInput} />
}
```

**正確：通用介面實現相依注入**

```tsx
// 定義任何 Provider 都可以實作的通用 (GENERIC) 介面
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

**UI 元件使用介面，而非實作：**

```tsx
function ComposerInput() {
  const {
    state,
    actions: { update },
    meta,
  } = use(ComposerContext)

  // 此元件可與任何實作該介面的 Provider 配合使用
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
// Provider A: 用於暫存表單的區域狀態
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

// Provider B: 用於頻道的全域同步狀態
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

**相同的組合 UI 可與兩者配合使用：**

```tsx
// 與 ForwardMessageProvider (區域狀態) 配合使用
<ForwardMessageProvider>
  <Composer.Frame>
    <Composer.Input />
    <Composer.Submit />
  </Composer.Frame>
</ForwardMessageProvider>

// 與 ChannelProvider (全域同步狀態) 配合使用
<ChannelProvider channelId="abc">
  <Composer.Frame>
    <Composer.Input />
    <Composer.Submit />
  </Composer.Frame>
</ChannelProvider>
```

**元件之外的自定義 UI 也可以存取狀態與動作：**

```tsx
function ForwardMessageDialog() {
  return (
    <ForwardMessageProvider>
      <Dialog>
        {/* 編輯器 UI */}
        <Composer.Frame>
          <Composer.Input placeholder="若有需要，請新增訊息。" />
          <Composer.Footer>
            <Composer.Formatting />
            <Composer.Emojis />
          </Composer.Footer>
        </Composer.Frame>

        {/* 位於編輯器框框之外，但在 Provider 之內的自定義 UI */}
        <MessagePreview />

        {/* 對話框底部的動作 */}
        <DialogActions>
          <CancelButton />
          <ForwardButton />
        </DialogActions>
      </Dialog>
    </ForwardMessageProvider>
  )
}

// 此按鈕位於 Composer.Frame 之外，但仍可根據其 Context 進行提交！
function ForwardButton() {
  const {
    actions: { submit },
  } = use(ComposerContext)
  return <Button onPress={submit}>轉傳</Button>
}

// 此預覽位於 Composer.Frame 之外，但可以讀取編輯器的狀態！
function MessagePreview() {
  const { state } = use(ComposerContext)
  return <Preview message={state.input} attachments={state.attachments} />
}
```

Provider 的邊界才是重點 —— 而非視覺上的嵌套。需要共享狀態的元件不一定要在 `Composer.Frame` 裡面，它們只需要在 Provider 裡面即可。

`ForwardButton` 與 `MessagePreview` 在視覺上並不在編輯器框框內，但它們仍可存取其狀態與動作。這就是將狀態提升至 Provider 的力量。

UI 是您組合在一起的可重複使用片段。狀態由 Provider 相依注入。更換 Provider，保留 UI。

### 2.3 將狀態提升至 Provider 元件

**影響程度：高 (HIGH)（實現元件邊界外的狀態共享）**

將狀態管理移至專用的 Provider 元件中。這允許主 UI 之外的同層元件存取並修改狀態，而無需屬性鑽取或彆扭的 Ref。

**錯誤：狀態困在元件內部**

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

**錯誤：使用 useEffect 同步狀態**

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

**錯誤：在提交時從 Ref 讀取狀態**

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

**正確：狀態提升至 Provider**

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

`ForwardButton` 位在 `Composer.Frame` 之外，但由於它在 Provider 內，因此仍可存取提交動作。即便它是個一次性的元件，它仍能從 UI 本身之外存取編輯器的狀態與動作。

**關鍵見解：**需要共享狀態的元件不一定要在視覺上互相嵌套 —— 它們只需要在同一個 Provider 內即可。

---

## 3. 實作模式

**影響程度：中 (MEDIUM)**

實作複合元件與 Context Provider 的特定技術。

### 3.1 建立明確的元件變體

**影響程度：中 (MEDIUM)（自我說明的程式碼，無隱藏條件句）**

與其使用一個具有許多布林屬性的元件，不如建立明確的變體元件。每個變體組合其所需的片段。程式碼本身就是文件。

**錯誤：一個元件，多種模式**

```tsx
// 此元件實際上渲染了什麼？
<Composer
  isThread
  isEditing={false}
  channelId='abc'
  showAttachments
  showFormatting={false}
/>
```

**正確：明確的變體**

```tsx
// 渲染內容一目瞭然
<ThreadComposer channelId="abc" />

// 或
<EditMessageComposer messageId="xyz" />

// 或
<ForwardMessageComposer messageId="123" />
```

每個實作都是唯一、明確且自成一格的。然而，它們都可以使用共享的部分。

**實作方式：**

```tsx
function ThreadComposer({ channelId }: { channelId: string }) {
  return (
    <ThreadProvider channelId={channelId}>
      <Composer.Frame>
        <Composer.Input />
        <AlsoSendToChannelField channelId={channelId} />
        <Composer.Footer>
          <Composer.Formatting />
          <Composer.Emojis />
          <Composer.Submit />
        </Composer.Footer>
      </Composer.Frame>
    </ThreadProvider>
  )
}

function EditMessageComposer({ messageId }: { messageId: string }) {
  return (
    <EditMessageProvider messageId={messageId}>
      <Composer.Frame>
        <Composer.Input />
        <Composer.Footer>
          <Composer.Formatting />
          <Composer.Emojis />
          <Composer.CancelEdit />
          <Composer.SaveEdit />
        </Composer.Footer>
      </Composer.Frame>
    </EditMessageProvider>
  )
}

function ForwardMessageComposer({ messageId }: { messageId: string }) {
  return (
    <ForwardMessageProvider messageId={messageId}>
      <Composer.Frame>
        <Composer.Input placeholder="若有需要，請新增訊息。" />
        <Composer.Footer>
          <Composer.Formatting />
          <Composer.Emojis />
          <Composer.Mentions />
        </Composer.Footer>
      </Composer.Frame>
    </ForwardMessageProvider>
  )
}
```

每個變體都明確表示：

- 使用哪個 Provider/狀態

- 包含哪些 UI 元素

- 哪些動作可用

無需推敲布林屬性的組合。沒有不可能發生的狀態。

### 3.2 偏好組合 Children 而非 Render Props

**影響程度：中 (MEDIUM)（更簡潔的組合，更好的可讀性）**

使用 `children` 進行組合，而非 `renderX` 屬性。Children 更具可讀性，組合起來更自然，且不需要了解回呼函式的特徵標記 (callback signature)。

**錯誤：使用 render props**

```tsx
function Composer({
  renderHeader,
  renderFooter,
  renderActions,
}: {
  renderHeader?: () => React.ReactNode
  renderFooter?: () => React.ReactNode
  renderActions?: () => React.ReactNode
}) {
  return (
    <form>
      {renderHeader?.()}
      <Input />
      {renderFooter ? renderFooter() : <DefaultFooter />}
      {renderActions?.()}
    </form>
  )
}

// 用法彆扭且缺乏彈性
return (
  <Composer
    renderHeader={() => <CustomHeader />}
    renderFooter={() => (
      <>
        <Formatting />
        <Emojis />
      </>
    )}
    renderActions={() => <SubmitButton />}
  />
)
```

**正確：具 Children 的複合元件**

```tsx
function ComposerFrame({ children }: { children: React.ReactNode }) {
  return <form>{children}</form>
}

function ComposerFooter({ children }: { children: React.ReactNode }) {
  return <footer className='flex'>{children}</footer>
}

// 用法極具彈性
return (
  <Composer.Frame>
    <CustomHeader />
    <Composer.Input />
    <Composer.Footer>
      <Composer.Formatting />
      <Composer.Emojis />
      <SubmitButton />
    </Composer.Footer>
  </Composer.Frame>
)
```

**何時適合使用 Render Props：**

```tsx
// 當您需要將資料傳回時，Render props 效果很好
<List
  data={items}
  renderItem={({ item, index }) => <Item item={item} index={index} />}
/>
```

當父元件需要將資料或狀態提供給子元件時，請使用 Render props。

在組合靜態結構時，請使用 Children。

---

## 4. React 19 API

**影響程度：中 (MEDIUM)**

僅限 React 19+。不要使用 `forwardRef`；使用 `use()` 代替 `useContext()`。

### 4.1 React 19 API 變更

**影響程度：中 (MEDIUM)（更簡潔的元件定義與 Context 使用）**

> **⚠️ 僅限 React 19+。** 如果您使用的是 React 18 或更早版本，請跳過此部分。

在 React 19 中，`ref` 現在是一個普通的 Prop（無需 `forwardRef` 封裝），而 `use()` 取代了 `useContext()`。

**錯誤：在 React 19 中使用 forwardRef**

```tsx
const ComposerInput = forwardRef<TextInput, Props>((props, ref) => {
  return <TextInput ref={ref} {...props} />
})
```

**正確：將 ref 作為普通 Prop**

```tsx
function ComposerInput({ ref, ...props }: Props & { ref?: React.Ref<TextInput> }) {
  return <TextInput ref={ref} {...props} />
}
```

**錯誤：在 React 19 中使用 useContext**

```tsx
const value = useContext(MyContext)
```

**正確：使用 use 代替 useContext**

```tsx
const value = use(MyContext)
```

與 `useContext()` 不同，`use()` 也可以在條件句中呼叫。

---

## 參考資料 (References)

1. [https://react.dev](https://react.dev)
2. [https://react.dev/learn/passing-data-deeply-with-context](https://react.dev/learn/passing-data-deeply-with-context)
3. [https://react.dev/reference/react/use](https://react.dev/reference/react/use)
