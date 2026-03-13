# AGENTS.md (代理人說明文件)

本文件在 AI 編碼代理人（Claude Code, Cursor, Copilot 等）處理本儲存庫中的程式碼時提供指引。

[English Version](./AGENTS.md)

## 儲存庫概觀

本儲存庫包含一系列用於 Claude.ai 和 Claude Code 的技能，用於處理 Vercel 部署。技能是封裝好的指令與腳本，旨在擴展 Claude 的能力。

## 建立新技能

### 目錄結構

```
skills/
  {skill-name}/           # 使用 kebab-case 命名目錄
    SKILL.md              # 必要：技能定義
    scripts/              # 必要：可執行腳本
      {script-name}.sh    # Bash 腳本（偏好使用）
  {skill-name}.zip        # 必要：用於發佈的打包檔案
```

### 命名慣例

- **技能目錄**：`kebab-case`（例如：`vercel-deploy`、`log-monitor`）
- **SKILL.md**：一律大寫，檔名必須完全相同
- **腳本**：`kebab-case.sh`（例如：`deploy.sh`、`fetch-logs.sh`）
- **Zip 檔案**：必須與目錄名稱完全匹配：`{skill-name}.zip`

### SKILL.md 格式

```markdown
---
name: {skill-name}
description: {用一句話描述何時使用此技能。包含觸發詞，如「部署我的應用程式」、「檢查日誌」等。}
---

# {技能標題}

{簡述技能的功能。}

## 運作方式

{解釋技能工作流程的編號列表}

## 用法

```bash
bash /mnt/skills/user/{skill-name}/scripts/{script}.sh [引數]
```

**引數：**
- `arg1` - 描述（預設為 X）

**範例：**
{展示 2-3 個常用的使用模式}

## 輸出

{展示使用者將會看到的範例輸出}

## 向使用者呈現結果

{Claude 在向使用者呈現結果時應如何格式化結果的模板}

## 疑難排解

{常見問題與解決方案，特別是網路/權限錯誤}
```

### 上下文效率的最佳實踐

技能是隨選載入的 —— 啟動時僅載入技能名稱與描述。只有當代理人判定該技能相關時，完整的 `SKILL.md` 才會載入到上下文中。為了最小化上下文使用量：

- **保持 SKILL.md 在 500 行以下** —— 將詳細的參考資料放在獨立檔案中
- **撰寫明確的描述** —— 協助代理人確切知道何時啟用該技能
- **使用漸進式揭露** —— 引用僅在需要時才讀取的支援文件
- **優先使用腳本而非內聯程式碼** —— 執行腳本不消耗上下文（僅輸出會消耗）
- **檔案引用僅支援一層深度** —— 從 SKILL.md 直接連結到支援文件

### 腳本要求

- 使用 `#!/bin/bash` shebang
- 使用 `set -e` 以實現快速失敗行為
- 將狀態訊息寫入 stderr：`echo "訊息" >&2`
- 將機器可讀的輸出 (JSON) 寫入 stdout
- 包含用於暫存檔的清理陷阱 (cleanup trap)
- 引用腳本路徑為 `/mnt/skills/user/{skill-name}/scripts/{script}.sh`

### 建立 Zip 套件

建立或更新技能後：

```bash
cd skills
zip -r {skill-name}.zip {skill-name}/
```

### 終端使用者安裝

為使用者記錄這兩種安裝方法：

**Claude Code：**
```bash
cp -r skills/{skill-name} ~/.claude/skills/
```

**claude.ai：**
將技能加入專案知識庫，或將 SKILL.md 內容貼到對話中。

如果技能需要網路存取，請指示使用者在 `claude.ai/settings/capabilities` 加入必要的網域。
