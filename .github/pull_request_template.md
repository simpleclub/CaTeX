## Description

*A clear and concise description of what your PR accomplishes.*

## Related issues & PRs

*Links to issues and PRs that are related to your PR. Use [keywords] for issues if applicable.*

[keywords]: https://docs.github.com/en/github/managing-your-work-on-github/linking-a-pull-request-to-an-issue#linking-a-pull-request-to-an-issue-using-a-keyword

## Checklist

*Remove `If [...]` items that do not apply to your PR.*

- [x] I have made myself familiar with the CaTeX
      [contributing guide](https://github.com/simpleclub/CaTeX/blob/master/CONTRIBUTING.md).
- [ ] I added a PR description.
- [ ] I linked all related issues and PRs I could find (no links if there are none).
- [ ] If this PR changes anything about the main `catex` or `example` package (also README etc.),
      I created an entry in `CHANGELOG.md` (`## UPCOMING RELEASE` if the change on its own
      is not worth an update).
- [ ] If this PR includes a notable change in the `catex` package, I updated the version according
      to [Dart's semantic versioning](https://dart.dev/tools/pub/versioning#semantic-versions).
- [ ] If this PR adds new functions, I updated the `function_prioritization.csv` file.
- [ ] If there is new functionality in code, I added tests covering all my additions
      (Golden tests for anything rendering related).
- [ ] All required checks pass.
