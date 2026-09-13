# GeWu 云主机运行环境

## 云主机

- SSH 别名：`gewu-ecs`
- 远程主机：`matrix-lab`
- 用户：`jieke`
- 远程工作目录：`~/GeWu_Auto_Writing/`
- 冻结参考仓库：`~/GeWu_Auto_Writing/gewu-top30/`
- 仓库数量：30
- 仓库用途：只读分析，不在其中提交修改

登录：

```bash
ssh gewu-ecs
```

## 已安装工具

| 工具 | 版本/状态 |
|---|---|
| Node.js | v24.21.0，用户级安装 |
| npm | 11.19.0 |
| pi | 0.85.1 |
| Codex CLI | 0.154.0 |
| TeX Live | 2026，用户级安装 |
| pdfLaTeX | 可用 |
| XeLaTeX | 可用 |
| latexmk | 4.88，可用 |
| glab | 1.117.0 |
| bohr | 2.6.86 |

新登录 shell 已将以下路径加入 `PATH`：

```text
~/.local/bin
~/texlive/2026/bin/x86_64-linux
```

## GravArc Router

运行时 provider：`gravarc-router`

- API endpoint：`https://api.epicllmrouter.top/v1`
- 云主机上的 key 由 MacBook 通过受管的 `accountctl secrets sync` 同步
- key 文件不在项目目录中：`~/.config/opencode/account-keys/gravarc-router.key`
- Pi 配置位于：`~/.pi/agent/models.json` 和 `~/.pi/agent/auth.json`
- `auth.json` 只引用本机 key 文件，不包含 key 内容

截至配置时，GravArc `/v1/models` live catalog 返回 57 个模型；Pi 当前配置并启用其中 32 个已验证的 coding/文本模型。包含：

- DeepSeek：`deepseek-v4-flash`、`deepseek-v4-pro-*`
- GLM：`glm-5.1`、`glm-5.2`、`glm-5.3`、`glm-5.3-shouyun`
- Qwen：`qwen3-235b-a22b`、`qwen3.6-*`、`qwen3.7-*`
- Kimi：`kimi-for-coding`、`kimi-k2-thinking`、`kimi-k2.6`、`kimi-k2.7-code`
- GPT：`gpt-5*`、`gpt-5.2`、`gpt-5.4*`、`gpt-5.5*`、`gpt-5.6-luna`、`gpt-5.6-terra`
- Codex：`gpt-5.3-codex`、`gpt-5.3-codex-spark`、`codex-cli`

上游还公开列出 Claude 和图像模型，但它们没有加入当前 Pi coding catalog；不能仅凭 `/v1/models` 广告列表认定当前账号对每个模型都有调用权限。已通过真实 Pi 请求验证：

```bash
pi --print --model gravarc-router/kimi-for-coding 'Reply with exactly PI_GRAVARC_OK'
```

## Bohrium

Bohrium CLI 已配置为用户级工具。运行时 key 文件：

```text
~/.config/opencode/account-keys/bohrium.key
```

为避免持久化导出 `BOHR_ACCESS_KEY`，使用包装命令：

```bash
bohr-gewu auth status -o json
bohr-gewu auth whoami -o json
bohr-gewu lkm search 'your query' --top-k 10 --yes -o json
```

`bohr-gewu` 只在当前子进程环境中读取 key，不把 key 放入项目、shell 配置或命令参数。LKM 查询是可能计费的操作，使用 `--yes` 前应确认查询意图和费用。

## 写作工作流约定

论文写作和高并发任务放在云主机上执行。长任务应使用 `tmux`、`nohup` 或其他持久化远程执行方式，不要依赖单次 SSH 会话保持运行。

推荐进入工作区：

```bash
ssh gewu-ecs
cd ~/GeWu_Auto_Writing
```
