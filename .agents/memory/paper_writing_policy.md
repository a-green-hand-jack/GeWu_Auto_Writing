# 论文写作策略与 paperwriter-pi 结构

## 核心决策：已产出的论文不修复，直接从源头重跑

已经生成的论文草稿 **不做事后 patch**。需要改动时，从 `SOURCE_ROOT` 重新完整运行一次写作任务，产出一份新的 `WORKSPACE`。

原因：

- 修复是手工过程：改 `\FloatBarrier`、补 `\section*{References}`、清理 bibliography 叙述、删未引用条目、补文献，每一步都要人工判断且容易漏改级联位置（摘要、结论、表格、已编译 PDF、视觉复查）；
- 重跑是可复用、可验证的：同一 `SOURCE_ROOT` + 同一 skill 版本 + 同一门禁，产出的是一份内部自洽的新稿，而不是一份"打补丁的历史文件"；
- 于是配套约束是：**技能与门禁要一次做对**，不要让产出物积累需要修补的债务。发现产出缺陷时，修 skill 与 preflight，然后重跑。

`paperwriter-*-runs/` 下的运行产物是生成物、已被 `.gitignore` 忽略，不视作需要维护的资产，也不逐份修补。

## 模板：固定使用 PRX

正式手稿固定使用 `templates/prx-official/apstemplate.tex`，document class 必须是：

```latex
\documentclass[aps,prx,reprint,groupedaddress]{revtex4-2}
```

任何使用 `article`、`amsart`、`plainnat`、`unsrt`、PRE、PRL 或 `pre-generic` 的历史产出都视为 legacy，应当重新生成，而不是就地改造。

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

## paperwriter-pi 结构（2026-09-13 重构）

三层，按需加载，41 文件/2750 行 → 12 文件/约 1500 行：

1. `references/constitution.md` —— 恒定加载的原则层（不写流程，只写不可违反的原则）；
2. `references/workflows/production.md`（写作全流程）、`preflight.md`（交付前门禁）、`review.md`（整篇复查与有界修订），配合 `knowledge/writing-craft.md`；
3. `references/domains/<domain>.md` —— 每篇论文**只加载一个**领域文件；`layout.md` 域无关，有渲染页面时使用。

关键约束：物理理论论文**不再加载数学写作框架**。数学文件里的正向结构模板（theorem/lemma chain、完整证明、sharpness）会把普通物理结果包装成 Theorem；物理所需的推导纪律改由 `domains/physics.md` 的 "Derivations and formal statements" 一节自带。

## 重跑方式

见 `README.md` 的 "Pi 运行方式"：每个任务显式给出 `SOURCE_ROOT`（只读）与 `WORKSPACE`（唯一可写），任务 prompt 里指明使用 PRX 模板。30 篇可并行，各自独立 workspace。
