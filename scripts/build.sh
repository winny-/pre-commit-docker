#!/bin/sh
set -eu

# This builds from cache.
docker pull registry.gitlab.com/winny/pre-commit-docker || :
docker build \
       --cache-from registry.gitlab.com/winny/pre-commit-docker \
       -t registry.gitlab.com/winny/pre-commit-docker .
