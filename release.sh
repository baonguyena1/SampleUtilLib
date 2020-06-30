#!/bin/sh

WORKSPACE="$( cd "$(dirname ${BASH_SOURCE[0]})" >/dev/null 2>& 1 && pwd )/"

SDK_VERSION=""
SDK_NAME="SampleUtilLib"
BUILD_CONFIGURATION="Release"
SOURCE_BRANCH="master"

function checkout_source() {
    echo "➡️ Checkout Source"
    cd $WORKSPACE
    git reset --hard
    git checkout master
    git fetch
    git pull
}

checkout_source