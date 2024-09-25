FROM ghcr.io/actions/actions-runner:2.319.1

USER root

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
  curl \
  ca-certificates \
  zstd \
  gzip \
  tar \
  jq \
  git \
  zip \
  unzip \
  maven \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*

COPY --chown=runner:docker utils.sh entrypoint.sh /

USER runner

ENV RUNNER_WORKDIR=/home/runner/work

RUN mkdir -p ${RUNNER_WORKDIR}

ENTRYPOINT [ "/entrypoint.sh" ]