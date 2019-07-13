# Toolchain for TeamTalkLib

[![Build Status](https://travis-ci.org/bear101/toolchain.svg?branch=master)](https://travis-ci.org/bear101/toolchain)

3rd party libraries for TeamTalk are git submodules in ```build```
folder. To initialize the submodules go to
```Library/TeamTalkLib/toolchain/build``` and type ```make prepare```.

Note that submodule qt5 is not initialized because it is very big and
only needed on Windows. To initialize a single submodule type ```git
submodule update --init ACE``` to e.g. initialize ACE framework.

When building TeamTalk's 3rd party libraries they **must** be built in the
following order:

1. openssl
2. MPC
3. ACE
4. ffmpeg
5. libvpx
6. ogg
7. opus
8. opus-tools
9. portaudio
10. speex
11. speexdsp
12. tinyxml
13. zlib
14. qt5

## Building on Android

### Dependencies for Android Builds

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

### Build 3rd party Android Dependencies

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

## Building on Windows

### Dependencies for Windows Builds

Install *Microsoft Visual Studio Community 2015*.

Install *ActivePerl* and place ```perl.exe``` in %PATH%.

* Required by ACE, MPC and OpenSSL

Install *cygwin* with ```make``` and ```git```.

* Required by libvpx

Install yasm from http://yasm.tortall.net/

* Required by libvpx

Install *CMake* from https://cmake.org/

* Required by PortAudio


### Build 3rd party Windows Dependencies

Building on Windows is quite a challenge and cannot be done
automatically. The location of header and libraries is quite different
from Unix-like systems, since Visual Studio is mostly to build the
binaries. Basically there's no ```make install```-type installation.

The 3rd party libraries must be installed in the order described in
first section.

Start a cygwin shell and source ```toolchain.sh``` in
```Library/TeamTalkLib/toolchain```. Choose either Win32 or Win64 as
architecture. Each architecture **must** use a separate repository
checkout.

Now change to ```Library/TeamTalkLib/toolchain/build```.

Run the following command make command for each library ```make
LIBNAME-win``` where LIBNAME is the name of the library name. Follow
the instruction output by the Makefile. This is cumbersome and error
prone process. Sorry...
