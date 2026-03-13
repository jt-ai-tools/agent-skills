---
title: 建立明確的元件變體 (Create Explicit Component Variants)
impact: MEDIUM
impactDescription: 程式碼具備自我描述性，沒有隱藏的條件判斷
tags: composition, variants, architecture
---

[English Version](./patterns-explicit-variants.md)

## 建立明確的元件變體

不要使用一個帶有許多布林屬性（boolean props）的元件，而是建立明確的變體元件。每個變體組合其所需的片段。程式碼會自我描述。

**不正確（一個元件，多種模式）：**

```tsx
// 這個元件實際上渲染了什麼？
<Composer
  isThread
  isEditing={false}
  channelId='abc'
  showAttachments
  showFormatting={false}
/>
```

**正確（明確的變體）：**

```tsx
// 立即清楚它渲染了什麼
<ThreadComposer channelId="abc" />

// 或者
<EditMessageComposer messageId="xyz" />

// 或者
<ForwardMessageComposer messageId="123" />
```

每個實作都是唯一、明確且獨立的。然而，它們都可以使用共享的部分。

**實作：**

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
        <Composer.Input placeholder="Add a message, if you'd like." />
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

每個變體都明確說明：

- 它使用了哪個 Provider/狀態
- 它包含了哪些 UI 元素
- 提供了哪些操作

不需要推理布林屬性的組合。沒有不可能的狀態。
