---
name: docker-mirror-helper
description: Query, rewrite, and troubleshoot Docker image usage with the public docker.aityp.com mirror service. Use when an assistant needs to find whether an image has been mirrored, fetch a usable mirror address, check supported registries or platforms, rewrite docker pull commands or image references in Dockerfile/docker-compose/Kubernetes YAML, inspect mirror-site status, or explain likely pull and sync failures for mirrored images.
---

# Docker Mirror Helper

Use this skill to work with the public Docker mirror service at `docker.aityp.com`.

使用这个 skill 来处理 `docker.aityp.com` 的公开 Docker 镜像查询、镜像地址改写和常见排障。

## Quick Start

Use this skill when the user wants any of the following:

- Find a China-accessible mirror for a Docker image
- Check whether an image is already mirrored
- Rewrite `docker pull` commands or image references to use the mirror
- Update `Dockerfile`, `docker-compose.yml`, or Kubernetes manifests with mirrored images
- Check mirror-site health, supported registries, or supported architectures
- Explain likely mirror sync or pull failures

当用户想做下面这些事情时，使用这个 skill：

- 找某个镜像的国内可拉取镜像地址
- 检查镜像是否已经同步
- 把 `docker pull` 或镜像引用改写成镜像站版本
- 修改 `Dockerfile`、`docker-compose.yml`、Kubernetes 清单中的镜像地址
- 查询镜像站健康状态、支持的源站或架构
- 解释镜像同步或拉取失败原因

## Workflow

Follow this order unless the task is purely static documentation:

1. Classify the task as lookup, rewrite, troubleshooting, or site-status.
2. Query live facts first when the answer may have changed.
3. Read only the smallest relevant reference file.
4. Give an action-oriented answer: commands, updated image references, or a concise diagnosis.
5. State limits and uncertainty clearly when the site data does not fully answer the question.

按下面顺序执行，除非用户只是在问静态文档内容：

1. 先判断任务属于查询、改写、排障还是站点状态。
2. 只要答案可能随时间变化，就先查实时数据。
3. 只读取当前任务最相关的 reference。
4. 输出优先给可执行结果：命令、替换后的镜像地址、简洁诊断。
5. 当站点数据不能完全证明结论时，明确说明限制和不确定性。

## Shell Helper

Prefer the bundled shell helper for routine API access:

`scripts/docker_mirror_api.sh`

Use these subcommands:

- `website`
- `health`
- `latest`
- `today`
- `wait`
- `error`
- `image <search> [site] [platform]`
- `email <address>`
- `ip`

Examples:

```bash
bash scripts/docker_mirror_api.sh website
bash scripts/docker_mirror_api.sh image 'python:3.12-slim' docker.io linux/amd64
bash scripts/docker_mirror_api.sh error
bash scripts/docker_mirror_api.sh email 'user@example.com'
```

If the helper is unavailable or too limited for a special case, use direct `curl` against the public API.

优先使用内置 shell 脚本查询 API；如果脚本不适合特殊场景，再直接写 `curl`。

## Task Guide

### 1. Lookup

For questions like "is this image mirrored?" or "what is the mirror address?":

- Use `scripts/docker_mirror_api.sh image ...`
- Summarize `mirror`, `platform`, `size`, and `createdAt`
- If there are many matches, narrow by exact source, site, or platform
- If no result appears, say that the image is not currently confirmed by the API

处理“有没有这个镜像”“镜像地址是什么”这类问题时：

- 先用 `scripts/docker_mirror_api.sh image ...`
- 提炼 `mirror`、`platform`、`size`、`createdAt`
- 匹配过多时，用精确镜像名、源站、平台继续缩小范围
- 没结果时，说明当前 API 还不能确认该镜像已同步

### 2. Rewrite

For rewriting commands or config files:

- Prefer the exact `mirror` value returned by the API over hand-built guesses
- Edit only image-related content
- Preserve unrelated lines, comments, and formatting when possible
- If the API does not confirm a mirror, do not invent a final mirror URL

改写命令或配置文件时：

- 优先使用 API 返回的准确 `mirror` 字段，不要自己硬猜最终地址
- 只修改镜像相关内容
- 尽量保持无关行、注释和原有格式
- 如果 API 没确认镜像已同步，不要虚构最终镜像地址

Read `references/rewrite-patterns.md` before editing `Dockerfile`, Compose, or Kubernetes YAML.

### 3. Troubleshooting

For pull or sync failures:

- Check `error` for recent failure patterns
- Use documented site behavior from `references/usage-and-troubleshooting.md`
- Distinguish among at least these classes when supported by evidence:
  - missing tag or wrong image name
  - unsupported or unavailable architecture
  - permission or login-related issue
  - image not yet mirrored

排障时：

- 先看 `error` 接口中的最近失败样本
- 再结合 `references/usage-and-troubleshooting.md`
- 至少区分以下几类常见情况：
  - 镜像名错误或 tag 不存在
  - 架构不支持或该架构版本不存在
  - 权限或登录相关问题
  - 镜像尚未同步

### 4. Site Status and Limits

For questions about the site itself:

- Use `website`, `health`, `today`, `wait`, or `latest`
- Read `references/limitations-and-policy.md`
- Mention policy constraints when relevant, especially the public non-commercial limitation

查询站点本身时：

- 使用 `website`、`health`、`today`、`wait`、`latest`
- 参考 `references/limitations-and-policy.md`
- 涉及适用范围时，提示公开文档中的非商业限制

## References

Open only what the current task needs:

- `references/api-reference.md`
  - endpoints, parameters, response shapes, shell examples
- `references/usage-and-troubleshooting.md`
  - add-image flow, common failures, diagnosis hints
- `references/rewrite-patterns.md`
  - safe rewrite patterns for commands and config files
- `references/limitations-and-policy.md`
  - supported registries, supported platforms, query limits, policy boundaries

只打开当前任务最需要的 reference：

- `references/api-reference.md`
- `references/usage-and-troubleshooting.md`
- `references/rewrite-patterns.md`
- `references/limitations-and-policy.md`

## Output Rules

- Do not dump large raw JSON to the user unless they explicitly asked for it.
- Prefer short summaries plus concrete commands or edited snippets.
- Use absolute dates when the freshness matters.
- Treat live counts, health, queue size, and availability as time-sensitive facts that should be queried.
- Do not claim commercial permission for this API.

输出时遵循这些规则：

- 不要把大段原始 JSON 直接倒给用户，除非用户明确要求
- 优先给简短总结，加可执行命令或改写片段
- 涉及时效时，用明确日期
- 站点计数、健康、等待队列和可用性都属于实时信息，应先查询
- 不要把该 API 描述成允许商业化盈利使用

## Limits

- The public search endpoint returns at most 50 records.
- Public docs say the API does not currently require authentication.
- Public docs say the API is intended for development, ops testing, and internal technical usage.
- Public docs prohibit commercial-for-profit use.
- Use mirror-site data as operational evidence, not as a guarantee that every workflow will succeed everywhere.

限制说明：

- 搜索接口最多返回 50 条
- 公开文档显示当前不需要鉴权
- 公开文档说明主要用于开发、运维测试和内部技术使用
- 公开文档禁止商业化盈利使用
- 站点数据适合作为运维事实依据，但不等于任何环境都一定成功
