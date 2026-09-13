---
name: gewu-authentication
description: Authenticate to the GeWu GitLab platform over HTTPS and access the Matrixlab ECS over SSH without exposing credentials.
---

# GeWu Authentication

## Service boundaries

GeWu has two separate access surfaces:

1. **GitLab**: `https://git.gewu-lab.ai`, used for repositories, Issues, Merge Requests, and platform journals/registries. Use `glab` and HTTPS; do not switch Git remotes to SSH.
2. **Matrixlab ECS**: the project-local `ecs-login.sh` connects to the configured ECS host as `jieke` using an SSH key. Keep compute commands and long-running jobs on the ECS, not on the control machine.

Never place passwords, PATs, private keys, or `.env` files in this repository or in chat.

## First-time GitLab access

The user must first register at `https://git.gewu-lab.ai/` and obtain administrator approval. After approval, create a GitLab PAT with the minimum required scopes. Use `api` when API operations through `glab` are needed; add `read_repository` or `write_repository` only when repository operations require them.

Install the latest `glab` using the operating system's supported package manager. Then authenticate without putting the token in shell history or command arguments:

```bash
glab auth login --hostname git.gewu-lab.ai --git-protocol https --token-stdin
```

Paste the PAT only at the hidden/stdin prompt. Verify without printing credentials:

```bash
glab auth status --hostname git.gewu-lab.ai
glab repo list --hostname git.gewu-lab.ai --mine
```

If `glab auth status` reports a network reset or timeout, diagnose network reachability first. Do not reprint or rotate a valid token solely because a sandboxed process cannot access its credential backend.

## Matrixlab ECS access

From this project directory:

```bash
./ecs-login.sh
```

The script uses the local SSH private key selected by `GEWU_ECS_KEY_FILE`, defaulting to `~/.ssh/id_ed25519`. It enables keepalives and does not reveal the password file. To run a command remotely:

```bash
./ecs-login.sh 'hostname; id -un; pwd'
```

For long-running work, use `tmux`, `nohup`, or another durable remote wrapper rather than leaving the process attached to a fragile SSH session.

## Key handling

Only synchronize a specifically identified private key after confirming its intended host and purpose. Prefer copying the public key to the target and generating a new direction-specific key over copying an existing private key. If an existing MacBook key is explicitly authorized for Matrixlab, transfer it only over the already verified `macbook` SSH channel, install it with mode `600`, and never print its contents. Do not copy unrelated GitHub, GitLab, or other ECS keys by filename guess.

Before any transfer, compare fingerprints of the candidate public key on both devices and verify the destination host. After transfer, test `ssh -o IdentitiesOnly=yes ... hostname` and keep the private key outside Git.

## Validation contract

Report:

- GitLab HTTPS authentication state and `glab` version;
- Matrixlab SSH key authentication state;
- the exact non-secret command used for the next connection; and
- any missing approval, PAT, network access, or host-key prerequisite.
