# Toolchain for TeamTalkLib

[![Build Status](https://travis-ci.org/bear101/toolchain.svg?branch=master)](https://travis-ci.org/bear101/toolchain)

3rd party libraries for [TeamTalk5](https://github.com/BearWare/TeamTalk5) are Git submodules in ```build```
folder. To initialize the submodules go to ```$TOOLCHAIN_ROOT/build```
and type ```make prepare```. Throughout this document
```$TOOLCHAIN_ROOT``` is the root folder of the
[toolchain](https://github.com/bear101/toolchain) Git
repository. Typically the *toolchain*
Git repository is initialized as a submodule of Git repository
[TeamTalk5](https://github.com/BearWare/TeamTalk5).

Note that submodule *qt5* is not initialized because it is very big and
only needed on Windows. To initialize a single submodule type ```git
submodule update --init ACE``` to e.g. initialize ACE framework.

When building TeamTalk's 3rd party libraries they **must** be built in the
following order:

1. openssl (Required by macOS, Windows, iOS and Android)
2. MPC (Required by all platforms)
3. ACE (Required by all platforms)
4. gas-preprocessor (Required by iOS)
5. ffmpeg (Required by Linux, macOS, Android)
6. libvpx (Required by Linux, macOS, Windows, Android)
7. ogg (Required by Linux, macOS, Windows, Android)
8. opus (Required by all platforms)
9. opus-tools (Required by Linux, macOS, Windows, Android)
10. portaudio (Required by Linux, macOS, Windows)
11. speex (Required by all platforms)
12. speexdsp (Required by all platforms)
13. tinyxml (Required by Linux, macOS, Windows)
14. zlib (Required by Windows)
15. qt5 (Required by Windows)

The following sections explain how to build for each of the supported
platforms:

* [Building for macOS](#building-for-macos)
* [Building for Ubuntu 18](#building-for-ubuntu-18)
* [Building for CentOS 7](#building-for-centos-7)
* [Building for Android](#building-for-android)
* [Building for Windows](#building-for-windows)
* [Building for iOS](#building-for-ios)

## Building for macOS

### Dependencies for Building macOS Libraries

Install *MacPorts* or *Homebrew* and install the following packages:

* autoconf
  * Required by *ffmpeg*
* automake
  * Required by *ogg*
* libtool
  * Required by *ogg*
* pkg-config
  * Required by *ffmpeg*
* yasm
  * Required by *libvpx*

### Build 3rd Party Libraries for macOS

First source ```toolchain.sh``` in
```$TOOLCHAIN_ROOT```. Select 'macOS' as platform.

Now change to ```$TOOLCHAIN_ROOT/build```.

Run ```make mac```.

## Building for Ubuntu 18

These are build instructions for Ubuntu 18 but should also work on
Ubuntu 16 and Debian 9.

### Dependencies for Building Ubuntu 18 Libraries

Run the following command to install required packages:

* ```sudo apt install libasound2-dev```
  * Required by *portaudio*
* ```sudo apt install yasm```
  * Required by *libvpx*
* ```sudo apt install pkg-config```
  * Required by *SpeexDSP*
* ```sudo apt install autoconf libtool```
  * Required by *ogg*

### Build 3rd Party Libraries for Ubuntu 18

First source ```toolchain.sh``` in
```$TOOLCHAIN_ROOT```. Select Linux as platform.

Now change to ```$TOOLCHAIN_ROOT/build```.

Run ```make deb64```.

## Building for CentOS 7

These are build instructions for CentOS 7.

### Dependencies for Building CentOS 7 Libraries

Run the following command to install required packages:

* ```yum --enablerepo=extras install epel-release```
  * Need to enable "Extra Packages for Enterprise Linux 7"
* ```sudo dnf install alsa-lib-devel```
  * Required by *portaudio*
* ```sudo dnf install nasm```
  * Required by *libvpx*
* ```sudo dnf install pkgconfig```
  * Required by *SpeexDSP*
* ```sudo dnf install autoconf libtool```
  * Required by *ogg*

### Build 3rd Party Libraries for CentOS 7

First source ```toolchain.sh``` in
```$TOOLCHAIN_ROOT```. Select Linux as platform.

Now change to ```$TOOLCHAIN_ROOT/build```.

Run ```make openssl-deb64 mpc-deb64 ace-deb64 ffmpeg-deb64 ogg-deb64 opus-deb64 opus-tools-deb64 portaudio-deb64 speex-deb64 speexdsp-deb64 tinyxml-deb64 zlib-deb64```. Target ```deb64``` cannot be used because *libvpx* does not build on CentOS 7.

## Building for Android

### Dependencies for Building Android Libraries

For Ubuntu 18.10 download *Android NDK r21*,
**android-ndk-r21-linux-x86_64.zip**, and unpack it in
```$TOOLCHAIN_ROOT```.

On Ubuntu 18.10 install the following tools:

* For OpenSSL install dependencies
  * ```sudo apt-get install libncurses5-dev libncursesw5-dev```
  * ```sudo apt-get install libtinfo5```

* For Speex, SpeexDSP, OPUS and OPUS tools install dependencies
  * ```sudo apt-get install autoconf libtool```

### Build 3rd Party Libraries for Android

First source ```toolchain.sh``` in ```$TOOLCHAIN_ROOT```. Select
Android architecture (armeabi-v7a, arm64, x86 or x86_64) and the
shell-script will create a toolchain for the archtecture if it doesn't
exist already.

Start a new shell and source ```toolchain.sh``` for every Android
architecture.

Now change to ```$TOOLCHAIN_ROOT/build```.

For Android armeabi-v7a architecture type:

```make android-armeabi-v7a```

For Android arm64 architecture type:

```make android-arm64```

For Android x86 architecture (useful for simulators) type:

```make android-x86```

For Android x86_64 architecture (useful for simulators) type:

```make android-x64```

When building a new architecture make sure to run ```make clean``` to
delete all intermediate files and configurations.

## Building for Windows

### Dependencies for Building Windows Libraries

Install *Microsoft Visual Studio Community 2015*.

Install *ActivePerl* and place ```perl.exe``` in %PATH%.

* Required by *ACE*, *MPC* and *OpenSSL*

Install *cygwin* with ```make``` and ```git``` packages.

Install *yasm* from http://yasm.tortall.net/

* Required by *libvpx*

Install *CMake* from https://cmake.org/

* Required by *PortAudio*

### Build 3rd Party Libraries for Windows

Building on Windows is quite a challenge and cannot be done
automatically. The location of header and libraries is quite different
from Unix-like systems, since Visual Studio is mostly to build the
binaries. Basically there's no ```make install```-type installation.

The 3rd party libraries must be installed in the order described in
[first section](#toolchain-for-teamtalklib).

Start a cygwin shell and source ```toolchain.sh``` in
```$TOOLCHAIN_ROOT```. Choose either Win32 or Win64 as
architecture. Each architecture **must** use a separate repository
checkout.

Now change to ```$TOOLCHAIN_ROOT/build```.

Run the following command make command for each library ```make
LIBNAME-win``` where *LIBNAME* is the name of the library name. Follow
the instruction output by the Makefile. This is cumbersome and error
prone process. Sorry...

## Building for iOS

### Dependencies for Building iOS Libraries

Download Xcode 7.3 from Apple and place Xcode.app in
```$TOOLCHAIN_ROOT```.

### Build 3rd Party Libraries for iOS

First source ```toolchain.sh``` in
```$TOOLCHAIN_ROOT```. Select iOS as platform and then
choose architecture, i.e. armv7, arm64, i386 or x86_64.

Start a new shell and source ```toolchain.sh``` for every iOS
architecture.

Now change to ```$TOOLCHAIN_ROOT/build```.

For iOS armv7 architecture type:

```make ios-armv7```

For iOS arm64 architecture type:

```make ios-arm64```

For iOS i386 architecture (useful for simulators) type:

```make ios-i386```

For iOS x86_64 architecture (useful for simulators) type:

```make ios-x64```

When building a new architecture make sure to run ```make clean``` to
delete all intermediate files and configurations.
