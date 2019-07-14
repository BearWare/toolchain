# Toolchain for TeamTalkLib

[![Build Status](https://travis-ci.org/bear101/toolchain.svg?branch=master)](https://travis-ci.org/bear101/toolchain)

3rd party libraries for TeamTalk are git submodules in ```build```
folder. To initialize the submodules go to
```Library/TeamTalkLib/toolchain/build``` and type ```make prepare```.

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
15. qt5 (Required Windows)

## Building for Android

### Dependencies for Build Android Libraries

For Ubuntu 18.10 download *Android NDK r17c*,
**android-ndk-r17c-linux-x86_64.zip**, and unpack it in
```Library/TeamTalkLib/toolchain```.

### Install 3rd party Android Dependencies

On Ubuntu 18.10 install the following tools:

* OpenSSL dependencies
** ```sudo apt-get install libncurses5-dev libncursesw5-dev```
** ```sudo apt-get install libtinfo5```

* Speex, SpeexDSP, OPUS dependencies
** ```apt-get install autoconf libtool```

### Build 3rd Party Libraries for Android

First source ```toolchain.sh``` in
```Library/TeamTalkLib/toolchain```. Select Android architecture
(armeabi-v7a, arm64 or x86) and the shell-script will create a
toolchain for the archtecture if it doesn't exist already.

Start a new shell and source ```toolchain.sh``` for every Android
architecture.

Now change to ```Library/TeamTalkLib/toolchain/build```.

For Android armeabi-v7a architecture type:

```make android-armeabi-v7a```

For Android arm64 architecture type:

```make android-arm64```

For Android x86 architecture (useful for simulators) type:

```make android-x86```

When building a new architecture make sure to run ```make clean``` to
delete all intermediate files and configurations.

## Building for Windows

### Dependencies for Building Windows Libraries

Install *Microsoft Visual Studio Community 2015*.

Install *ActivePerl* and place ```perl.exe``` in %PATH%.

* Required by *ACE*, *MPC* and *OpenSSL*

Install *cygwin* with ```make``` and ```git```.

* Required by *libvpx*

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
```Library/TeamTalkLib/toolchain```. Choose either Win32 or Win64 as
architecture. Each architecture **must** use a separate repository
checkout.

Now change to ```Library/TeamTalkLib/toolchain/build```.

Run the following command make command for each library ```make
LIBNAME-win``` where *LIBNAME* is the name of the library name. Follow
the instruction output by the Makefile. This is cumbersome and error
prone process. Sorry...

## Building for Ubuntu 18

### Dependencies for Building Ubuntu 18 Libraries

Run the following command to install required packages:

```sudo apt install libasound2-dev yasm```

### Build 3rd Party Libraries for Ubuntu

First source ```toolchain.sh``` in
```Library/TeamTalkLib/toolchain```. Select Linux as platform.

Now change to ```Library/TeamTalkLib/toolchain/build```.

Run ```make deb64```.

## Building for iOS

### Dependencies for Building iOS Libraries

Download Xcode 9.3 from Apple and place Xcode.app in
```Library/TeamTalkLib/toolchain```.

### Build 3rd Party Libraries for iOS

First source ```toolchain.sh``` in
```Library/TeamTalkLib/toolchain```. Select iOS as platform and then
choose architecture, i.e. armv7, arm64, i386 or x86_64.

Start a new shell and source ```toolchain.sh``` for every iOS
architecture.

Now change to ```Library/TeamTalkLib/toolchain/build```.

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
