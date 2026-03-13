---
title: 合併多次陣列迭代 (Combine Multiple Array Iterations)
impact: LOW-MEDIUM
impactDescription: 減少迭代次數 (reduces iterations)
tags: javascript, arrays, loops, performance
---

[English Version](./js-combine-iterations.md)

## 合併多次陣列迭代 (Combine Multiple Array Iterations)

多次呼叫 `.filter()` 或 `.map()` 會對陣列進行多次迭代。應將其合併為單次迴圈。

**不正確 (3 次迭代)：**

```typescript
const admins = users.filter(u => u.isAdmin)
const testers = users.filter(u => u.isTester)
const inactive = users.filter(u => !u.isActive)
```

**正確 (1 次迭代)：**

```typescript
const admins: User[] = []
const testers: User[] = []
const inactive: User[] = []

for (const user of users) {
  if (user.isAdmin) admins.push(user)
  if (user.isTester) testers.push(user)
  if (!user.isActive) inactive.push(user)
}
```
