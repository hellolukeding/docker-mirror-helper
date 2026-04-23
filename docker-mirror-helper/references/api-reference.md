# API Reference / API 参考

## Overview / 概览

This skill works against the public API documented at `https://docker.aityp.com/manage/api`.

这个 skill 使用 `https://docker.aityp.com/manage/api` 公开列出的接口。

Base API prefix:

```text
https://docker.aityp.com/api/v1
```

## Endpoints / 接口列表

Static-style endpoints:

- `GET /latest`
- `GET /website`
- `GET /wait`
- `GET /today`
- `GET /error`
- `GET /health`
- `GET /ip`

Parameterized endpoints:

- `GET /email/{email}`
- `GET /image?search=...`

## Image Search / 镜像搜索

Endpoint:

```text
GET /image?search=<query>[&site=<site>][&platform=<platform>]
```

Known parameters:

- `search`
  - required
  - supports fuzzy matching
- `site`
  - optional
  - examples from public docs: `docker.io`, `ghcr.io`, `quay.io`, `All`
- `platform`
  - optional
  - examples: `linux/amd64`, `linux/arm64`, `All`

Public docs say the endpoint returns at most 50 records.

公开文档说明搜索接口最多返回 50 条。

## Observed Response Shapes / 已观察到的返回结构

Many list/search endpoints return this general shape:

```json
{
  "count": 20,
  "error": false,
  "results": []
}
```

Observed fields inside `results` for successful image lookups:

- `source`
- `mirror`
- `platform`
- `size`
- `createdAt`

Observed fields inside `results` for error samples:

- `source`
- `platform`
- `error`
- `createdAt`

Special endpoints:

- `website`
  - returns site counts plus `supported_site` and `supported_arch`
- `health`
  - returns a numeric `status`
- `ip`
  - returns `ClientIp` and `RealIp`

## Shell Examples / Shell 示例

```bash
curl -sS https://docker.aityp.com/api/v1/website
curl -sS https://docker.aityp.com/api/v1/health
curl -sS 'https://docker.aityp.com/api/v1/image?search=python&site=docker.io&platform=linux/amd64'
curl -sS https://docker.aityp.com/api/v1/error
curl -sS https://docker.aityp.com/api/v1/ip
```

Bundled helper examples:

```bash
bash scripts/docker_mirror_api.sh website
bash scripts/docker_mirror_api.sh image 'python:3.12-slim' docker.io linux/amd64
bash scripts/docker_mirror_api.sh error
```

## How To Summarize Results / 如何提炼结果

For most user-facing answers, prefer:

- exact `mirror` image address
- matching `platform`
- `size`
- `createdAt`

For site-level questions, prefer:

- supported registries
- supported architectures
- health status
- queue count or latest sync count when relevant

面向用户输出时，优先提炼这些字段：

- 准确的 `mirror` 地址
- 对应 `platform`
- `size`
- `createdAt`

站点级问题则优先提炼：

- 支持的镜像源
- 支持的架构
- 健康状态
- 等待数量或最近同步情况
