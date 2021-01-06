# Toolchain for TeamTalkLib

3rd party libraries for
[TeamTalk5](https://github.com/BearWare/TeamTalk5) are Git submodules
in ```build``` folder.

Throughout this document ```$TOOLCHAIN_ROOT``` is the root folder of
the [toolchain](https://github.com/bear101/toolchain) Git
repository. Typically the *toolchain* Git repository is initialized as
a submodule of Git repository
[TeamTalk5](https://github.com/BearWare/TeamTalk5).

To initialize the submodules in *toolchain* Git repository go to
```$TOOLCHAIN_ROOT/build``` and type ```make prepare```.

Note that submodule *qt5* is not initialized because it is very big and
only needed on Windows. To initialize a single submodule type ```git
submodule update --init ACE``` to e.g. initialize ACE framework.

Also note that WebRTC is not initialized because it comes with it's
own repository and tools. Quite a few manual steps are needed to setup
and build WebRTC.

When building TeamTalk's 3rd party libraries they **must** be built in the
following order:

1. openssl (Required by macOS, Windows, iOS and Android)
2. MPC (Required by all platforms)
3. ACE (Required by all platforms)
4. gas-preprocessor (Required by iOS)
5. ffmpeg (Required by Linux, macOS, Android)
6. libvpx (Required by all platforms)
7. ogg (Required by Linux, macOS, Windows, Android)
8. opus (Required by all platforms)
9. opus-tools (Required by Linux, macOS, Windows, Android)
10. portaudio (Required by Linux, macOS, Windows)
11. speex (Required by all platforms)
12. speexdsp (Required by all platforms)
13. tinyxml (Required by Linux, macOS, Windows)
14. zlib (Required by Windows)
15. WebRTC (Required by Linux, macOS, Windows, Android)
16. qt5 (Required by Windows)

The following sections explain how to build for each of the supported
platforms:

* [Building for macOS](#building-for-macos)
* [Building for Ubuntu 18.04](#building-for-ubuntu-1804)
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
  * Required by *libvpx*, *ffmpeg*

### Build 3rd Party Libraries for macOS

First source ```toolchain.sh``` in
```$TOOLCHAIN_ROOT```. Select 'macOS' as platform.

Now change to ```$TOOLCHAIN_ROOT/build```.

Run ```make mac```.

### Build WebRTC for macOS

Download WebRTC by running the following command: ```make prepare-webrtc```.

Build WebRTC by running the following command: ```make webrtc-mac```.


## Building for Ubuntu 18.04

These are build instructions for Ubuntu 18.04 but should also work on
Ubuntu 16 and Debian 9.

### Dependencies for Building Ubuntu 18.04 Libraries

Run the following command to install required packages:

* ```sudo apt install libssl-dev```
  * Required by *ACE*, *ffmpeg*
* ```sudo apt install libasound2-dev```
  * Required by *portaudio*
* ```sudo apt install yasm```
  * Required by *libvpx*
* ```sudo apt install pkg-config```
  * Required by *SpeexDSP*
* ```sudo apt install autoconf libtool```
  * Required by *ogg*
* ```sudo apt-get install wget python```
  * Required by *WebRTC*. Notice "python" is v2.7.

### Build 3rd Party Libraries for Ubuntu 18.04

First source ```toolchain.sh``` in
```$TOOLCHAIN_ROOT```. Select Linux as platform.

Now change to ```$TOOLCHAIN_ROOT/build```.

Run ```make deb64```.

### Build WebRTC for Ubuntu 18.04

Download WebRTC by running the following command: ```make prepare-webrtc```.

Build WebRTC by running the following command: ```make webrtc-deb64```.

## Building for CentOS 7

These are build instructions for CentOS 7.

Note that WebRTC is not supported on CentOS 7.

### Dependencies for Building CentOS 7 Libraries

Run the following command to install required packages:

* ```sudo yum install dnf```
  * Prefer *dnf* to *yum*
* ```sudo dnf install make gcc-c++```
  * Required by *ACE*
* ```sudo dnf install openssl-devel```
  * Required by *ACE* and *FFmpeg*
* ```sudo dnf install alsa-lib-devel```
  * Required by *portaudio*, *ffmpeg*
* ```sudo dnf install nasm```
  * Required by *ffmpeg*
* ```sudo dnf install pkgconfig```
  * Required by *SpeexDSP*
* ```sudo dnf install automake libtool```
  * Required by *ogg*

### Build 3rd Party Libraries for CentOS 7

First source ```toolchain.sh``` in
```$TOOLCHAIN_ROOT```. Select Linux as platform.

Now change to ```$TOOLCHAIN_ROOT/build```.

Run ```make openssl-deb64 mpc-deb64 ace-deb64 ffmpeg-deb64 ogg-deb64 opus-deb64 opus-tools-deb64 portaudio-deb64 speex-deb64 speexdsp-deb64 tinyxml-deb64 zlib-deb64```. Target ```deb64``` cannot be used because *libvpx* does not build on CentOS 7.


## Building for Android

### Dependencies for Building Android Libraries

For Ubuntu 18.04 download *Android NDK r21*,
**android-ndk-r21-linux-x86_64.zip**, and unpack it in
```$TOOLCHAIN_ROOT```.

On Ubuntu 18.04 install the following tools:

* For OpenSSL install dependencies
  * ```sudo apt-get install libncurses5-dev libncursesw5-dev```
  * ```sudo apt-get install libtinfo5```

* For Speex, SpeexDSP, OPUS and OPUS tools install dependencies
  * ```sudo apt-get install autoconf libtool```

* For WebRTC install dependencies
  * ```sudo apt-get install wget python```
  * Notice "python" is v2.7 in Ubuntu 18.04.

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

### Build WebRTC for Android

Download WebRTC by running the following command: ```make prepare-webrtc-android```.

Like in the previous section start a new shell and source
```toolchain.sh``` for every Android architecture.

Now change to ```$TOOLCHAIN_ROOT/build```.

For Android armeabi-v7a architecture type:

```make webrtc-android-armeabi-v7a```

For Android arm64 architecture type:

```make webrtc-android-arm64```

For Android x86 architecture (useful for simulators) type:

```make webrtc-android-x86```

For Android x86_64 architecture (useful for simulators) type:

```make webrtc-android-x64```


## Building for Windows

### Dependencies for Building Windows Libraries

Install *Microsoft Visual Studio Community 2019*.

Install *ActivePerl* or *Strawberry Perl* and place ```perl.exe``` in %PATH%.
* Required by *ACE*, *MPC* and *OpenSSL*

Install *yasm* from http://yasm.tortall.net/
* Required by *libvpx*

Install *CMake* from https://cmake.org and place ```cmake.exe``` in %PATH%
* Required by *PortAudio* and *OPUS*

Install *cygwin* with ```make``` and ```git``` packages.

### Build 3rd Party Libraries for Windows

Building on Windows is quite different from the other supported platforms.
Basically there no ```make install```-type installation on Windows, so
headers and libraries are located in the original source build directories.

Start a cygwin shell and source ```toolchain.sh``` in
```$TOOLCHAIN_ROOT```. Choose either Win32 or Win64 as
architecture.

Now change to ```$TOOLCHAIN_ROOT/build```.

Run the following command make command ```make win```.

Copy ```yasm.exe``` for x86 to ```$TOOLCHAIN_ROOT/build/libvpx/build_win32```
and ```yasm.exe``` for x64 to ```$TOOLCHAIN_ROOT/build/libvpx/build_win64```.

Now start either a Visual Studio 2019 command prompt, either "x86
Native Tools Command Prompt for VS 2019" for Win32 or "x64 Native
Tools Command Prompt for VS 2019" for x64 depending on the
architecture chosen in the cygwin shell.

In the Visual Studio 2019 command prompt change to same directory as
```$TOOLCHAIN_ROOT/build``` and run ```build_win.bat```. Follow the
instructions on what to build. 'Default' build process is recommended.

### Build WebRTC for Windows

Start a Visual Studio 2019 command prompt, either "x86 Native Tools
Command Prompt for VS 2019" or "x64 Native Tools Command Prompt for VS
2019" depending on the architecture to build for. In the command prompt
change to ```$TOOLCHAIN_ROOT/build/webrtc```.

Run ```build_win.bat``` and follow the instructions.


## Building for iOS

### Dependencies for Building iOS Libraries

Download Xcode 12.3 from Apple and place it in
```$TOOLCHAIN_ROOT```. Change default Xcode to Xcode 12.3:
```xcode-select -s $TOOLCHAIN_ROOT/Xcode.app/Contents/Developer```

### Build 3rd Party Libraries for iOS

Start a new shell and source ```toolchain.sh``` for every iOS
architecture, i.e. armv7, arm64, i386 or x86_64.

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
