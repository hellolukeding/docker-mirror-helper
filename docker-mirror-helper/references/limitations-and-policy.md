# Limitations and Policy / 限制与使用边界

## Supported Registries / 支持的镜像源

Observed from the public API and homepage on 2026-04-23:

- `gcr.io`
- `ghcr.io`
- `quay.io`
- `k8s.gcr.io`
- `docker.io`
- `registry.k8s.io`
- `docker.elastic.co`
- `skywalking.docker.scarf.sh`
- `mcr.microsoft.com`
- `docker.n8n.io`

这些支持范围会变化，回答“当前支持哪些源站”时应优先实时查询 `website` 接口。

## Supported Architectures / 支持的架构

Observed from the public `website` API on 2026-04-23:

- `linux/386`
- `linux/amd64`
- `linux/arm64`
- `linux/arm`
- `linux/ppc64le`
- `linux/s390x`
- `linux/mips64le`
- `linux/riscv64`
- `linux/loong64`

这同样属于实时信息，必要时重新查询。

## Query and Result Limits / 查询与返回限制

- Public docs say the API currently does not require authentication.
- Public docs say there is no request-count limit.
- Public docs say `image` returns at most 50 results.
- Live counts such as queue size, total image count, and daily sync count are time-sensitive.

公开文档说明：

- 当前不需要鉴权
- 没有调用次数限制
- `image` 搜索最多返回 50 条
- 队列大小、总镜像数、今日同步数都是实时变化信息

## Usage Policy / 使用政策

Public docs state that the API is intended for:

- development
- ops testing
- technical/internal system integration

Public docs also state that commercial-for-profit use is prohibited.

公开文档说明该 API 适用于：

- 开发
- 运维测试
- 技术或内部系统集成

同时公开文档也明确禁止商业化盈利使用。

Do not soften or remove that policy in user-facing answers.

## Recommendation Boundaries / 推荐边界

Do not recommend the mirror site as a guaranteed universal replacement when:

- the image is not confirmed by the public API
- the required platform is unavailable
- the site policy would conflict with the user's intended commercial use
- the user's workflow requires guarantees the public docs do not provide

以下场景不要把镜像站描述成“通用且必然可行”的替代方案：

- API 还没确认该镜像存在
- 所需架构不可用
- 用户用途与公开政策冲突
- 用户需要站点并未承诺的稳定性或 SLA
