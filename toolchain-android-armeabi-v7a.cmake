# Run 'cmake -DCMAKE_TOOLCHAIN_FILE=toolchain-android-*.cmake' to
# generate projects using this toolchain setup

set (CMAKE_SYSTEM_NAME Android)
set (CMAKE_SYSTEM_VERSION 21)
set (CMAKE_ANDROID_ARCH_ABI armeabi-v7a)
set (CMAKE_ANDROID_NDK $ENV{TOOLCHAIN_ROOT}/android-ndk-r17c)
set (CMAKE_ANDROID_STL_TYPE gnustl_static)
