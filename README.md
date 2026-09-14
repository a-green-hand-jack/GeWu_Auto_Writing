# GeWu Auto Writing

这是一个面向 GeWu Solution 集合的、source-bound 学术写作工作区。项目把写作规则和参考资料整理成当前仓库内的 Pi skill，并使用原生 Pi headless 进程完成论文草稿生成。

## 给别人用（一键安装）

这个仓库现在同时是一个可安装的包：skill 与 CLI 可以被别的 agent 直接使用。

```bash
# Pi 用户：一条命令拿到 skill（package.json 里已声明）
pi install git:github.com/a-green-hand-jack/GeWu_Auto_Writing

# 其它 harness：装 skill + CLI，并跑依赖自检
./install.sh                 # 或 --target claude|codex|pi|dir:PATH
gewu-doctor                  # 缺什么、怎么补，逐条列出
```

完整说明见 **[INSTALL.md](INSTALL.md)**：依赖清单、通用启动器 `tools/launchers/launch-generic.sh`（用 TSV 清单跑自己的语料）、第三方模板的来源与许可、以及卸载方式。

## 目标

- 将 GeWu Solution 仓库作为**只读研究输入**；
- 使用当前项目内的 `paperwriter-pi` skill，而不是依赖原始 PaperWriter 仓库；
- 将每个任务的论文源稿、研究记录和验证记录写入独立 workspace；
- 保留来源边界、作者声明、计算限制、负结果和未解决问题；
- 不把平台排名或 Solution 状态误表述为独立科学认证。

## 目录结构

```text
.
├── .agents/skills/
│   ├── gewu-authentication/
│   ├── gewu-problem-authoring/
│   ├── gewu-solution-authoring/
│   └── paperwriter-pi/
│       ├── SKILL.md
│       ├── references/
│       └── templates/
├── gewu-top30/                 # 本地只读输入；子目录各自是独立 Git 仓库
├── GEWU_TOP30_OVERVIEW.md      # Top 30 概览
├── GEWU_CLOUD_RUNTIME.md       # 远程运行环境说明
├── ecs-login.sh                # 使用本机 SSH key 登录 GeWu ECS
└── paperwriter-*-runs/         # 本地生成的运行数据，默认不纳入本仓库
```

`paperwriter-pi` 是一个 **prompt-only skill**，分三层组织：`references/constitution.md`（恒定加载的原则层）、`references/workflows/`（Pi 原生完整写作流程与交付前门禁）、`references/domains/<domain>.md`（按证据选择一个领域指南）。不包含第二套模型客户端、PaperWriter backend、Pi extension 或长期维护的 agent loop，也不包含需要执行的辅助脚本。

`gewu-top30/` 中的 30 个子目录保留各自的 Git 历史。为了避免在外层仓库中产生不可用的嵌套 gitlink，外层仓库只跟踪其 manifest；Solution 源码仍作为本地/远程的只读研究输入单独维护。

## Pi 运行方式

实际运行使用原生 Pi 的一次性 headless 进程：

```bash
pi \
  --no-session \
  --provider gravarc-router \
  --model deepseek-v4.1-flash \
  --thinking high \
  --no-context-files \
  --no-approve \
  --no-extensions \
  --no-skills \
  --no-prompt-templates \
  --no-themes \
  --tools read,write,edit,bash,grep,find,ls \
  --skill /path/to/.agents/skills/paperwriter-pi/SKILL.md \
  --print @/path/to/task.md
```

30 路并行时，每个任务使用独立的 task prompt 和 workspace，由一次性 shell controller 启动并等待。controller 只负责并发、PID、开始/结束时间和退出码；论文内容由 Pi 通过原生 `read`、`write`、`edit` 和 `bash` 工具完成。

默认模型为 `gravarc-router/deepseek-v4.1-flash`（纯文本输入、无图像能力）：因此每次运行的视觉检查按 skill 规则记为 `blocked`，不会假称通过。

一次 Top 30 批量的目录约定：

```text
paperwriter-pi-runs/<TIMESTAMP>/
├── task.md                      # 集合级任务说明（供人阅读）
├── <NN-solution-name>/          # 30 个任务目录
│   ├── task.md                  # 该任务的 prompt
│   ├── run.log                  # Pi 完整输出
│   ├── exit-code                # 退出码
│   └── workspace/               # WORKSPACE，唯一可写目录
└── controller.log               # 并发启动与汇总
```

## 写作策略约定

见 `.agents/memory/paper_writing_policy.md`：

- **已产出的论文不做事后修复，直接从 `SOURCE_ROOT` 重跑**；发现缺陷就修 skill 与门禁，然后重跑；
- **模板按领域路由**：物理（25 篇）用 PRX 模板（`\documentclass[aps,prx,reprint,groupedaddress]{revtex4-2}`），数学（5 篇）用 `amsart` + `amsplain`；排版是项目声明的属性，模型只负责从证据判断领域，不负责自由选择格式。

每个任务必须明确：

```text
SOURCE_ROOT = 只读 Solution 目录
WORKSPACE   = 唯一可写的任务输出目录
```

推荐的输出结构是：

```text
WORKSPACE/
├── paper/
│   ├── main.tex
│   ├── sections/
│   ├── references.bib
│   └── main.pdf              # 若编译门禁可用
└── research/
    ├── inventory.md
    ├── assessment.md
    ├── plan.md
    ├── provenance.md
    ├── literature.md
    └── validation.md
```

## 运维 CLI

`tools/gewu-batch` 是只读的批量运行检查器（在 ECS 上安装为 `gewu-batch`，本地用 `tools/gwb` 经 ssh 调用）：

```bash
./tools/gwb list                 # 所有 run 及 finished/running
./tools/gwb watches math5        # 单个 run 的进度一行
./tools/gwb status top30         # 逐任务表
./tools/gwb gates top30          # 逐篇门禁指标（模板/FloatBarrier/References/bibitem/未引用/叙述/theorem/PDF）
./tools/gwb report               # 汇总
./tools/gwb tail top30 18-... 40 # 看某任务报告
```

长任务一律后台启动（`setsid nohup ... < /dev/null &`），不要在前台等；反复执行的检查命令沉淀到该 CLI。详见 `.agents/memory/operations.md`。

## 写作与排版门禁

在已产出的 30 篇 PRX 论文上做过像素级与文本层排查，发现并已写入 `workflows/preflight.md` 的缺陷类型：

- 模板自带的 `placeins` / `\FloatBarrier` 被丢弃（30/30），导致整幅 `table*` 与参考文献挤在同一页；
- APS PRX 类只画粗细渐变的分隔线而不印 “REFERENCES” 标题词，入口文件必须自己补 `\section*{References}`（数学篇用 amsart，自带该标题）；
- 参考文献条目里写入内部流程描述（Crossref 校验日期、“not independently verified in the preparation environment”），这类内容属于 `research/literature.md`；
- 参考文献过少时应作为覆盖度问题显式记录，而不是当作版式问题或静默通过。

## 最近一次 Top 30 运行

最近一次远程运行目录为：

```text
/home/jieke/GeWu_Auto_Writing/paperwriter-pi-runs/20260913T103947Z/
```

结果：

- 30/30 Pi 任务正常结束，退出码均为 `0`；
- 生成 30 个 `main.tex` 和 30 个 `references.bib`；
- 29 个 PDF 可以读取并提取文本；
- `20-solution-open-xy-fcs-boundary-corrections` 因远程 ECS 无法建立所需的 bwrap user namespace，按规则保留源稿但没有生成 PDF；
- 30 个 Solution 源仓库保持 clean。

这些结果是自动化写作和有限一致性检查的结果，不等于科学认证、人工同行评审、投稿批准或平台接受。

## 远程环境和安全边界

- 写作任务优先在 GeWu ECS 上运行；
- `ecs-login.sh` 只引用本机 SSH key 路径，不在项目中保存私钥或 API key；
- 不读取或提交 `.env`、auth store、私钥和其他凭据；
- TeX/Poppler 可用性和 OS sandbox 状态必须如实记录；
- 如果隔离或视觉检查无法验证，不得把草稿描述成已完成的科学或投稿审阅。

## Git 约定

- 外层仓库跟踪项目规则、skill、元数据和文档；
- 生成的 `paperwriter-*-runs/` 默认被忽略，避免把大型临时产物和运行日志提交进 Git；
- `gewu-top30/` 的子仓库不作为外层仓库内容重复 vendoring；
- 提交前检查 `git status`，确认没有凭据、临时输出或不相关文件。
