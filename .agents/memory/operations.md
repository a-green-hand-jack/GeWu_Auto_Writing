# 项目运维规则（批量运行与 CLI）

## 规则 1：长命令/长任务一律后台运行

非常长的命令或任务不得在前台阻塞交互。

- 启动：`setsid nohup <cmd> > <log> 2>&1 < /dev/null &`，随后用短命令查状态；
- 不要用 `sleep N` 长时间占用前台来"等"任务；等待应交给后台 agent 或状态查询；
- 状态查询本身要快（秒级）。若某条查询命令本身很重（例如要 grep 上千个文件），先把它做成 CLI 并抽样，而不是每次全量阻塞执行。

## 规则 2：反复执行的命令沉淀为 CLI

本项目已沉淀的 CLI（源码版本化在仓库 `tools/`，ECS 安装到 `~/GeWu_Auto_Writing/bin/gewu-batch` 并软链到 `~/.local/bin/gewu-batch`）：

| 命令 | 用途 |
|---|---|
| `gewu-batch list` | 列出所有 run 目录及 finished/running 计数 |
| `gewu-batch watches [RUN]` | 单个 run 的一行进度 |
| `gewu-batch status [RUN]` | 逐任务表：state/files/tex/bib/pdf/elapsed |
| `gewu-batch gates [RUN]` | 逐篇门禁指标：class/FloatBarrier/References 标签/bibitem/未引用/流程叙述/theorem 环境/PDF |
| `gewu-batch report [RUN]` | 汇总统计 |
| `gewu-batch tail RUN TASK [N]` | 看某任务的 run.log |
| `gewu-batch show RUN TASK FILE` | 看某任务 workspace 下的文件 |

`RUN` 参数可用完整路径、名字片段（如 `math5`、`top30`）或留空表示最新。本地通过 `tools/gwb <cmd>` 经 ssh 调用（`GEWU_BATCH_HOST` 可改主机）。

## 规则 3：踩过的坑（务必避免）

- **传输脚本**：用 `ssh host 'cat > FILE' < local_file`。不要把 heredoc 传输与 `&` 后台链写在同一行，否则 heredoc 的 stdin 被吞，远端文件变成 0 字节（已实际踩过，导致 5 个数学任务以 exit 127 瞬间失败）。
- **PATH**：非交互 ssh 没有 `~/.local/bin`。launcher 必须自己 `export PATH="$HOME/.local/bin:$HOME/texlive/2026/bin/x86_64-linux:$PATH"`，并在启动前用 `command -v pi` 做守卫。
- **不要修改正在运行的脚本**：bash 边读边执行，改运行中的 launcher 会导致不可预期行为。要改就新建脚本文件。
- **运行产物**：`paperwriter-pi-runs/` 已被 `.gitignore` 忽略，属于生成物；不逐份修补（见 `paper_writing_policy.md`：失败即整份重跑）。
