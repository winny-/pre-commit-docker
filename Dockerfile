FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends git pre-commit \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN git config --global --add safe.directory /app

CMD ["pre-commit", "run", "-a"]
