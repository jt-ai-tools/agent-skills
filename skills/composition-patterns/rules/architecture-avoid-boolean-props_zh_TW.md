---
title: 避免布林值屬性過度增加
impact: CRITICAL
impactDescription: 防止元件變體變得難以維護
tags: 組合, props, 架構
---

[English Version](./architecture-avoid-boolean-props.md)

## 避免布林值屬性過度增加 (Avoid Boolean Prop Proliferation)

不要使用 `isThread`、`isEditing`、`isDMThread` 等布林值屬性 (boolean props) 來自定義元件行為。每個布林值都會使可能的狀態增加一倍，並產生難以維護的條件邏輯。請改用組合 (composition) 模式。

**不正確的做法 (布林值屬性會產生指數級的複雜性)：**

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

**正確的做法 (透過組合消除條件判斷)：**

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

// 編輯模式編輯器 (Edit composer) - 不同的頁尾操作
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

每個變體都明確定義了它所渲染的內容。我們可以共享內部邏輯，而不需要共享一個單一且龐大的父元件。
