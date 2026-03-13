---
name: deploy-to-vercel
description: 將應用程式與網站部署到 Vercel。當使用者要求部署動作時使用，例如「部署我的應用程式」、「部署並給我連結」、「將此發佈上線」或「建立預覽部署」。
metadata:
  author: vercel
  version: "3.0.0"
---

# 部署到 Vercel (Deploy to Vercel)

[English Version](./SKILL.md)

將任何專案部署到 Vercel。**一律部署為預覽 (preview)**（而非正式環境 (production)），除非使用者明確要求正式環境。

目標是讓使用者進入最佳的長期設定：將他們的專案連結到 Vercel 並使用 git-push 進行部署。以下每種方法都試圖讓使用者更接近該狀態。

## 步驟 1：收集專案狀態

在決定使用哪種方法之前，請執行所有四項檢查：

```bash
# 1. 檢查是否有 git remote
git remote get-url origin 2>/dev/null

# 2. 檢查本地是否已連結到 Vercel 專案（任一檔案存在即表示已連結）
cat .vercel/project.json 2>/dev/null || cat .vercel/repo.json 2>/dev/null

# 3. 檢查是否已安裝 Vercel CLI 並已驗證身份
vercel whoami 2>/dev/null

# 4. 列出可用的團隊（如果已驗證身份）
vercel teams list --format json 2>/dev/null
```

### 團隊選擇 (Team selection)

如果使用者屬於多個團隊，請將所有可用的團隊代稱 (team slug) 以列表形式呈現，並詢問要部署到哪一個。一旦使用者選擇了團隊，請立即進行下一步 —— 不要詢問額外的確認。

在所有後續的 CLI 指令（`vercel deploy`、`vercel link`、`vercel inspect` 等）中透過 `--scope` 傳遞團隊代稱：

```bash
vercel deploy [path] -y --no-wait --scope <team-slug>
```

如果專案已經連結（存在 `.vercel/project.json` 或 `.vercel/repo.json`），這些檔案中的 `orgId` 會決定團隊 —— 無需再次詢問。如果只有一個團隊（或僅有個人帳戶），請跳過提示並直接使用。

**關於 `.vercel/` 目錄：** 連結的專案具有以下之一：
- `.vercel/project.json` — 由 `vercel link` 建立（單一專案連結）。包含 `projectId` 與 `orgId`。
- `.vercel/repo.json` — 由 `vercel link --repo` 建立（基於儲存庫的連結）。包含 `orgId`、`remoteName`，以及將目錄對應到 Vercel 專案 ID 的 `projects` 陣列。

任一檔案存在都代表專案已連結。請檢查兩者。

**切勿**在未連結的目錄中使用 `vercel project inspect`、`vercel ls` 或 `vercel link` 來偵測狀態 —— 若沒有 `.vercel/` 配置，它們會產生互動式提示（或者在使用 `--yes` 時，會產生靜態連結作為副作用）。只有 `vercel whoami` 是可以在任何地方安全執行的。

## 步驟 2：選擇部署方法

### 已連結（存在 `.vercel/`）+ 具有 git remote → Git Push

這是理想狀態。專案已連結並具有 git 整合。

1. **在推送前詢問使用者。** 未經明確核准切勿推送：
   ```
   此專案已透過 git 連接到 Vercel。我可以提交並推送以觸發部署。
   要我繼續嗎？
   ```

2. **提交並推送：**
   ```bash
   git add .
   git commit -m "deploy: <變更描述>"
   git push
   ```
   Vercel 會從推送中自動建置。非正式環境分支會獲得預覽部署；正式環境分支（通常是 `main`）會獲得正式環境部署。

3. **獲取預覽 URL。** 如果 CLI 已驗證身份：
   ```bash
   sleep 5
   vercel ls --format json
   ```
   JSON 輸出有一個 `deployments` 陣列。找到最新的項目 —— 其 `url` 欄位即為預覽 URL。

   如果 CLI 未驗證身份，請告知使用者到 Vercel 控制面板或其 git 供應商的提交狀態檢查中查看預覽 URL。

---

### 已連結（存在 `.vercel/`）+ 沒有 git remote → `vercel deploy`

專案已連結但沒有 git 儲存庫。直接使用 CLI 進行部署。

```bash
vercel deploy [path] -y --no-wait
```

使用 `--no-wait` 讓 CLI 立即回傳部署 URL，而不是阻塞直到建置完成（建置可能需要一段時間）。然後使用以下指令檢查部署狀態：

```bash
vercel inspect <deployment-url>
```

對於正式環境部署（僅在使用者明確要求時）：
```bash
vercel deploy [path] --prod -y --no-wait
```

---

### 未連結 + CLI 已驗證身份 → 先連結，再部署

CLI 可運作但專案尚未連結。這是讓使用者進入最佳狀態的機會。

1. **詢問使用者要部署到哪個團隊。** 以列表形式呈現步驟 1 中的團隊代稱。如果只有一個團隊（或僅有個人帳戶），請跳過此步驟。

2. **一旦選定團隊，直接進行連結。** 告知使用者將會發生什麼事，但不要詢問單獨的確認：
   ```
   正在將此專案連結到 Vercel 上的 <團隊名稱>。
   這將建立一個 Vercel 專案用於部署，並在未來的 git 推送中啟用自動部署。
   ```

3. **如果存在 git remote**，對選定的團隊範圍使用基於儲存庫的連結：
   ```bash
   vercel link --repo --scope <team-slug>
   ```
   這會讀取 git remote URL，並將其與從該儲存庫部署的現有 Vercel 專案進行比對。它會建立 `.vercel/repo.json`。這比 `vercel link`（不帶 `--repo`）可靠得多，後者嘗試按目錄名稱比對，當本地資料夾與 Vercel 專案名稱不同時經常失敗。

   **如果沒有 git remote**，則退而求其次使用標準連結：
   ```bash
   vercel link --scope <team-slug>
   ```
   這會提示使用者選擇或建立專案。它會建立 `.vercel/project.json`。

4. **然後使用最佳的可用方法進行部署：**
   - 如果存在 git remote → 提交並推送（參見上方的 git push 方法）
   - 如果沒有 git remote → `vercel deploy [path] -y --no-wait --scope <team-slug>`，然後使用 `vercel inspect <url>` 檢查狀態

---

### 未連結 + CLI 未驗證身份 → 安裝、驗證、連結、部署

尚未設定 Vercel CLI。

1. **安裝 CLI（如果尚未安裝）：**
   ```bash
   npm install -g vercel
   ```

2. **驗證身份：**
   ```bash
   vercel login
   ```
   使用者在瀏覽器中完成驗證。如果在無法登入的非互動式環境中執行，請跳至下方的 **無驗證備案 (no-auth fallback)**。

3. **詢問要部署到哪個團隊** — 以列表形式呈現 `vercel teams list --format json` 中的團隊代稱。如果只有一個團隊 / 個人帳戶，請跳過。一旦選定，立即繼續。

4. **連結專案** 並使用選定的團隊範圍（如果存在 git remote 請使用 `--repo`，否則使用一般的 `vercel link`）：
   ```bash
   vercel link --repo --scope <team-slug>   # 如果存在 git remote
   vercel link --scope <team-slug>          # 如果沒有 git remote
   ```

5. **部署** 使用最佳可用方法（如果存在 remote 則使用 git push，否則執行 `vercel deploy -y --no-wait --scope <team-slug>`，然後執行 `vercel inspect <url>` 檢查狀態）。

---

### 無驗證備案 (No-Auth Fallback) — claude.ai 沙盒

**使用時機：** 當 CLI 無法在 claude.ai 沙盒中安裝或驗證身份時的最後手段。這不需要驗證 —— 它會回傳一個 **預覽 URL (Preview URL)** (正式網站) 與一個 **認領 URL (Claim URL)** (轉移到您的 Vercel 帳戶)。

```bash
bash /mnt/skills/user/deploy-to-vercel/resources/deploy.sh [路徑]
```

**引數：**
- `路徑` - 要部署的目錄，或一個 `.tgz` 檔案（預設為目前目錄）

**範例：**
```bash
# 部署目前目錄
bash /mnt/skills/user/deploy-to-vercel/resources/deploy.sh

# 部署特定專案
bash /mnt/skills/user/deploy-to-vercel/resources/deploy.sh /path/to/project

# 部署現有的 tarball
bash /mnt/skills/user/deploy-to-vercel/resources/deploy.sh /path/to/project.tgz
```

此腳本會從 `package.json` 自動偵測框架、打包專案（排除 `node_modules`、`.git`、`.env`）、上傳，並等待建置完成。

**告知使用者：** 「您的部署已就緒，請見 [previewUrl]。請至 [claimUrl] 認領以管理您的部署。」

---

### 無驗證備案 (No-Auth Fallback) — Codex 沙盒

**使用時機：** 在 CLI 可能未驗證身份的 Codex 沙盒中。Codex 預設在沙盒環境中執行 —— 請先嘗試 CLI，如果驗證失敗，再退而求其次使用部署腳本。

1. **檢查是否已安裝 Vercel CLI**（此檢查不需要提升權限）：
   ```bash
   command -v vercel
   ```

2. **如果已安裝 `vercel`**，嘗試使用 CLI 進行部署：
   ```bash
   vercel deploy [路徑] -y --no-wait
   ```

3. **如果未安裝 `vercel`，或是 CLI 失敗並顯示 "No existing credentials found"**，請使用備案腳本：
   ```bash
   skill_dir="<技能路徑>"

   # 部署目前目錄
   bash "$skill_dir/resources/deploy-codex.sh"

   # 部署特定專案
   bash "$skill_dir/resources/deploy-codex.sh" /path/to/project

   # 部署現有的 tarball
   bash "$skill_dir/resources/deploy-codex.sh" /path/to/project.tgz
   ```

此腳本負責框架偵測、打包與部署。它會等待建置完成，並回傳包含 `previewUrl` 與 `claimUrl` 的 JSON。

**告知使用者：** 「您的部署已就緒，請見 [previewUrl]。請至 [claimUrl] 認領以管理您的部署。」

**提升網路存取權限：** 僅當沙盒阻擋網路呼叫時才提升實際部署指令的權限 (`sandbox_permissions=require_escalated`)。**不要**提升 `command -v vercel` 檢查的權限。

---

## 代理人專用注意事項 (Agent-Specific Notes)

### Claude Code / 基於終端的代理人

您具有完整的 shell 存取權限。**不要**使用 `/mnt/skills/` 路徑。直接使用 CLI 並遵循上述決策流程。

對於無驗證備案，請從技能安裝位置執行部署腳本：
```bash
bash ~/.claude/skills/deploy-to-vercel/resources/deploy.sh [路徑]
```
路徑可能因使用者安裝技能的位置而異。

### 沙盒環境 (claude.ai)

您可能無法執行 `vercel login` 或 `git push`。請直接前往 **無驗證備案 — claude.ai 沙盒**。

### Codex

Codex 在沙盒中執行。先檢查 CLI 是否可用，然後再退而求其次使用部署腳本。前往 **無驗證備案 — Codex 沙盒**。

---

## 輸出 (Output)

務必向使用者顯示部署 URL。

- **Git push:** 使用 `vercel ls --format json` 尋找預覽 URL。如果 CLI 未驗證身份，請告知使用者查看 Vercel 控制面板或提交狀態檢查。
- **CLI 部署:** 顯示 `vercel deploy --no-wait` 回傳的 URL。使用 `vercel inspect <url>` 檢查建置狀態並回報給使用者。
- **無驗證備案:** 同時顯示預覽 URL 與認領 URL：
  ```
  部署成功！

  預覽 URL： https://my-app-abc123.vercel.app
  認領 URL：   https://vercel.com/claim-deployment?code=...

  請至預覽 URL 查看您的網站。
  若要將此部署轉移到您的 Vercel 帳戶，請造訪認領 URL。
  ```

**不要**透過 curl 或 fetch 部署的 URL 來驗證其是否正常運作。只需回傳連結即可。

---

## 疑難排解 (Troubleshooting)

### 網路流出錯誤 (Network Egress Error) (claude.ai)

如果部署因 claude.ai 的網路限制而失敗，請告知使用者：

```
部署因網路限制而失敗。修復方法如下：

1. 前往 https://claude.ai/settings/capabilities
2. 將 *.vercel.com 加入允許的網域
3. 再次嘗試部署
```

### 提升網路存取權限 (Codex / 沙盒環境)

如果部署因沙盒環境中的網路問題（逾時、DNS 錯誤、連線重設）而失敗，請以提升權限重新執行 (`sandbox_permissions=require_escalated`)。不要提升初始的 CLI 可用性檢查 —— 僅提升實際的部署指令。

給使用者的引數範例：
```
部署到 Vercel 需要提升網路存取權限。我可以以提升權限重新執行指令
——要我繼續嗎？
```

### CLI 驗證失敗

如果 `vercel login` 或 `vercel deploy` 因驗證錯誤而失敗，請退而求其次使用無驗證部署腳本（視環境而定，使用 claude.ai 或 Codex 變體）。
