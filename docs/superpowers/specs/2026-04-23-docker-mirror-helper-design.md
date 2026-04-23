# docker-mirror-helper Design

Date: 2026-04-23

## Summary / 摘要

`docker-mirror-helper` is a lightweight, open-source skill for AI assistants that need to work with the public Docker mirror service at `docker.aityp.com`. It is designed to be broadly reusable, shell-first, and easy to run in constrained environments.

`docker-mirror-helper` 是一个轻量、开源、面向 AI 助手的 skill，用于帮助助手使用 `docker.aityp.com` 提供的公开 Docker 镜像查询与镜像站能力。设计目标是通用、纯 shell 优先、依赖极少，并适合在受限环境中复用。

The skill is not limited to raw API lookups. It supports a wider workflow:

- Check whether an image has already been mirrored
- Find a usable mirror address and relevant platform metadata
- Rewrite image references in commands and config files
- Explain likely sync and pull failures using documented error patterns
- Surface site capabilities, limits, and policy boundaries

这个 skill 不只做 API 查询，还覆盖更完整的工作流：

- 检查镜像是否已经同步
- 获取可用镜像地址与平台元信息
- 改写命令和配置文件中的镜像引用
- 基于公开错误模式解释同步或拉取失败
- 提示站点能力、限制与使用边界

## Goals / 目标

- Be reusable across general AI assistants, not tied to a single product
- Prefer `bash` and common Unix tools over Python or Node.js
- Keep the repository small and maintainable for open-source release
- Use bilingual documentation so Chinese and English readers can both adopt it
- Provide a stable workflow for assistants: query facts first, then explain or edit

## Non-Goals / 非目标

- Do not become a full standalone CLI product
- Do not implement large-scale YAML or Dockerfile refactoring in shell
- Do not embed site content that is better kept in references and updated over time
- Do not promise support for commercial use when the site policy forbids it

## Supported User Tasks / 覆盖的用户任务

This skill should trigger for requests such as:

- "Find a China-accessible mirror for this Docker image"
- "Tell me whether this image exists on the mirror site"
- "Rewrite this `docker pull` command to use the mirror"
- "Update my `Dockerfile`, Compose file, or Kubernetes YAML to use mirrored images"
- "Why does this mirrored image fail to pull?"
- "Show the mirror site's supported registries, architectures, or health"

适合触发本 skill 的请求包括：

- “帮我找这个镜像的国内可拉取地址”
- “这个镜像在镜像站有没有同步”
- “把这个 `docker pull` 改成镜像站版本”
- “把我的 `Dockerfile`、Compose、K8s YAML 改成镜像站镜像”
- “这个镜像为什么拉取失败”
- “镜像站支持哪些源、架构、现在是否健康”

## Source Facts / 已确认的事实来源

As of 2026-04-23, the public site exposes these documented endpoints:

- `GET /api/v1/latest`
- `GET /api/v1/website`
- `GET /api/v1/wait`
- `GET /api/v1/today`
- `GET /api/v1/error`
- `GET /api/v1/health`
- `GET /api/v1/email/{email}`
- `GET /api/v1/ip`
- `GET /api/v1/image?search=...`

Observed response patterns:

- Many list endpoints return `count`, `error`, and `results`
- `website` returns supported sites, architectures, counts, and size totals
- `health` returns a numeric `status`
- `ip` returns `ClientIp` and `RealIp`
- `error` exposes recent failures such as missing architecture, missing tags, or permission errors

Documented site boundaries observed from public docs:

- API is public and does not currently require authentication
- API has no published request-count limit
- Search endpoint returns at most 50 records
- Public docs state the API is for development, ops testing, and internal technical usage
- Public docs prohibit commercial-for-profit use of the site API

## Repository Layout / 仓库结构

```text
docker-mirror-helper/
├── SKILL.md
├── agents/
│   └── openai.yaml
├── scripts/
│   └── docker_mirror_api.sh
└── references/
    ├── api-reference.md
    ├── usage-and-troubleshooting.md
    ├── rewrite-patterns.md
    └── limitations-and-policy.md
```

## Component Responsibilities / 组件职责

### `SKILL.md`

Use `SKILL.md` to define:

- When the skill should trigger
- The default workflow assistants should follow
- Which reference file to open for each kind of task
- When to use the shell script and when to use direct `curl`
- Output expectations: summarize key facts, give commands or edits, avoid dumping raw JSON unless useful

`SKILL.md` 不做大段 API 细节罗列，而是负责：

- 说明何时触发
- 规定默认工作流
- 指导不同任务读取哪份 reference
- 说明何时优先用脚本，何时直接 `curl`
- 约束输出方式：优先给结论、命令、改写片段，而不是直接倾倒 JSON

### `scripts/docker_mirror_api.sh`

The script should stay thin and deterministic. Its job is to standardize API access, not to replace assistant reasoning.

Responsibilities:

- Wrap the public endpoints with stable subcommands
- Validate required arguments
- Construct request URLs consistently
- Perform network requests with `curl`
- Return raw JSON on success
- Return non-zero exit codes and compact error messages on failures

Non-responsibilities:

- Deep JSON transformation
- Bulk config-file rewriting
- Policy interpretation
- High-level troubleshooting conclusions

### `references/api-reference.md`

Include:

- Endpoint list
- Query parameters
- Known response shapes
- Shell examples
- Guidance on which fields usually matter to end users

### `references/usage-and-troubleshooting.md`

Include:

- Add-image workflow summary from public docs
- Common failures documented or observed from error examples
- Pull/login/permission troubleshooting notes
- Guidance for when to recommend waiting, resubmitting, or changing platform/tag

### `references/rewrite-patterns.md`

Include:

- How to rewrite `docker pull` commands
- How to replace image references in `Dockerfile`
- How to update `docker-compose.yml`
- How to update Kubernetes manifests
- A conservative editing rule: only modify image-related content

### `references/limitations-and-policy.md`

Include:

- Supported registries
- Supported architectures
- Search result limit
- Authentication expectations
- Public usage policy and non-commercial constraint
- When not to recommend the mirror site

## Workflow / 工作流

The default assistant workflow should be:

1. Classify the user request as lookup, rewrite, troubleshooting, or site-status.
2. Query facts first when the answer depends on live data.
3. Open the smallest relevant reference file.
4. Produce an action-oriented answer: a usable command, a changed image reference, or a concise diagnosis.
5. Explicitly note uncertainty or policy limits when relevant.

默认工作流：

1. 先判断请求属于查询、改写、排障还是站点状态。
2. 只要答案依赖实时数据，就先查 API，不凭空猜。
3. 只读取当前任务最相关的 reference。
4. 输出时优先给可执行内容：命令、改写后的镜像地址、简短诊断。
5. 涉及不确定性或站点限制时，明确说明边界。

## Script Interface / 脚本接口设计

Proposed subcommands:

- `website`
- `health`
- `latest`
- `today`
- `wait`
- `error`
- `image <search> [site] [platform]`
- `email <address>`
- `ip`

Design rules:

- Require `bash`
- Depend on `curl`
- Avoid hard dependency on `jq`
- Preserve raw JSON by default for maximum portability
- Keep usage help short and clear

## Documentation Strategy / 文档策略

The repository should be bilingual.

Guidelines:

- Keep the trigger description in `SKILL.md` strong in English so general assistants can discover it
- Write the body content and references in bilingual form where practical
- Prefer concise paired sections over maintaining separate full copies of the same document

## Validation Criteria / 验收标准

The skill is successful when:

- Another assistant can understand when to trigger it by reading `SKILL.md`
- The shell script can successfully query the public endpoints
- The references are enough to guide conservative mirror rewrites
- The skill can explain common failure classes without inventing unsupported claims
- The repository remains small, readable, and open-source friendly

## Implementation Plan / 实施范围

The first implementation pass should create:

- `SKILL.md`
- `agents/openai.yaml`
- `scripts/docker_mirror_api.sh`
- The four reference documents

The first implementation pass should not add:

- Extra README-like files unless explicitly needed
- Language-specific SDKs
- Python or Node tooling
- Complex batch rewrite utilities
