# Contributing | 贡献指南

Thanks for your interest in improving `docker-mirror-helper`.

感谢你对 `docker-mirror-helper` 的关注与改进。

## Scope | 贡献范围

Good contributions for this repository include:

适合本仓库的贡献包括：

- improving `SKILL.md` trigger quality and workflow clarity
- refining bilingual references and examples
- improving the shell helper without making it heavy
- fixing documentation mistakes or outdated API notes
- improving validation and CI

- 提升 `SKILL.md` 的触发质量和工作流清晰度
- 优化中英双语参考文档和示例
- 改进 shell helper，但不要把它做重
- 修正文档错误或过期的 API 说明
- 改进校验脚本和 CI

## Design Principles | 设计原则

Please try to preserve these project principles:

请尽量保持以下项目原则：

- shell-first
- lightweight
- bilingual
- easy for AI assistants to reuse
- conservative about claims when live API data is missing

- 纯 shell 优先
- 保持轻量
- 中英双语
- 便于 AI 助手复用
- 当缺少实时 API 证据时，结论要保守

## Local Validation | 本地验证

Before opening a pull request, run:

提交 PR 之前，建议先运行：

```bash
bash scripts/validate.sh
```

If you have additional local tooling, feel free to run extra checks such as shell formatting or linting as long as they do not change the project’s lightweight direction.

如果你本地有额外工具，也可以运行更多检查，例如 shell 格式化或 lint，但请不要因此把项目带向重型依赖。

## Pull Requests | Pull Request 建议

Please keep pull requests focused and easy to review.

请尽量让 PR 聚焦且易于 review。

Helpful PRs usually:

高质量 PR 一般会做到：

- describe the problem clearly
- explain the chosen approach briefly
- mention whether API behavior was validated live
- include updated examples or docs when behavior changes

- 清楚说明问题是什么
- 简短解释采取的方案
- 标明是否基于实时 API 验证过行为
- 如果行为变化，顺手更新示例和文档

## Documentation Contributions | 文档贡献

For documentation changes:

对于文档改动：

- keep English and Chinese sections aligned
- avoid product-specific assumptions unless clearly marked
- prefer practical examples over abstract explanation

- 保持中英文内容基本对齐
- 不要默认某个单一 AI 产品环境，除非明确标注
- 优先提供实用例子，不要只有抽象解释

## Issues | 提交问题

If you find a bug or want a new feature, please use the GitHub issue templates included in this repository.

如果你发现 bug 或希望增加功能，请优先使用仓库内置的 GitHub issue 模板。
