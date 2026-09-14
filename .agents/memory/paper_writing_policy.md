# 论文写作策略与 paperwriter-pi 结构

## 核心决策：已产出的论文不修复，直接从源头重跑

已经生成的论文草稿 **不做事后 patch**。需要改动时，从 `SOURCE_ROOT` 重新完整运行一次写作任务，产出一份新的 `WORKSPACE`。

原因：

- 修复是手工过程：改 `\FloatBarrier`、补 `\section*{References}`、清理 bibliography 叙述、删未引用条目、补文献，每一步都要人工判断且容易漏改级联位置（摘要、结论、表格、已编译 PDF、视觉复查）；
- 重跑是可复用、可验证的：同一 `SOURCE_ROOT` + 同一 skill 版本 + 同一门禁，产出的是一份内部自洽的新稿，而不是一份"打补丁的历史文件"；
- 于是配套约束是：**技能与门禁要一次做对**，不要让产出物积累需要修补的债务。发现产出缺陷时，修 skill 与 preflight，然后重跑。

`paperwriter-*-runs/` 下的运行产物是生成物、已被 `.gitignore` 忽略，不视作需要维护的资产，也不逐份修补。

## 模板：按领域路由，不按论文自由选择

排版是**项目声明**的属性，由**评估出的领域**路由；模型只负责从证据判断领域，不负责发明格式。

| 领域 | 入口 | document class |
|---|---|---|
| Physics（25 篇） | `templates/prx-official/apstemplate.tex` | `\documentclass[aps,prx,reprint,groupedaddress]{revtex4-2}` |
| Mathematics（5 篇：rank 10/12/13/14/23） | `domains/mathematics.md` 里的 amsart 房规 preamble | `\documentclass[11pt,reqno]{amsart}` + `\bibliographystyle{amsplain}` |
| 其他领域 | 用户指定的 venue | 按该 venue 要求 |

要点：

- 数学稿**不**塞进 PRX 两栏物理格式，物理稿**不**用 `article`/`amsart`/PRE/PRL/`pre-generic`；
- 同一领域组内必须class 与 preamble 一致，且 preflight 按“class 是否匹配已记录领域”检查，而不是硬编码“必须 PRX”；
- PRX 需要手工补 `\section*{References}`（APS class 只画分隔线不印标题词）；amsart 自带 `References` 标题。

历史备注：上一批（2026-09-13-r4）实际上已经是这个行为——物理用 PRX、数学用 `amsart`。本项目曾经的 `publication-mode.md` 把它写成“整批固定 PRX”，而数学指南又推荐 amsart，二者矛盾；现已改为显式声明+按领域路由。

## 已确认的产出缺陷（2026-09-13 的 30 篇产出，实证记录）

这些缺陷是"重跑 + 门禁"策略的直接动机，已写入 `workflows/preflight.md`：

| 缺陷 | 证据 | 命中 |
|---|---|---|
| 丢弃模板的 `placeins` / `\FloatBarrier` | 模板第 27、182 行有，产出源码 0/30 有 | 30/30 |
| 参考文献列表无标题词 | `aps4-2.rtx` 的 `\bibsection` 只画 APS 渐变分割线（`\bib@device`，第 499–521 行），不输出 `\refname`；最小复现证实 | 30/30 |
| 参考文献页被整幅浮动体挤占 | 像素级检测参考文献页存在全宽表格粗线 | 3/30（11、20、30） |
| 参考文献过少 | `.bbl` bibitem 计数 2–20，中位约 10 | ≤5 条的有 5 篇（12、14、23、24、28） |
| 参考文献条目写入内部流程 | `verified through the Crossref registry (2026-09-13)`、`not independently verified in the preparation environment` | 3 篇（03、09、11） |

补充：`gewu-top30/*/paper/` 下更早的 27 篇用 `article` 类 + `plainnat/unsrt`，不符合 PRX 模板要求，同属需要重新生成的 legacy。

## 领域路由原则（2026-09-13 修正）

**按"解决的问题属于数学还是物理"分类，不按论证形式或证据层级分类。**

- 数学：图与超图、组合设计、枚举与计数、匹配/极值/染色问题、代数数论几何拓扑对象、对数学猜想的反例。用穷举计算验证图论断言仍然是数学。
- 物理：哈密顿量与运动方程、自旋链、统计力学模型、物理态的纠缠与量子信息、输运、热力学、测量统计。用图论/组合手段求解的物理模型仍然是物理。
- **不是**路由依据的：是否使用 `Theorem` 环境、证据是不是定理级、论证是证明还是推导还是数值计算、平台自己的 category 标签。
- 边界情形：在 `research/assessment.md` 写明对象与问题，按"回答的是哪个共同体的问题"选择，并把残余歧义记为 limitation。

背景：首批把 `15-interaction-distance-flat-spectrum-conjectures`（图论/谱）这类题按平台标签归到物理、用 PRX 两栏渲染，同时又出现大量 theorem 环境——两边都不对。根因是把"论证形式"误当成了"领域依据"。

## paperwriter-pi 结构（2026-09-13 重构）

三层，按需加载，41 文件/2750 行 → 12 文件/约 1500 行：

1. `references/constitution.md` —— 恒定加载的原则层（不写流程，只写不可违反的原则）；
2. `references/workflows/production.md`（写作全流程）、`preflight.md`（交付前门禁）、`review.md`（整篇复查与有界修订），配合 `knowledge/writing-craft.md`；
3. `references/domains/<domain>.md` —— 每篇论文**只加载一个**领域文件；`layout.md` 域无关，有渲染页面时使用。

关键约束：物理理论论文**不再加载数学写作框架**。数学文件里的正向结构模板（theorem/lemma chain、完整证明、sharpness）会把普通物理结果包装成 Theorem；物理所需的推导纪律改由 `domains/physics.md` 的 "Derivations and formal statements" 一节自带。

## 重跑方式

见 `README.md` 的 "Pi 运行方式"：每个任务显式给出 `SOURCE_ROOT`（只读）与 `WORKSPACE`（唯一可写），任务 prompt 里指明使用 PRX 模板。30 篇可并行，各自独立 workspace。

## 已被实证的产出缺陷与对应规则（2026-09-14 第三轮）

用户视觉复核第二轮产出时发现三类缺陷，均已定位根因并写入 skill：

| 现象 | 根因 | 规则位置 |
|---|---|---|
| PRX 论文第一页**标题上方多出一段摘要文字** | 摘要文件 `\input` 在 `\maketitle` **之前**且**没有 `abstract` 环境包裹**，被当正文排出（17 篇） | `domains/physics.md` 前言骨架；`preflight.md` §9 |
| 数学论文文献区出现**"莫名其妙的下划线"**（同作者连续条目） | `amsplain.bst` 对重复作者输出 `\bysame`（长破折号）（27、10 篇） | `domains/mathematics.md` 的 `\bysame` 展开脚本；`preflight.md` §8/§9 |
| 数学论文文献区出现**表格的 booktabs 线** | 表格浮动体与文献表**共页**——只加 `\FloatBarrier` 不阻止浮动体落在文献起始页（13 篇） | `\FloatBarrier` 后加 `\clearpage`；`preflight.md` §8/§9 |

两个通用教训：**只读源码抓不到这类问题**——必须渲染第 1 页与文献页并按版面判据检查（`domains/layout.md` 已加入"标题必须是页面最上元素""文献页只能有文献表""不得有只由破折号构成的行"三条）。

## 章节骨架：顺序 ≠ 骨架（2026-09-14 第四轮检查）

**现象**：round3 的 `28-hard-square-zm1-transfer-factorization` 第一章写成 `\section{Introduction and model}`（且根本没有 intro 文件）；round4 的 `05`、`10` 第一章分别是「Model, conventions, and scope」「Setting and notation」——**Introduction 整个缺失**。已核实**不是模板问题**（文档类是 `revtex4-2` PRX，正确）。

**根因**：`production.md` §5 的"起草顺序"把内容分组写成 `introduction and related work`、`discussion, limitations, conclusion`，模型把它当成了章节骨架，于是合并或省略 Introduction。

**修法**：
- `production.md` §4 计划阶段必须给出**显式有序的章节骨架**；§5 明确"写作顺序不是章节清单"，Introduction **永远是独立的第一节**，标题不得用 "and" 连接两个角色、不得是流程词；
- `physics.md`/`mathematics.md` 写明各自的常规骨架（物理：Introduction / Model / Method / Results / Discussion / Limitations / Conclusion / 附录；数学：Introduction / Preliminaries / Main result and proof / Related work / Conclusion / 附录）；
- `preflight.md` §14 新增机械门禁：解析 entrypoint 的章节顺序，要求第一节以 `Introduction` 开头、标记 `Introduction and …` 之类合并标题、标记按计划应是 section 却没有 `\section` 的文件。

**教训**：给模型的"写作顺序"若用并列词组表达，会被当成结构规范。流程与骨架必须分开写。

## 技能瘦身：Four requirements（2026-09-14）

**用户定的验收标准只有四条**：① 跟随模板要求；② 写作高屋建瓴、深入浅出；③ 不出现 GeWu 系统黑话；④ 不出现排版问题。诚实性不属于"要求"而是不可谈判的底线。

**问题**：skill 膨胀到 22 个 md / 4305 行 / 235KB——每发现一个缺陷就追加一条规则，规则之间大量重复（physics.md 与 mathematics.md 的 review checklist、where-numbers-live、figures、appendices 近乎同文；imported skills 占近一半体量，其中 `scientific-writing.md` 是**全部指向不存在文件的死链存根**，proofreading 的 PDF-标注流程、评分表、RL 统计检查与我们无关）。

**新结构：6 个 md / 1005 行 / 49KB**，一个关注点一个文件：

| 文件 | 关注点 |
|---|---|
| `SKILL.md` | 角色、四条要求、输入输出契约、领域与模板路由、文件表与加载纪律、改本 bundle 的规矩 |
| `references/constitution.md` | 诚实、证据语言、provenance/引用、**防火墙 + GeWu 黑话对照表**、scope、来源安全、生产说明 |
| `references/templates.md` | 三种格式与**逐字验证过的 LaTeX**（PRX/amsart/neutral）、bib 卫生、编译循环 |
| `references/writing.md` | 骨架、深度标定、记号、摘要、相关工作、语言与 AI 腔 |
| `references/production.md` | 线性流程：inventory→evidence→assessment→plan→draft→literature→figures→checks→assemble→compile→review→report |
| `references/checks.md` | 机械检查与可直接运行的命令 |

删除：`domains/{physics,mathematics,layout,life_sciences,ai_ml}.md`、`knowledge/{authoring,authorship}.md`、整个 `skills-imported/`（其内容压缩进 writing.md §8 与 checks.md §9，proofread 类别保留一行 MIT 致谢）。`templates/` 下的真实 LaTeX 资产与 `SOURCE-LICENSE.txt` 全部保留。

**教训**：规则要写"为什么"（哪个已交付的稿件栽在这上面），否则后人删掉它、缺陷复发；但只写最短的句子。

## 作者行缺陷（同一轮抽查发现，属第③条）

第五轮 30 篇的作者行不统一且含内部标识：`\author{Scientific Author 82}`（GeWu 匿名标签，约 10 篇）、`\author{kunchen}`（git 句柄）、`\author{Agent Scientific Author}`（凭空占位）、`\author{玮琦 蒋}`（中文名序倒置，与英文正文混排）。新规则（constitution §4）：作者行必须是**人名**，英文场刊用拉丁字母与场刊姓名序；不得出现平台标签、登录句柄、角色名或占位符；真名不可得时用 `Authors to be supplied by the submitting authors` 并在 `research/` 记录未决的作者身份。真名需从 GeWu 系统取（受 API scope 阻塞）。

**作者行是白名单（用户 2026-09-14 明确）**：`\author{}` / `\collaboration{}` **逐字取自** `gewu-top30/AUTHORSHIP.json` 的 display 形式，GeWu 的标签（`Scientific Author 82`、`kunchen`、`玮琦 蒋`）**按原样写入即为正确**——不要翻译、不要调序、不要罗马化、不要"改进"。我此前把它当缺陷要求改真名是**误判**，已改正（constitution §4、checks §2 的 grep 排除该两字段、production §5、launcher）。唯一保留的底线：不得凭空编造作者，不得把记录中已有的 display 形式换成占位符。

## 严重缺陷：工作目录错位与 agent 自毁（2026-09-14 第六轮 B）

**现象**：30 个任务里 **7 个稿件归零**（`.tex` 全无），其中 `23-solution-p3234` 在 workspace 完全空的情况下以 **exit 0 报告成功**；另有 `paper/figures,`、`workspace/{paper`、`research/checks,` 这类**畸形目录**；4 个任务把文件写到 workspace 之外；复活 7 篇时发现它们的 **`task.md` 已被删除**，连重跑都起不来。

**根因一（运行器，决定性）**：`gewu-run` 在启动 pi 前执行 `cd "$TASK_DIR"`——pi 的工作目录是**任务目录**而非 workspace。技能与任务书都要求所有产物落在 `WORKSPACE` 内，于是相对路径全部逃逸，且任何 run 级检查都看不到。已修：`cd "$TASK_DIR/workspace"`，并用 `/proc/<pid>/cwd` 验证。

**根因二（agent 行为）**：有 agent 把技能里的 workspace 目录树当成 `mkdir` 命令清单去"创建目录"，用了花括号/逗号形式，产生畸形目录；并有 agent 执行了破坏性命令删掉自己的 `task.md`。已修：SKILL.md 明写"这些目录已存在，不要创建；禁止 mkdir 该树、禁止 rm/mv/rmdir、禁止花括号/逗号路径"，并要求**收尾前确认 `paper/main.tex` 与 PDF 存在**。

**根因三（判定漏洞）**：pi 退出码 0 即视为成功，即使 workspace 全空。已修：退出码 0 但缺 `workspace/paper/main.tex` → 记为失败（RC=9），走正常重试。

**教训**：
1. **工作目录是契约的一部分**——规定"产物必须落在 WORKSPACE"却不把进程 cwd 设进去，等于没有这条规定。
2. **"成功"必须由产物定义，而不是由退出码定义**。
3. 目录树写在文档里会被模型当成命令执行；必须显式说明"已存在、不要创建"。
4. 删除类操作要显式禁止——agent 会"顺手清理"，代价不可逆。

