#!/bin/bash

# Find absolute path (that works on both macOS and Linux)
TOOLCHAIN_ROOT=$(dirname ${BASH_SOURCE[0]})
cd $TOOLCHAIN_ROOT
TOOLCHAIN_ROOT=$(pwd -P)
cd -

function xcode_setup() {

    sdk="$1"
    xcode=$(xcode-select -p)
    echo "Xcode is currently pointing to: '$xcode'"
    echo ""

    echo "Building TeamTalk toolchain has currently only been tested on Xcode 12.2."
    echo "It is therefore recommended to download Xcode 12.2 from Apple and change"
    echo "default Xcode to point to downloaded Xcode."
    echo ""
    echo "To change default Xcode run 'sudo xcode-select -s TOOLCHAIN_ROOT/Xcode.app/Contents/Developer'"
    echo "where TOOLCHAIN_ROOT is the location of Xcode.app."
    echo "To switch back run 'sudo xcode-select -s /Applications/Xcode.app/Contents/Developer'"
}

function mac64() {
    echo "### Setting TeamTalk Toolchain up for Mac OS x86_64 ###"

    TTLIBS_ROOT=$TOOLCHAIN_ROOT
    SDK=$(xcode-select -p)/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
    
    export SDK
    echo "Exporting SDK environment variable. This is required by build ACE."
    echo "TeamTalk toolchain will use $SDK"
}

function ios_common() {

    xcode_setup
    
    export IPHONE_VERSION=14.2 #compilation requires this

    if [ -z "$1" ]; then
        echo "1 = i386, 2 = x86_64, 3 = armv7, 4 = arm64"
        read arch

        case "$arch" in
            "1")
                arch=i386
                ;;
            "2")
                arch=x86_64
                ;;
            "3")
                arch=armv7
                ;;
            "4")
                arch=arm64
                ;;
            *)
                echo "Unknown arch"
                return 1
                ;;
        esac
        
    else
        arch=$1
    fi

    case "$arch" in
        "i386")
            ios_i386
            ios_export
            ;;
        "x86_64")
            ios_x86_64
            ios_export
            ;;
        "armv7")
            ios_armv7
            ios_export
            ;;
        "arm64")
            ios_arm64
            ios_export
            ;;
        *)
            echo "Unknown arch"
            return 1
            ;;
    esac
}

function ios_armv7() {
    echo "### Setting TeamTalk up for iOS armv7 ###"

    export IPHONE_TARGET=HARDWARE
    export ARCH=armv7
    
    SDK=$(xcode-select -p)/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk
    
    export SDK
}

function ios_arm64() {
    echo "### Setting TeamTalk up for iOS arm64 ###"

    export IPHONE_TARGET=HARDWARE
    export ARCH=arm64

    SDK=$(xcode-select -p)/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk
    
    export SDK
}

function ios_i386() {
    echo "### Setting TeamTalk up for iOS Simulator i386 ###"

    export IPHONE_TARGET=SIMULATOR

    export ARCH=i386
    SDK=$(xcode-select -p)/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk
    
    export SDK
}

function ios_x86_64() {
    echo "### Setting TeamTalk up for iOS Simulator x86_64 ###"

    export IPHONE_TARGET=SIMULATOR

    export ARCH=x86_64

    SDK=$(xcode-select -p)/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk
    
    export SDK
}

function ios_export() {

    TTLIBS_ROOT=$TOOLCHAIN_ROOT/$ARCH

    export CC="clang"

    if [ "$IPHONE_TARGET" = "SIMULATOR" ]; then
        export CFLAGS=" -arch $ARCH -isysroot $SDK -mios-simulator-version-min=7.0"
    else
        export CFLAGS=" -arch $ARCH -isysroot $SDK -miphoneos-version-min=7.0 -fembed-bitcode"
    fi
    export CXX="$CC"
    export CXXFLAGS=$CFLAGS
    export LD="$CC"
    export LDFLAGS=$CFLAGS

    echo "Exporting SDK environment variable. This is required by build ACE."
    echo "TeamTalk toolchain will use $SDK"
}

function linux() {
    echo "### Setting TeamTalk Toolchain up for Linux ###"

    TTLIBS_ROOT=$TOOLCHAIN_ROOT
}

function android() {

    if [ -z "$1" ]; then
        echo "1 = armeabi-v7a, 2 = arm64-v8a, 3 = x86, 4 = x86_64"
        read arch

        case "$arch" in
            "1")
                arch=armeabi-v7a
                ;;
            "2")
                arch=arm64-v8a
                ;;
            "3")
                arch=x86
                ;;
            "4")
                arch=x86_64
                ;;
            *)
                echo "Unknown selection"
                return 1
                ;;
        esac
    else
        arch=$1
    fi

    NDK=$TOOLCHAIN_ROOT/android-ndk-r21

    if ! test -d "$NDK"; then
        echo "Android NDK r21 not found. Must be placed in $NDK"
        return 1
    fi
    
    ANDROID_APP_PLATFORM=android-21
    ANDROID_APP_STL=c++_static

    if [ "Darwin" = `uname -s` ]; then
        TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/darwin-x86_64
    else
        TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64
    fi

    case "$arch" in
        "armeabi-v7a")
            echo "### Setting TeamTalk up for Android armv7a ###"

            ANDROID_APP_ABI=armeabi-v7a
            ANDROID_ARCH=arm
            ;;
        "arm64-v8a")
            echo "### Setting TeamTalk up for Android arm64 ###"

            ANDROID_APP_ABI=arm64-v8a
            ANDROID_ARCH=arm64
            ;;
        "x86")
            echo "### Setting TeamTalk up for Android x86 ###"

            ANDROID_APP_ABI=x86
            ANDROID_ARCH=x86
            ;;
        "x86_64")
            echo "### Setting TeamTalk up for Android x86_64 ###"

            ANDROID_APP_ABI=x86_64
            ANDROID_ARCH=x86_64
            ;;        
        *)
            echo "Unknown arch"
            return 1
            ;;
    esac

    ANDROID_ABI=$ANDROID_APP_ABI
    ARCH=$ANDROID_APP_ABI
    SYSROOT=$TOOLCHAIN/sysroot
    PATH=$TOOLCHAIN/bin:$PATH

    TTLIBS_ROOT=$TOOLCHAIN_ROOT/$ARCH
    
    export ANDROID_ABI ANDROID_ARCH ARCH NDK SYSROOT TOOLCHAIN PATH ANDROID_APP_ABI ANDROID_APP_PLATFORM ANDROID_APP_STL

    echo "Android NDK: $NDK"
    echo "Android $ANDROID_APP_ABI toolchain: $TOOLCHAIN"
}

function win() {
    TTLIBS_ROOT=$TOOLCHAIN_ROOT/build
}

function win32() {

    win

}

function win64() {

    win

}

echo "1 = Win32, 2 = Win64, 3 = macOS, 4 = Android, 5 = iOS, 6 = Linux"
if [ -z "$1" ]; then
    read platform
    case "$platform" in
        "1")
            platform=win32
            ;;
        "2")
            platform=win64
            ;;
        "3")
            platform=mac
            ;;
        "4")
            platform=android
            ;;
        "5")
            platform=ios
            ;;
        "6")
            platform=linux
            ;;
        *)
            echo "Unknown arch"
            return 1
            ;;
    esac
else
    platform=$1
fi

case "$platform" in
    win32)
        win32
        ;;
    win64)
        win64
        ;;
    mac)
        mac64
        ;;
    android)
        android $2
        ;;
    ios)
        ios_common $2
        ;;
    linux)
        linux
        ;;
    *)
        echo "Unknown platform"
        return 1
        ;;
esac

if [ "$?" -eq 0 ]; then
    echo "TOOLCHAIN_ROOT is now \"$TOOLCHAIN_ROOT\""
    echo "TTLIBS_ROOT is now \"$TTLIBS_ROOT\""
    export TTLIBS_ROOT TOOLCHAIN_ROOT
    return 0
else
    echo "Failed to set up toolchain"
    return 1
fi
