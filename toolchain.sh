#!/bin/bash

TOOLCHAIN_ROOT=$PWD

function mac64() {
    echo "### Setting TeamTalk up for Mac OS x86_64 ###"

    TTLIBS_ROOT=$BEARWARE_ROOT/libraries
    QTDIR=$TTLIBS_ROOT/Qt/5.12.0/clang_64

    PATH=$QTDIR/bin:$PATH
    export QTDIR
    echo "Setting QTDIR to $QTDIR"

    DYLD_LIBRARY_PATH=$TEAMTALK_ROOT/Library/TeamTalk_DLL:$TEAMTALK_ROOT/Library/TeamTalkJNI/libs:$QTDIR/plugins/accessible:$DYLD_LIBRARY_PATH
    export DYLD_LIBRARY_PATH

    export SDK=$TTLIBS_ROOT/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk

    export HAMCRESTCORE_JAR=$TTLIBS_ROOT/hamcrest-core-1.3.jar
    export JUNIT_JAR=$TTLIBS_ROOT/junit-4.11.jar
}

function ios_common() {

    export XCODE_ROOT=$COMMON_LIB_ROOT/Xcode.app

    export IPHONE_VERSION=9.3 #compilation requires this

    ln -sf $COMMON_LIB_ROOT/FacebookSDK TeamTalk5/Client/iTeamTalk/FacebookSDK
    
if [ -z "$1" ]; then
echo "1 = i386, 2 = x86_64, 3 = armv6, 4 = armv7, 5 = arm64"
read arch
else
arch=$1
fi

case "$arch" in
    "1")
        ios_i386
        ios_export
        ;;
    "2")
        ios_x86_64
        ios_export
        ;;
    "3")
        echo "Unsupported"
        return 1
        ;;
    "4")
        ios_armv7
        ios_export
        ;;
    "5")
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
    export SDK="$XCODE_ROOT/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS"$IPHONE_VERSION".sdk"
}

function ios_arm64() {
    echo "### Setting TeamTalk up for iOS arm64 ###"

    export IPHONE_TARGET=HARDWARE

    export ARCH=arm64
    export SDK="$XCODE_ROOT/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS"$IPHONE_VERSION".sdk"
}

function ios_i386() {
    echo "### Setting TeamTalk up for iOS Simulator i386 ###"

    export IPHONE_TARGET=SIMULATOR

    export ARCH=i386
    export SDK="$XCODE_ROOT/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator"${IPHONE_VERSION}".sdk"
}

function ios_x86_64() {
    echo "### Setting TeamTalk up for iOS Simulator x86_64 ###"

    export IPHONE_TARGET=SIMULATOR

    export ARCH=x86_64
    export SDK="$XCODE_ROOT/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator"${IPHONE_VERSION}".sdk"
}

function ios_export() {

    TTLIBS_ROOT=$BEARWARE_ROOT/libraries/$ARCH

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
}

function linux() {
    echo "### Setting TeamTalk up for Linux ###"

    TTLIBS_ROOT=$BEARWARE_ROOT/libraries

    LD_LIBRARY_PATH=$TEAMTALK_ROOT/Library/TeamTalk_DLL:$TEAMTALK_ROOT/Library/TeamTalkJNI/libs:$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH

    # cmake needs a hint to find Java home
    if [ "raspberrypi" = `uname -n` ]; then
        export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-armhf
    fi

    export HAMCRESTCORE_JAR=$TTLIBS_ROOT/hamcrest-core-1.3.jar
    export JUNIT_JAR=$TTLIBS_ROOT/junit-4.11.jar
}

function android() {

    if [ -z "$1" ]; then
        echo "1 = armeabi-v7a, 2 = arm64-v8a, 3 = x86"
        read arch
    else
        arch=$1
    fi

    NDK=$TOOLCHAIN_ROOT/android-ndk-r17c

    if ! test -d "$NDK"; then
        echo "Android NDK r17c not found. Must be placed in $NDK"
        exit 1
    fi
    
    ANDROID_APP_PLATFORM=android-21
    ANDROID_APP_STL=gnustl_static

    case "$arch" in
        "1")
            echo "### Setting TeamTalk up for Android armv7a ###"

            ANDROID_APP_ABI=armeabi-v7a
            ANDROID_ARCH=arm
            TOOLCHAIN=$TOOLCHAIN_ROOT/toolchain-arm-linux-androideabi-4.9

            ;;
        "2")
            echo "### Setting TeamTalk up for Android arm64 ###"

            ANDROID_APP_ABI=arm64-v8a
            ANDROID_ARCH=arm64
            TOOLCHAIN=$TOOLCHAIN_ROOT/toolchain-aarch64-linux-android
            ;;
        "3")
            echo "### Setting TeamTalk up for Android x86 ###"

            ANDROID_APP_ABI=x86
            ANDROID_ARCH=x86
            TOOLCHAIN=$TOOLCHAIN_ROOT/toolchain-i686-linux-android
            ;;
        *)
            echo "Unknown arch"
            return 1
            ;;
    esac

    if ! test -d "$TOOLCHAIN"; then
        echo "Toolchain for $ANDROID_APP_ABI not found. Creating new toolchain..."
        $NDK/build/tools/make_standalone_toolchain.py --arch "$ANDROID_ARCH" --api 21 --stl gnustl --install-dir "$TOOLCHAIN"
    fi
    
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
    TTLIBS_ROOT=$BEARWARE_ROOT/libraries
    MSBUILDPATH=/cygdrive/c/Windows/Microsoft.NET/Framework64/v4.0.30319
    MSBUILD=$MSBUILDPATH/msbuild.exe

    PATH=$PATH:$TEAMTALK_ROOT/Library/TeamTalk_DLL:$TEAMTALK_ROOT/Library/TeamTalkJNI/libs:$MSBUILDPATH:
    SIGNTOOL='"/cygdrive/c/Program Files (x86)/Microsoft SDKs/Windows/v7.1A/Bin/signtool.exe"'
    CLASSPATH="c:\Programming\Libraries\junit-4.11.jar;c:\Programming\Libraries\hamcrest-core-1.3.jar"

    if [ "CYGWIN_NT-10.0" = `uname -s` ]; then
      MSBUILD='"/cygdrive/c/Program Files (x86)/MSBuild/14.0/bin/MSBuild.exe"'
      PLATFORMTOOLSET="/property:PlatformToolset=v140"
      SIGNTOOL='"/cygdrive/c/Program Files (x86)/Microsoft SDKs/Windows/v7.1A/Bin/signtool.exe"'
    fi

    export MSBUILD CLASSPATH PLATFORMTOOLSET SIGNTOOL
}

function win32() {

    win

    JDK_ROOT=$TTLIBS_ROOT/Java_x86/jdk1.8.0_45
    PATH=$JDK_ROOT/bin:$PATH

    export PATH JDK_ROOT
}

function win64() {

    win

    JDK_ROOT=$TTLIBS_ROOT/Java_x64/jdk1.8.0_45
    PATH=$JDK_ROOT/bin:$PATH

    export PATH JDK_ROOT
}


echo "1 = Win32, 2 = Win64, 3 = macOS, 4 = Android, 5 = iOS"
if [ -z "$1" ]; then
read arch
else
arch=$1
fi

case "$arch" in
    "1")
        win32
        ;;
    "2")
        win64
        ;;
    "3")
        mac64
        ;;
    "4")
        android $2
        ;;
    "5")
        ios_common $2
        ;;
    *)
        echo "Unknown arch"
        return 1
        ;;
esac

echo "TOOLCHAIN_ROOT is now \"$TOOLCHAIN_ROOT\""
echo "TTLIBS_ROOT is now \"$TTLIBS_ROOT\""

export TTLIBS_ROOT TOOLCHAIN_ROOT
