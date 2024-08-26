# pre-commit in docker - fast GitHub Actions and GitLab CI!

[![Pipeline
Status](https://gitlab.com/winny/pre-commit-docker/badges/master/pipeline.svg)](https://gitlab.com/winny/pre-commit-docker/-/pipelines/?page=1&scope=all&ref=master)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit)](https://github.com/pre-commit/pre-commit)

Speed up pre-commit in your [GitHub Actions](#github-actions) and [GitLab
CI](#gitlab-ci) jobs.  Run pre-commit locally with [Docker](#docker)!  Read
more about the rationale in the [announcement blog post][announcement].

[announcement]: https://blog.winny.tech/posts/pre-commit-in-github-actions-gitlab-ci/

## <span id='docker'>Docker</span>

All Docker images are hosted at the [gitlab.com Container Registry][registry].

To run `pre-commit` against all files in the repository root (there should eist
a `.pre-commit-config.yaml`), try:

```sh
docker run -v "$PWD":/app registry.gitlab.com/winny/pre-commit-docker:latest
```

To get help:

```sh
docker run -v "$PWD":/app registry.gitlab.com/winny/pre-commit-docker:latest pre-commit --help
```

[registry]: https://gitlab.com/winny/pre-commit-docker/container_registry/3957810

### Image Tags

- `registry.gitlab.com/winny/pre-commit-docker:latest` - rebuilt weekly to for
  the latest Debian stable security updates

## <span id='github-actions'>GitHub Actions</span>

To use in GitHub Actions, create a workflow file in `.github/workflows`.  For
example create this file at `.github/workflows/pre-commit.yml`:

```yaml
name: Run pre-commit

on: push

jobs:
  pre-commit:
    runs-on: ubuntu-latest
    container:
      image: registry.gitlab.com/winny/pre-commit-docker:latest
      env:
        PRE_COMMIT_HOME: .pre-commit-cache
    steps:
      - uses: actions/checkout@v4
      - name: Allow workspace
        run: git config --global --add safe.directory "$GITHUB_WORKSPACE"
      - name: Cache .pre-commit-cache
        uses: actions/cache@v4
        with:
          path: |
            .pre-commit-cache
          key: ${{ runner.os }}-pre-commit-cache-${{ hashFiles('.pre-commit-config.yaml') }}
      - name: Run pre-commit
        run: pre-commit run -a
```


## <span id='gitlab-ci'>GitLab CI</span>

To use in GitLab CI add a job like the following to your `.gitlab-ci.yml`:

```yaml
pre-commit:
  stage: test
  image: registry.gitlab.com/winny/pre-commit-docker:latest
  variables:
    PRE_COMMIT_HOME: .pre-commit-cache
  cache:
    - key:
        files: [.pre-commit-config.yaml]
      paths: ['${PRE_COMMIT_HOME}']
  script:
    - pre-commit run -a
```


## Best Practices

See [pre-commit's official CI docs][pre-commit-official-ci-docs] for more
examples of pre-commit in CI.

Use a pre-built Docker image for CI jobs to cut down on initialization time.
Cache pre-commit's `PRE_COMMIT_HOME` in further eliminate initialization time.
The above GitHub Actions and GitLab CI YAML snippets achieve both of these best
practices.

[pre-commit-official-ci-docs]: https://pre-commit.com/#usage-in-continuous-integration

## pre-commit-docker compared to other pre-commit CI solutions

Here is a comparison of a few solutions for pre-commit in CI:

| Feature                               | [pre-commit-docker][pcd] | [vanilla pre-commit][vpc] | [action/pre-commit][apc] | [pre-commit.ci][pcc]             |
|---------------------------------------|--------------------------|---------------------------|--------------------------|----------------------------------|
| Official                              | ❌ No                    | ✅ Yes                    | ❌ No                    | ❌ No                            |
| Active development                    | ✅ Yes                   | ✅ Yes                    | ❌ No                    | ✅ Yes                           |
| Fast startup (without install script) | ✅ Yes                   | ❌ No                     | ❌ No                    | ❔ Unknown                       |
| Automatically commit changes in CI    | ❌ No                    | ❌ No                     | ❌ No                    | ✅ Yes                           |
| Runtime/CI environment                | Docker, GitHub, GitLab   | Any OS with Python        | GitHub                   | Many CI including GitHub, GitLab |
| Automatic caching                     | ✅ Yes with setup        | ✅ Yes with setup         | ✅ Yes                   | ✅ Yes                           |
| All source code auditable             | ✅ Yes                   | ✅ Yes                    | ✅ Yes                   | ❌ No                            |
| Free                                  | ✅ Yes                   | ✅ Yes                    | ✅ Yes                   | ❌ Only for public repositories  |

[pcd]: https://gitlab.com/winny/pre-commit-docker/container_registry/3957810
[vpc]: https://pre-commit.com/
[apc]: https://github.com/pre-commit/action
[pcc]: https://pre-commit.ci/

## License

MIT/X.  See [LICENSE](LICENSE).
