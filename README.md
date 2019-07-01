# Toolchain for TeamTalkLib

3rd party libraries for TeamTalk are git submodules in ```build```
folder. To initialize the submodules go to
```Library/TeamTalkLib/toolchain/build``` and type ```make prepare```.

It might be preferable to only initialize the dependencies that are
needed. qt5 submodule is very big and is only needed on Windows. To
initialize a single submodule type ```git submodule update --init ACE```
to e.g. initialize ACE framework.

## Dependencies for Android builds

For Ubuntu 18.10 download Android NDK r17c,
**android-ndk-r17c-linux-x86_64.zip**, and unpack it in
```Library/TeamTalkLib/toolchain```.

### Install 3rd party library dependencies

On Ubuntu 18.10 install the following tools:

* OpenSSL dependencies

```sudo apt-get install libncurses5-dev libncursesw5-dev```
```sudo apt-get install libtinfo5```

* Speex, SpeexDSP, OPUS dependencies

```apt-get install autoconf libtool```

## Build TeamTalk dependencies

First source ```env.sh``` in
```Library/TeamTalkLib/toolchain```. Select Android architecture
(armeabi-v7a, arm64 or x86) and the shell-script will create a
toolchain for the archtecture if it doesn't exist already.

Start a new shell and source ```env.sh``` for every architecture.

Now change to ```Library/TeamTalkLib/toolchain/build```.

For Android armeabi-v7a architecture type:

```make android-armeabi-v7a```

For Android arm64 architecture type:

```make android-arm64```

For Android x86 architecture (useful for simulators) type:

```make android-x86```
