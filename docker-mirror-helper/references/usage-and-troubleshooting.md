# Usage and Troubleshooting / 使用与排障

## Add Image Flow / 添加镜像流程

Public docs describe this basic workflow:

1. Open the add-image page from the site.
2. Submit the image that needs to be mirrored.
3. For Docker Hub images, include the registry prefix such as `docker.io/...`.
4. Choose a notification email and complete the verification step.
5. Wait for sync completion.

公开文档描述的基础流程是：

1. 打开站点的“添加镜像”页面。
2. 提交需要同步的镜像。
3. 对于 Docker Hub 镜像，带上 `docker.io/...` 这类源站前缀。
4. 选择通知邮箱并完成验证。
5. 等待同步完成。

One public article says the site will sync within 24 hours after submission. Queue timing on the site may still vary, so present it as documented guidance rather than a guaranteed SLA.

有文章写明提交后会在 24 小时内同步完成，但这应被表述为公开文档里的说明，而不是强保证。

## Common Failure Classes / 常见失败分类

Observed from public docs and live error samples:

- `镜像名称错误或Tag版本不存在`
  - likely wrong image path or nonexistent tag
- `镜像所指定架构版本不存在`
  - likely the image exists, but not for the requested platform
- `拉取权限错误`
  - likely upstream permission restriction or mirror pull permission issue

可作为常见错误分类：

- `镜像名称错误或Tag版本不存在`
- `镜像所指定架构版本不存在`
- `拉取权限错误`

## Troubleshooting Rules / 排障规则

When the user reports a failure:

1. Check whether the exact image exists in `image` search results.
2. Check whether the requested platform appears in successful matches.
3. Check recent `error` samples for the same or similar image.
4. Compare the user's source image name with the mirrored `source` field.
5. If the image is not confirmed by the API, say that the mirror is not currently confirmed.

用户报告失败时，按这个顺序排查：

1. 先查 `image` 接口里有没有这个精确镜像。
2. 再看目标平台是否存在成功匹配。
3. 再看 `error` 接口里有没有同类镜像的最近失败样本。
4. 对比用户提供的镜像名和 API 里的 `source` 字段是否一致。
5. 如果 API 不能确认镜像存在，就明确说明当前还不能确认它已同步。

## Pull/Login Issues / 拉取与登录问题

Public docs mention a specific case where a pull may ask for login because of a Huawei Cloud permission setting issue. The documented fix is to use the site's "repair permission" action and retry.

公开文档提到过一个场景：由于华为云权限设置问题，拉取时可能提示需要登录。文档给出的处理方式是在页面上点击“修复权限”后再重试。

If the user reports a generic login failure, do not assume all login problems are the same root cause. Use the documented Huawei-cloud permission case only when it actually matches the symptom.

如果用户只是泛泛说“登录失败”，不要默认都是同一个原因。只有当症状与公开文档中的华为云权限问题接近时，才引用这个修复建议。

## When To Recommend Waiting / 何时建议等待

Recommend waiting when:

- the image was recently submitted for sync
- the queue or latest-sync endpoints show recent activity but no exact image yet
- the image name looks valid but the mirror is not confirmed yet

建议等待的场景：

- 镜像刚提交同步
- 队列或最新同步接口显示站点仍在处理，但还没出现目标镜像
- 镜像名看起来有效，但还没有从 API 确认镜像已就绪

## When To Recommend Edits / 何时建议修改请求

Recommend changing the request when:

- the tag appears invalid
- the requested architecture is unavailable
- the image name omits the registry prefix and the site expects it

建议修改请求的场景：

- tag 看起来不存在
- 指定架构不可用
- 漏掉了镜像源前缀，而站点需要完整镜像名
