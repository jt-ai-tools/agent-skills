# Agent Skills (代理人技能)

AI 編碼代理人的技能集合。技能是封裝好的指令與腳本，用於擴展代理人的能力。

技能遵循 [Agent Skills](https://agentskills.io/) 格式。

[English Version](./README.md)

## 可用技能

### react-best-practices (React 最佳實踐)

來自 Vercel 工程團隊的 React 與 Next.js 效能優化指南。包含跨 8 個類別的 40+ 條規則，依影響程度排序。

**使用時機：**
- 撰寫新的 React 元件或 Next.js 頁面
- 實作資料獲取（客戶端或伺服器端）
- 審查程式碼的效能問題
- 優化 bundle 大小或載入時間

**涵蓋類別：**
- 消除瀑布流 (關鍵)
- Bundle 大小優化 (關鍵)
- 伺服器端效能 (高)
- 客戶端資料獲取 (中高)
- 重複渲染優化 (中)
- 渲染效能 (中)
- JavaScript 微優化 (低中)

### web-design-guidelines (網頁設計指南)

審查 UI 程式碼是否符合網頁介面最佳實踐。稽核您的程式碼，涵蓋 100+ 條關於無障礙、效能與 UX 的規則。

**使用時機：**
- 「審查我的 UI」
- 「檢查無障礙性」
- 「稽核設計」
- 「審查 UX」
- 「根據最佳實踐檢查我的網站」

**涵蓋類別：**
- 無障礙性 (aria-labels, 語義化 HTML, 鍵盤處理常式)
- 焦點狀態 (可見焦點, focus-visible 模式)
- 表單 (自動完成, 驗證, 錯誤處理)
- 動畫 (prefers-reduced-motion, 合成器友善的轉換)
- 字體排印 (捲曲引號, 省略號, tabular-nums)
- 圖片 (尺寸, 延遲載入, alt 文本)
- 效能 (虛擬化, 版面配置抖動, 預先連線)
- 導覽與狀態 (URL 反映狀態, 深層連結)
- 深色模式與主題 (color-scheme, theme-color meta)
- 觸控與互動 (touch-action, tap-highlight)
- 本地化與 i18n (Intl.DateTimeFormat, Intl.NumberFormat)

### react-native-guidelines (React Native 指南)

為 AI 代理人優化的 React Native 最佳實踐。包含跨 7 個章節的 16 條規則，涵蓋效能、架構與平台特定模式。

**使用時機：**
- 建立 React Native 或 Expo 應用程式
- 優化行動裝置效能
- 實作動畫或手勢
- 處理原生模組或平台 API

**涵蓋類別：**
- 效能 (關鍵) - FlashList, 記憶化, 重度運算
- 版面配置 (高) - flex 模式, 安全區域, 鍵盤處理
- 動畫 (高) - Reanimated, 手勢處理
- 圖片 (中) - expo-image, 快取, 延遲載入
- 狀態管理 (中) - Zustand 模式, React 編譯器
- 架構 (中) - monorepo 結構, 匯入
- 平台 (中) - iOS/Android 特定模式

### composition-patterns (組合模式)

可擴展的 React 組合模式。透過複合元件、狀態提升與內部組合，協助避免布林屬性 (boolean prop) 激增。

**使用時機：**
- 重構具有許多布林屬性的元件
- 建立可重複使用的元件庫
- 設計具彈性的 API
- 審查元件架構

**涵蓋模式：**
- 提取複合元件
- 提升狀態以減少屬性
- 組合內部以增加彈性
- 避免屬性鑽取 (prop drilling)

### vercel-deploy-claimable (Vercel 部署 - 可認領)

立即將應用程式與網站部署到 Vercel。專為搭配 claude.ai 與 Claude Desktop 使用而設計，可直接從對話中進行部署。部署是「可認領的」——使用者可以將擁有權轉移到他們自己的 Vercel 帳戶。

**使用時機：**
- 「部署我的應用程式」
- 「將此部署到正式環境」
- 「將此發佈上線」
- 「部署並給我連結」

**特點：**
- 從 `package.json` 自動偵測 40+ 個框架
- 回傳預覽 URL (正式網站) 與認領 URL (轉移擁有權)
- 自動處理靜態 HTML 專案
- 從上傳中排除 `node_modules` 與 `.git`

**運作方式：**
1. 將您的專案打包成 tarball
2. 偵測框架 (Next.js, Vite, Astro 等)
3. 上傳到部署服務
4. 回傳預覽 URL 與認領 URL

**輸出：**
```
部署成功！

預覽 URL： https://skill-deploy-abc123.vercel.app
認領 URL： https://vercel.com/claim-deployment?code=...
```

## 安裝

```bash
npx skills add vercel-labs/agent-skills
```

## 用法

技能安裝後即可自動使用。代理人在偵測到相關任務時將會使用它們。

**範例：**
```
部署我的應用程式
```
```
審查此 React 元件的效能問題
```
```
協助我優化此 Next.js 頁面
```

## 技能結構

每個技能包含：
- `SKILL.md` - 給代理人的指令
- `scripts/` - 用於自動化的輔助腳本 (選填)
- `references/` - 支援文件 (選填)

## 授權

MIT
