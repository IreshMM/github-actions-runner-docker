#!/usr/bin/env bash

# Construct registration URL for self-hosted runner
get_registration_token_endpoint() {
    if [[ "$RUNNER_SCOPE" == "ORG" ]]; then
        echo "https://api.github.com/orgs/${GITHUB_OWNER}/actions/runners/registration-token"
    elif [[ "$RUNNER_SCOPE" == "REPO" ]]; then
        echo "https://api.github.com/repos/${GITHUB_OWNER}/${GITHUB_REPO}/actions/runners/registration-token"
    else
        echo "Invalid RUNNER_SCOPE: $RUNNER_SCOPE" > /dev/null 1>&2
        exit 1
    fi
}

# Get registration token from GitHub
get_registration_token() {
    local token_url=$(get_registration_token_endpoint)
    local response=$(curl -s -X POST -H "X-GitHub-Api-Version: 2022-11-28" -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github+json" "$token_url")
    echo "$response" | jq -r .token
}

# Get the runner's owner URL
get_owner_url() {
    if [[ "$RUNNER_SCOPE" == "ORG" ]]; then
        echo "https://github.com/${GITHUB_OWNER}"
    elif [[ "$RUNNER_SCOPE" == "REPO" ]]; then
        echo "https://github.com/repos/${GITHUB_OWNER}/${GITHUB_REPO}"
    else
        echo "Invalid RUNNER_SCOPE: $RUNNER_SCOPE" > /dev/null 1>&2
        exit 1
    fi
}

# Wait for docker socket
wait_for_docker_socket() {
    local docker_socket=/var/run/docker.sock
    local count=0

    while [[ ! -S "${docker_socket}" ]]
    do
        echo "Waiting for ${docker_socket}"
        sleep 1

        count=$((count+1))
        if [[ ${count} -gt 60 ]]
        then
            echo "Timed out waiting for docker socket"
            exit 1
        fi
    done
}