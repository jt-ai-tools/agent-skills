---
title: 為長列表使用 CSS content-visibility
impact: HIGH
impactDescription: 更快的初始渲染
tags: rendering, css, content-visibility, long-lists
---

[English Version](./rendering-content-visibility.md)

## 為長列表使用 CSS content-visibility

應用 `content-visibility: auto` 來延遲螢幕外內容的渲染。

**CSS：**

```css
.message-item {
  content-visibility: auto;
  contain-intrinsic-size: 0 80px;
}
```

**範例：**

```tsx
function MessageList({ messages }: { messages: Message[] }) {
  return (
    <div className="overflow-y-auto h-screen">
      {messages.map(msg => (
        <div key={msg.id} className="message-item">
          <Avatar user={msg.author} />
          <div>{msg.content}</div>
        </div>
      ))}
    </div>
  )
}
```

對於 1000 條訊息，瀏覽器會跳過大約 990 個螢幕外項目的佈局（layout）和繪製（paint），使初始渲染速度提高 10 倍。
