# GeWu Auto Writing

把一份只读的源码仓库（或一小组仓库）写成一篇完整、诚实、可溯源的学术论文。

这是一个 **agent skill + 配套 CLI**：规则是 Markdown，干活的是 agent，CLI 负责批量运行、渲染页面和过门禁。产物遵循所选期刊自己的模板，文献经 LKM 检索与核验，交付前有 14 项机械门禁。

- 技能本体：`.agents/skills/paperwriter-pi/`（规则 + 4 套期刊模板 + `tools/` 里的 CLI）
- 详细安装与依赖说明：**[INSTALL.md](INSTALL.md)**
- 本仓库自身的项目上下文（GeWu Top 30 批量）：见文末

---

## 一、下载与安装

三条路，按你的 harness 选一条。

### 1. Pi 用户（最省事）

```bash
pi install git:github.com/a-green-hand-jack/GeWu_Auto_Writing
```

`package.json` 里用 `pi.skills` 声明了技能，Pi 会把它放进 skills 目录。**只装这一个技能**——本仓库里另有 `gewu-authentication`、`gewu-problem-authoring`、`gewu-solution-authoring` 三个无关技能，它们**不在**声明之列，不会被装入（实测：装包前后新会话可见技能数 54 → 55，差集恰好 `paperwriter-pi`）。

### 2. 任意 harness（免克隆）

```bash
curl -fsSL https://raw.githubusercontent.com/a-green-hand-jack/GeWu_Auto_Writing/main/install.sh | bash

# 传参：指定 harness、钉版本
curl -fsSL .../install.sh | bash -s -- --target claude --ref v1.0.0
```

脚本发现自己身边没有检出时会**自己下载仓库**，然后：技能 → `~/.agents/skills/paperwriter-pi`（跨 harness 公共位置），CLI → `~/.local/bin`。`--target pi|claude|codex|dir:PATH`、`--link`、`--dry-run`、`--uninstall` 均可用。

> 不想"管道执行远程脚本"的话，用两步式：下载 tarball → `cd GeWu_Auto_Writing-main && ./install.sh`。

### 3. 从检出安装

```bash
git clone https://github.com/a-green-hand-jack/GeWu_Auto_Writing
cd GeWu_Auto_Writing && ./install.sh && gewu-doctor
```

### 安装后必做：依赖自检

```bash
gewu-doctor
```

它逐条告诉你缺什么、怎么补：

| 必需 | 为什么 |
|---|---|
| `pi`（或任何能读该 skill 的 agent） | 模型、会话、工具循环都由它提供 |
| TeX Live 含 `revtex4-2.cls` 与 `amsart.cls` | PRX 与 Annals 用它编译（`tlmgr install revtex amscls`） |
| `bibtex`、`pdflatex` | 编译循环 |
| `python3` + `pypdfium2` | 渲染页面（无需系统 poppler）；**所有视觉门禁依赖它** |
| **`bohr` CLI（Bohrium / LKM），已登录** | **文献检索的必经路径**。技能的两道文献下限（≥50% 内容级、≥25 条）在无 LKM 时实际达不到：实测无 LKM 的轮次只有 12–25 条、内容级低至 19%，而公共 API 会把这类使用限流成 429 |

想确认 LKM 真的能用（而不只是装了），加 `--probe-lkm`：它会**真发一次检索**（计费约 ¥0.05），默认关闭——`gewu-doctor` 平时不花钱。

---

## 二、怎么用

### 方式 A：让它写一篇

在下述 harness 会话里加载这个技能（Pi 里是 `/skill:paperwriter-pi`，或直接指向 `SKILL.md`），然后给它两样东西：

```text
SOURCE_ROOT = 只读的源码仓库（绝不修改）
WORKSPACE   = 唯一可写的输出目录
```

它就会走完整流程：清点源码 → 建证据映射 → 判断领域与期刊 → 写计划 → 经 LKM 取文献并核验 → 起草 → 编译 → 渲染检查 → 过门禁 → 报告**哪些做完了、哪些被阻塞**。

**领域决定期刊**（按研究对象与问题，而不是按论证形式）：

| 领域 | 期刊 | 模板 |
|---|---|---|
| 物理 | Physical Review X | revtex4-2（TeX Live 自带 + 官方入口文件） |
| 数学 | Annals of Mathematics | amsart（Annals 无自有类文件，按 AMS 惯例） |
| 生命科学 | Nature Communications | 随技能分发的 nature 类（CTAN 2004 版，README 有说明） |
| AI / 机器学习 | ICLR | 随技能分发的官方 ICLR 2026 样式 |

### 方式 B：整批跑

写一份 TSV 清单（`slug`、`源码路径`、`领域`、可选标题提示）：

```tsv
ising-chain	src/ising-chain	physics	有限尺寸态密度
hard-square	src/hard-square	mathematics
pdpc-cycle	src/pdpc-cycle	life_sciences
```

然后：

```bash
SKILL=~/.agents/skills/paperwriter-pi

# 1. 先看会做什么（不启动任何东西）
$SKILL/tools/launch-generic.sh --manifest entries.tsv --out ~/runs --dry-run

# 2. 跑（会把技能与 runner 冻结进 run 目录，保证可复现）
$SKILL/tools/launch-generic.sh --manifest entries.tsv --out ~/runs --name mybatch

# 3. 看进度与门禁
export GEWU_BATCH_BASE=~/runs
gewu-batch watches mybatch
gewu-verify  ~/runs/<run-dir>

# 4. 收 PDF 与 INDEX
gewu-batch handover --out ~/runs/<run-dir>-final <run-dir>
```

启动器具备：**起跑前的 provider 健康门禁**、卡死看门狗、无进展看门狗、真实失败重试，以及**独立的 provider 故障预算**（故障不吃任务的重试次数）。任务若仍被打死，`gewu-revive <run-dir>` 会带着它自己的 workspace 原地续跑。

### 文献从哪来

经 **LKM**（Bohrium 的大知识模型，**必需项**），由技能内的 `gewu-lit` 封装：`search` / `reasoning` / `graph` / `parse-local`，原始响应缓存在 `research/checks/literature_raw/`，`gewu-lit replay <file>` 可免费重读缓存，调用有预算上限（计费）。两条硬性下限：**至少一半参考文献达到内容级**（真读过全文或摘要），**至少 25 条**；每条 DOI/arXiv 标识符都必须能解析。

---

## 三、技能里有什么

```text
.agents/skills/paperwriter-pi/
├── SKILL.md                角色、四条要求、领域与期刊路由、文件表
├── references/
│   ├── constitution.md     诚实、证据语言、provenance、平台防火墙、来源仓库引用
│   ├── production.md       流程：清点 → 证据 → 评估 → 计划 → LKM 文献 → 检查 → 成文 → 编译 → 复核 → 报告
│   ├── templates.md        4 套期刊模板与逐字验证过的 LaTeX、theorem/proof 规范
│   ├── writing.md          按期刊要求写作、深度标定、记号、摘要、相关工作、语言
│   └── checks.md           14 项机械门禁及可直接执行的命令
├── templates/              prx-official · annals-of-mathematics · nature-comms · iclr-2026
└── tools/                  CLI 随技能分发，装好后即命令名
    gewu-run gewu-batch gewu-revive gewu-verify gewu-lit pdf-pages gewu-doctor launch-generic.sh
```

**四条要求**（其余皆为可选项）：

1. **跟随期刊模板**；
2. **高屋建瓴、深入浅出**；
3. **不把平台词汇写进科学**——正文里不出现平台、仓库、路径、哈希、运行号、agent/模型名，来源仓库只作为一条**参考文献**出现；
4. **不出现排版问题**——编译、读警告、渲染页面、逐页看。

诚实不是"四条要求"之一，因为它是底线而非可选项。

**核心规则细节**：附录必须在正文之后、文献之前，`\appendix` 必须真的写出来（否则附录文件会印成正文节）；proof 环境一律用 `amsthm`，禁止手写、禁止斜体正文；limitations 必须说明但不要求独立成节。

---

## 四、本仓库的项目上下文（GeWu Top 30）

上面讲的是**通用的技能与 CLI**。这个仓库同时还有它自己的用途：把 GeWu 的 30 个 Solution 仓库写成 30 篇论文。

### 目标

- 将 Solution 仓库作为**只读研究输入**；
- 每篇论文的源稿、研究记录与验证记录写入独立 workspace；
- 保留来源边界、作者声明、计算限制、负结果与未解决问题；
- 不把平台排名或 Solution 状态表述为独立科学认证。

### 目录结构

```text
.
├── .agents/
│   ├── skills/paperwriter-pi/      # 上面那个技能（唯一被安装的）
│   ├── skills/gewu-*/              # 本仓库另外三个技能，不随包安装
│   └── memory/                     # 运维与写作策略记忆
├── gewu-top30/                     # 本地只读输入；30 个子目录各自是独立 Git 仓库
├── tools/
│   ├── gwb                         # 本机经 ssh 调用 ECS 上的 gewu-batch
│   └── launchers/                  # 本项目 14 次批次的启动器（历史记录）
├── install.sh / package.json       # 安装与 Pi 包声明
├── INSTALL.md                      # 安装与依赖详解
└── paperwriter-*-runs/             # 运行数据，默认不纳入 Git
```

### 运行方式

实际运行使用原生 Pi 的一次性 headless 进程（启动器已封装，下列是核心形态）：

```bash
pi --no-session --provider gravarc-router --model glm-5.3 --thinking high \
   --no-context-files --no-approve --no-extensions --no-skills \
   --no-prompt-templates --no-themes --tools read,write,edit,bash,grep,find,ls \
   --skill <run>/skill/SKILL.md --print @<task-dir>/task.md
```

30 路并行时每个任务有独立 task prompt 与 workspace，由一次性 shell controller 启动并等待（只负责并发、PID、起止时间与退出码）。文本模型无法读图，因此**视觉核查按规则记为 blocked**，绝不假称通过。

### 运维 CLI

```bash
./tools/gwb list                 # 所有 run 及 finished/running
./tools/gwb watches <run>        # 一行进度
./tools/gwb status <run>         # 逐任务表
./tools/gwb gates <run>          # 逐篇门禁指标
./tools/gwb report               # 汇总
gewu-verify <run-dir>            # 14 项机械门禁，一条命令
```

长任务一律后台启动（`setsid nohup ... < /dev/null &`）；反复执行的检查一律沉淀进 CLI。详见 `.agents/memory/operations.md`。

### 写作策略

见 `.agents/memory/paper_writing_policy.md`，其中最重要的一条：

- **已产出的论文不做事后修补，直接从 `SOURCE_ROOT` 重跑**；发现缺陷就修技能与门禁，然后重跑。

### 最近一次批量（第十轮）

```text
远程: ~/GeWu_Auto_Writing/paperwriter-pi-runs/20260914T163952Z-round10-final
本机: paperwriter-pi-runs/20260914T182500Z-round10-final/   ← 30 个 PDF + INDEX.csv + INDEX.md
```

- **30/30 任务正常结束，退出码全 0**；0 stalled、0 无进展、0 provider 故障；
- 30 篇 PDF，共 516 页：**PRX 23 篇 · amsart 6 篇 · Nature 1 篇**；
- 14 项机械门禁 **全部通过**（期刊头部顺序、附录区、proof 环境、平台防火墙、仓库引用、作者行白名单、散文形态…）；
- 文献 25–42 条（下限 25），内容级比例均值 59%。仅 `07-sun-aklt-transfer-matrix-spectrum` 为 48%，低于 50% 下限，待定向重跑；
- 标识符核验：848 条中无编造、无不可解析；129/848（约 15%）为书籍或前数字时代论文（无 DOI/arXiv 属正常，但需人工核验）。

这些是自动化写作与有限一致性检查的结果，**不等于**科学认证、同行评审、投稿批准或平台接受。

### 远程环境与安全边界

- 写作任务优先在 GeWu ECS 上运行；
- `ecs-login.sh` 只引用本机 SSH key 路径，仓库中不保存私钥或 API key；
- 不读取或提交 `.env`、auth store、私钥及其他凭据；
- TeX / poppler 可用性与沙箱状态必须如实记录；
- 隔离或视觉检查无法验证时，不得把草稿描述成已完成的科学或投稿审阅。

### Git 约定

- 外层仓库跟踪技能、规则、CLI、元数据与文档；
- `paperwriter-*-runs/` 默认忽略，避免把运行日志与大型产物提交进 Git；
- `gewu-top30/` 的子仓库不作为外层内容重复 vendoring；
- 提交前检查 `git status`，确认没有凭据、临时输出或不相关文件。