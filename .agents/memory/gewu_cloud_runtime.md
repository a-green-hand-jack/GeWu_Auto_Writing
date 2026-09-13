# GeWu 云主机与写作运行时

## 当前工作决策

本项目后续的 Solution report 阅读、论文写作和高并发 coding-agent 工作统一在 GeWu ECS 上进行。当前决定使用 **GravArc Router + Pi** 作为主要 LLM coding-agent 运行方案；不再继续配置云主机上的 Codex OAuth。

原因：云主机通过 OpenAI OAuth 完成授权后的 token exchange 时，OpenAI 返回：

```text
403 Forbidden: Country, region, or territory not supported
```

headless device-auth 和普通浏览器 OAuth 都触发了同一类区域限制。重复尝试当前云主机出口不会解决问题。Codex CLI 可以保留安装状态，但不视为本项目云端写作环境的可用 LLM provider。

## 云主机入口

```bash
ssh gewu-ecs
cd ~/GeWu_Auto_Writing
```

云主机上的冻结 Top 30 Solution 仓库位于：

```text
~/GeWu_Auto_Writing/gewu-top30/
```

这些仓库仅作只读参考，不在其中修改或提交。

## 主要 LLM 使用方式

Pi 和 GravArc 已安装并配置。推荐启动：

```bash
pi-gewu
```

`pi-gewu` 默认使用：

```text
gravarc-router/kimi-for-coding
```

如果该模型临时返回 503，使用已验证的替代模型：

```bash
pi --print --model gravarc-router/deepseek-v4-flash '你的任务'
pi --print --model gravarc-router/qwen3.7-max '你的任务'
pi --print --model gravarc-router/glm-5.3:low '你的任务'
```

GravArc 的模型可用性会随上游变化；实时目录中出现的模型不保证当前账号全部可调用。部分模型失败不代表本地 provider 配置失败。

## 已确认的基础设施

- Pi：`0.85.1`
- GravArc provider key：`~/.config/opencode/account-keys/gravarc-router.key`
- Bohrium CLI：`2.6.86`
- Bohrium 包装命令：`bohr-gewu`
- TeX Live：2026
- pdfLaTeX、XeLaTeX、latexmk：已通过真实编译 smoke test
- 30 个冻结 Solution repo：已同步且工作树 clean

Bohrium 使用：

```bash
bohr-gewu auth status -o json
bohr-gewu auth whoami -o json
```

Bohrium 的 LKM 查询可能计费，只有在用户明确需要查询时才执行带 `--yes` 的调用。

## 凭证边界

不要在项目、memory、skill、shell 配置、日志或聊天中保存或打印 API key、PAT、密码、OAuth token 或私钥内容。GravArc 和 Bohrium key 由 `accountctl` 管理的用户级运行时文件提供；`BOHR_ACCESS_KEY` 仅由 `bohr-gewu` 注入到短命令进程中。
