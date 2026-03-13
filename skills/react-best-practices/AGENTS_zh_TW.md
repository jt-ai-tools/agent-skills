[English Version](./AGENTS.md)

# React 最佳實踐

**版本 1.0.0**  
Vercel 工程團隊  
2026 年 1 月

> **注意：**  
> 本文件主要供代理程式（Agents）和大型語言模型（LLMs）在維護、  
> 生成或重構 React 和 Next.js 程式碼庫時遵循。人類讀者  
> 也可能會發現其用途，但此處的指南針對 AI 輔助工作流的  
> 自動化和一致性進行了最佳化。

---

## 摘要

針對 AI 代理和 LLM 設計的 React 與 Next.js 應用程式全面效能優化指南。包含 8 個類別共 40 多條規則，按影響程度排序，從至關重要（消除瀑布流、減少套件大小）到遞增改進（進階模式）。每條規則都包含詳細說明、比較錯誤與正確實作的真實案例，以及具體的影響指標，以指導自動化重構和程式碼生成。

---

## 目錄

1. [消除瀑布流 (Eliminating Waterfalls)](#1-消除瀑布流) — **至關重要 (CRITICAL)**
   - 1.1 [延遲 await 直到需要時](#11-延遲-await-直到需要時)
   - 1.2 [基於依賴的並行化](#12-基於依賴的並行化)
   - 1.3 [防止 API 路由中的瀑布鏈](#13-防止-api-路由中的瀑布鏈)
   - 1.4 [對獨立操作使用 Promise.all()](#14-對獨立操作使用-promiseall)
   - 1.5 [策略性 Suspense 邊界](#15-策略性-suspense-邊界)
2. [套件大小優化 (Bundle Size Optimization)](#2-套件大小優化) — **至關重要 (CRITICAL)**
   - 2.1 [避免桶文件 (Barrel File) 匯入](#21-避免桶文件-barrel-file-匯入)
   - 2.2 [條件式模組載入](#22-條件式模組載入)
   - 2.3 [延遲非關鍵第三方函式庫](#23-延遲非關鍵第三方函式庫)
   - 2.4 [為大型組件使用動態匯入](#24-為大型組件使用動態匯入)
   - 2.5 [基於用戶意圖進行預載](#25-基於用戶意圖進行預載)
3. [伺服器端效能 (Server-Side Performance)](#3-伺服器端效能) — **高 (HIGH)**
   - 3.1 [像 API 路由一樣驗證 Server Actions](#31-像-api-路由一樣驗證-server-actions)
   - 3.2 [避免在 RSC Props 中重複序列化](#32-避免在-rsc-props-中重複序列化)
   - 3.3 [跨請求 LRU 快取](#33-跨請求-lru-快取)
   - 3.4 [將靜態 I/O 提升至模組層級](#34-將靜態-io-提升至模組層級)
   - 3.5 [最小化 RSC 邊界的序列化](#35-最小化-rsc-邊界的序列化)
   - 3.6 [透過組件組合進行並行數據獲取](#36-透過組件組合進行並行數據獲取)
   - 3.7 [使用 React.cache() 進行單次請求去重](#37-使用-reactcache-進行單次請求去重)
   - 3.8 [對非阻塞操作使用 after()](#38-對非阻塞操作使用-after)
4. [用戶端數據獲取 (Client-Side Data Fetching)](#4-用戶端數據獲取) — **中高 (MEDIUM-HIGH)**
   - 4.1 [去重全域事件監聽器](#41-去重全域事件監聽器)
   - 4.2 [使用被動事件監聽器提升滾動效能](#42-使用被動事件監聽器提升滾動效能)
   - 4.3 [使用 SWR 進行自動去重](#43-使用-swr-進行自動去重)
   - 4.4 [版本化並最小化 localStorage 數據](#44-版本化並最小化-localstorage-數據)
5. [重新渲染優化 (Re-render Optimization)](#5-重新渲染優化) — **中 (MEDIUM)**
   - 5.1 [在渲染期間計算衍生狀態](#51-在渲染期間計算衍生狀態)
   - 5.2 [將狀態讀取延遲到使用點](#52-將狀態讀取延遲到使用點)
   - 5.3 [不要用 useMemo 包裹返回原始型別結果的簡單表達式](#53-不要用-usememo-包裹返回原始型別結果的簡單表達式)
   - 5.4 [不要在組件內部定義組件](#54-不要在組件內部定義組件)
   - 5.5 [將備忘錄組件的預設非原始參數值提取為常數](#55-將備忘錄組件的預設非原始參數值提取為常數)
   - 5.6 [提取為備忘錄組件](#56-提取為備忘錄組件)
   - 5.7 [縮小 Effect 依賴範圍](#57-縮小-effect-依賴範圍)
   - 5.8 [將交互邏輯放入事件處理程序](#58-將交互邏輯放入事件處理程序)
   - 5.9 [訂閱衍生狀態](#59-訂閱衍生狀態)
   - 5.10 [使用函式形式的 setState 更新](#510-使用函式形式的-setstate-更新)
   - 5.11 [使用延遲狀態初始化](#511-使用延遲狀態初始化)
   - 5.12 [對非緊急更新使用 Transitions](#512-對非緊急更新使用-transitions)
   - 5.13 [對瞬態值使用 useRef](#513-對瞬態值使用-useref)
6. [渲染效能 (Rendering Performance)](#6-渲染效能) — **中 (MEDIUM)**
   - 6.1 [動畫化 SVG 包裹器而非 SVG 元素本身](#61-動畫化-svg-包裹器而非-svg-元素本身)
   - 6.2 [對長列表使用 CSS content-visibility](#62-對長列表使用-css-content-visibility)
   - 6.3 [提升靜態 JSX 元素](#63-提升靜態-jsx-元素)
   - 6.4 [優化 SVG 精度](#64-優化-svg-精度)
   - 6.5 [防止水合不匹配且不引起閃爍](#65-防止水合不匹配且不引起閃爍)
   - 6.6 [抑制預期的水合不匹配](#66-抑制預期的水合不匹配)
   - 6.7 [對顯示/隱藏使用 Activity 組件](#67-對顯示隱藏使用-activity-組件)
   - 6.8 [在 Script 標籤上使用 defer 或 async](#68-在-script-標籤上使用-defer-或-async)
   - 6.9 [使用顯式條件渲染](#69-使用顯式條件渲染)
   - 6.10 [使用 React DOM 資源提示 (Resource Hints)](#610-使用-react-dom-資源提示-resource-hints)
   - 6.11 [使用 useTransition 代替手動載入狀態](#611-使用-usetransition-代替手動載入狀態)
7. [JavaScript 效能 (JavaScript Performance)](#7-javascript-效能) — **低中 (LOW-MEDIUM)**
   - 7.1 [避免佈局抖動 (Layout Thrashing)](#71-避免佈局抖動-layout-thrashing)
   - 7.2 [為重複查詢建立索引映射 (Index Maps)](#72-為重複查詢建立索引映射-index-maps)
   - 7.3 [在迴圈中快取屬性存取](#73-在迴圈中快取屬性存取)
   - 7.4 [快取重複的函式調用](#74-快取重複的函式調用)
   - 7.5 [快取 Storage API 調用](#75-快取-storage-api-調用)
   - 7.6 [合併多個陣列迭代](#76-合併多個陣列迭代)
   - 7.7 [陣列比較時優先進行長度檢查](#77-陣列比較時優先進行長度檢查)
   - 7.8 [從函式中提早返回 (Early Return)](#78-從函式中提早返回-early-return)
   - 7.9 [提升 RegExp 建立](#79-提升-regexp-建立)
   - 7.10 [使用 flatMap 在一次遍歷中同時完成映射和篩選](#710-使用-flatmap-在一次遍歷中同時完成映射和篩選)
   - 7.11 [使用迴圈計算最大/最小值而非排序](#711-使用迴圈計算最大最小值而非排序)
   - 7.12 [使用 Set/Map 進行 O(1) 查詢](#712-使用-setmap-進行-o1-查詢)
   - 7.13 [使用 toSorted() 代替 sort() 以確保不可變性](#713-使用-tosorted-代替-sort-以確保不可變性)
8. [進階模式 (Advanced Patterns)](#8-進階模式) — **低 (LOW)**
   - 8.1 [應用程式初始化一次，而非每次掛載](#81-應用程式初始化一次而非每次掛載)
   - 8.2 [將事件處理程序儲存在 Refs 中](#82-將事件處理程序儲存在-refs-中)
   - 8.3 [使用 useEffectEvent 取得穩定的回呼 Refs](#83-useeffectevent-取得穩定的回呼-refs)

---

## 1. 消除瀑布流 (Eliminating Waterfalls)

**影響程度：至關重要 (CRITICAL)**

瀑布流是效能的第一大殺手。每個順序執行的 `await` 都會增加完整的網路延遲。消除它們能帶來最大的收益。

### 1.1 延遲 await 直到需要時

**影響程度：高 (HIGH)（避免阻塞未使用的程式碼路徑）**

將 `await` 操作移入實際使用它們的分支中，以避免阻塞不需要它們的程式碼路徑。

**不正確：阻塞了兩個分支**

```typescript
async function handleRequest(userId: string, skipProcessing: boolean) {
  const userData = await fetchUserData(userId)
  
  if (skipProcessing) {
    // 立即返回，但仍然等待了 userData
    return { skipped: true }
  }
  
  // 只有此分支使用 userData
  return processUserData(userData)
}
```

**正確：僅在需要時阻塞**

```typescript
async function handleRequest(userId: string, skipProcessing: boolean) {
  if (skipProcessing) {
    // 立即返回，無需等待
    return { skipped: true }
  }
  
  // 僅在需要時獲取
  const userData = await fetchUserData(userId)
  return processUserData(userData)
}
```

**另一個例子：提早返回優化**

```typescript
// 不正確：總是獲取權限
async function updateResource(resourceId: string, userId: string) {
  const permissions = await fetchPermissions(userId)
  const resource = await getResource(resourceId)
  
  if (!resource) {
    return { error: 'Not found' }
  }
  
  if (!permissions.canEdit) {
    return { error: 'Forbidden' }
  }
  
  return await updateResourceData(resource, permissions)
}

// 正確：僅在需要時獲取
async function updateResource(resourceId: string, userId: string) {
  const resource = await getResource(resourceId)
  
  if (!resource) {
    return { error: 'Not found' }
  }
  
  const permissions = await fetchPermissions(userId)
  
  if (!permissions.canEdit) {
    return { error: 'Forbidden' }
  }
  
  return await updateResourceData(resource, permissions)
}
```

當經常進入跳過的分支，或延遲的操作代價高昂時，此優化特別有價值。

### 1.2 基於依賴的並行化

**影響程度：至關重要 (CRITICAL)（2-10 倍提升）**

對於具有部分依賴的操作，使用 `better-all` 來最大化並行性。它會自動在最早可能的時刻啟動每個任務。

**不正確：profile 不必要地等待 config**

```typescript
const [user, config] = await Promise.all([
  fetchUser(),
  fetchConfig()
])
const profile = await fetchProfile(user.id)
```

**正確：config 和 profile 並行執行**

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

**無需額外依賴的替代方案：**

```typescript
const userPromise = fetchUser()
const profilePromise = userPromise.then(user => fetchProfile(user.id))

const [user, config, profile] = await Promise.all([
  userPromise,
  fetchConfig(),
  profilePromise
])
```

我們也可以先建立所有的 Promise，最後再執行 `Promise.all()`。

參考：[https://github.com/shuding/better-all](https://github.com/shuding/better-all)

### 1.3 防止 API 路由中的瀑布鏈

**影響程度：至關重要 (CRITICAL)（2-10 倍提升）**

在 API 路由和 Server Actions 中，立即啟動獨立的操作，即使尚未對其進行 await。

**不正確：config 等待 auth，data 等待兩者**

```typescript
export async function GET(request: Request) {
  const session = await auth()
  const config = await fetchConfig()
  const data = await fetchData(session.user.id)
  return Response.json({ data, config })
}
```

**正確：auth 和 config 立即啟動**

```typescript
export async function GET(request: Request) {
  const sessionPromise = auth()
  const configPromise = fetchConfig()
  const session = await sessionPromise
  const [config, data] = await Promise.all([
    configPromise,
    fetchData(session.user.id)
  ])
  return Response.json({ data, config })
}
```

對於具有更複雜依賴鏈的操作，請使用 `better-all` 自動最大化並行性（參見「基於依賴的並行化」）。

### 1.4 對獨立操作使用 Promise.all()

**影響程度：至關重要 (CRITICAL)（2-10 倍提升）**

當非同步操作之間沒有相互依賴時，使用 `Promise.all()` 同步執行它們。

**不正確：順序執行，3 次往返**

```typescript
const user = await fetchUser()
const posts = await fetchPosts()
const comments = await fetchComments()
```

**正確：並行執行，1 次往返**

```typescript
const [user, posts, comments] = await Promise.all([
  fetchUser(),
  fetchPosts(),
  fetchComments()
])
```

### 1.5 策略性 Suspense 邊界

**影響程度：高 (HIGH)（更快的首次繪製）**

與其在非同步組件中等待數據後再返回 JSX，不如使用 Suspense 邊界在數據載入時更快地顯示包裹器 UI。

**不正確：包裹器被數據獲取阻塞**

```tsx
async function Page() {
  const data = await fetchData() // 阻塞整個頁面
  
  return (
    <div>
      <div>Sidebar</div>
      <div>Header</div>
      <div>
        <DataDisplay data={data} />
      </div>
      <div>Footer</div>
    </div>
  )
}
```

整個佈局都在等待數據，即使只有中間部分需要它。

**正確：包裹器立即顯示，數據流式傳輸**

```tsx
function Page() {
  return (
    <div>
      <div>Sidebar</div>
      <div>Header</div>
      <div>
        <Suspense fallback={<Skeleton />}>
          <DataDisplay />
        </Suspense>
      </div>
      <div>Footer</div>
    </div>
  )
}

async function DataDisplay() {
  const data = await fetchData() // 僅阻塞此組件
  return <div>{data.content}</div>
}
```

Sidebar、Header 和 Footer 立即渲染。只有 DataDisplay 等待數據。

**替代方案：在組件間共享 Promise**

```tsx
function Page() {
  // 立即開始獲取，但不 await
  const dataPromise = fetchData()
  
  return (
    <div>
      <div>Sidebar</div>
      <div>Header</div>
      <Suspense fallback={<Skeleton />}>
        <DataDisplay dataPromise={dataPromise} />
        <DataSummary dataPromise={dataPromise} />
      </Suspense>
      <div>Footer</div>
    </div>
  )
}

function DataDisplay({ dataPromise }: { dataPromise: Promise<Data> }) {
  const data = use(dataPromise) // 解開 Promise
  return <div>{data.content}</div>
}

function DataSummary({ dataPromise }: { dataPromise: Promise<Data> }) {
  const data = use(dataPromise) // 重用同一個 Promise
  return <div>{data.summary}</div>
}
```

兩個組件共享同一個 Promise，因此只會發生一次獲取。佈局立即渲染，而兩個組件一起等待。

**何時不應使用此模式：**

- 佈局決策所需的關鍵數據（影響定位）

- 首屏（above the fold）的關鍵 SEO 內容

- 小型、快速的查詢，Suspense 的開銷不值得

- 當你想避免佈局偏移（載入 → 內容跳動）時

**權衡：** 更快的首次繪製 vs 潛在的佈局偏移。根據您的 UX 優先級進行選擇。

---

## 2. 套件大小優化 (Bundle Size Optimization)

**影響程度：至關重要 (CRITICAL)**

減少初始套件大小可縮短可交互時間 (Time to Interactive) 和最大內容繪製 (Largest Contentful Paint)。

### 2.1 避免桶文件 (Barrel File) 匯入

**影響程度：至關重要 (CRITICAL)（200-800ms 匯入成本，減慢建置速度）**

直接從來源檔案匯入，而不是從桶文件匯入，以避免載入數千個未使用的模組。**桶文件**是重新導出多個模組的進入點（例如 `index.js` 中包含 `export * from './module'`）。

流行的圖示和組件庫在其進入點檔案中可能有多達 **10,000 個重新導出**。對於許多 React 套件，僅匯入它們就需要 **200-800ms**，這會影響開發速度 and 生產環境的冷啟動。

**為什麼 Tree-shaking 沒有幫助：** 當一個函式庫被標記為外部（不打包）時，打包器無法對其進行優化。如果您為了啟用 Tree-shaking 而將其打包，建置過程會因為分析整個模組圖而大幅變慢。

**不正確：匯入整個函式庫**

```tsx
import { Check, X, Menu } from 'lucide-react'
// 載入 1,583 個模組，在開發環境中額外耗時約 2.8 秒
// 運行時成本：每次冷啟動耗時 200-800ms

import { Button, TextField } from '@mui/material'
// 載入 2,225 個模組，在開發環境中額外耗時約 4.2 秒
```

**正確：僅匯入您需要的內容**

```tsx
import Check from 'lucide-react/dist/esm/icons/check'
import X from 'lucide-react/dist/esm/icons/x'
import Menu from 'lucide-react/dist/esm/icons/menu'
// 僅載入 3 個模組（約 2KB vs 約 1MB）

import Button from '@mui/material/Button'
import TextField from '@mui/material/TextField'
// 僅載入您使用的內容
```

**替代方案：Next.js 13.5+**

```js
// next.config.js - 使用 optimizePackageImports
module.exports = {
  experimental: {
    optimizePackageImports: ['lucide-react', '@mui/material']
  }
}

// 接著您可以保持方便的桶匯入：
import { Check, X, Menu } from 'lucide-react'
// 建置時會自動轉換為直接匯入
```

直接匯入可使開發啟動速度提升 15-70%，建置速度提升 28%，冷啟動速度提升 40%，且 HMR 速度顯著加快。

常受影響的函式庫：`lucide-react`、`@mui/material`、`@mui/icons-material`、`@tabler/icons-react`、`react-icons`、`@headlessui/react`、`@radix-ui/react-*`、`lodash`、`ramda`、`date-fns`、`rxjs`、`react-use`。

參考：[https://vercel.com/blog/how-we-optimized-package-imports-in-next-js](https://vercel.com/blog/how-we-optimized-package-imports-in-next-js)

### 2.2 條件式模組載入

**影響程度：高 (HIGH)（僅在需要時載入大型數據）**

僅在功能啟用時載入大型數據或模組。

**範例：延遲載入動畫幀**

```tsx
function AnimationPlayer({ enabled, setEnabled }: { enabled: boolean; setEnabled: React.Dispatch<React.SetStateAction<boolean>> }) {
  const [frames, setFrames] = useState<Frame[] | null>(null)

  useEffect(() => {
    if (enabled && !frames && typeof window !== 'undefined') {
      import('./animation-frames.js')
        .then(mod => setFrames(mod.frames))
        .catch(() => setEnabled(false))
    }
  }, [enabled, frames, setEnabled])

  if (!frames) return <Skeleton />
  return <Canvas frames={frames} />
}
```

`typeof window !== 'undefined'` 檢查可防止此模組在 SSR 中被打包，從而優化伺服器端套件大小和建置速度。

### 2.3 延遲非關鍵第三方函式庫

**影響程度：中 (MEDIUM)（在水合之後載入）**

分析、日誌記錄和錯誤追蹤不應阻塞用戶互動。請在水合（Hydration）後載入它們。

**不正確：阻塞初始套件**

```tsx
import { Analytics } from '@vercel/analytics/react'

export default function RootLayout({ children }) {
  return (
    <html>
      <body>
        {children}
        <Analytics />
      </body>
    </html>
  )
}
```

**正確：在水合後載入**

```tsx
import dynamic from 'next/dynamic'

const Analytics = dynamic(
  () => import('@vercel/analytics/react').then(m => m.Analytics),
  { ssr: false }
)

export default function RootLayout({ children }) {
  return (
    <html>
      <body>
        {children}
        <Analytics />
      </body>
    </html>
  )
}
```

### 2.4 為大型組件使用動態匯入

**影響程度：至關重要 (CRITICAL)（直接影響 TTI 和 LCP）**

使用 `next/dynamic` 來延遲載入初始渲染不需要的大型組件。

**不正確：Monaco 與主區塊一起打包，大小約 300KB**

```tsx
import { MonacoEditor } from './monaco-editor'

function CodePanel({ code }: { code: string }) {
  return <MonacoEditor value={code} />
}
```

**正確：Monaco 按需載入**

```tsx
import dynamic from 'next/dynamic'

const MonacoEditor = dynamic(
  () => import('./monaco-editor').then(m => m.MonacoEditor),
  { ssr: false }
)

function CodePanel({ code }: { code: string }) {
  return <MonacoEditor value={code} />
}
```

### 2.5 基於用戶意圖進行預載

**影響程度：中 (MEDIUM)（減少感知的延遲）**

在需要之前預載大型套件，以減少感知的延遲。

**範例：懸停/聚焦時預載**

```tsx
function EditorButton({ onClick }: { onClick: () => void }) {
  const preload = () => {
    if (typeof window !== 'undefined') {
      void import('./monaco-editor')
    }
  }

  return (
    <button
      onMouseEnter={preload}
      onFocus={preload}
      onClick={onClick}
    >
      Open Editor
    </button>
  )
}
```

**範例：功能旗標啟用時預載**

```tsx
function FlagsProvider({ children, flags }: Props) {
  useEffect(() => {
    if (flags.editorEnabled && typeof window !== 'undefined') {
      void import('./monaco-editor').then(mod => mod.init())
    }
  }, [flags.editorEnabled])

  return <FlagsContext.Provider value={flags}>
    {children}
  </FlagsContext.Provider>
}
```

`typeof window !== 'undefined'` 檢查可防止預載的模組在 SSR 中被打包，從而優化伺服器端套件大小和建置速度。

---

## 3. 伺服器端效能 (Server-Side Performance)

**影響程度：高 (HIGH)**

優化伺服器端渲染和數據獲取可消除伺服器端瀑布流並減少回應時間。

### 3.1 像 API 路由一樣驗證 Server Actions

**影響程度：至關重要 (CRITICAL)（防止未經授權訪問伺服器端變更）**

Server Actions（帶有 `"use server"` 的函式）與 API 路由一樣，是以公開端點的形式暴露的。務必在**每個** Server Action 內部驗證身份驗證 (Authentication) 和授權 (Authorization)——不要僅依賴中間件 (Middleware)、佈局保護 (Layout Guards) 或頁面級別的檢查，因為 Server Actions 可以被直接調用。

Next.js 文件明確指出：「對待 Server Actions 應像對待公開的 API 端點一樣考慮安全性，並驗證用戶是否被允許執行該變更。」

**不正確：無身份驗證檢查**

```typescript
'use server'

export async function deleteUser(userId: string) {
  // 任何人都可以調用！無身份驗證檢查
  await db.user.delete({ where: { id: userId } })
  return { success: true }
}
```

**正確：Action 內部進行身份驗證**

```typescript
'use server'

import { verifySession } from '@/lib/auth'
import { unauthorized } from '@/lib/errors'

export async function deleteUser(userId: string) {
  // 務必在 Action 內部檢查身份驗證
  const session = await verifySession()
  
  if (!session) {
    throw unauthorized('必須登入')
  }
  
  // 同時檢查授權
  if (session.user.role !== 'admin' && session.user.id !== userId) {
    throw unauthorized('無法刪除其他用戶')
  }
  
  await db.user.delete({ where: { id: userId } })
  return { success: true }
}
```

**配合輸入驗證：**

```typescript
'use server'

import { verifySession } from '@/lib/auth'
import { z } from 'zod'

const updateProfileSchema = z.object({
  userId: z.string().uuid(),
  name: z.string().min(1).max(100),
  email: z.string().email()
})

export async function updateProfile(data: unknown) {
  // 首先驗證輸入
  const validated = updateProfileSchema.parse(data)
  
  // 然後進行身份驗證
  const session = await verifySession()
  if (!session) {
    throw new Error('未經授權')
  }
  
  // 然後進行授權
  if (session.user.id !== validated.userId) {
    throw new Error('只能更新自己的個人資料')
  }
  
  // 最後執行變更
  await db.user.update({
    where: { id: validated.userId },
    data: {
      name: validated.name,
      email: validated.email
    }
  })
  
  return { success: true }
}
```

參考：[https://nextjs.org/docs/app/guides/authentication](https://nextjs.org/docs/app/guides/authentication)

### 3.2 避免在 RSC Props 中重複序列化

**影響程度：低 (LOW)（透過避免重複序列化來減少網路負載）**

RSC → Client 的序列化去重是基於物件引用而非數值的。相同的引用 = 序列化一次；新的引用 = 再次序列化。請在用戶端而非伺服器端執行資料轉換（`.toSorted()`、`.filter()`、`.map()`）。

**不正確：陣列重複**

```tsx
// RSC：發送 6 個字串（2 個陣列 × 3 個項目）
<ClientList usernames={usernames} usernamesOrdered={usernames.toSorted()} />
```

**正確：發送 3 個字串**

```tsx
// RSC：發送一次
<ClientList usernames={usernames} />

// 用戶端：在那裡進行轉換
'use client'
const sorted = useMemo(() => [...usernames].sort(), [usernames])
```

**嵌套去重行為：**

```tsx
// string[] - 全部重複
usernames={['a','b']} sorted={usernames.toSorted()} // 發送 4 個字串

// object[] - 僅重複陣列結構
users={[{id:1},{id:2}]} sorted={users.toSorted()} // 發送 2 個陣列 + 2 個唯一物件（而非 4 個）
```

去重是遞迴工作的。影響程度隨資料型別而異：

- `string[]`、`number[]`、`boolean[]`：**影響程度高** - 陣列 + 所有原始資料皆完整重複

- `object[]`：**影響程度低** - 陣列重複，但嵌套物件透過引用去重

**破壞去重的操作：建立新引用**

- 陣列：`.toSorted()`、`.filter()`、`.map()`、`.slice()`、`[...arr]`

- 物件：`{...obj}`、`Object.assign()`、`structuredClone()`、`JSON.parse(JSON.stringify())`

**更多範例：**

```tsx
// ❌ 錯誤
<C users={users} active={users.filter(u => u.active)} />
<C product={product} productName={product.name} />

// ✅ 正確
<C users={users} />
<C product={product} />
// 在用戶端進行篩選/解構
```

**例外：** 當轉換運算代價極高，或用戶端不需要原始資料時，傳遞衍生資料。

### 3.3 跨請求 LRU 快取

**影響程度：高 (HIGH)（跨請求快取）**

`React.cache()` 僅在單次請求內有效。對於跨連續請求共享的數據（用戶點擊按鈕 A 然後點擊按鈕 B），請使用 LRU 快取。

**實作：**

```typescript
import { LRUCache } from 'lru-cache'

const cache = new LRUCache<string, any>({
  max: 1000,
  ttl: 5 * 60 * 1000  // 5 分鐘
})

export async function getUser(id: string) {
  const cached = cache.get(id)
  if (cached) return cached

  const user = await db.user.findUnique({ where: { id } })
  cache.set(id, user)
  return user
}

// 請求 1：資料庫查詢，結果被快取
// 請求 2：快取命中，無資料庫查詢
```

當連續的用戶動作點擊多個需要相同數據的端點（且在幾秒鐘內）時使用。

**配合 Vercel 的 [Fluid Compute](https://vercel.com/docs/fluid-compute)：** LRU 快取特別有效，因為多個並發請求可以共享同一個函式實例和快取。這意味著快取可以跨請求持久存在，無需 Redis 等外部儲存。

**在傳統伺服器端（Traditional Serverless）中：** 每次調用都是隔離運行的，因此請考慮使用 Redis 進行跨行程快取。

參考：[https://github.com/isaacs/node-lru-cache](https://github.com/isaacs/node-lru-cache)

### 3.4 將靜態 I/O 提升至模組層級

**影響程度：高 (HIGH)（避免每次請求重複檔案/網路 I/O）**

在路由處理程序或伺服器函式中載入靜態資產（字體、Logo、圖像、配置文件）時，請將 I/O 操作提升至模組層級。模組層級的程式碼在模組首次被匯入時運行一次，而不是在每次請求時運行。這消除了每次調用時都會運行的冗餘檔案系統讀取或網路獲取。

**不正確：每次請求都讀取字體檔案**

**正確：在模組初始化時載入一次**

**替代方案：使用 Node.js fs 進行同步檔案讀取**

**一般 Node.js 範例：載入配置或模板**

**何時使用此模式：**

- 為生成 OG 圖像載入字體

- 載入靜態 Logo、圖示或浮水印

- 讀取在運行時不會更改的配置文件

- 載入電子郵件模板或其他靜態模板

- 任何在所有請求中都相同的靜態資產

**何時不應使用此模式：**

- 隨每次請求或用戶而異的資產

- 可能在運行期間更改的文件（請改用帶有 TTL 的快取）

- 過大、若一直保持載入會消耗過多記憶體的檔案

- 不應持久存在於記憶體中的敏感數據

**配合 Vercel 的 [Fluid Compute](https://vercel.com/docs/fluid-compute)：** 模組級快取特別有效，因為多個並發請求共享同一個函式實例。靜態資產跨請求保持在記憶體中載入，無冷啟動懲罰。

**在傳統伺服器端中：** 每次冷啟動都會重新執行模組層級的程式碼，但隨後的熱調用會重用已載入的資產，直到實例被回收。

### 3.5 最小化 RSC 邊界的序列化

**影響程度：高 (HIGH)（減少數據傳輸大小）**

React Server/Client 邊界會將所有物件屬性序列化為字串，並嵌入 HTML 回應和後續的 RSC 請求中。此序列化數據直接影響頁面權重和載入時間，因此**大小至關重要**。僅傳遞用戶端實際使用的欄位。

**不正確：序列化全部 50 個欄位**

```tsx
async function Page() {
  const user = await fetchUser()  // 50 個欄位
  return <Profile user={user} />
}

'use client'
function Profile({ user }: { user: User }) {
  return <div>{user.name}</div>  // 僅使用 1 個欄位
}
```

**正確：僅序列化 1 個欄位**

```tsx
async function Page() {
  const user = await fetchUser()
  return <Profile name={user.name} />
}

'use client'
function Profile({ name }: { name: string }) {
  return <div>{name}</div>
}
```

### 3.6 透過組件組合進行並行數據獲取

**影響程度：至關重要 (CRITICAL)（消除伺服器端瀑布流）**

React Server Components 在樹中按順序執行。請透過組件組合重新結構化以實現並行數據獲取。

**不正確：Sidebar 等待 Page 的獲取完成**

```tsx
export default async function Page() {
  const header = await fetchHeader()
  return (
    <div>
      <div>{header}</div>
      <Sidebar />
    </div>
  )
}

async function Sidebar() {
  const items = await fetchSidebarItems()
  return <nav>{items.map(renderItem)}</nav>
}
```

**正確：兩者同時獲取**

```tsx
async function Header() {
  const data = await fetchHeader()
  return <div>{data}</div>
}

async function Sidebar() {
  const items = await fetchSidebarItems()
  return <nav>{items.map(renderItem)}</nav>
}

export default function Page() {
  return (
    <div>
      <Header />
      <Sidebar />
    </div>
  )
}
```

**使用 children prop 的替代方案：**

```tsx
async function Header() {
  const data = await fetchHeader()
  return <div>{data}</div>
}

async function Sidebar() {
  const items = await fetchSidebarItems()
  return <nav>{items.map(renderItem)}</nav>
}

function Layout({ children }: { children: ReactNode }) {
  return (
    <div>
      <Header />
      {children}
    </div>
  )
}

export default function Page() {
  return (
    <Layout>
      <Sidebar />
    </Layout>
  )
}
```

### 3.7 使用 React.cache() 進行單次請求去重

**影響程度：中 (MEDIUM)（單次請求內去重）**

使用 `React.cache()` 進行伺服器端請求去重。身份驗證和資料庫查詢受益最深。

**用法：**

```typescript
import { cache } from 'react'

export const getCurrentUser = cache(async () => {
  const session = await auth()
  if (!session?.user?.id) return null
  return await db.user.findUnique({
    where: { id: session.user.id }
  })
})
```

在單次請求中，多次調用 `getCurrentUser()` 僅會執行一次查詢。

**避免使用內聯物件作為引數：**

`React.cache()` 使用淺層比較 (`Object.is`) 來決定快取命中。內聯物件每次調用都會建立新引用，從而阻止快取命中。

**不正確：總是快取失效**

```typescript
const getUser = cache(async (params: { uid: number }) => {
  return await db.user.findUnique({ where: { id: params.uid } })
})

// 每次調用都建立新物件，永遠不會命中快取
getUser({ uid: 1 })
getUser({ uid: 1 })  // 快取失效，再次執行查詢
```

**正確：快取命中**

```typescript
const params = { uid: 1 }
getUser(params)  // 查詢執行
getUser(params)  // 快取命中（相同引用）
```

如果必須傳遞物件，請傳遞相同的引用。

**Next.js 特有說明：**

在 Next.js 中，`fetch` API 已自動擴展為具備請求備忘錄（Memoization）功能。具有相同 URL 和選項的請求會在單次請求內自動去重，因此您不需要對 `fetch` 調用使用 `React.cache()`。然而，`React.cache()` 對於其他非同步任務仍然至關重要：

- 資料庫查詢（Prisma, Drizzle 等）

- 密集的計算

- 身份驗證檢查

- 檔案系統操作

- 任何非 fetch 的非同步工作

請使用 `React.cache()` 在您的組件樹中去重這些操作。

參考：[https://react.dev/reference/react/cache](https://react.dev/reference/react/cache)

### 3.8 對非阻塞操作使用 after()

**影響程度：中 (MEDIUM)（更快的響應時間）**

使用 Next.js 的 `after()` 來排定應在發送響應後執行的工作。這可以防止日誌記錄、分析和其他副作用阻塞響應。

**不正確：阻塞響應**

```tsx
import { logUserAction } from '@/app/utils'

export async function POST(request: Request) {
  // 執行變更
  await updateDatabase(request)
  
  // 日誌記錄阻塞了響應
  const userAgent = request.headers.get('user-agent') || 'unknown'
  await logUserAction({ userAgent })
  
  return new Response(JSON.stringify({ status: 'success' }), {
    status: 200,
    headers: { 'Content-Type': 'application/json' }
  })
}
```

**正確：非阻塞**

```tsx
import { after } from 'next/server'
import { headers, cookies } from 'next/headers'
import { logUserAction } from '@/app/utils'

export async function POST(request: Request) {
  // 執行變更
  await updateDatabase(request)
  
  // 在響應發送後記錄日誌
  after(async () => {
    const userAgent = (await headers()).get('user-agent') || 'unknown'
    const sessionCookie = (await cookies()).get('session-id')?.value || 'anonymous'
    
    logUserAction({ sessionCookie, userAgent })
  })
  
  return new Response(JSON.stringify({ status: 'success' }), {
    status: 200,
    headers: { 'Content-Type': 'application/json' }
  })
}
```

響應會立即發送，而日誌記錄則在背景進行。

**常見使用情境：**

- 分析追蹤

- 稽核日誌

- 發送通知

- 快取失效 (Invalidation)

- 清理任務

**重要說明：**

- 即使響應失敗或重定向，`after()` 仍會執行

- 適用於 Server Actions、Route Handlers 和 Server Components

參考：[https://nextjs.org/docs/app/api-reference/functions/after](https://nextjs.org/docs/app/api-reference/functions/after)

---

## 4. 用戶端數據獲取 (Client-Side Data Fetching)

**影響程度：中高 (MEDIUM-HIGH)**

自動去重和高效的數據獲取模式可減少冗餘的網路請求。

### 4.1 去重全域事件監聽器

**影響程度：低 (LOW)（N 個組件共享單個監聽器）**

使用 `useSWRSubscription()` 在組件實例之間共享全域事件監聽器。

**不正確：N 個實例 = N 個監聽器**

```tsx
function useKeyboardShortcut(key: string, callback: () => void) {
  useEffect(() => {
    const handler = (e: KeyboardEvent) => {
      if (e.metaKey && e.key === key) {
        callback()
      }
    }
    window.addEventListener('keydown', handler)
    return () => window.removeEventListener('keydown', handler)
  }, [key, callback])
}
```

當多次使用 `useKeyboardShortcut` hook 時，每個實例都會註冊一個新的監聽器。

**正確：N 個實例 = 1 個監聽器**

```tsx
import useSWRSubscription from 'swr/subscription'

// 模組層級的 Map，用來追蹤每個按鍵的回呼
const keyCallbacks = new Map<string, Set<() => void>>()

function useKeyboardShortcut(key: string, callback: () => void) {
  // 在 Map 中註冊此回呼
  useEffect(() => {
    if (!keyCallbacks.has(key)) {
      keyCallbacks.set(key, new Set())
    }
    keyCallbacks.get(key)!.add(callback)

    return () => {
      const set = keyCallbacks.get(key)
      if (set) {
        set.delete(callback)
        if (set.size === 0) {
          keyCallbacks.delete(key)
        }
      }
    }
  }, [key, callback])

  useSWRSubscription('global-keydown', () => {
    const handler = (e: KeyboardEvent) => {
      if (e.metaKey && keyCallbacks.has(e.key)) {
        keyCallbacks.get(e.key)!.forEach(cb => cb())
      }
    }
    window.addEventListener('keydown', handler)
    return () => window.removeEventListener('keydown', handler)
  })
}

function Profile() {
  // 多個捷徑將共用同一個監聽器
  useKeyboardShortcut('p', () => { /* ... */ }) 
  useKeyboardShortcut('k', () => { /* ... */ })
  // ...
}
```

### 4.2 使用被動事件監聽器提升滾動效能

**影響程度：中 (MEDIUM)（消除由事件監聽器引起的滾動延遲）**

在觸控和滾輪事件監聽器中加入 `{ passive: true }` 以啟用立即滾動。瀏覽器通常會等待監聽器完成以檢查是否呼叫了 `preventDefault()`，這會導致滾動延遲。

**不正確：**

```typescript
useEffect(() => {
  const handleTouch = (e: TouchEvent) => console.log(e.touches[0].clientX)
  const handleWheel = (e: WheelEvent) => console.log(e.deltaY)
  
  document.addEventListener('touchstart', handleTouch)
  document.addEventListener('wheel', handleWheel)
  
  return () => {
    document.removeEventListener('touchstart', handleTouch)
    document.removeEventListener('wheel', handleWheel)
  }
}, [])
```

**正確：**

```typescript
useEffect(() => {
  const handleTouch = (e: TouchEvent) => console.log(e.touches[0].clientX)
  const handleWheel = (e: WheelEvent) => console.log(e.deltaY)
  
  document.addEventListener('touchstart', handleTouch, { passive: true })
  document.addEventListener('wheel', handleWheel, { passive: true })
  
  return () => {
    document.removeEventListener('touchstart', handleTouch)
    document.removeEventListener('wheel', handleWheel)
  }
}, [])
```

**在以下情況使用 passive：** 追蹤/分析、日誌記錄、任何不呼叫 `preventDefault()` 的監聽器。

**不要在以下情況使用 passive：** 實作自定義滑動手勢、自定義縮放控制，或任何需要 `preventDefault()` 的監聽器。

### 4.3 使用 SWR 進行自動去重

**影響程度：中-高 (MEDIUM-HIGH)（自動去重）**

SWR 可以在組件實例之間實現請求去重、快取 and 重新驗證。

**不正確：無去重，每個實例都會獲取數據**

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

**正確：多個實例共享一個請求**

```tsx
import useSWR from 'swr'

function UserList() {
  const { data: users } = useSWR('/api/users', fetcher)
}
```

**針對不可變數據：**

```tsx
import { useImmutableSWR } from '@/lib/swr'

function StaticContent() {
  const { data } = useImmutableSWR('/api/config', fetcher)
}
```

**針對變更 (Mutations)：**

```tsx
import { useSWRMutation } from 'swr/mutation'

function UpdateButton() {
  const { trigger } = useSWRMutation('/api/user', updateUser)
  return <button onClick={() => trigger()}>更新</button>
}
```

參考：[https://swr.vercel.app](https://swr.vercel.app)

### 4.4 版本化並最小化 localStorage 數據

**影響程度：中 (MEDIUM)（防止架構衝突，減少儲存大小）**

在鍵值前加入版本前綴，且僅儲存需要的欄位。這能防止架構衝突並避免意外儲存敏感數據。

**不正確：**

```typescript
// 無版本、儲存所有內容、無錯誤處理
localStorage.setItem('userConfig', JSON.stringify(fullUserObject))
const data = localStorage.getItem('userConfig')
```

**正確：**

```typescript
const VERSION = 'v2'

function saveConfig(config: { theme: string; language: string }) {
  try {
    localStorage.setItem(`userConfig:${VERSION}`, JSON.stringify(config))
  } catch {
    // 在無痕/私密瀏覽、配額超出或停用時會拋出錯誤
  }
}

function loadConfig() {
  try {
    const data = localStorage.getItem(`userConfig:${VERSION}`)
    return data ? JSON.parse(data) : null
  } catch {
    return null
  }
}

// 從 v1 遷移至 v2
function migrate() {
  try {
    const v1 = localStorage.getItem('userConfig:v1')
    if (v1) {
      const old = JSON.parse(v1)
      saveConfig({ theme: old.darkMode ? 'dark' : 'light', language: old.lang })
      localStorage.removeItem('userConfig:v1')
    }
  } catch {}
}
```

**從伺服器回應中儲存最小欄位：**

```typescript
// 用戶物件有 20 個以上的欄位，僅儲存 UI 需要的內容
function cachePrefs(user: FullUser) {
  try {
    localStorage.setItem('prefs:v1', JSON.stringify({
      theme: user.preferences.theme,
      notifications: user.preferences.notifications
    }))
  } catch {}
}
```

**務必使用 try-catch 包裹：** `getItem()` 和 `setItem()` 在無痕/私密瀏覽（Safari、Firefox）、配額超出或功能停用時會拋出錯誤。

**優點：** 透過版本控制進行架構演進、減少儲存大小、防止儲存 Token/PII（個人識別資訊）/內部旗標。

---

## 5. 重新渲染優化 (Re-render Optimization)

**影響程度：中 (MEDIUM)**

減少不必要的重新渲染可最小化計算浪費並提升 UI 響應性。

### 5.1 在渲染期間計算衍生狀態

**影響程度：中 (MEDIUM)（避免冗餘渲染和狀態漂移）**

如果一個值可以從當前的 Props/State 計算出來，請不要將其儲存在 State 中或在 Effect 中更新它。在渲染期間衍生該值，以避免額外的渲染和狀態漂移。不要僅為了回應 Prop 變更而使用 Effect 來設定狀態；應偏好衍生值或使用 Key 重設。

**不正確：冗餘的狀態和 Effect**

```tsx
function Form() {
  const [firstName, setFirstName] = useState('First')
  const [lastName, setLastName] = useState('Last')
  const [fullName, setFullName] = useState('')

  useEffect(() => {
    setFullName(firstName + ' ' + lastName)
  }, [firstName, lastName])

  return <p>{fullName}</p>
}
```

**正確：在渲染期間衍生**

```tsx
function Form() {
  const [firstName, setFirstName] = useState('First')
  const [lastName, setLastName] = useState('Last')
  const fullName = firstName + ' ' + lastName

  return <p>{fullName}</p>
}
```

參考：[https://react.dev/learn/you-might-not-need-an-effect](https://react.dev/learn/you-might-not-need-an-effect)

### 5.2 將狀態讀取延遲到使用點

**影響程度：中 (MEDIUM)（避免不必要的訂閱）**

如果您僅在回呼函式內部讀取動態狀態（如 searchParams、localStorage），則不要訂閱它。

**不正確：訂閱了所有 searchParams 的變更**

```tsx
function ShareButton({ chatId }: { chatId: string }) {
  const searchParams = useSearchParams()

  const handleShare = () => {
    const ref = searchParams.get('ref')
    shareChat(chatId, { ref })
  }

  return <button onClick={handleShare}>分享</button>
}
```

**正確：按需讀取，無訂閱**

```tsx
function ShareButton({ chatId }: { chatId: string }) {
  const handleShare = () => {
    const params = new URLSearchParams(window.location.search)
    const ref = params.get('ref')
    shareChat(chatId, { ref })
  }

  return <button onClick={handleShare}>分享</button>
}
```

### 5.3 不要用 useMemo 包裹返回原始型別結果的簡單表達式

**影響程度：低-中 (LOW-MEDIUM)（每次渲染都會浪費計算）**

當運算式很簡單（僅有少數邏輯或算術運算子）且回傳原始型別結果（布林值、數字、字串）時，不要用 `useMemo` 包裹它。

呼叫 `useMemo` 並比較 Hook 的依賴項所消耗的資源，可能比運算式本身還多。

**不正確：**

```tsx
function Header({ user, notifications }: Props) {
  const isLoading = useMemo(() => {
    return user.isLoading || notifications.isLoading
  }, [user.isLoading, notifications.isLoading])

  if (isLoading) return <Skeleton />
  // 回傳一些標記
}
```

**正確：**

```tsx
function Header({ user, notifications }: Props) {
  const isLoading = user.isLoading || notifications.isLoading

  if (isLoading) return <Skeleton />
  // 回傳一些標記
}
```

### 5.4 不要在組件內部定義組件

**影響程度：高 (HIGH)（防止每次渲染時重新掛載）**

在另一個組件內部定義組件，會在每次渲染時建立一個新的組件類型。React 每次都會將其視為不同的組件並完全重新掛載它，從而銷毀所有狀態和 DOM。

開發者這樣做的一個常見原因是為了在不傳遞 Props 的情況下存取父組件的變數。請務必改為傳遞 Props。

**不正確：每次渲染都重新掛載**

```tsx
function UserProfile({ user, theme }) {
  // 在內部定義以存取 `theme` - 錯誤
  const Avatar = () => (
    <img
      src={user.avatarUrl}
      className={theme === 'dark' ? 'avatar-dark' : 'avatar-light'}
    />
  )

  // 在內部定義以存取 `user` - 錯誤
  const Stats = () => (
    <div>
      <span>{user.followers} 位追蹤者</span>
      <span>{user.posts} 篇貼文</span>
    </div>
  )

  return (
    <div>
      <Avatar />
      <Stats />
    </div>
  )
}
```

每次 `UserProfile` 渲染時，`Avatar` 和 `Stats` 都是新的組件類型。React 會卸載舊實例並掛載新實例，導致失去任何內部狀態、重新執行 Effect 並重新建立 DOM 節點。

**正確：改為傳遞 Props**

```tsx
function Avatar({ src, theme }: { src: string; theme: string }) {
  return (
    <img
      src={src}
      className={theme === 'dark' ? 'avatar-dark' : 'avatar-light'}
    />
  )
}

function Stats({ followers, posts }: { followers: number; posts: number }) {
  return (
    <div>
      <span>{followers} 位追蹤者</span>
      <span>{posts} 篇貼文</span>
    </div>
  )
}

function UserProfile({ user, theme }) {
  return (
    <div>
      <Avatar src={user.avatarUrl} theme={theme} />
      <Stats followers={user.followers} posts={user.posts} />
    </div>
  )
}
```

**此 Bug 的症狀：**

- 輸入欄位在每次按鍵時失去焦點。

- 動畫意外重新開始。

- `useEffect` 的清理/設定在每次父組件渲染時執行。

- 組件內部的捲動位置重置。

### 5.5 將備忘錄組件的預設非原始參數值提取為常數

**影響程度：中 (MEDIUM)（透過使用常數作為預設值來恢復備忘錄化）**

當備忘錄組件 (Memoized Component) 對某些非原始選用參數（如陣列、函式或物件）具有預設值時，在不帶該參數的情況下呼叫組件會導致備忘錄化失效。這是因為每次重新渲染時都會建立新的數值實例，且它們無法通過 `memo()` 的嚴格相等比較。

要解決此問題，請將預設值提取為常數。

**不正確：每次重新渲染時 `onClick` 都有不同的值**

```tsx
const UserAvatar = memo(function UserAvatar({ onClick = () => {} }: { onClick?: () => void }) {
  // ...
})

// 在沒有選用的 onClick 情況下使用
<UserAvatar />
```

**正確：穩定的預設值**

```tsx
const NOOP = () => {};

const UserAvatar = memo(function UserAvatar({ onClick = NOOP }: { onClick?: () => void }) {
  // ...
})

// 在沒有選用的 onClick 情況下使用
<UserAvatar />
```

### 5.6 提取為備忘錄組件

**影響程度：中 (MEDIUM)（啟用提早回傳）**

將昂貴的工作提取到備忘錄組件中，以便在計算前啟用提早回傳 (Early Returns)。

**不正確：即使在載入中仍計算大頭貼**

```tsx
function Profile({ user, loading }: Props) {
  const avatar = useMemo(() => {
    const id = computeAvatarId(user)
    return <Avatar id={id} />
  }, [user])

  if (loading) return <Skeleton />
  return <div>{avatar}</div>
}
```

**正確：載入中時跳過計算**

```tsx
const UserAvatar = memo(function UserAvatar({ user }: { user: User }) {
  const id = useMemo(() => computeAvatarId(user), [user])
  return <Avatar id={id} />
})

function Profile({ user, loading }: Props) {
  if (loading) return <Skeleton />
  return (
    <div>
      <UserAvatar user={user} />
    </div>
  )
}
```

**註記：** 如果您的專案啟用了 [React Compiler](https://react.dev/learn/react-compiler)，則不需要手動使用 `memo()` 和 `useMemo()` 進行備忘錄化。編譯器會自動優化重新渲染。

### 5.7 縮小 Effect 依賴範圍

**影響程度：低 (LOW)（最小化 Effect 的重新執行）**

指定原始型別依賴項而非物件，以最小化 Effect 的重新執行。

**不正確：在任何用戶欄位變更時重新執行**

```tsx
useEffect(() => {
  console.log(user.id)
}, [user])
```

**正確：僅在 id 變更時重新執行**

```tsx
useEffect(() => {
  console.log(user.id)
}, [user.id])
```

**對於衍生狀態，在 Effect 外部計算：**

```tsx
// 不正確：在 width=767, 766, 765... 時執行
useEffect(() => {
  if (width < 768) {
    enableMobileMode()
  }
}, [width])

// 正確：僅在布林值轉換時執行
const isMobile = width < 768
useEffect(() => {
  if (isMobile) {
    enableMobileMode()
  }
}, [isMobile])
```

### 5.8 將交互邏輯放入事件處理程序

**影響程度：中 (MEDIUM)（避免 Effect 重新執行和重複的副作用）**

如果副作用是由特定的用戶動作（提交、點擊、拖曳）觸發的，請在該事件處理程序中執行它。不要將動作建模為「狀態 + Effect」；這會導致 Effect 在無關的變更時重新執行，並可能導致動作重複。

**不正確：將事件建模為狀態 + Effect**

```tsx
function Form() {
  const [submitted, setSubmitted] = useState(false)
  const theme = useContext(ThemeContext)

  useEffect(() => {
    if (submitted) {
      post('/api/register')
      showToast('已註冊', theme)
    }
  }, [submitted, theme])

  return <button onClick={() => setSubmitted(true)}>提交</button>
}
```

**正確：在處理程序中執行**

```tsx
function Form() {
  const theme = useContext(ThemeContext)

  function handleSubmit() {
    post('/api/register')
    showToast('已註冊', theme)
  }

  return <button onClick={handleSubmit}>提交</button>
}
```

參考：[https://react.dev/learn/removing-effect-dependencies#should-this-code-move-to-an-event-handler](https://react.dev/learn/removing-effect-dependencies#should-this-code-move-to-an-event-handler)

### 5.9 訂閱衍生狀態

**影響程度：中 (MEDIUM)（減少重新渲染頻率）**

訂閱衍生的布林狀態而非連續數值，以減少重新渲染頻率。

**不正確：在每個像素變更時重新渲染**

```tsx
function Sidebar() {
  const width = useWindowWidth()  // 持續更新
  const isMobile = width < 768
  return <nav className={isMobile ? 'mobile' : 'desktop'} />
}
```

**正確：僅在布林值變更時重新渲染**

```tsx
function Sidebar() {
  const isMobile = useMediaQuery('(max-width: 767px)')
  return <nav className={isMobile ? 'mobile' : 'desktop'} />
}
```

### 5.10 使用函式形式的 setState 更新

**影響程度：中 (MEDIUM)（防止過時閉包並避免不適當的回呼重建）**

當根據當前狀態值更新狀態時，請使用 setState 的函式更新形式，而非直接引用狀態變數。這能防止過時閉包、消除不必要的依賴，並建立穩定的回呼引用。

**不正確：需要狀態作為依賴項**

```tsx
function TodoList() {
  const [items, setItems] = useState(initialItems)
  
  // 回呼必須依賴 items，在每次 items 變更時都會重建
  const addItems = useCallback((newItems: Item[]) => {
    setItems([...items, ...newItems])
  }, [items])  // ❌ items 依賴項導致重建
  
  // 如果忘記依賴項，存在過時閉包的風險
  const removeItem = useCallback((id: string) => {
    setItems(items.filter(item => item.id !== id))
  }, [])  // ❌ 缺少 items 依賴項 - 將使用過時的 items！
  
  return <ItemsEditor items={items} onAdd={addItems} onRemove={removeItem} />
}
```

第一個回呼在每次 `items` 變更時都會重建，這可能導致子組件不必要的重新渲染。第二個回呼存在過時閉包 Bug —— 它將永遠引用初始的 `items` 值。

**正確：穩定的回呼，無過時閉包**

```tsx
function TodoList() {
  const [items, setItems] = useState(initialItems)
  
  // 穩定的回呼，永不重建
  const addItems = useCallback((newItems: Item[]) => {
    setItems(curr => [...curr, ...newItems])
  }, [])  // ✅ 不需要依賴項
  
  // 總是使用最新狀態，無過時閉包風險
  const removeItem = useCallback((id: string) => {
    setItems(curr => curr.filter(item => item.id !== id))
  }, [])  // ✅ 安全且穩定
  
  return <ItemsEditor items={items} onAdd={addItems} onRemove={removeItem} />
}
```

**優點：**

1. **穩定的回呼引用** - 當狀態變更時，回呼不需要重建。

2. **無過時閉包** - 總是操作最新的狀態值。

3. **更少的依賴項** - 簡化依賴項陣列並減少記憶體洩漏。

4. **防止 Bug** - 消除了 React 閉包 Bug 最常見的來源。

**何時使用函式更新：**

- 任何依賴於當前狀態值的 setState。

- 在 useCallback/useMemo 內部需要用到狀態時。

- 引用了狀態的事件處理程序。

- 更新狀態的非同步操作。

**何時直接更新即可：**

- 將狀態設定為靜態值：`setCount(0)`。

- 僅從 Props/參數設定狀態：`setName(newName)`。

- 狀態不依賴於前一個值。

**註記：** 如果您的專案啟用了 [React Compiler](https://react.dev/learn/react-compiler)，編譯器可以自動優化某些案例，但為了正確性及防止過時閉包 Bug，仍建議使用函式更新。

### 5.11 使用延遲狀態初始化

**影響程度：中 (MEDIUM)（每次渲染都會浪費計算）**

對於昂貴的初始值，請向 `useState` 傳遞一個函式。如果不使用函式形式，初始化程式會在每次渲染時執行，儘管該值僅使用一次。

**不正確：每次渲染都執行**

```tsx
function FilteredList({ items }: { items: Item[] }) {
  // buildSearchIndex() 在「每次」渲染時都會執行，即使在初始化之後也是
  const [searchIndex, setSearchIndex] = useState(buildSearchIndex(items))
  const [query, setQuery] = useState('')
  
  // 當 query 變更時，buildSearchIndex 會不必要地再次執行
  return <SearchResults index={searchIndex} query={query} />
}

function UserProfile() {
  // JSON.parse 在每次渲染時都會執行
  const [settings, setSettings] = useState(
    JSON.parse(localStorage.getItem('settings') || '{}')
  )
  
  return <SettingsForm settings={settings} onChange={setSettings} />
}
```

**正確：僅執行一次**

```tsx
function FilteredList({ items }: { items: Item[] }) {
  // buildSearchIndex() 「僅」在初次渲染時執行
  const [searchIndex, setSearchIndex] = useState(() => buildSearchIndex(items))
  const [query, setQuery] = useState('')
  
  return <SearchResults index={searchIndex} query={query} />
}

function UserProfile() {
  // JSON.parse 僅在初次渲染時執行
  const [settings, setSettings] = useState(() => {
    const stored = localStorage.getItem('settings')
    return stored ? JSON.parse(stored) : {}
  })
  
  return <SettingsForm settings={settings} onChange={setSettings} />
}
```

當從 localStorage/sessionStorage 計算初始值、建立資料結構（索引、Map）、從 DOM 讀取或執行繁重的轉換時，請使用延遲初始化。

對於簡單的原始型別 (`useState(0)`)、直接引用 (`useState(props.value)`) 或廉價的字面值 (`useState({})`)，則不需要使用函式形式。

### 5.12 對非緊急更新使用 Transitions

**影響程度：中 (MEDIUM)（維持 UI 響應性）**

將頻繁且非緊急的狀態更新標記為過渡 (Transitions)，以維持 UI 的響應性。

**不正確：每次捲動都會阻塞 UI**

```tsx
function ScrollTracker() {
  const [scrollY, setScrollY] = useState(0)
  useEffect(() => {
    const handler = () => setScrollY(window.scrollY)
    window.addEventListener('scroll', handler, { passive: true })
    return () => window.removeEventListener('scroll', handler)
  }, [])
}
```

**正確：非阻塞更新**

```tsx
import { startTransition } from 'react'

function ScrollTracker() {
  const [scrollY, setScrollY] = useState(0)
  useEffect(() => {
    const handler = () => {
      startTransition(() => setScrollY(window.scrollY))
    }
    window.addEventListener('scroll', handler, { passive: true })
    return () => window.removeEventListener('scroll', handler)
  }, [])
}
```

### 5.13 對瞬態值使用 useRef

**影響程度：中 (MEDIUM)（避免在頻繁更新時進行不必要的重新渲染）**

當一個值頻繁變動，且您不希望在每次更新時都重新渲染（例如：滑鼠追蹤器、計時器、瞬態旗標）時，請將其儲存在 `useRef` 而非 `useState` 中。保持組件狀態用於 UI，將 Ref 用於與 DOM 相關的臨時值。更新 Ref 不會觸發重新渲染。

**不正確：每次更新都渲染**

```tsx
function Tracker() {
  const [lastX, setLastX] = useState(0)

  useEffect(() => {
    const onMove = (e: MouseEvent) => setLastX(e.clientX)
    window.addEventListener('mousemove', onMove)
    return () => window.removeEventListener('mousemove', onMove)
  }, [])

  return (
    <div
      style={{
        position: 'fixed',
        top: 0,
        left: lastX,
        width: 8,
        height: 8,
        background: 'black',
      }}
    />
  )
}
```

**正確：追蹤時不重新渲染**

```tsx
function Tracker() {
  const lastXRef = useRef(0)
  const dotRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    const onMove = (e: MouseEvent) => {
      lastXRef.current = e.clientX
      const node = dotRef.current
      if (node) {
        node.style.transform = `translateX(${e.clientX}px)`
      }
    }
    window.addEventListener('mousemove', onMove)
    return () => window.removeEventListener('mousemove', onMove)
  }, [])

  return (
    <div
      ref={dotRef}
      style={{
        position: 'fixed',
        top: 0,
        left: 0,
        width: 8,
        height: 8,
        background: 'black',
        transform: 'translateX(0px)',
      }}
    />
  )
}
```

---

## 6. 渲染效能 (Rendering Performance)

**影響程度：中 (MEDIUM)**

優化渲染過程可減少瀏覽器需要執行的工作。

### 6.1 動畫化 SVG 包裹器而非 SVG 元素本身

**影響程度：低 (LOW)（啟用硬體加速）**

許多瀏覽器不支援在 SVG 元素上對 CSS3 動畫進行硬體加速。請將 SVG 包裹在 `<div>` 中，並改為動畫化該包裹器。

**不正確：直接動畫化 SVG - 無硬體加速**

```tsx
function LoadingSpinner() {
  return (
    <svg 
      className="animate-spin"
      width="24" 
      height="24" 
      viewBox="0 0 24 24"
    >
      <circle cx="12" cy="12" r="10" stroke="currentColor" />
    </svg>
  )
}
```

**正確：動畫化包裹器的 div - 硬體加速**

```tsx
function LoadingSpinner() {
  return (
    <div className="animate-spin">
      <svg 
        width="24" 
        height="24" 
        viewBox="0 0 24 24"
      >
        <circle cx="12" cy="12" r="10" stroke="currentColor" />
      </svg>
    </div>
  )
}
```

這適用於所有 CSS 轉換 (Transforms) 和過渡 (Transitions)（`transform`、`opacity`、`translate`、`scale`、`rotate`）。包裹器 div 讓瀏覽器可以使用 GPU 加速，從而使動畫更流暢。

### 6.2 對長列表使用 CSS content-visibility

**影響程度：高 (HIGH)（更快的初次渲染）**

套用 `content-visibility: auto` 以延遲螢幕外內容的渲染。

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

對於 1000 條訊息，瀏覽器會跳過約 990 個螢幕外項目的版面配置/繪製（初次渲染快 10 倍）。

### 6.3 提升靜態 JSX 元素

**影響程度：低 (LOW)（避免重新建立）**

將靜態 JSX 提取至組件外部，以避免重新建立。

**不正確：每次渲染都重新建立元素**

```tsx
function LoadingSkeleton() {
  return <div className="animate-pulse h-20 bg-gray-200" />
}

function Container() {
  return (
    <div>
      {loading && <LoadingSkeleton />}
    </div>
  )
}
```

**正確：重複使用相同元素**

```tsx
const loadingSkeleton = (
  <div className="animate-pulse h-20 bg-gray-200" />
)

function Container() {
  return (
    <div>
      {loading && loadingSkeleton}
    </div>
  )
}
```

這對大型且靜態的 SVG 節點特別有幫助，因為它們在每次渲染時重新建立的成本可能很高。

**註記：** 如果您的專案啟用了 [React Compiler](https://react.dev/learn/react-compiler)，編譯器會自動提升靜態 JSX 元素並優化組件重新渲染，因此不需要手動提升。

### 6.4 優化 SVG 精度

**影響程度：低 (LOW)（減少檔案大小）**

減少 SVG 座標精度以縮減檔案大小。最佳精度取決於 viewBox 大小，但通常應考慮降低精度。

**不正確：過度精確**

```svg
<path d="M 10.293847 20.847362 L 30.938472 40.192837" />
```

**正確：保留 1 位小數**

```svg
<path d="M 10.3 20.8 L 30.9 40.2" />
```

**使用 SVGO 自動化：**

```bash
npx svgo --precision=1 --multipass icon.svg
```

### 6.5 防止水合不匹配且不引起閃爍

**影響程度：中 (MEDIUM)（避免視覺閃爍和水合錯誤）**

當渲染依賴於用戶端儲存（localStorage、Cookie）的內容時，請透過注入同步腳本在 React 水合 (Hydrate) 之前更新 DOM，以同時避免 SSR 損壞和水合後的閃爍。

**不正確：損壞 SSR**

```tsx
function ThemeWrapper({ children }: { children: ReactNode }) {
  // localStorage 在伺服器上不可用 - 會拋出錯誤
  const theme = localStorage.getItem('theme') || 'light'
  
  return (
    <div className={theme}>
      {children}
    </div>
  )
}
```

伺服器端渲染會失敗，因為 `localStorage` 未定義。

**不正確：視覺閃爍**

```tsx
function ThemeWrapper({ children }: { children: ReactNode }) {
  const [theme, setTheme] = useState('light')
  
  useEffect(() => {
    // 在水合後執行 - 導致可見的閃爍
    const stored = localStorage.getItem('theme')
    if (stored) {
      setTheme(stored)
    }
  }, [])
  
  return (
    <div className={theme}>
      {children}
    </div>
  )
}
```

組件會先以預設值 (`light`) 渲染，然後在水合後更新，導致不正確內容的可見閃爍。

**正確：無閃爍、無水合不匹配**

```tsx
function ThemeWrapper({ children }: { children: ReactNode }) {
  return (
    <>
      <div id="theme-wrapper">
        {children}
      </div>
      <script
        dangerouslySetInnerHTML={{
          __html: `
            (function() {
              try {
                var theme = localStorage.getItem('theme') || 'light';
                var el = document.getElementById('theme-wrapper');
                if (el) el.className = theme;
              } catch (e) {}
            })();
          `,
        }}
      />
    </>
  )
}
```

內嵌腳本在顯示元素前同步執行，確保 DOM 已經具有正確的值。無閃爍，無水合不匹配。

此模式對於切換佈景主題、用戶偏好、驗證狀態，以及任何應立即渲染且不顯示預設值閃爍的純用戶端數據特別有用。

### 6.6 抑制預期的水合不匹配

**影響程度：低-中 (LOW-MEDIUM)（避免對已知的差異發出擾人的水合警告）**

在 SSR 框架（如 Next.js）中，某些值在伺服器端與用戶端本來就不同（隨機 ID、日期、語系/時區格式化）。對於這些 *預期中* 的不匹配，請在元素上包裹 `suppressHydrationWarning` 以防止擾人的警告。不要用它來隱藏真正的 Bug。不要過度使用。

**不正確：已知的對不匹配發出警告**

```tsx
function Timestamp() {
  return <span>{new Date().toLocaleString()}</span>
}
```

**正確：僅抑制預期的不匹配**

```tsx
function Timestamp() {
  return (
    <span suppressHydrationWarning>
      {new Date().toLocaleString()}
    </span>
  )
}
```

### 6.7 對顯示/隱藏使用 Activity 組件

**影響程度：中 (MEDIUM)（保留狀態/DOM）**

對頻繁切換顯示狀態且成本昂貴的組件，使用 React 的 `<Activity>` 來保留其狀態和 DOM。

**用法：**

```tsx
import { Activity } from 'react'

function Dropdown({ isOpen }: Props) {
  return (
    <Activity mode={isOpen ? 'visible' : 'hidden'}>
      <ExpensiveMenu />
    </Activity>
  )
}
```

避開了昂貴的重新渲染和狀態丟失。

### 6.8 在 Script 標籤上使用 defer 或 async

**影響程度：高 (HIGH)（消除渲染阻塞）**

不帶有 `defer` 或 `async` 的 Script 標籤會在下載和執行腳本時阻塞 HTML 解析。這會延遲首次內容繪製 (First Contentful Paint) 和可互動時間 (Time to Interactive)。

- **`defer`**：平行下載，在 HTML 解析完成後執行，並保持執行順序。

- **`async`**：平行下載，準備就緒後立即執行，不保證順序。

對於依賴 DOM 或其他腳本的腳本，請使用 `defer`。對於獨立腳本（如分析工具），請使用 `async`。

**錯誤：阻塞渲染**

```tsx
export default function Document() {
  return (
    <html>
      <head>
        <script src="https://example.com/analytics.js" />
        <script src="/scripts/utils.js" />
      </head>
      <body>{/* 內容 */}</body>
    </html>
  )
}
```

**正確：非阻塞**

```tsx
import Script from 'next/script'

export default function Page() {
  return (
    <>
      <Script src="https://example.com/analytics.js" strategy="afterInteractive" />
      <Script src="/scripts/utils.js" strategy="beforeInteractive" />
    </>
  )
}
```

**註記：** 在 Next.js 中，偏好使用具有 `strategy` 屬性的 `next/script` 組件，而非原始的 script 標籤：

參考：[https://developer.mozilla.org/en-US/docs/Web/HTML/Element/script#defer](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/script#defer)

### 6.9 使用顯式條件渲染

**影響程度：低 (LOW)（防止渲染 0 或 NaN）**

當條件可能為 `0`、`NaN` 或其他會被渲染的虛值 (falsy values) 時，請使用顯式的三元運算子 (`? :`) 而非 `&&` 來進行條件渲染。

**錯誤：當 count 為 0 時渲染 "0"**

```tsx
function Badge({ count }: { count: number }) {
  return (
    <div>
      {count && <span className="badge">{count}</span>}
    </div>
  )
}

// 當 count = 0 時，渲染：<div>0</div>
// 當 count = 5 時，渲染：<div><span class="badge">5</span></div>
```

**正確：當 count 為 0 時不渲染任何內容**

```tsx
function Badge({ count }: { count: number }) {
  return (
    <div>
      {count > 0 ? <span className="badge">{count}</span> : null}
    </div>
  )
}

// 當 count = 0 時，渲染：<div></div>
// 當 count = 5 時，渲染：<div><span class="badge">5</span></div>
```

### 6.10 使用 React DOM 資源提示 (Resource Hints)

**影響程度：高 (HIGH)（減少關鍵資源的載入時間）**

React DOM 提供了 API 來提示瀏覽器即將需要的資源。這些 API 在伺服器組件中特別有用，可以在用戶端接收到 HTML 之前就開始載入資源。

- **`prefetchDNS(href)`**：解析預期會連線的網域之 DNS。

- **`preconnect(href)`**：建立與伺服器的連線（DNS + TCP + TLS）。

- **`preload(href, options)`**：獲取即將使用的資源（樣式表、字體、腳本、圖片）。

- **`preloadModule(href)`**：獲取即將使用的 ES 模組。

- **`preinit(href, options)`**：獲取並評估樣式表或腳本。

- **`preinitModule(href)`**：獲取並評估 ES 模組。

**範例：預先連線至第三方 API**

```tsx
import { preconnect, prefetchDNS } from 'react-dom'

export default function App() {
  prefetchDNS('https://analytics.example.com')
  preconnect('https://api.example.com')

  return <main>{/* 內容 */}</main>
}
```

**範例：預載關鍵字體和樣式**

```tsx
import { preload, preinit } from 'react-dom'

export default function RootLayout({ children }) {
  // 預載字體檔案
  preload('/fonts/inter.woff2', { as: 'font', type: 'font/woff2', crossOrigin: 'anonymous' })

  // 立即獲取並套用關鍵樣式表
  preinit('/styles/critical.css', { as: 'style' })

  return (
    <html>
      <body>{children}</body>
    </html>
  )
}
```

**範例：為程式碼分割的路由預載模組**

```tsx
import { preloadModule, preinitModule } from 'react-dom'

function Navigation() {
  const preloadDashboard = () => {
    preloadModule('/dashboard.js', { as: 'script' })
  }

  return (
    <nav>
      <a href="/dashboard" onMouseEnter={preloadDashboard}>
        儀表板
      </a>
    </nav>
  )
}
```

**何時使用：**

| API | 使用案例 |
|-----|----------|
| `prefetchDNS` | 稍後會連線的第三方網域 |
| `preconnect` | 會立即獲取的 API 或 CDN |
| `preload` | 當前頁面需要的關鍵資源 |
| `preloadModule` | 可能進行下次導覽所需的 JS 模組 |
| `preinit` | 必須儘早執行的樣式表/腳本 |
| `preinitModule` | 必須儘早執行的 ES 模組 |

參考：[https://react.dev/reference/react-dom#resource-preloading-apis](https://react.dev/reference/react-dom#resource-preloading-apis)

### 6.11 使用 useTransition 代替手動載入狀態

**影響程度：低 (LOW)（減少重新渲染並提升程式碼清晰度）**

使用 `useTransition` 而非手動使用 `useState` 來管理載入狀態。這提供了內建的 `isPending` 狀態，並能自動管理過渡。

**錯誤：手動載入狀態**

```tsx
function SearchResults() {
  const [query, setQuery] = useState('')
  const [results, setResults] = useState([])
  const [isLoading, setIsLoading] = useState(false)

  const handleSearch = async (value: string) => {
    setIsLoading(true)
    setQuery(value)
    const data = await fetchResults(value)
    setResults(data)
    setIsLoading(false)
  }

  return (
    <>
      <input onChange={(e) => handleSearch(e.target.value)} />
      {isLoading && <Spinner />}
      <ResultsList results={results} />
    </>
  )
}
```

**正確：使用具有內建 pending 狀態的 useTransition**

```tsx
import { useTransition, useState } from 'react'

function SearchResults() {
  const [query, setQuery] = useState('')
  const [results, setResults] = useState([])
  const [isPending, startTransition] = useTransition()

  const handleSearch = (value: string) => {
    setQuery(value) // 立即更新輸入
    
    startTransition(async () => {
      // 獲取並更新結果
      const data = await fetchResults(value)
      setResults(data)
    })
  }

  return (
    <>
      <input onChange={(e) => handleSearch(e.target.value)} />
      {isPending && <Spinner />}
      <ResultsList results={results} />
    </>
  )
}
```

**優點：**

- **自動 Pending 狀態**：無需手動管理 `setIsLoading(true/false)`。

- **錯誤韌性**：即使過渡發生錯誤，Pending 狀態也會正確重設。

- **更好的響應性**：在更新期間保持 UI 的響應性。

- **中斷處理**：新的過渡會自動取消掛起的過渡。

參考：[https://react.dev/reference/react/useTransition](https://react.dev/reference/react/useTransition)

---

## 7. JavaScript 效能 (JavaScript Performance)

**影響程度：低-中 (LOW-MEDIUM)**

針對熱點路徑 (hot paths) 的微優化可以累積成顯著的改進。

### 7.1 避免版面配置抖動 (Layout Thrashing)

**影響程度：中 (MEDIUM)（防止強制同步版面配置並減少效能瓶頸）**

避免在樣式寫入與版面配置讀取之間交錯進行。當您在樣式變更之間讀取版面配置屬性（如 `offsetWidth`、`getBoundingClientRect()` 或 `getComputedStyle()`）時，瀏覽器會被迫觸發同步重排 (reflow)。

**這沒問題：瀏覽器會批次處理樣式變更**

```typescript
function updateElementStyles(element: HTMLElement) {
  // 每一行都會使樣式失效，但瀏覽器會批次處理重新計算
  element.style.width = '100px'
  element.style.height = '200px'
  element.style.backgroundColor = 'blue'
  element.style.border = '1px solid black'
}
```

**錯誤：交錯讀取和寫入會強制重排**

```typescript
function layoutThrashing(element: HTMLElement) {
  element.style.width = '100px'
  const width = element.offsetWidth  // 強制重排
  element.style.height = '200px'
  const height = element.offsetHeight  // 強制另一次重排
}
```

**正確：批次寫入，然後讀取一次**

```typescript
function updateElementStyles(element: HTMLElement) {
  // 將所有寫入批次處理在一起
  element.style.width = '100px'
  element.style.height = '200px'
  element.style.backgroundColor = 'blue'
  element.style.border = '1px solid black'
  
  // 在所有寫入完成後讀取（單次重排）
  const { width, height } = element.getBoundingClientRect()
}
```

**正確：批次讀取，然後寫入**

```typescript
function updateElementStyles(element: HTMLElement) {
  element.classList.add('highlighted-box')
  
  const { width, height } = element.getBoundingClientRect()
}
```

**更好的做法：使用 CSS 類別**

**React 範例：**

```tsx
// 錯誤：將樣式變更與版面配置查詢交錯進行
function Box({ isHighlighted }: { isHighlighted: boolean }) {
  const ref = useRef<HTMLDivElement>(null)
  
  useEffect(() => {
    if (ref.current && isHighlighted) {
      ref.current.style.width = '100px'
      const width = ref.current.offsetWidth // 強制版面配置
      ref.current.style.height = '200px'
    }
  }, [isHighlighted])
  
  return <div ref={ref}>內容</div>
}

// 正確：切換類別
function Box({ isHighlighted }: { isHighlighted: boolean }) {
  return (
    <div className={isHighlighted ? 'highlighted-box' : ''}>
      內容
    </div>
  )
}
```

盡可能偏好使用 CSS 類別而非內嵌樣式。CSS 檔案會被瀏覽器快取，類別提供了更好的關注點分離，且更易於維護。

更多關於強制版面配置操作的資訊，請參閱 [此 Gist](https://gist.github.com/paulirish/5d52fb081b3570c81e3a) 和 [CSS Triggers](https://csstriggers.com/)。

### 7.2 為重複查詢建立索引映射 (Index Maps)

**影響程度：低-中 (LOW-MEDIUM)（從 1M 次操作減少至 2K 次）**

對於使用相同鍵值的多次 `.find()` 呼叫，應使用 Map。

**錯誤 (每次查詢為 O(n))：**

```typescript
function processOrders(orders: Order[], users: User[]) {
  return orders.map(order => ({
    ...order,
    user: users.find(u => u.id === order.userId)
  }))
}
```

**正確 (每次查詢為 O(1))：**

```typescript
function processOrders(orders: Order[], users: User[]) {
  const userById = new Map(users.map(u => [u.id, u]))

  return orders.map(order => ({
    ...order,
    user: userById.get(order.userId)
  }))
}
```

建立 Map 一次 (O(n))，之後的所有查詢均為 O(1)。

對於 1000 個訂單 × 1000 個用戶：1M 次操作 → 2K 次操作。

### 7.3 在迴圈中快取屬性存取

**影響程度：低-中 (LOW-MEDIUM)（減少查詢次數）**

在熱點路徑中快取物件屬性查詢。

**錯誤：3 次查詢 × N 次迭代**

```typescript
for (let i = 0; i < arr.length; i++) {
  process(obj.config.settings.value)
}
```

**正確：總共 1 次查詢**

```typescript
const value = obj.config.settings.value
const len = arr.length
for (let i = 0; i < len; i++) {
  process(value)
}
```

### 7.4 快取重複的函式呼叫

**影響程度：中 (MEDIUM)（避免冗餘計算）**

當在渲染期間使用相同的輸入重複呼叫同一個函式時，請使用模組層級的 Map 來快取函式結果。

**錯誤：冗餘計算**

```typescript
function ProjectList({ projects }: { projects: Project[] }) {
  return (
    <div>
      {projects.map(project => {
        // slugify() 為相同的專案名稱呼叫了 100 次以上
        const slug = slugify(project.name)
        
        return <ProjectCard key={project.id} slug={slug} />
      })}
    </div>
  )
}
```

**正確：快取結果**

```typescript
// 模組層級快取
const slugifyCache = new Map<string, string>()

function cachedSlugify(text: string): string {
  if (slugifyCache.has(text)) {
    return slugifyCache.get(text)!
  }
  const result = slugify(text)
  slugifyCache.set(text, result)
  return result
}

function ProjectList({ projects }: { projects: Project[] }) {
  return (
    <div>
      {projects.map(project => {
        // 每個唯一的專案名稱僅計算一次
        const slug = cachedSlugify(project.name)
        
        return <ProjectCard key={project.id} slug={slug} />
      })}
    </div>
  )
}
```

**單數值函式的簡單模式：**

```typescript
let isLoggedInCache: boolean | null = null

function isLoggedIn(): boolean {
  if (isLoggedInCache !== null) {
    return isLoggedInCache
  }
  
  isLoggedInCache = document.cookie.includes('auth=')
  return isLoggedInCache
}

// 當驗證狀態變更時清除快取
function onAuthChange() {
  isLoggedInCache = null
}
```

使用 Map（而非 Hook），以便在任何地方運作：工具函式、事件處理常式，而不僅限於 React 組件。

參考：[https://vercel.com/blog/how-we-made-the-vercel-dashboard-twice-as-fast](https://vercel.com/blog/how-we-made-the-vercel-dashboard-twice-as-fast)

### 7.5 快取 Storage API 呼叫

**影響程度：低-中 (LOW-MEDIUM)（減少昂貴的 I/O）**

`localStorage`、`sessionStorage` 和 `document.cookie` 是同步且昂貴的。應在記憶體中快取讀取結果。

**錯誤：每次呼叫都讀取儲存空間**

```typescript
function getTheme() {
  return localStorage.getItem('theme') ?? 'light'
}
// 呼叫 10 次 = 10 次儲存讀取
```

**正確：Map 快取**

```typescript
const storageCache = new Map<string, string | null>()

function getLocalStorage(key: string) {
  if (!storageCache.has(key)) {
    storageCache.set(key, localStorage.getItem(key))
  }
  return storageCache.get(key)
}

function setLocalStorage(key: string, value: string) {
  localStorage.setItem(key, value)
  storageCache.set(key, value)  // 保持快取同步
}
```

使用 Map（而非 Hook），以便在任何地方運作：工具函式、事件處理常式，而不僅限於 React 組件。

**Cookie 快取：**

```typescript
let cookieCache: Record<string, string> | null = null

function getCookie(name: string) {
  if (!cookieCache) {
    cookieCache = Object.fromEntries(
      document.cookie.split('; ').map(c => c.split('='))
    )
  }
  return cookieCache[name]
}
```

**重要：在外部變更時使快取失效**

如果儲存空間可能在外部發生變更（另一個分頁、伺服器設置的 cookie），請使快取失效：

```typescript
window.addEventListener('storage', (e) => {
  if (e.key) storageCache.delete(e.key)
})

document.addEventListener('visibilitychange', () => {
  if (document.visibilityState === 'visible') {
    storageCache.clear()
  }
})
```

### 7.6 合併多個陣列迭代

**影響程度：低-中 (LOW-MEDIUM)（減少迭代次數）**

多次 `.filter()` 或 `.map()` 呼叫會對陣列進行多次迭代。應將其合併為單次迴圈。

**錯誤：3 次迭代**

```typescript
const admins = users.filter(u => u.isAdmin)
const testers = users.filter(u => u.isTester)
const inactive = users.filter(u => !u.isActive)
```

**正確：1 次迭代**

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

### 7.7 陣列比較時優先進行長度檢查

**影響程度：中-高 (MEDIUM-HIGH)（在長度不同時避免昂貴操作）**

當使用昂貴的操作（排序、深層比較、序列化）比較陣列時，請先檢查長度。如果長度不同，陣列肯定不相等。

在實際應用中，當比較發生在熱點路徑（事件處理常式、渲染迴圈）時，此優化特別有價值。

**錯誤：總是執行昂貴的比較**

```typescript
function hasChanges(current: string[], original: string[]) {
  // 即使長度不同，也總是進行排序和合併
  return current.sort().join() !== original.sort().join()
}
```

即使 `current.length` 是 5 而 `original.length` 是 100，也會執行兩次 O(n log n) 的排序。此外還有合併陣列和比較字串的開銷。

**正確 (優先進行 O(1) 長度檢查)：**

```typescript
function hasChanges(current: string[], original: string[]) {
  // 如果長度不同，提早回傳
  if (current.length !== original.length) {
    return true
  }
  // 僅在長度相符時進行排序
  const currentSorted = current.toSorted()
  const originalSorted = original.toSorted()
  for (let i = 0; i < currentSorted.length; i++) {
    if (currentSorted[i] !== originalSorted[i]) {
      return true
    }
  }
  return false
}
```

這種新方法更有效率，因為：

- 避免了在長度不同時排序和合併陣列的開銷。

- 避免了為合併後的字串消耗記憶體（對於大型陣列尤為重要）。

- 避免了變更原始陣列。

- 在發現差異時立即回傳。

### 7.8 從函式中提早返回 (Early Return)

**影響程度：低-中 (LOW-MEDIUM)（避免不必要的計算）**

一旦確定結果，立即從函式中返回，以跳過不必要的處理。

**錯誤：即使找到答案後仍處理所有項目**

```typescript
function validateUsers(users: User[]) {
  let hasError = false
  let errorMessage = ''
  
  for (const user of users) {
    if (!user.email) {
      hasError = true
      errorMessage = '需要 Email'
    }
    if (!user.name) {
      hasError = true
      errorMessage = '需要名稱'
    }
    // 即使發現錯誤後仍繼續檢查所有用戶
  }
  
  return hasError ? { valid: false, error: errorMessage } : { valid: true }
}
```

**正確：在發現第一個錯誤時立即返回**

```typescript
function validateUsers(users: User[]) {
  for (const user of users) {
    if (!user.email) {
      return { valid: false, error: '需要 Email' }
    }
    if (!user.name) {
      return { valid: false, error: '需要名稱' }
    }
  }

  return { valid: true }
}
```

### 7.9 提升 RegExp 建立

**影響程度：低-中 (LOW-MEDIUM)（避免重複建立）**

不要在渲染期間建立 RegExp。應將其提升至模組作用域，或使用 `useMemo()` 進行備忘錄化。

**錯誤：每次渲染都建立新的 RegExp**

```tsx
function Highlighter({ text, query }: Props) {
  const regex = new RegExp(`(${query})`, 'gi')
  const parts = text.split(regex)
  return <>{parts.map((part, i) => ...)}</>
}
```

**正確：備忘錄化或提升**

```tsx
const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

function Highlighter({ text, query }: Props) {
  const regex = useMemo(
    () => new RegExp(`(${escapeRegex(query)})`, 'gi'),
    [query]
  )
  const parts = text.split(regex)
  return <>{parts.map((part, i) => ...)}</>
}
```

**警告：全域正則表達式具有可變狀態**

全域正則表達式 (`/g`) 具有可變的 `lastIndex` 狀態：

```typescript
const regex = /foo/g
regex.test('foo')  // true, lastIndex = 3
regex.test('foo')  // false, lastIndex = 0
```

### 7.10 使用 flatMap 在一次遍歷中同時完成映射和篩選

**影響程度：低-中 (LOW-MEDIUM)（消除中間陣列）**

串聯 `.map().filter(Boolean)` 會建立一個中間陣列並迭代兩次。使用 `.flatMap()` 可以在單次遍歷中完成轉換和篩選。

**錯誤：2 次迭代，存在中間陣列**

```typescript
const userNames = users
  .map(user => user.isActive ? user.name : null)
  .filter(Boolean)
```

**正確：1 次迭代，無中間陣列**

```typescript
const userNames = users.flatMap(user =>
  user.isActive ? [user.name] : []
)
```

**更多範例：**

```typescript
// 從回應中提取有效的 email
// 之前
const emails = responses
  .map(r => r.success ? r.data.email : null)
  .filter(Boolean)

// 之後
const emails = responses.flatMap(r =>
  r.success ? [r.data.email] : []
)

// 解析並篩選有效的數字
// 之前
const numbers = strings
  .map(s => parseInt(s, 10))
  .filter(n => !isNaN(n))

// 之後
const numbers = strings.flatMap(s => {
  const n = parseInt(s, 10)
  return isNaN(n) ? [] : [n]
})
```

**何時使用：**

- 在轉換項目的同時篩選掉某些項目。

- 某些輸入不產生輸出的條件式映射。

- 需要跳過無效輸入的解析/驗證。

### 7.11 使用迴圈計算最大/最小值而非排序

**影響程度：低 (LOW) (O(n) 而非 O(n log n))**

尋找最小或最大元素只需要遍歷陣列一次。排序是浪費且較慢的。

**錯誤 (O(n log n) - 透過排序尋找最新項)：**

```typescript
interface Project {
  id: string
  name: string
  updatedAt: number
}

function getLatestProject(projects: Project[]) {
  const sorted = [...projects].sort((a, b) => b.updatedAt - a.updatedAt)
  return sorted[0]
}
```

僅為了尋找最大值而對整個陣列進行排序。

**錯誤 (O(n log n) - 透過排序尋找最舊和最新項)：**

```typescript
function getOldestAndNewest(projects: Project[]) {
  const sorted = [...projects].sort((a, b) => a.updatedAt - b.updatedAt)
  return { oldest: sorted[0], newest: sorted[sorted.length - 1] }
}
```

在僅需要最小/最大值時，仍然進行了不必要的排序。

**正確 (O(n) - 單次迴圈)：**

```typescript
function getLatestProject(projects: Project[]) {
  if (projects.length === 0) return null
  
  let latest = projects[0]
  
  for (let i = 1; i < projects.length; i++) {
    if (projects[i].updatedAt > latest.updatedAt) {
      latest = projects[i]
    }
  }
  
  return latest
}

function getOldestAndNewest(projects: Project[]) {
  if (projects.length === 0) return { oldest: null, newest: null }
  
  let oldest = projects[0]
  let newest = projects[0]
  
  for (let i = 1; i < projects.length; i++) {
    if (projects[i].updatedAt < oldest.updatedAt) oldest = projects[i]
    if (projects[i].updatedAt > newest.updatedAt) newest = projects[i]
  }
  
  return { oldest, newest }
}
```

單次遍歷陣列，無複製，無排序。

**替代方案：對小型陣列使用 Math.min/Math.max**

```typescript
const numbers = [5, 2, 8, 1, 9]
const min = Math.min(...numbers)
const max = Math.max(...numbers)
```

這適用於小型陣列，但對於極大型陣列，由於展開運算子 (spread operator) 的限制，可能會較慢甚至拋出錯誤。Chrome 143 的最大陣列長度約為 124,000，Safari 18 約為 638,000；確切數值可能有所不同 —— 請參閱 [此 Fiddle](https://jsfiddle.net/qw1jabsx/4/)。為了可靠性，請使用迴圈方法。

### 7.12 使用 Set/Map 進行 O(1) 查詢

**影響程度：低-中 (LOW-MEDIUM) (O(n) 降至 O(1))**

將陣列轉換為 Set/Map 以進行重複的成員檢查。

**錯誤 (每次檢查為 O(n))：**

```typescript
const allowedIds = ['a', 'b', 'c', ...]
items.filter(item => allowedIds.includes(item.id))
```

**正確 (每次檢查為 O(1))：**

```typescript
const allowedIds = new Set(['a', 'b', 'c', ...])
items.filter(item => allowedIds.has(item.id))
```

### 7.13 使用 toSorted() 代替 sort() 以確保不可變性

**影響程度：中-高 (MEDIUM-HIGH)（防止 React 狀態中的變更 Bug）**

`.sort()` 會就地 (in place) 變更陣列，這可能會導致 React 狀態和 Props 的 Bug。請使用 `.toSorted()` 來建立一個新的排序後陣列，而不變更原陣列。

**錯誤：變更了原始陣列**

```typescript
function UserList({ users }: { users: User[] }) {
  // 變更了 users prop 陣列！
  const sorted = useMemo(
    () => users.sort((a, b) => a.name.localeCompare(b.name)),
    [users]
  )
  return <div>{sorted.map(renderUser)}</div>
}
```

**正確：建立新陣列**

```typescript
function UserList({ users }: { users: User[] }) {
  // 建立新的排序後陣列，原始陣列保持不變
  const sorted = useMemo(
    () => users.toSorted((a, b) => a.name.localeCompare(b.name)),
    [users]
  )
  return <div>{sorted.map(renderUser)}</div>
}
```

**為什麼這在 React 中很重要：**

1. Props/狀態的變更破壞了 React 的不可變性模型 —— React 預期 Props 和狀態應被視為唯讀。

2. 導致過時閉包 (stale closure) Bug —— 在閉包（回呼、Effect）中變更陣列可能導致非預期的行為。

**瀏覽器支援：針對舊型瀏覽器的備案**

```typescript
// 針對舊型瀏覽器的備案
const sorted = [...items].sort((a, b) => a.value - b.value)
```

`.toSorted()` 已在所有現代瀏覽器（Chrome 110+、Safari 16+、Firefox 115+、Node.js 20+）中可用。對於舊型環境，請使用展開運算子。

**其他不可變陣列方法：**

- `.toSorted()` - 不可變排序

- `.toReversed()` - 不可變反轉

- `.toSpliced()` - 不可變拼接 (splice)

- `.with()` - 不可變元素替換

---

## 8. 進階模式 (Advanced Patterns)

**影響程度：低 (LOW)**

針對需要謹謹慎實作之特定案例的進階模式。

### 8.1 應用程式初始化一次，而非每次掛載

**影響程度：低-中 (LOW-MEDIUM)（避免在開發環境中重複初始化）**

不要將整個應用程式範圍內、每次載入僅需執行一次的初始化邏輯放在組件的 `useEffect([])` 中。組件可能會重新掛載，導致 Effect 再次執行。應改用模組層級的守衛 (guard) 或在進入點模組中進行頂層初始化。

**錯誤：在開發環境執行兩次，重新掛載時再次執行**

```tsx
function Comp() {
  useEffect(() => {
    loadFromStorage()
    checkAuthToken()
  }, [])

  // ...
}
```

**正確：每次應用程式載入執行一次**

```tsx
let didInit = false

function Comp() {
  useEffect(() => {
    if (didInit) return
    didInit = true
    loadFromStorage()
    checkAuthToken()
  }, [])

  // ...
}
```

參考：[https://react.dev/learn/you-might-not-need-an-effect#initializing-the-application](https://react.dev/learn/you-might-not-need-an-effect#initializing-the-application)

### 8.2 將事件處理程序儲存在 Refs 中

**影響程度：低 (LOW)（穩定訂閱）**

當在不應隨回呼變更而重新訂閱的 Effect 中使用回呼時，將回呼儲存在 Ref 中。

**錯誤：每次渲染都重新訂閱**

```tsx
function useWindowEvent(event: string, handler: (e) => void) {
  useEffect(() => {
    window.addEventListener(event, handler)
    return () => window.removeEventListener(event, handler)
  }, [event, handler])
}
```

**正確：穩定訂閱**

```tsx
import { useEffectEvent } from 'react'

function useWindowEvent(event: string, handler: (e) => void) {
  const onEvent = useEffectEvent(handler)

  useEffect(() => {
    window.addEventListener(event, onEvent)
    return () => window.removeEventListener(event, onEvent)
  }, [event])
}
```

**替代方案：如果您使用最新版本的 React，請使用 `useEffectEvent`：**

`useEffectEvent` 為相同模式提供了更簡潔的 API：它會建立一個穩定的函式參照，且該參照總是呼叫最新版本的處理常式。

### 8.3 使用 useEffectEvent 取得穩定的回呼 Refs

**影響程度：低 (LOW)（防止 Effect 重新執行）**

在回呼中存取最新值，而無需將其加入相依性陣列。這能防止 Effect 重新執行，同時避免過時閉包。

**錯誤：Effect 在每次回呼變更時重新執行**

```tsx
function SearchInput({ onSearch }: { onSearch: (q: string) => void }) {
  const [query, setQuery] = useState('')

  useEffect(() => {
    const timeout = setTimeout(() => onSearch(query), 300)
    return () => clearTimeout(timeout)
  }, [query, onSearch])
}
```

**正確：使用 React 的 useEffectEvent**

```tsx
import { useEffectEvent } from 'react';

function SearchInput({ onSearch }: { onSearch: (q: string) => void }) {
  const [query, setQuery] = useState('')
  const onSearchEvent = useEffectEvent(onSearch)

  useEffect(() => {
    const timeout = setTimeout(() => onSearchEvent(query), 300)
    return () => clearTimeout(timeout)
  }, [query])
}
```

---

## 參考資料

1. [https://react.dev](https://react.dev)
2. [https://nextjs.org](https://nextjs.org)
3. [https://swr.vercel.app](https://swr.vercel.app)
4. [https://github.com/shuding/better-all](https://github.com/shuding/better-all)
5. [https://github.com/isaacs/node-lru-cache](https://github.com/isaacs/node-lru-cache)
6. [https://vercel.com/blog/how-we-optimized-package-imports-in-next-js](https://vercel.com/blog/how-we-optimized-package-imports-in-next-js)
7. [https://vercel.com/blog/how-we-made-the-vercel-dashboard-twice-as-fast](https://vercel.com/blog/how-we-made-the-vercel-dashboard-twice-as-fast)
