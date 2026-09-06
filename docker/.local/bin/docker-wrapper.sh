#!/bin/bash
# supports Docker & Podman in root or rootless mode.

set -Eeuo pipefail
DOCKER_IMAGE="${DOCKER_IMAGE:-hello-world}"
DOCKER_FLAGS="${DOCKER_FLAGS:-}"

function __docker() {
    if command -v docker >/dev/null; then
        docker "$@"
    elif command -v podman >/dev/null; then
        podman "$@"
    else
        >&2 echo "Docker not found"
        exit 127
    fi
}

function __hostname() {
    if command -v hostname >/dev/null; then
        hostname --fqdn
    else
        cat /proc/sys/kernel/hostname
    fi
}

function __docker_perm_test() {
    if __docker info >/dev/null; then
        return 0
    else
        return 126
    fi
}

function __docker_wait() {
    if __docker_perm_test; then
        return 0
    fi

    for i in $(seq 5);do
        echo "Waiting for Docker: #$i"
        if __docker_perm_test; then
            break
        fi
        sleep 1
    done
    
    return 126
}

function __docker_rootless_setup() {
    export XDG_RUNTIME_DIR="${HOME}/.docker/run"
    export DOCKER_HOST="unix://${HOME}/.docker/run/docker.sock"
    PATH=/usr/bin:/sbin:/usr/sbin:$PATH dockerd-rootless.sh &
    DOCKER_ROOTLESS_DAEMON_PID="$?"

    >&2 echo "Docker started"
}

function __docker_rootless_shutdown() {
    if [ -n "${DOCKER_ROOTLESS_DAEMON_PID+x}" ]; then
        >&2 echo "Stopping Docker daemon"
        kill "${DOCKER_ROOTLESS_DAEMON_PID}"
    fi
}

function __on_quit() {
    __docker_rootless_shutdown
}

trap __on_quit SIGINT SIGTERM EXIT # don't need to trap on ERR since EXIT will be executed anyway

if ! __docker_perm_test; then
    if command -v dockerd-rootless.sh >/dev/null 2>&1; then
        # docker rootless mode is installed but not started
        >&2 echo "Trying to setup docker-rootless"
        __docker_rootless_setup
    else
        >&2 echo "Unable to execute Docker, please manually install Docker or Podman."
    fi
fi

__docker_wait

if [ -t 1 ]; then
    # output is a terminal
    DOCKER_FLAGS_AUX="-it"
else
    DOCKER_FLAGS_AUX=""
fi

cd "$( dirname "${BASH_SOURCE[0]}" )" || exit 126
# shellcheck disable=SC2086
__docker run --rm ${DOCKER_FLAGS} ${DOCKER_FLAGS_AUX} \
    -v "$(pwd):/root" \
    --hostname "$(__hostname)" \
    ${DOCKER_IMAGE} \
    "$@"
