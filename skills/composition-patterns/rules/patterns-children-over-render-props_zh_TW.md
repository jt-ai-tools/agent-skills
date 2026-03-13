---
title: 優先使用子元件 (Children) 而非渲染屬性 (Render Props)
impact: MEDIUM
impactDescription: 更清晰的組合，更好的可讀性
tags: 組合, children, 渲染屬性
---

[English Version](./patterns-children-over-render-props.md)

## 優先使用子元件而非渲染屬性 (Prefer Children Over Render Props)

使用 `children` 進行組合，而不是使用 `renderX` 屬性。`children` 更具可讀性，組合起來更自然，且不需要理解回呼函數 (callback) 的簽署方式。

**不正確的做法 (渲染屬性)：**

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

// 用法笨拙且缺乏靈活性
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

**正確的做法 (使用 children 的複合元件)：**

```tsx
function ComposerFrame({ children }: { children: React.ReactNode }) {
  return <form>{children}</form>
}

function ComposerFooter({ children }: { children: React.ReactNode }) {
  return <footer className='flex'>{children}</footer>
}

// 用法靈活
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

**何時適合使用渲染屬性 (render props)：**

```tsx
// 當你需要將數據回傳時，渲染屬性非常有用
<List
  data={items}
  renderItem={({ item, index }) => <Item item={item} index={index} />}
/>
```

當父元件需要向子元件提供數據或狀態時，請使用渲染屬性。當組合靜態結構時，請使用 `children`。
