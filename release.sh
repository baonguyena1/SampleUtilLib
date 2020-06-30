#!/bin/sh

# 1
# Set bash script to exit immediately if any commands fail.
set -e

# 2
# Setup some constants for use later on.
PREFIX="➡️    "
WORKSPACE="$( cd "$(dirname ${BASH_SOURCE[0]})" >/dev/null 2>& 1 && pwd )"
SDK_VERSION=""
SDK_NAME="SampleUtilLib"
BUILD_CONFIGURATION="Release"
SOURCE_BRANCH="master"

function checkout_source() {
    echo "${PREFIX}Checkout Source"
    cd $WORKSPACE
    git reset --hard
    git checkout $SOURCE_BRANCH
    git fetch
    git pull
}

function build_sdk() {
    echo "${PREFIX}INFO: Build: ${SDK_NAME}, Branch: ${SOURCE_BRANCH}, Version: ${SDK_VERSION}"
    cd $WORKSPACE

    # 3
    # If remnants from a previous build exist, delete them.
    BUILD_DIR="BUILD_COMMAND_LINE"
    DERIVED_DATA_DIR="${BUILD_DIR}/DerivedData"
    if [ -d "${BUILD_DIR}" ]; then
        echo "${PREFIX}Remove build command line folder"
        rm -rf "${BUILD_DIR}"
    fi
    mkdir -p $DERIVED_DATA_DIR

    # 4
    # Build the framework for device and for simulator (using
    # all needed architectures).
    xcodebuild -target "${SDK_NAME}" \
                -scheme "${SDK_NAME}" \
                -configuration "${BUILD_CONFIGURATION}" \
                -arch arm64 \
                only_active_arch=no defines_module=yes \
                -sdk "iphoneos" \
                -derivedDataPath ${DERIVED_DATA_DIR} \
                >/dev/null 2>&1
    xcodebuild -target "${SDK_NAME}" \
                -scheme "${SDK_NAME}" \
                -configuration "${BUILD_CONFIGURATION}" \
                only_active_arch=no defines_module=yes \
                -sdk "iphonesimulator" \
                -derivedDataPath ${DERIVED_DATA_DIR} \
                >/dev/null 2>&1

    BUILD_FOLDER="build"
    # 5
    # Remove .framework file if exists on Build folder from previous run.  
    if [ -d "${BUILD_FOLDER}" ]; then
        echo "${PREFIX}Remove build folder"
        rm -rf "${BUILD_FOLDER}"
    fi  
    mkdir -p $BUILD_FOLDER

    # 6
    # Copy the device version of framework to Build folder.
    cp -r "${DERIVED_DATA_DIR}/build/Products/Release-iphoneos/${SDK_NAME}.framework" "${WORKSPACE}/${BUILD_FOLDER}/${SDK_NAME}.framework"
    
    # 7
    # Replace the framework executable within the framework with
    # a new version created by merging the device and simulator
    # frameworks' executables with lipo.
    lipo -create -output "${WORKSPACE}/${BUILD_FOLDER}/${SDK_NAME}.framework/${SDK_NAME}" \
        "${DERIVED_DATA_DIR}/build/Products/Release-iphoneos/${SDK_NAME}.framework/${SDK_NAME}" \
        "${DERIVED_DATA_DIR}/build/Products/Release-iphonesimulator/${SDK_NAME}.framework/${SDK_NAME}"

    # 8
    # Copy the Swift module mappings for the simulator into the 
    # framework.  The device mappings already exist from step 6.
    cp -r "${DERIVED_DATA_DIR}/build/Products/Release-iphonesimulator/${SDK_NAME}.framework/Modules/${SDK_NAME}.swiftmodule/" "${WORKSPACE}/${BUILD_FOLDER}/${SDK_NAME}.framework/Modules/${SDK_NAME}.swiftmodule"

    #dSYM
    # 9
    # Copy the device version of dSYM to Build folder.
    cp -r "${DERIVED_DATA_DIR}/build/Products/Release-iphoneos/${SDK_NAME}.framework.dSYM" "${WORKSPACE}/${BUILD_FOLDER}/${SDK_NAME}.framework.dSYM"

    lipo -create -output "${DERIVED_DATA_DIR}/build/Products/Release-iphoneos/${SDK_NAME}.framework.dSYM/Contents/Resources/DWARF/${SDK_NAME}" \
        "${DERIVED_DATA_DIR}/build/Products/Release-iphoneos/${SDK_NAME}.framework.dSYM/Contents/Resources/DWARF/${SDK_NAME}" \
        "${DERIVED_DATA_DIR}/build/Products/Release-iphonesimulator/${SDK_NAME}.framework.dSYM/Contents/Resources/DWARF/${SDK_NAME}"

    # Create the modulemap file
    cd "${WORKSPACE}/${BUILD_FOLDER}"

    echo "${PREFIX}zip framework"
    zip -r "${SDK_NAME}.zip" ${SDK_NAME}.framework ${SDK_NAME}.framework.dSYM > /dev/null 2>&1
}   

function usage() {
    cat <<EOF
Usage: $0 options

options:
    -v  SDK version (require).

EOF
}

# Get version
while getopts v: arg; do
    case $arg in
    v)  SDK_VERSION=$OPTARG ;;
    esac
done

if [ "${SDK_VERSION}" == "" ]; then
    usage
    exit 1
fi

# checkout_source

build_sdk