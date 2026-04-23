# Rewrite Patterns / 改写模式

## Principle / 原则

Prefer the exact `mirror` field returned by the API over manually constructing a mirror address.

优先使用 API 返回的准确 `mirror` 字段，不要自己手工拼接最终镜像地址。

Why:

- exact API results may include platform-specific naming details
- some mirrored results differ from a simple prefix substitution
- using the API avoids overconfident rewrites

原因：

- API 结果可能包含平台相关的命名细节
- 有些镜像并不是简单前缀替换就能得到最终地址
- 用 API 能降低误改风险

## Docker Pull / docker pull

Preferred workflow:

1. Query the image with the desired platform if known.
2. Use the returned `mirror` value directly.

Example:

```text
source: docker.io/library/python:3.12-slim
mirror: swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/python:3.12-slim
```

Rewrite:

```bash
docker pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/python:3.12-slim
```

## Dockerfile

Public articles show Dockerfile acceleration examples using mirrored images such as:

```dockerfile
FROM swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/library/golang:1.22.5 AS builder
FROM swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/alpine:3.14
```

Rewrite only `FROM` lines or ARG-derived image references that clearly point to upstream images.

只改 `FROM` 行，或明确作为镜像地址使用的变量值。

Conservative pattern:

```dockerfile
FROM python:3.12-slim
```

becomes:

```dockerfile
FROM swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/python:3.12-slim
```

Use the exact API-confirmed mirror when possible. Preserve stage aliases such as `AS builder`.

## Compose

Change only `image:` values.

Example:

```yaml
services:
  app:
    image: docker.io/library/nginx:1.27
```

becomes:

```yaml
services:
  app:
    image: swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/library/nginx:1.27
```

Do not rewrite unrelated fields such as ports, volumes, or environment variables.

## Kubernetes

Change only container image fields.

Example:

```yaml
containers:
  - name: api
    image: docker.io/library/redis:7.2
```

becomes:

```yaml
containers:
  - name: api
    image: swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/library/redis:7.2
```

Keep:

- container names
- probes
- resources
- commands
- annotations

## Fallback Guidance / 回退策略

If the API does not confirm a mirror:

- do not invent a final mirror image address
- explain that the image is not currently confirmed by the public API
- suggest searching again with an exact name, different site, or different platform
- suggest submitting the image for sync when appropriate

如果 API 没有确认镜像：

- 不要编造最终镜像地址
- 明确说明公开 API 还没有确认该镜像
- 建议换成精确镜像名、不同源站或不同平台重查
- 合适时建议提交同步
