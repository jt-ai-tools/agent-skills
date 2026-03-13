---
title: 使用 SWR 進行自動要求去重
impact: MEDIUM-HIGH
impactDescription: 自動要求去重（deduplication）
tags: client, swr, deduplication, data-fetching
---

[English Version](./client-swr-dedup.md)

## 使用 SWR 進行自動要求去重

SWR 可以在不同元件實例之間實現要求去重、快取和重新驗證。

**錯誤做法（沒有去重，每個實例都會發送請求）：**

```tsx
function UserList() {
  const [users, setUsers] = useState([])
  useEffect(() => {
    fetch('/api/users')
      .then(r => r.json())
      .then(setUsers)
  }, [])
}
```

**正確做法（多個實例共享同一個請求）：**

```tsx
import useSWR from 'swr'

function UserList() {
  const { data: users } = useSWR('/api/users', fetcher)
}
```

**對於不可變數據：**

```tsx
import { useImmutableSWR } from '@/lib/swr'

function StaticContent() {
  const { data } = useImmutableSWR('/api/config', fetcher)
}
```

**對於資料變更（Mutations）：**

```tsx
import { useSWRMutation } from 'swr/mutation'

function UpdateButton() {
  const { trigger } = useSWRMutation('/api/user', updateUser)
  return <button onClick={() => trigger()}>Update</button>
}
```

參考資料：[https://swr.vercel.app](https://swr.vercel.app)
