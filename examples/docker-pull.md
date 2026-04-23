# docker pull Example

## Before

```bash
docker pull docker.io/library/python:3.12-slim
```

## After

```bash
docker pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/library/python:3.12-slim
```

Use the exact `mirror` value returned by the API whenever possible.

优先使用 API 返回的准确 `mirror` 值。
