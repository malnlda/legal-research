# legal-research

法律研究 Claude Code 技能序列。把"查法律法规 → 查案例 → 生成法律研究备忘录"
串成一条流水线，调度三个子技能：

| 子技能 | 来源 | 作用 |
|---|---|---|
| `legal-research`        | 本仓库 | 编排技能，按流水线调度下面三者 |
| `yd-law-search`         | 本仓库 | 元典开放平台 · 法律法规检索 |
| `yd-case-search`        | 本仓库 | 元典开放平台 · 案例检索 |
| `cs-china-lawyer-analyst` | git submodule → [CSlawyer1985/china-lawyer-analyst](https://github.com/CSlawyer1985/china-lawyer-analyst) | 法律分析与备忘录生成 |

## 前置条件

- macOS / Linux，Bash + Python 3
- Claude Code 已安装，技能目录在 `~/.claude/skills/`
- 元典开放平台 API Key（<https://open.chineselaw.com/>）

## 安装

```bash
git clone --recurse-submodules https://github.com/malnlda/legal-research.git
cd legal-research
./install.sh
```

如果克隆时忘了 `--recurse-submodules`：
```bash
git submodule update --init --recursive
./install.sh
```

`install.sh` 会把 `skills/*` 与 `external/cs-china-lawyer-analyst` 软链到
`~/.claude/skills/` 下。已存在的同名目录会自动备份为 `<name>.bak.<时间戳>`。

## API Key 配置

按以下顺序读取（任一即可）：
1. 环境变量 `YD_OPEN_API_KEY`
2. `~/.yd_open_api_key`（推荐）
3. 环境变量 `YD_API_KEY`（兼容旧版）
4. `~/.yd_api_key`
5. 各脚本目录下 `.api_key`

例：
```bash
printf "%s" "你的 X-API-Key" > ~/.yd_open_api_key
chmod 600 ~/.yd_open_api_key
```

## 使用

### 完整流水线

直接告诉 Claude：
> 请使用 legal-research 帮我研究：[案件事实和问题]

Claude 会按流水线依次调度三个子技能，并最终给出备忘录。

### 单个子技能

也可以单独使用：
- "用 yd-law-search 查一下民间借贷利率上限相关法条"
- "用 yd-case-search 找两个相关案例"
- "请 cs-china-lawyer-analyst 基于上面的检索结果出备忘录"

## 升级

```bash
./update.sh
```

会同时更新本仓库与 `cs-china-lawyer-analyst` submodule。如需锁版本，
拉完后显式 commit submodule 指针：

```bash
git add external/cs-china-lawyer-analyst
git commit -m "chore: bump cs-china-lawyer-analyst"
```

## 卸载

```bash
./uninstall.sh
```

只移除本仓库装的软链，`.bak.*` 备份不动。

## 目录结构

```
legal-research/
├── README.md
├── install.sh / update.sh / uninstall.sh
├── .gitmodules
├── skills/
│   ├── legal-research/             # 编排 SKILL.md
│   ├── yd-law-search/              # SKILL.md + scripts/
│   └── yd-case-search/             # SKILL.md + scripts/
├── external/
│   └── cs-china-lawyer-analyst/    # git submodule，不修改
└── docs/
    └── api-reference.md            # 元典开放平台 9 个接口的本地速查
```

## 设计说明

- **token 节约**：所有检索接口默认只返回元数据 + ≤120 字摘要；要全文用 `*_detail` 子命令配合 id 拉取，或加 `--full`。
- **法条 vs 法规**：`yd-law-search` 用决策树严格区分粒度，避免误用 `search_fg` 返回法规清单当法条。
- **不污染 submodule**：cs-china-lawyer-analyst 上游升级直接 `./update.sh`，本仓库不 fork、不打 patch。

## 许可

MIT
