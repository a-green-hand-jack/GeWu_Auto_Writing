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

## 规则 3：视觉能力与页面渲染（2026-09-13 更新）

### GravArc Router 的模型清单与视觉模型

路由器自己的清单**无需认证**即可读取，这是权威来源（`pi --list-models` 只反映本地目录，会漂移）：

```bash
curl -sS https://api.epicllmrouter.top/v1/models -o /tmp/router_models.json   # 当前 57 个模型
```

清单里带视觉语义的条目：

- `moonshot-v1-8k/32k/128k-vision-preview`（kimi，名字里就写 vision）
- `gpt-5`/`gpt-5.2`/`gpt-5.4`/`gpt-5.5`/`gpt-5.6-sol|luna|terra`/`gpt-6-astra`（GPT-5 系通常多模态，但名字不含 vision）
- `claude-*`（Anthropic 系通常多模态）
- `gpt-image-2`、`chatgpt-image-latest` 是**图像生成**，不是图像理解

**但当前账号下这些渠道全部不可用**：用纯文本请求逐个验证，`moonshot-v1-*-vision-preview`、`gpt-5.6-sol`、`claude-sonnet-4-6`、`claude-haiku-4-5` 一律 `503`（连纯文本都 503 → 是渠道缺失，不是不接受图像）。对照 `deepseek-v4.1-flash` 纯文本正常。所以"清单里有"不等于"能用"。

### 现在可用的视觉路径

`apex/gpt-5.6-sol` —— 本地目录里已配置、声明 `input: ["text","image"]`，**已实测可读图**（正确识别随机形状+随机 5 位数字的验证图），并已成功读真实论文页面并给出具体版面观察。这是当前唯一验证可用的视觉模型。

### ECS 页面渲染（已安装）

ECS 是 Ubuntu 24.04，**无免密 sudo**、docker 不可用、poppler 未装。已安装：

- `pip3 install --user --break-system-packages pypdfium2`（venv 不可用：缺 ensurepip）；
- `tools/pdf-pages`（仓库版本化；ECS 装到 `~/GeWu_Auto_Writing/bin/pdf-pages` 并软链 `~/.local/bin/`）：用 PDFium 渲染，无需系统 poppler，支持 `--dpi`、`--pages 1-5`。

已实测：渲染真实论文 PDF → 取回本地 → `apex/gpt-5.6-sol` 逐页给出具体观察。**视觉门禁因此可执行**；用 GravArc Router 跑批量时仍需按模型实际能力判断，不得从编译退出码推断视觉通过。

### 实验纪律

修改模型声明做实验后必须恢复并校验哈希（本次两次实验后均已恢复，sha256 一致）。

## 规则 4：踩过的坑（务必避免）

- **传输脚本**：用 `ssh host 'cat > FILE' < local_file`。不要把 heredoc 传输与 `&` 后台链写在同一行，否则 heredoc 的 stdin 被吞，远端文件变成 0 字节（已实际踩过，导致 5 个数学任务以 exit 127 瞬间失败）。
- **PATH**：非交互 ssh 没有 `~/.local/bin`。launcher 必须自己 `export PATH="$HOME/.local/bin:$HOME/texlive/2026/bin/x86_64-linux:$PATH"`，并在启动前用 `command -v pi` 做守卫。
- **不要修改正在运行的脚本**：bash 边读边执行，改运行中的 launcher 会导致不可预期行为。要改就新建脚本文件。
- **运行产物**：`paperwriter-pi-runs/` 已被 `.gitignore` 忽略，属于生成物；不逐份修补（见 `paper_writing_policy.md`：失败即整份重跑）。

## 规则 5：看门狗（provider 卡死）

模型供应商偶尔会挂起 HTTP 请求：pi 进程活着、**CPU 时间几乎不增长**、workspace 长时间没有新文件。首批 30 个任务里出现 2 次，各空转约 75 分钟。

判断方法：比较进程的 `CPU TIME`（`ps -o etime,time`）与 workspace 最新文件时间。CPU 时间远小于墙上时间 + 文件长时间不更新 = 卡死，不是"在算"。

处理：按环境失败处理（**不是**写作结果），停掉并整份重跑。启动任务用 `tools/gewu-run`：

```bash
gewu-run --task-dir DIR --timeout 10800 --stall 1200   # 20 分钟无写入即判卡死并终止
```

它写与 launcher 相同的 `pid/started-at/run.log/exit-code/finished-at`，额外写 `stall-detected`。批量的 `timeout 14400` 只兜住"永远不返回"，单独的 stall 看门狗才能及早释放卡死任务。
