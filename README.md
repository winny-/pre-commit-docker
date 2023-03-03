# pre-commit in docker!

![Pipeline Status](https://gitlab.com/winny/pre-commit-docker/badges/master/pipeline.svg)

I had success using `debian:bullseye` directly.  Builds seemed to take a little
bit longer than usual, so I created this docker image (and CI how-to notes) for
self-consumption.  If you like this that's cool too!  Contributions welcome.

## Image tags

- `registry.gitlab.com/winny/pre-commit-docker:latest`

This image is built every time the master branch is pushed.

## Use in GitLab CI

To use in GitLab CI add a job like the following to your `.gitlab-ci.yml`:

```yaml
precommit:
  stage: test
  image: registry.gitlab.com/winny/pre-commit-docker:latest
  variables:
    PRE_COMMIT_HOME: .pre-commit-cache
  cache:
    - key:
        files: [.pre-commit-config.yaml]
      paths: [.pre-commit-cache]
  script:
    - pre-commit run -a
```

This will cache your pre-commit environments between builds, so CI jobs should
be fast and successful!

## License

MIT/X.  See [LICENSE](LICENSE).
