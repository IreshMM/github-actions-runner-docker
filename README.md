# GitHub Actions Runner Docker Image

FROM official upstream K8S ARC `ghcr.io/actions/actions-runner` image. Adds utilities so actions actually work. Adds an entrypoint for use with `docker run` and `docker compose`. This is a fork of the [actions-runner](https://github.com/mobilecoinofficial/gha-runner) and work is also based on [marcel-dempers-guide](https://github.com/marcel-dempers/docker-development-youtube-series/tree/master/github/actions/self-hosted-runner).

Adds the following packages to the base image.

```
curl
ca-certificates
zstd
gzip
tar
jq
git
zip
unzip
```

# How to use
### Docker Compose

```yaml
services:
  runner:
    image: docker.io/ireshmm/gha-runner:latest
    env_file:
      - .env
    environment:
      - ACTIONS_RUNNER_PRINT_LOG_TO_STDOUT=0
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:rw
    group_add:
      - 988 # Make sure to change this to the group id of the docker group on your host
    deploy:
      mode: replicated
      replicas: 1
```

#### .env file
```bash
RUNNER_SCOPE= # ORG or REPO
GITHUB_OWNER= # ORG or USER
GITHUB_REPO= # REPO if RUNNER_SCOPE=REPO
GITHUB_TOKEN= # Access token for obtaining runner registration token
RUNNER_LABELS= # Labels for the runner, comma separated
```