#!/bin/bash
set -e
set -o pipefail

_here=`dirname $(realpath $0)`
apt_sync="${_here}/apt-sync.py"

ARCH="all,amd64,arm64,riscv64"
VERSION="stable"
BASE_URL="${TUNASYNC_UPSTREAM_URL:-https://pkgs.tailscale.com}/${VERSION}"
BASE_PATH="${TUNASYNC_WORKING_DIR}/${VERSION}"

# refer to https://github.com/tuna/tunasync-scripts/blob/c2051ee938594b22423f6d18e92690c9b11763fa/apt-sync.py#L31
# currently, "@ubuntu-lts" = "focal,jammy,nobel"
UBUNTU_CODENAME="@ubuntu-lts"
# currently, "@debian-current" = "bullseye,bookworm"
DEBIAN_CODENAME="@debian-current"

# Ubuntu
"$apt_sync" --delete "${BASE_URL}/ubuntu" ${UBUNTU_CODENAME} main ${ARCH} "${BASE_PATH}/ubuntu"
echo "Ubuntu finished"

# Debian
"$apt_sync" --delete "${BASE_URL}/debian" ${DEBIAN_CODENAME} main ${ARCH} "${BASE_PATH}/debian"
echo "Debian finished"

# Done
echo "Tailscale finished"
