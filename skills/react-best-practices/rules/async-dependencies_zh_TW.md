---
title: 基於依賴的並行化
impact: CRITICAL
impactDescription: 2-10 倍的性能提升
tags: async, parallelization, dependencies, better-all
---

[English Version](./async-dependencies.md)

## 基於依賴的並行化 (Dependency-Based Parallelization)

對於具有部分依賴的操作，請使用 `better-all` 來最大化並行性。它會自動在最早可能的時刻啟動每個任務。

**錯誤範例 (profile 不必要地等待 config)：**

```typescript
const [user, config] = await Promise.all([
  fetchUser(),
  fetchConfig()
])
const profile = await fetchProfile(user.id)
```

**正確範例 (config 和 profile 並行運行)：**

```typescript
import { all } from 'better-all'

const { user, config, profile } = await all({
  async user() { return fetchUser() },
  async config() { return fetchConfig() },
  async profile() {
    return fetchProfile((await this.$.user).id)
  }
})
```

**不使用額外依賴的替代方案：**

我們可以先創建所有的 Promise，最後再執行 `Promise.all()`。

```typescript
const userPromise = fetchUser()
const profilePromise = userPromise.then(user => fetchProfile(user.id))

const [user, config, profile] = await Promise.all([
  userPromise,
  fetchConfig(),
  profilePromise
])
```

參考資料：[https://github.com/shuding/better-all](https://github.com/shuding/better-all)
