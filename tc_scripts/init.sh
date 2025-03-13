#!/usr/bin/env bash
# ---- Clang Build Scripts ----
# Copyright (C) 2023-2024 fadlyas07 <mhmmdfdlyas@proton.me>

# Working directory
export DIR="$(pwd)"

# Specify the build flags for the scripts
if [[ "${1}" == final ]]; then
    export build_flags="--final"
elif ! [[ "${1}" == profile || "${1}" == final ]]; then
    echo "You need to set the correct arguments!"
    exit 1
fi

# Setup GitHub config and hooks
mkdir -p ~/.git/hooks
git config --global user.name "${GH_USER}"
git config --global user.email "${GH_EMAIL}"
git config --global core.hooksPath ~/.git/hooks
curl -s -Lo ~/.git/hooks/commit-msg https://review.lineageos.org/tools/hooks/commit-msg
chmod u+x ~/.git/hooks/commit-msg

# Export common environment variables
export PATH="/usr/bin/core_perl:${PATH}"
export release_tag="$(date +'%d%m%Y')"     # "{date}{month}{year}" format
export release_date="$(date +'%-d %B %Y')" # "Day Month Year" format
export install_path="${DIR}/install"
export glibc_version="$(ldd --version | head -n1 | grep -oE '[^ ]+$')"

# Execute the build scripts
./tc_scripts/build.sh "${1}"
