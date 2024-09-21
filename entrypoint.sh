#!/usr/bin/env bash

source /utils.sh

export RUNNER_TOKEN=$(get_registration_token)
echo "Runner token: ${RUNNER_TOKEN}"
export OWNER_URL=$(get_owner_url)
echo "Owner URL: ${OWNER_URL}"

./config.sh \
    --name "$(hostname)" \
    --token "${RUNNER_TOKEN}" \
    --labels "${RUNNER_LABELS}" \
    --url "${OWNER_URL}" \
    --work "${RUNNER_WORKDIR}" \
    --unattended \
    --replace

remove() {
    ./config.sh remove --unattended --token "${RUNNER_TOKEN}"
}

trap 'remove; exit 130' INT
trap 'remove; exit 143' TERM

wait_for_docker_socket

./run.sh "$*" &

wait $!