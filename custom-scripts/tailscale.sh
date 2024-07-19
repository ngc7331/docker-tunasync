#!/bin/bash
set -e
set -o pipefail

_here=`dirname $(realpath $0)`
apt_sync="${_here}/apt-sync.py"

ARCH="amd64,arm64,riscv64"
VERSION="stable"
BASE_URL="${TUNASYNC_UPSTREAM_URL:-https://pkgs.tailscale.com}/${VERSION}"
BASE_PATH="${TUNASYNC_WORKING_DIR}/${VERSION}"

# Ubuntu
"$apt_sync" --delete "${BASE_URL}/ubuntu" @ubuntu-lts main ${ARCH} "${BASE_PATH}/ubuntu"
echo "Ubuntu finished"

# Debian
"$apt_sync" --delete "${BASE_URL}/debian" @debian-current main ${ARCH} "${BASE_PATH}/debian"
echo "Debian finished"

# Done
echo "Tailscale finished"
