# docker-mirror-helper

A lightweight, bilingual, shell-first skill for querying, rewriting, and troubleshooting Docker image usage with the public mirror service at [docker.aityp.com](https://docker.aityp.com/).

一个轻量、双语、纯 shell 优先的 skill，用于基于公开镜像站 [docker.aityp.com](https://docker.aityp.com/) 查询镜像、改写镜像引用，并处理常见拉取和同步问题。

## What This Repo Contains

This repository ships a reusable skill folder:

- [docker-mirror-helper](/Users/lukeding/Desktop/playground/2026/product/docker-mirror-skill/docker-mirror-helper)

Inside it you will find:

- [SKILL.md](/Users/lukeding/Desktop/playground/2026/product/docker-mirror-skill/docker-mirror-helper/SKILL.md)
- [agents/openai.yaml](/Users/lukeding/Desktop/playground/2026/product/docker-mirror-skill/docker-mirror-helper/agents/openai.yaml)
- [scripts/docker_mirror_api.sh](/Users/lukeding/Desktop/playground/2026/product/docker-mirror-skill/docker-mirror-helper/scripts/docker_mirror_api.sh)
- Four bilingual reference files under [references/](/Users/lukeding/Desktop/playground/2026/product/docker-mirror-skill/docker-mirror-helper/references)

仓库里主要内容就是可复用的 skill 目录：

- [docker-mirror-helper](/Users/lukeding/Desktop/playground/2026/product/docker-mirror-skill/docker-mirror-helper)

它包含：

- `SKILL.md`
- `agents/openai.yaml`
- `scripts/docker_mirror_api.sh`
- `references/` 下的 4 份双语参考文档

## What The Skill Does

Use this skill to:

- Find whether a Docker image has already been mirrored
- Get a usable mirror address from the public API
- Rewrite `docker pull` commands or image references in `Dockerfile`, Compose, and Kubernetes YAML
- Check site status, supported registries, or supported architectures
- Explain likely sync and pull failures with public documentation plus live API evidence

这个 skill 可以用来：

- 查询某个镜像是否已经同步
- 从公开 API 获取可用镜像地址
- 改写 `docker pull`、`Dockerfile`、Compose、Kubernetes YAML 中的镜像引用
- 查询站点状态、支持的镜像源、支持的架构
- 结合公开文档与实时 API 解释常见同步和拉取失败

## Design Goals

- Shell-first: `bash + curl`, no Python or Node runtime required for normal usage
- Broadly reusable: suitable for Codex and other general AI assistants
- Bilingual: key instructions and references are written in English and Chinese
- Lightweight: the shell helper stays thin and returns raw JSON by default

## Quick Start

### Use The Shell Helper

```bash
bash docker-mirror-helper/scripts/docker_mirror_api.sh website
bash docker-mirror-helper/scripts/docker_mirror_api.sh health
bash docker-mirror-helper/scripts/docker_mirror_api.sh image 'python:3.12-slim' docker.io linux/amd64
bash docker-mirror-helper/scripts/docker_mirror_api.sh error
```

### Use The Skill In Codex

Place the `docker-mirror-helper/` folder under your skills directory, for example:

```bash
mkdir -p "${CODEX_HOME:-$HOME/.codex}/skills"
cp -R docker-mirror-helper "${CODEX_HOME:-$HOME/.codex}/skills/"
```

Then ask for tasks such as:

- "Find me a China-accessible mirror for `docker.io/library/nginx:1.27`"
- "Rewrite this `Dockerfile` to use mirrored images"
- "Why does this mirrored image fail to pull on `linux/arm64`?"

### Use The Skill In Other Assistants

If your assistant can read repository files and execute shell commands:

1. Load `docker-mirror-helper/SKILL.md`
2. Let it open only the relevant file under `references/`
3. Let it call `scripts/docker_mirror_api.sh` for live API checks

## Repository Layout

```text
.
├── README.md
├── docker-mirror-helper/
│   ├── SKILL.md
│   ├── agents/openai.yaml
│   ├── references/
│   └── scripts/docker_mirror_api.sh
└── docs/superpowers/specs/
    └── 2026-04-23-docker-mirror-helper-design.md
```

## Validation

The skill was validated locally with:

```bash
python3 /Users/lukeding/.codex/skills/.system/skill-creator/scripts/quick_validate.py docker-mirror-helper
bash docker-mirror-helper/scripts/docker_mirror_api.sh website
bash docker-mirror-helper/scripts/docker_mirror_api.sh image 'python:3.12-slim' docker.io linux/amd64
```

## Important Notes

- Live API facts can change over time. Query first when freshness matters.
- Public documentation states that the API is for development, ops testing, and technical/internal usage.
- Public documentation also states that commercial-for-profit use is prohibited.
- This repository is released under the MIT License. See [LICENSE](/Users/lukeding/Desktop/playground/2026/product/docker-mirror-skill/LICENSE).

## Related Files

- Skill: [docker-mirror-helper/SKILL.md](/Users/lukeding/Desktop/playground/2026/product/docker-mirror-skill/docker-mirror-helper/SKILL.md)
- Shell helper: [docker-mirror-helper/scripts/docker_mirror_api.sh](/Users/lukeding/Desktop/playground/2026/product/docker-mirror-skill/docker-mirror-helper/scripts/docker_mirror_api.sh)
- Design spec: [docs/superpowers/specs/2026-04-23-docker-mirror-helper-design.md](/Users/lukeding/Desktop/playground/2026/product/docker-mirror-skill/docs/superpowers/specs/2026-04-23-docker-mirror-helper-design.md)
