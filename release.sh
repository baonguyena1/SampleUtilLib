#!/bin/sh
set -e
underline=$(tput smul)
nounderline=$(tput rmul)

WORKSPACE="$( cd "$(dirname ${BASH_SOURCE[0]})" >/dev/null 2>& 1 && pwd )/"

SDK_VERSION=""
SDK_NAME="SampleUtilLib"
BUILD_CONFIGURATION="Release"
SOURCE_BRANCH="master"

function checkout_source() {
    echo "➡️ Checkout Source"
    cd $WORKSPACE
    git reset --hard
    git checkout $SOURCE_BRANCH
    git fetch
    git pull
}

function usage() {
    cat <<EOF
$(underline)Usage: $0 options

$(underline)options:
    -v  SDK version (require).
EOF
}

function check_commands() {
    while getopts v: option
    do
    case "$option"
    in
    v) SDK_VERSION=$(OPTARG);;
    esac
    done
    if [ "${SDK_VERSION}" == "" ]; then
        usage
        exit 1
    fi
}

check_commands
checkout_source