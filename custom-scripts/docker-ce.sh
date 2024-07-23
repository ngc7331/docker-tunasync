#!/bin/bash
# Used for apt-based distros only, for mac/windows/other distros, please refer to https://github.com/tuna/tunasync-scripts/blob/master/docker-ce.py
set -e
set -o pipefail

_here=`dirname $(realpath $0)`
apt_sync="${_here}/apt-sync.py"

ARCH="amd64,arm64"
VERSION="stable"
BASE_URL="${TUNASYNC_UPSTREAM_URL:-https://download.docker.com}/linux"
BASE_PATH="${TUNASYNC_WORKING_DIR}/linux"

# refer to https://github.com/tuna/tunasync-scripts/blob/c2051ee938594b22423f6d18e92690c9b11763fa/apt-sync.py#L31
# currently, "@ubuntu-lts" = "focal,jammy,nobel"
UBUNTU_CODENAME="@ubuntu-lts"
# currently, "@debian-current" = "bullseye,bookworm"
DEBIAN_CODENAME="@debian-current"
# and raspbian shares the same codename with debian
RASPBIAN_CODENAME="@debian-current"

# Ubuntu
"$apt_sync" --delete "${BASE_URL}/ubuntu" ${UBUNTU_CODENAME} ${VERSION} ${ARCH} "${BASE_PATH}/ubuntu"
echo "Ubuntu finished"

# Debian
"$apt_sync" --delete "${BASE_URL}/debian" ${DEBIAN_CODENAME} ${VERSION} ${ARCH} "${BASE_PATH}/debian"
echo "Debian finished"

# Raspbian
"$apt_sync" --delete "${BASE_URL}/raspbian" ${RASPBIAN_CODENAME} ${VERSION} ${ARCH} "${BASE_PATH}/raspbian"
echo "Raspbian finished"

# Done
echo "Docker-ce finished"
