# docker-mirror-helper

[![License: MIT](https://img.shields.io/badge/License-MIT-0f766e.svg)](LICENSE)
![Shell](https://img.shields.io/badge/Shell-bash%20%2B%20curl-1f6feb)
![Bilingual](https://img.shields.io/badge/Docs-English%20%2F%20中文-f59e0b)
![Use Case](https://img.shields.io/badge/Use%20Case-Docker%20Mirror-2563eb)
![Status](https://img.shields.io/badge/Status-Open%20Source-9333ea)

> A lightweight, bilingual, shell-first skill for querying, rewriting, and troubleshooting Docker image usage with the public mirror service at [docker.aityp.com](https://docker.aityp.com/).
>
> 一个轻量、双语、纯 shell 优先的 skill，用于基于公开镜像站 [docker.aityp.com](https://docker.aityp.com/) 查询镜像、改写镜像引用，并处理常见拉取和同步问题。

## Install | 安装方法

### Install In Codex | 在 Codex 中安装

Place the `docker-mirror-helper/` folder under your Codex skills directory:

把 `docker-mirror-helper/` 目录复制到你的 Codex skills 目录中：

```bash
mkdir -p "${CODEX_HOME:-$HOME/.codex}/skills"
cp -R docker-mirror-helper "${CODEX_HOME:-$HOME/.codex}/skills/"
```

### Installation Prompt | 安装提示词

```text
Please install the skill from this repository into my AI assistant's skills directory. Repository URLs: https://github.com/hellolukeding/docker-mirror-helper.git , git@github.com:hellolukeding/docker-mirror-helper.git . You can also clone it with: gh repo clone hellolukeding/docker-mirror-helper . After cloning, copy the `docker-mirror-helper/` folder into the correct skills directory for my assistant.

请帮我把这个仓库里的 skill 安装到我的 AI 助手 skills 目录。仓库地址：https://github.com/hellolukeding/docker-mirror-helper.git ，SSH 地址：git@github.com:hellolukeding/docker-mirror-helper.git 。也可以使用 `gh repo clone hellolukeding/docker-mirror-helper` 进行克隆。克隆完成后，请把 `docker-mirror-helper/` 目录复制到适合我当前 AI 助手的 skills 目录中。
```

## Overview | 项目简介

This repository ships a reusable skill folder for Codex and other AI assistants that can read files and execute shell commands.

这个仓库提供了一个可复用的 skill，适合 Codex 以及其他能够读取文件并执行 shell 命令的 AI 助手。

The core skill lives in:

核心 skill 目录位于：

- [`docker-mirror-helper/`](docker-mirror-helper/)

Inside it you will find:

其中包含：

- [`SKILL.md`](docker-mirror-helper/SKILL.md)
- [`agents/openai.yaml`](docker-mirror-helper/agents/openai.yaml)
- [`scripts/docker_mirror_api.sh`](docker-mirror-helper/scripts/docker_mirror_api.sh)
- Four bilingual reference files under [`references/`](docker-mirror-helper/references/)

## Features | 功能特点

Use this skill to:

你可以用这个 skill 来：

- Find whether a Docker image has already been mirrored
- Check supported registries, architectures, queue status, and site health
- Get a usable mirror address from the public API
- Rewrite `docker pull` commands or image references in `Dockerfile`, Compose, and Kubernetes YAML
- Explain likely sync and pull failures with public documentation plus live API evidence

- 查询某个镜像是否已经同步
- 查询站点支持的镜像源、架构、等待队列和健康状态
- 从公开 API 获取可用镜像地址
- 改写 `docker pull`、`Dockerfile`、Compose、Kubernetes YAML 中的镜像引用
- 结合公开文档与实时 API 解释常见同步和拉取失败

## Why This Repo | 为什么做这个项目

This project is designed around a few practical goals:

这个项目主要围绕几个很实际的目标来设计：

- Shell-first: `bash + curl`, no Python or Node runtime required for normal usage
- Broadly reusable: suitable for Codex and other general AI assistants
- Bilingual: key instructions and references are written in English and Chinese
- Lightweight: the shell helper stays thin and returns raw JSON by default

- 纯 shell 优先：日常使用只需要 `bash + curl`
- 通用复用：不绑定单一 AI 产品
- 中英双语：关键说明和参考文档都能直接阅读
- 保持轻量：shell helper 尽量薄，默认返回原始 JSON

## Quick Start | 快速开始

### Shell Helper | Shell 脚本直接使用

```bash
bash docker-mirror-helper/scripts/docker_mirror_api.sh website
bash docker-mirror-helper/scripts/docker_mirror_api.sh health
bash docker-mirror-helper/scripts/docker_mirror_api.sh image 'python:3.12-slim' docker.io linux/amd64
bash docker-mirror-helper/scripts/docker_mirror_api.sh error
```

### Example Requests | 示例请求

- "Find me a China-accessible mirror for `docker.io/library/nginx:1.27`"
- "Rewrite this `Dockerfile` to use mirrored images"
- "Why does this mirrored image fail to pull on `linux/arm64`?"

- “帮我找 `docker.io/library/nginx:1.27` 的国内可拉取镜像地址”
- “把这个 `Dockerfile` 改成镜像站版本”
- “为什么这个镜像在 `linux/arm64` 上拉取失败”

### Use In Other Assistants | 在其他 AI 助手中使用

If your assistant can read repository files and execute shell commands:

如果你的 AI 助手可以读取仓库文件并执行 shell：

1. Load [`docker-mirror-helper/SKILL.md`](docker-mirror-helper/SKILL.md)
2. Open only the relevant file under [`docker-mirror-helper/references/`](docker-mirror-helper/references/)
3. Call [`docker_mirror_api.sh`](docker-mirror-helper/scripts/docker_mirror_api.sh) for live API checks

1. 先读取 [`docker-mirror-helper/SKILL.md`](docker-mirror-helper/SKILL.md)
2. 按任务需要打开 [`docker-mirror-helper/references/`](docker-mirror-helper/references/) 里的相关文档
3. 用 [`docker_mirror_api.sh`](docker-mirror-helper/scripts/docker_mirror_api.sh) 查询实时 API

## Examples | 示例文件

The repository includes concrete before/after examples:

仓库里提供了可直接查看的 before/after 示例：

- [`examples/docker-pull.md`](examples/docker-pull.md)
- [`examples/Dockerfile.before`](examples/Dockerfile.before)
- [`examples/Dockerfile.after`](examples/Dockerfile.after)
- [`examples/docker-compose.before.yml`](examples/docker-compose.before.yml)
- [`examples/docker-compose.after.yml`](examples/docker-compose.after.yml)
- [`examples/kubernetes.before.yaml`](examples/kubernetes.before.yaml)
- [`examples/kubernetes.after.yaml`](examples/kubernetes.after.yaml)

## Repository Layout | 仓库结构

```text
.
├── README.md
├── LICENSE
├── examples/
├── docker-mirror-helper/
│   ├── SKILL.md
│   ├── agents/openai.yaml
│   ├── references/
│   └── scripts/docker_mirror_api.sh
└── docs/superpowers/specs/
    └── 2026-04-23-docker-mirror-helper-design.md
```

## Validation | 验证方式

Run the shell helper smoke tests:

可以先运行这几个 shell smoke test：

```bash
bash docker-mirror-helper/scripts/docker_mirror_api.sh website
bash docker-mirror-helper/scripts/docker_mirror_api.sh image 'python:3.12-slim' docker.io linux/amd64
bash docker-mirror-helper/scripts/docker_mirror_api.sh error
```

Or run the repository validation script:

也可以直接运行仓库自带的校验脚本：

```bash
bash scripts/validate.sh
```

If you are using Codex and have the local skill validation tool available, you can also run that validator against `docker-mirror-helper/`.

如果你在 Codex 环境里，并且本地有 skill 校验工具，也可以额外对 `docker-mirror-helper/` 做结构校验。

## Notes | 注意事项

- Live API facts can change over time. Query first when freshness matters.
- Public documentation states that the API is for development, ops testing, and technical/internal usage.
- Public documentation also states that commercial-for-profit use is prohibited.
- This repository is released under the [MIT License](LICENSE).

- 实时 API 信息会变化，涉及时效时要先查询再回答。
- 公开文档说明该 API 主要用于开发、运维测试和技术/内部系统集成。
- 公开文档同时说明禁止商业化盈利使用。
- 本仓库使用 [MIT License](LICENSE) 开源。

## Related Files | 相关文件

- Skill: [`docker-mirror-helper/SKILL.md`](docker-mirror-helper/SKILL.md)
- Shell helper: [`docker-mirror-helper/scripts/docker_mirror_api.sh`](docker-mirror-helper/scripts/docker_mirror_api.sh)
- Design spec: [`docs/superpowers/specs/2026-04-23-docker-mirror-helper-design.md`](docs/superpowers/specs/2026-04-23-docker-mirror-helper-design.md)
- Contributing guide: [`CONTRIBUTING.md`](CONTRIBUTING.md)
