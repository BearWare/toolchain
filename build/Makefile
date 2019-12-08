help:
	@echo "Targets:"
	@echo "	LIBNAME-ARCH"
	@echo "	LIBNAME-ARCH-clean"
	@echo "	LIBNAME-ARCH-uninstall"

JOBS?=4
LIBS=openssl mpc ace ffmpeg libvpx ogg opus opus-tools portaudio speex speexdsp tinyxml zlib qt5 Catch2

MACMINVERSION="-mmacosx-version-min=10.9"
MACCFGFLAGS=CFLAGS=$(MACMINVERSION) CPPFLAGS=$(MACMINVERSION)
ARCHS=deb32 deb64 raspi3 mac win android-armeabi-v7a android-arm64 android-x86 ios-i386 ios-x64 ios-armv7 ios-arm64

prepare:
	git submodule update --init --recursive openssl MPC ACE gas-preprocessor FFmpeg libvpx ogg opus opus-tools portaudio speex speexdsp tinyxml zlib Catch2
	git submodule update --init qt5
	@echo "Done..."
	@echo "Note that 'qt5' submodule is not cloned recursively to limit disk usage."

clean: $(foreach lib,$(LIBS),$(lib)-clean)

uninstall: 
	@echo "This will erase _EVERYTHING_"
	@read h
	make uninstall-all

uninstall-all: $(foreach lib,$(LIBS),$(lib)-uninstall)

depend-debian9:
	apt install cmake g++ libssl-dev yasm automake libtool pkg-config libasound2-dev

depend-ubuntu18:
	apt install cmake g++ libssl-dev yasm automake libtool pkg-config libasound2-dev

depend-centos7:
	yum install epel-release # get cmake3
	yum install cmake3 gcc openssl-devel

deb32: $(foreach lib,$(LIBS),$(lib)-deb32)

deb64: $(foreach lib,$(LIBS),$(lib)-deb64)

raspi3: $(foreach lib,$(LIBS),$(lib)-raspi3)

mac: $(foreach lib,$(LIBS),$(lib)-mac)

win: $(foreach lib,$(LIBS),$(lib)-mac)

android-armeabi-v7a: $(foreach lib,$(LIBS),$(lib)-android-armeabi-v7a)

android-arm64: $(foreach lib,$(LIBS),$(lib)-android-arm64)

android-x86: $(foreach lib,$(LIBS),$(lib)-android-x86)

ios-i386: $(foreach lib,$(LIBS),$(lib)-ios-i386)
ios-x64: $(foreach lib,$(LIBS),$(lib)-ios-x64)
ios-armv7: $(foreach lib,$(LIBS),$(lib)-ios-armv7)
ios-arm64: $(foreach lib,$(LIBS),$(lib)-ios-arm64)

openssl-clean:
	cd openssl && git clean -xdf .

openssl-uninstall:
	rm -rf $(TTLIBS_ROOT)/openssl

openssl-deb64:
	cd openssl && git checkout OpenSSL_1_1_0g && ./Configure --prefix=$(TTLIBS_ROOT)/openssl -DPIC -fPIC linux-x86_64 && make install

openssl-deb32:
	cd openssl && git checkout OpenSSL_1_1_0g && ./Configure --prefix=$(TTLIBS_ROOT)/openssl linux-generic32 && make install

openssl-raspi3:
	cd openssl && git checkout OpenSSL_1_1_0g && ./Configure --prefix=$(TTLIBS_ROOT)/openssl linux-armv4 && make install

openssl-mac:
	cd openssl && git checkout OpenSSL_1_1_0g && ./Configure --prefix=$(TTLIBS_ROOT)/openssl darwin64-x86_64-cc $(MACMINVERSION) && make install

openssl-android-armeabi-v7a:
	cd openssl && git checkout OpenSSL_1_1_1b && ANDROID_NDK_HOME=$(TOOLCHAIN) ./Configure --prefix=$(TTLIBS_ROOT)/openssl no-shared android-arm -D__ANDROID_API__=21
	cd openssl && ANDROID_NDK_HOME=$(TOOLCHAIN) make install

openssl-android-arm64:
	cd openssl && git checkout OpenSSL_1_1_1b && ANDROID_NDK_HOME=$(TOOLCHAIN) ./Configure  --prefix=$(TTLIBS_ROOT)/openssl no-shared android-arm64 -D__ANDROID_API__=21
	cd openssl && ANDROID_NDK_HOME=$(TOOLCHAIN) make install

openssl-android-x86:
	cd openssl && git checkout OpenSSL_1_1_1b && ANDROID_NDK_HOME=$(TOOLCHAIN) ./Configure  --prefix=$(TTLIBS_ROOT)/openssl -DPIC -fPIC no-shared android-x86 -D__ANDROID_API__=21
	cd openssl && ANDROID_NDK_HOME=$(TOOLCHAIN) make install

openssl-ios-iphone:
	cd openssl && git checkout OpenSSL_1_1_0g && export CROSS_TOP="$(SDK)/../.." CROSS_SDK="iPhoneOS.sdk -arch $(ARCH) -fembed-bitcode -miphoneos-version-min=7.0" && ./Configure --prefix=$(TTLIBS_ROOT)/openssl iphoneos-cross no-shared no-async && make install

openssl-ios-armv7: openssl-ios-iphone
openssl-ios-arm64: openssl-ios-iphone

openssl-ios-simulator:
	cd openssl && git checkout OpenSSL_1_1_1a && export CROSS_TOP="$(SDK)/../.." CROSS_SDK="iPhoneSimulator.sdk -arch $(ARCH) -mios-simulator-version-min=7.0" && ./Configure --prefix=$(TTLIBS_ROOT)/openssl $(DARWIN) no-shared no-async && make install

openssl-ios-i386:
	make DARWIN=iossimulator-xcrun openssl-ios-simulator

openssl-ios-x64:
	make DARWIN=darwin64-x86_64-cc openssl-ios-simulator

openssl-win:
	cd openssl && git checkout bdr/win
	@echo "--------------------------------------------------"
	@echo "First install ActivePerl and place it in PATH"
	@echo "To build open 'VS2015 x86 Native Tools Command Prompt' and run openssl/build_win32.bat'"
	@echo "or 'VS2015 x64 Native Tools Command Prompt' and run openssl/build_x64.bat'"

mpc-clean:
	@echo "Nothing to do"

mpc-uninstall:
	cd MPC && git clean -xdf .
	rm -f $(TTLIBS_ROOT)/MPC

mpc-build:
	cd MPC && git checkout $(TAG)
	mkdir -p $(TTLIBS_ROOT)
	ln -fs $(PWD)/MPC $(TTLIBS_ROOT)/MPC

mpc-deb64:
	make TAG=ACE+TAO-6_4_5 mpc-build
mpc-deb32:
	make TAG=ACE+TAO-6_4_5 mpc-build
mpc-raspi3:
	make TAG=ACE+TAO-6_4_5 mpc-build
mpc-mac:
	make TAG=ACE+TAO-6_4_5 mpc-build
mpc-ios-armv7:
	make TAG=ACE+TAO-6_5_6 mpc-build
mpc-ios-arm64:
	make TAG=ACE+TAO-6_5_6 mpc-build
mpc-ios-i386:
	make TAG=ACE+TAO-6_5_6 mpc-build
mpc-ios-x64:
	make TAG=ACE+TAO-6_5_6 mpc-build

mpc-android-armeabi-v7a:
	make TAG=ACE+TAO-6_4_5 mpc-build
mpc-android-arm64:
	cd MPC && git checkout ACE+TAO-6_4_8
	ln -fs $(PWD)/MPC $(TTLIBS_ROOT)/MPC
mpc-android-x86:
	cd MPC && git checkout ACE+TAO-6_4_8
	ln -fs $(PWD)/MPC $(TTLIBS_ROOT)/MPC
mpc-win:
	cd ACE && git submodule update --init --recursive

ace-clean:
	cd ACE && git clean -xdf .
ace-uninstall:
	rm -rf $(TTLIBS_ROOT)/ACE

ace-build:
	cd ACE/ACE && git checkout $(BRANCH)
	ln -sf $(PWD)/MPC ACE/ACE/MPC
	cd ACE/ACE/ace && $(ACE_ROOT)/bin/mwc.pl -type gnuace -recurse
	cd ACE/ACE/protocols/ace/INet && $(ACE_ROOT)/bin/mwc.pl -type gnuace -recurse
	cd ACE/ACE/ace && make install -j$(JOBS)
	cd ACE/ACE/protocols/ace/INet && make install -j$(JOBS)

ace-deb64:
	make BRANCH=bdr/deb64 ACE_ROOT=$(PWD)/ACE/ACE ace-build

ace-deb32:
	make BRANCH=bdr/deb32 ACE_ROOT=$(PWD)/ACE/ACE ace-build

ace-raspi3:
	make BRANCH=bdr/raspi3 ACE_ROOT=$(PWD)/ACE/ACE ace-build

ace-android-armeabi-v7a:
	make BRANCH=bdr/android_armeabi-v7a ACE_ROOT=$(PWD)/ACE/ACE JOBS=1 ace-build

ace-android-arm64:
	make BRANCH=bdr/android_arm64-v8a ACE_ROOT=$(PWD)/ACE/ACE ace-build

ace-android-x86:
	make BRANCH=bdr/android_x86 ACE_ROOT=$(PWD)/ACE/ACE ace-build

ace-ios-armv7:
	make BRANCH=bdr/ios_armv7 ACE_ROOT=$(PWD)/ACE/ACE ace-build

ace-ios-arm64:
	make BRANCH=bdr/ios_arm64 ACE_ROOT=$(PWD)/ACE/ACE ace-build

ace-ios-i386:
	make BRANCH=bdr/ios_i386 ACE_ROOT=$(PWD)/ACE/ACE ace-build

ace-ios-x64:
	make BRANCH=bdr/ios_x86_64 ACE_ROOT=$(PWD)/ACE/ACE ace-build

ace-mac:
	@echo "Testing that SDK environment variable has been specified"
	test -d $(SDK)
	make BRANCH=bdr/mac64 ACE_ROOT=$(PWD)/ACE/ACE ace-build

ace-win:
	cd ACE && git checkout bdr/win
	make mpc-win
	@echo "--------------------------------------------------"
	@echo "Now run ACE/ACE/build.bat from 'VS2015 x86 Native Tools Command Prompt'."
	@echo "Ignore the WARNING messages from MPC."
	@echo ""
	@echo "Don't press continue until the above step has been performed."
	@read
	@echo "Patching SSL inc32"
	sed -i -e "s/\\inc32/\\include/" ACE/ACE/ace/SSL/SSL.vcxproj
	sed -i -e "s/\\inc32/\\include/" ACE/ACE/protocols/ace/INet/INet_SSL.vcxproj
	@echo "--------------------------------------------------"
	@echo "Now open ACE/ACE/ace/ace.sln and build Win32 or x64 debug and release"
	@echo "configurations in projects 'ACE' and 'SSL'."
	@echo "Afterwards open ACE/ACE/protocols/protocols.sln and build Win32 or x64"
	@echo "Debug/Release configuration in projects 'INet' and 'INetSSL'."

ffmpeg-clean:
	cd FFmpeg && git clean -xdf .

ffmpeg-uninstall:
	rm -rf $(TTLIBS_ROOT)/ffmpeg

ffmpeg-build:
	cd FFmpeg && git checkout $(BRANCH) && \
	./configure --disable-libxcb --prefix=$(TTLIBS_ROOT)/ffmpeg \
	$(CFGFLAGS) && make install -j$(JOBS)

ffmpeg-deb64:
	make BRANCH=release/3.4 CFGFLAGS="--enable-pic --enable-openssl" ffmpeg-build

ffmpeg-deb32:
	make BRANCH=release/3.4 CFGFLAGS="--enable-openssl" ffmpeg-build

ffmpeg-raspi3: ffmpeg-deb32

ffmpeg-android-armeabi-v7a:
	cd FFmpeg && git checkout release/3.1
	cd FFmpeg && ./configure --extra-cflags="-D__ANDROID_API__=21" --cross-prefix=arm-linux-androideabi- --arch=arm --enable-cross-compile --sysroot=$(SYSROOT) --target-os=android --prefix=$(TTLIBS_ROOT)/ffmpeg --disable-doc --disable-programs
	make -C FFmpeg -j$(JOBS) install

ffmpeg-android-arm64:
	cd FFmpeg && git checkout release/3.1
	cd FFmpeg && ./configure --extra-cflags="-D__ANDROID_API__=21" --cross-prefix=aarch64-linux-android- --arch=aarch64 --enable-cross-compile --sysroot=$(SYSROOT) --target-os=android --prefix=$(TTLIBS_ROOT)/ffmpeg --disable-doc --disable-programs
	make -C FFmpeg -j$(JOBS) install

ffmpeg-android-x86:
	cd FFmpeg && git checkout release/3.1
	cd FFmpeg && ./configure --extra-cflags="-D__ANDROID_API__=21" --cross-prefix=i686-linux-android- --arch=x86 --enable-cross-compile --sysroot=$(SYSROOT) --target-os=android --prefix=$(TTLIBS_ROOT)/ffmpeg --disable-doc --disable-programs --enable-pic --disable-asm
	make -C FFmpeg -j$(JOBS) install

ffmpeg-ios-build:
	cd FFmpeg && git checkout release/3.1

ffmpeg-ios-armv7: ffmpeg-ios-build
	cd FFmpeg && PATH=$(PATH):$(PWD)/gas-preprocessor ./configure --arch=arm --target-os=darwin --cc="clang -arch armv7" --sysroot=$(xcrun --sdk iphoneos --show-sdk-path) --cpu=cortex-a8 --enable-pic --disable-doc --disable-programs --enable-cross-compile --as="gas-preprocessor.pl -arch arm -as-type apple-clang -- clang -arch armv7 -v" --prefix=$(TTLIBS_ROOT)/ffmpeg && make PATH=$(PATH):$(PWD)/gas-preprocessor -j$(JOBS) install

ffmpeg-ios-arm64: ffmpeg-ios-build
	cd FFmpeg && PATH=$(PATH):$(PWD)/gas-preprocessor ./configure --arch=arm64 --target-os=darwin --cc="clang -arch arm64" --sysroot=$(shell xcrun --sdk iphoneos --show-sdk-path)  --enable-pic --disable-doc --disable-programs --enable-cross-compile --as="gas-preprocessor.pl -arch arm64 -as-type apple-clang -- clang -arch arm64 -v" --prefix=$(TTLIBS_ROOT)/ffmpeg && make PATH=$(PATH):$(PWD)/gas-preprocessor -j$(JOBS) install

ffmpeg-ios-i386: ffmpeg-ios-build
	cd FFmpeg && ./configure --arch=i386 --target-os=darwin --cc="clang -arch i386" --sysroot=$(shell xcrun --sdk iphonesimulator --show-sdk-path)  --enable-pic --disable-doc --disable-programs --enable-cross-compile --prefix=$(TTLIBS_ROOT)/ffmpeg && make -j$(JOBS) install

ffmpeg-ios-x64: ffmpeg-ios-build
	cd FFmpeg && ./configure --arch=x86_64 --target-os=darwin --cc="clang -arch x86_64" --sysroot=$(shell xcrun --sdk iphonesimulator --show-sdk-path)  --enable-pic --disable-doc --disable-programs --enable-cross-compile --prefix=$(TTLIBS_ROOT)/ffmpeg && make -j$(JOBS) install

ffmpeg-mac:
	cd FFmpeg && git checkout release/3.4 && \
	export PKG_CONFIG_PATH=$(TTLIBS_ROOT)/openssl/lib/pkgconfig && \
	./configure --prefix=$(TTLIBS_ROOT)/ffmpeg --disable-iconv \
	--disable-libxcb --disable-libxcb-shm --disable-libxcb-xfixes \
	--disable-libxcb-shape --disable-securetransport \
	--disable-schannel --disable-xlib --disable-jack \
	--extra-cflags="$(MACMINVERSION)"  \
	--extra-cxxflags="$(MACMINVERSION)"  \
	--extra-ldexeflags="$(MACMINVERSION)" \
	--disable-videotoolbox --disable-sdl2 --pkg-config-flags="--static" \
	--enable-debug=3 --disable-optimizations --disable-stripping --enable-openssl && make -j$(JOBS) install

libvpx-clean:
	cd libvpx && git clean -xdf .

libvpx-uninstall:
	rm -rf $(TTLIBS_ROOT)/libvpx

libvpx-build:
	cd libvpx && git checkout $(BRANCH) && \
	./configure --prefix=$(TTLIBS_ROOT)/libvpx $(CFGFLAGS) --disable-unit-tests --disable-examples --disable-docs && make install -j$(JOBS)

libvpx-deb64:
	make BRANCH=v1.6.1 CFGFLAGS="--target=x86_64-linux-gcc --enable-pic --disable-tools" libvpx-build

libvpx-deb32:
	make BRANCH=v1.6.1 CFGFLAGS="--disable-tools" libvpx-build

# if v1.6.1 causes "../libraries/libvpx/lib/libvpx.a(vpx_codec.c.o): relocation R_ARM_MOVW_ABS_NC against `a local symbol' can not be used when making a shared object; recompile with -fPIC"
libvpx-raspi3:
	make BRANCH=v1.4.0 libvpx-build

libvpx-mac:
	cd libvpx && git checkout v1.6.1 && \
	./configure --extra-cflags="$(MACMINVERSION)" --prefix=$(TTLIBS_ROOT)/libvpx \
	--target=x86_64-darwin13-gcc && make install -j$(JOBS)

libvpx-android-armeabi-v7a:
	cd libvpx && git checkout v1.8.0
	cd libvpx && CROSS=arm-linux-androideabi- CC=clang CXX=clang++ ./configure --target=armv7-android-gcc --prefix=$(TTLIBS_ROOT)/libvpx --disable-examples --disable-docs --extra-cflags="-D__ANDROID_API__=21" --extra-cxxflags="-D__ANDROID_API__=21" && make -j$(JOBS) install

libvpx-android-arm64:
	cd libvpx && git checkout v1.8.0
	cd libvpx && CROSS=aarch64-linux-android- CC=clang CXX=clang++ ./configure --target=arm64-android-gcc --prefix=$(TTLIBS_ROOT)/libvpx --disable-examples --disable-docs --extra-cflags="-D__ANDROID_API__=21" --extra-cxxflags="-D__ANDROID_API__=21" && make -j$(JOBS) install

libvpx-android-x86:
	cd libvpx && git checkout v1.8.0
	cd libvpx && CROSS=i686-linux-android- ./configure --target=x86-android-gcc --prefix=$(TTLIBS_ROOT)/libvpx --disable-examples --disable-docs --enable-pic --extra-cflags="-D__ANDROID_API__=21" --extra-cxxflags="-D__ANDROID_API__=21" && make -j$(JOBS) install

# libvpx on iOS cannot build when environment variables are set. It defaults to /Applications/Xcode
libvpx-ios-build:
	make libvpx-build

libvpx-ios-armv7:
	make BRANCH=v1.8.1 CFGFLAGS="--target=armv7-darwin-gcc --disable-examples" libvpx-ios-build

libvpx-ios-arm64:
	make BRANCH=v1.8.1 CFGFLAGS="--target=arm64-darwin-gcc --disable-examples" libvpx-ios-build

libvpx-ios-i386:
	make BRANCH=v1.8.1 CFGFLAGS="--target=x86-iphonesimulator-gcc --disable-examples" libvpx-ios-build

libvpx-ios-x64:
	make BRANCH=v1.8.1 CFGFLAGS="--target=x86_64-iphonesimulator-gcc --disable-examples" libvpx-ios-build

libvpx-win:
	cd libvpx && git checkout v1.6.1
	cd libvpx && mkdir -p build_win32
	@echo "--------------------------------------------------"
	@echo "Configuring Win32 build...  (Win64 will be configured afterwards)"
	cd libvpx/build_win32 && ../configure --target=x86-win32-vs14 --disable-examples --disable-docs --enable-static-msvcrt
	cd libvpx && mkdir -p build_win64
	@echo "--------------------------------------------------"
	@echo "Configuring Win64 build..."
	cd libvpx/build_win64 && ../configure --target=x86_64-win64-vs14 --disable-examples --disable-docs --enable-static-msvcrt
	@echo "--------------------------------------------------"
	@echo "Copy yasm.exe for 32-bit to build_win32"
	@echo "Copy yasm.exe for 64-bit to build_win64"
	@echo "Afterwards run 'make' in libvpx/build_win32 or libvpx/build_win64"
	@echo "It should be possible to build using MSBUILD but it is not possible to find in PATH..."
	@echo "Instead open either libvpx/build_win32/vpx.sln or libvpx/build_win64/vpx.sln to build"
	@echo "manually from Visual Studio."
	@echo "Change 'Output Directory' for 'vpx' project to '..\lib\$(PlatformName)' in Debug/Release configurations."
	@echo "Build project 'vpx' in Debug/Release configurations for either Win32 or x64"

ogg-clean:
	cd ogg && git clean -xdf .

ogg-uninstall:
	rm -rf $(TTLIBS_ROOT)/ogg

ogg-build:
	cd ogg && ./autogen.sh $(GENFLAGS) && git checkout $(BRANCH) && \
	./configure $(CFGFLAGS) --prefix=$(TTLIBS_ROOT)/ogg && make install -j$(JOBS)

ogg-deb64:
	make BRANCH=v1.3.2 CFGFLAGS="--with-pic" ogg-build

ogg-deb32:
	make BRANCH=v1.3.2 ogg-build

ogg-raspi3:
	make BRANCH=v1.3.2 ogg-build

ogg-mac:
	make BRANCH=v1.3.2 CFGFLAGS=$(MACCFGFLAGS) ogg-build

ogg-build-android:
	cd ogg && ./autogen.sh $(GENFLAGS) && git checkout $(BRANCH) && \
	./configure $(CFGFLAGS) --prefix=$(TTLIBS_ROOT)/ogg && make install-exec install-data -j$(JOBS)

ogg-android-armeabi-v7a:
	make BRANCH=v1.3.3 GENFLAGS="--host=arm-linux-androideabi" CFGFLAGS="--host=arm-linux-androideabi --disable-shared" ogg-build-android

ogg-android-arm64:
	make BRANCH=v1.3.3 GENFLAGS="--host=aarch64-linux-android" CFGFLAGS="--host=aarch64-linux-android --disable-shared" ogg-build-android

ogg-android-x86:
	make BRANCH=v1.3.3 GENFLAGS="--host=i686-linux-android" CFGFLAGS="--with-pic --host=i686-linux-android --disable-shared" ogg-build-android

ogg-win:
	cd ogg && git checkout bdr/win
	@echo "--------------------------------------------------"
	@echo "Now open ogg\win32\VS2015\libogg_static.sln and build"
	@echo "project 'libogg_static' in Debug/Release configuration"
	@echo "either for Win32 or x64"

ogg-ios-armv7:
	make BRANCH=v1.3.3 GENFLAGS="--host=arm-apple-darwin" CFGFLAGS="--host=arm-apple-darwin" ogg-build
ogg-ios-arm64:
	make BRANCH=v1.3.3 GENFLAGS="--host=arm-apple-darwin" CFGFLAGS="--host=arm-apple-darwin" ogg-build
ogg-ios-i386:
	make BRANCH=v1.3.3 GENFLAGS="--host=$(ARCH)" CFGFLAGS="--host=$(ARCH)" ogg-build
ogg-ios-x64:
	make BRANCH=v1.3.3 GENFLAGS="--host=$(ARCH)" CFGFLAGS="--host=$(ARCH)" ogg-build

opus-clean:
	cd opus && git clean -xdf .

opus-uninstall:
	rm -rf $(TTLIBS_ROOT)/opus

opus-build:
	cd opus && git checkout v1.3 && ./autogen.sh $(GENFLAGS) && \
	./configure $(CFGFLAGS) --prefix=$(TTLIBS_ROOT)/opus && make install -j$(JOBS)

opus-deb64:
	make CFGFLAGS="--with-pic" opus-build

opus-deb32: opus-build

opus-raspi3:
	make CFGFLAGS="--enable-fixed-point" opus-build

opus-android-armeabi-v7a:
	make GENFLAGS="--host=arm-linux-androideabi" CFGFLAGS="'CFLAGS=-D__ANDROID_API__=21' --host=arm-linux-androideabi --enable-fixed-point --disable-extra-programs" opus-build

opus-android-arm64:
	make GENFLAGS="--host=aarch64-linux-android" CFGFLAGS="'CFLAGS=-D__ANDROID_API__=21' --host=aarch64-linux-android --enable-fixed-point --disable-extra-programs" opus-build

opus-android-x86:
	make GENFLAGS="--host=i686-linux-android" CFGFLAGS="'CFLAGS=-D__ANDROID_API__=21' --with-pic --host=i686-linux-android --disable-extra-programs" opus-build

opus-ios-armv7:
	make GENFLAGS="--host=arm-apple-darwin" CFGFLAGS="--host=arm-apple-darwin --enable-fixed-point --enable-shared=no --enable-static=yes --disable-extra-programs" opus-build

opus-ios-arm64:
	make GENFLAGS="--host=arm-apple-darwin" CFGFLAGS="--host=arm-apple-darwin --enable-shared=no --enable-static=yes --disable-extra-programs" opus-build

opus-ios-simulator:
	make GENFLAGS="--host=$(ARCH)" CFGFLAGS="--host=$(ARCH) --enable-shared=no --enable-static=yes --disable-extra-programs" opus-build

opus-ios-i386: opus-ios-simulator
opus-ios-x64: opus-ios-simulator

opus-mac:
	make CFGFLAGS=$(MACCFGFLAGS) opus-build

opus-win:
	cd opus && git checkout bdr/win
	@echo "------------------------------------------------------------"
	@echo "Now open opus\win32\VS2015\opus.sln and build project 'opus'"
	@echo "in Debug/Release configuration either for Win32 or x64."

opus-tools-clean:
	true

opus-tools-uninstall:
	rm -rf $(TTLIBS_ROOT)/opus-tools

opus-tools-build:
	cd opus-tools && git checkout v0.1.10
	ln -fs $(PWD)/opus-tools $(TTLIBS_ROOT)/opus-tools

opus-tools-deb64: opus-tools-build

opus-tools-deb32: opus-tools-build

opus-tools-raspi3: opus-tools-build

opus-tools-mac: opus-tools-build

opus-tools-android-armeabi-v7a: opus-tools-build

opus-tools-android-arm64: opus-tools-build

opus-tools-android-x86: opus-tools-build

opus-tools-ios-armv7: opus-tools-build
opus-tools-ios-arm64: opus-tools-build
opus-tools-ios-i386: opus-tools-build
opus-tools-ios-x64: opus-tools-build

opus-tools-win:

portaudio-clean:
	cd portaudio && git clean -xdf .

portaudio-uninstall:
	rm -rf $(TTLIBS_ROOT)/portaudio

portaudio-build:
	cd portaudio && git checkout $(BRANCH) && \
	./configure $(CFGFLAGS) --with-alsa --without-jack --without-oss \
	--prefix=$(TTLIBS_ROOT)/portaudio && make install

portaudio-deb64:
	make BRANCH=1bdcb9e CFGFLAGS="--with-pic" portaudio-build

portaudio-deb32:
	make BRANCH=1bdcb9e portaudio-build

portaudio-raspi3:
	make BRANCH=1bdcb9e portaudio-build

portaudio-mac:
	cd portaudio && git checkout $(BRANCH) && \
	./configure $(MACCFGFLAGS) --disable-mac-universal \
	--prefix=$(TTLIBS_ROOT)/portaudio && make install

portaudio-win:
	cd portaudio && git checkout bdr/win32
	@echo "--------------------------------------------------"
	@echo "Now open CMake and put empty string in DXSDK_DSOUND_LIBRARY"
	@echo "and '.' in remaining DXSDK_* paths (DirectX is included with Visual Studio 2015)."
	@echo "Generate project for Win32 (default) and 'Visual Studio 2015 - Win64'."
	@echo "Build project 'portaudio_static' in Debug/Release configuration either for Win32 or x64."

portaudio-android-armeabi-v7a:
portaudio-android-arm64:
portaudio-android-x86:
portaudio-ios-armv7:
portaudio-ios-arm64:
portaudio-ios-i386:
portaudio-ios-x64:

speex-clean:
	cd speex && git clean -xdf .

speex-uninstall:
	rm -rf $(TTLIBS_ROOT)/speex

speex-build:
	cd speex && git checkout Speex-1.2.0 && ./autogen.sh $(GENFLAGS) && \
	./configure $(CFGFLAGS) --prefix=$(TTLIBS_ROOT)/speex && make install -j$(JOBS)

speex-deb64:
	make CFGFLAGS="--with-pic" speex-build

speex-deb32: speex-build

speex-mac:
	make CFGFLAGS=$(MACCFGFLAGS) speex-build

speex-raspi3:
	cd speex && git checkout Speex-1.2.0 && ./autogen.sh && \
	./configure --enable-fixed-point --prefix=$(TTLIBS_ROOT)/speex && make install -j$(JOBS)

speex-android-armeabi-v7a:
	make GENFLAGS="--host=arm-linux-androideabi" CFGFLAGS="'CFLAGS=-D__ANDROID_API__=21' --disable-binaries --enable-fixed-point --host=arm-linux-androideabi" speex-build

speex-android-arm64:
	make GENFLAGS="--host=aarch64-linux-android" CFGFLAGS="'CFLAGS=-D__ANDROID_API__=21' --disable-binaries --enable-fixed-point --host=aarch64-linux-android" speex-build

speex-android-x86:
	make GENFLAGS="--host=i686-linux-android" CFGFLAGS="'CFLAGS=-D__ANDROID_API__=21' --with-pic --disable-binaries --host=i686-linux-android" speex-build

speex-ios-iphone:
	make GENFLAGS="--host=arm-apple-darwin" CFGFLAGS="--enable-shared=no --enable-static=yes --disable-binaries --enable-fixed-point --host=arm-apple-darwin" speex-build

speex-ios-armv7: speex-ios-iphone
speex-ios-arm64: speex-ios-iphone

speex-ios-simulator:
	make GENFLAGS="--host=$(ARCH)" CFGFLAGS="--host=$(ARCH) --enable-shared=no --enable-static=yes --disable-binaries" speex-build

speex-ios-i386: speex-ios-simulator

speex-ios-x64: speex-ios-simulator

speex-win:
	cd speex && git checkout bdr/win
	@echo "--------------------------------------------------"
	@echo "Now open VS2015 and open win32\VS2015\libspeex\libspeex.vcxproj"
	@echo "Build project 'libspeex' in Debug/Release_SSE2 configuration either for Win32 or x64."

speexdsp-clean:
	cd speexdsp && git clean -xdf .

speexdsp-uninstall:
	rm -rf $(TTLIBS_ROOT)/speex

speexdsp-build:
	cd speexdsp && git checkout SpeexDSP-1.2.0 && ./autogen.sh $(GENFLAGS) && \
	./configure $(CFGFLAGS) --prefix=$(TTLIBS_ROOT)/speex && make install -j$(JOBS)

speexdsp-mac:
	make CFGFLAGS=$(MACCFGFLAGS) speexdsp-build

speexdsp-deb64:
	dpkg -l | grep pkg-config
	make CFGFLAGS="--with-pic" speexdsp-build

speexdsp-deb32:
	dpkg -l | grep pkg-config
	cd speexdsp && git checkout 4691839 && ./autogen.sh && \
	./configure --prefix=$(TTLIBS_ROOT)/speex && make install -j$(JOBS)

speexdsp-raspi3:
	make CFGFLAGS=--enable-fixed-point speexdsp-build

speexdsp-win:
	cd speexdsp && git checkout bdr/win
	@echo "--------------------------------------------------"
	@echo "Now open VS2015 and open speexdsp\win32\VS2015\libspeexdsp.sln."
	@echo "Build project 'libspeexdsp' in Debug/Release_Static_SSE configuration either for Win32 or x64."


speexdsp-android-armeabi-v7a:
	make GENFLAGS="--host=arm-linux-androideabi" CFGFLAGS="'CFLAGS=-mfloat-abi=softfp -mfpu=neon -D__ANDROID_API__=21' --enable-fixed-point --host=arm-linux-androideabi --enable-neon --disable-examples" speexdsp-build

speexdsp-android-arm64:
	make GENFLAGS="--host=aarch64-linux-android" CFGFLAGS="'CFLAGS=-D__ANDROID_API__=21' --host=aarch64-linux-android --enable-fixed-point --disable-neon --disable-examples" speexdsp-build

speexdsp-android-x86:
	make GENFLAGS="--host=i686-linux-android" CFGFLAGS="'CFLAGS=-D__ANDROID_API__=21' --with-pic --host=i686-linux-android --disable-neon --disable-examples" speexdsp-build

speexdsp-ios-armv7:
	make GENFLAGS="--host=arm-apple-darwin" CFGFLAGS="--host=arm-apple-darwin --enable-fixed-point --enable-shared=no --enable-static=yes --enable-neon" speexdsp-build

speexdsp-ios-arm64:
	make GENFLAGS="--host=arm-apple-darwin" CFGFLAGS="--host=arm-apple-darwin --enable-shared=no --enable-static=yes --disable-neon" speexdsp-build

speexdsp-ios-simulator:
	make GENFLAGS="--host=$(ARCH)" CFGFLAGS="--host=$(ARCH) --enable-shared=no --enable-static=yes" speexdsp-build

speexdsp-ios-i386: speexdsp-ios-simulator
speexdsp-ios-x64: speexdsp-ios-simulator

tinyxml-clean:
	cd tinyxml && git clean -xdf .
tinyxml-uninstall:
	rm -rf $(TTLIBS_ROOT)/tinyxml

tinyxml-build:
	cd tinyxml && git checkout $(BRANCH) && make
	ln -fs $(PWD)/tinyxml $(TTLIBS_ROOT)/tinyxml

tinyxml-deb64:
	make BRANCH=bdr/deb64 tinyxml-build

tinyxml-deb32:
	make BRANCH=bdr/deb32 tinyxml-build

tinyxml-raspi3: tinyxml-deb32

tinyxml-win:
	cd tinyxml && git checkout bdr/win32
	@echo "--------------------------------------------------"
	@echo "Now open tinyxml.vcxproj and build"
	@echo "in Debug/Release configuration either for Win32 or x64."

tinyxml-android-armeabi-v7a:
tinyxml-android-arm64:
tinyxml-android-x86:
tinyxml-ios-armv7:
tinyxml-ios-arm64:
tinyxml-ios-i386:
tinyxml-ios-x64:

tinyxml-mac:
	cd tinyxml && git checkout bdr/mac && make CPPFLAGS="-isysroot $(SDK) -fPIC -g -m64 $(MACMINVERSION) -std=c++11"
	ln -fs $(PWD)/tinyxml $(TTLIBS_ROOT)/tinyxml

zlib-clean:
	cd zlib && git clean -xdf .
zlib-uninstall:
	rm -rf $(TTLIBS_ROOT)/zlib

zlib-build:
	cd zlib && git checkout $(BRANCH) && $(CFGFLAGS) ./configure --prefix=$(TTLIBS_ROOT)/zlib --static && make install

zlib-deb64:
	make BRANCH=v1.2.9 CFGFLAGS="CFLAGS=-fPIC" zlib-build

zlib-deb32:
	make BRANCH=v1.2.9 zlib-build

zlib-mac:
	make BRANCH=v1.2.9 CFGFLAGS=$(MACCFGFLAGS) zlib-build

zlib-raspi3:
	make BRANCH=v1.2.9 zlib-build

zlib-win:
	cd zlib && git checkout bdr/win32
	@echo "--------------------------------------------------"
	@echo "Now open contrib\vstudio\vc14\zlibstat.vcxproj and build 'zlibstat'"
	@echo "in Debug/ReleaseWithoutASM configuration either for Win32 or x64."

zlib-android-armeabi-v7a:
zlib-android-arm64:
zlib-android-x86:
zlib-ios-armv7:
zlib-ios-arm64:
zlib-ios-i386:
zlib-ios-x64:

dshow-deb64:
dshow-deb32:
dshow-raspi3:
dshow-mac:
dshow-ios-armv7:
dshow-ios-arm64:
dshow-ios-i386:
dshow-ios-x64:
dshow-android-armeabi-v7a:
dshow-win:
	@echo "--------------------------------------------------"
	@echo "Now open VS2015 and open DirectShow\BaseClasses\BaseClasses.vcxproj"
	read
dshow-clean:
	cd DirectShow && git clean -xdf .
dshow-uninstall:

libvidcap-deb64:
libvidcap-deb32:
libvidcap-raspi3:
libvidcap-mac:
libvidcap-ios-armv7:
libvidcap-ios-arm64:
libvidcap-ios-i386:
libvidcap-ios-x64:
libvidcap-android-armeabi-v7a:
libvidcap-win:
	@echo "--------------------------------------------------"
	@echo "Now open VS2015 and open contrib\win\vs2010\libvidcap.sln"
	read

libvidcap-uninstall:
libvidcap-clean:
	cd libvidcap-dsbaseclasses && git clean -xdf .

catch-build:
	cd $(PWD)/Catch2 && git checkout v1.12.2
	ln -sf $(PWD)/Catch2 $(TTLIBS_ROOT)/Catch2

Catch2-deb64: catch-build
Catch2-deb32: catch-build
Catch2-raspi3: catch-build
Catch2-mac: catch-build
Catch2-ios-armv7: catch-build
Catch2-ios-arm64: catch-build
Catch2-ios-i386: catch-build
Catch2-ios-x64: catch-build
Catch2-android-armeabi-v7a: catch-build
Catch2-win: catch-build
Catch2-clean:
	cd Catch2 && git clean -xdf .
Catch2-uninstall:
	rm -f $(TTLIBS_ROOT)/Catch2


qt5-deb64:
qt5-deb32:
qt5-raspi3:
qt5-mac:
	# Qt WebEngine is not compatible with App Store.
	# cd qt5 && git checkout v5.10.1
	# cd qt5 && perl init-repository --module-subset=default,-qtwebengine
	# cd qt5 && ./configure --prefix=$(TTLIBS_ROOT)/qt5 -appstore-compliant -confirm-license -opensource -nomake examples -nomake tests
	# cd qt5 && gmake module-qtbase module-qtmultimedia module-qtwebengine module-qttools install -j$(JOBS)

qt5-ios-armv7:
qt5-ios-arm64:
qt5-ios-i386:
qt5-ios-x64:
qt5-android-armeabi-v7a:
qt5-android-arm64:
qt5-android-x86:
qt5-win:
	cd qt5 && git checkout v5.13.0-beta1
	cd qt5 && git submodule update --init qtbase qttools qtmultimedia qtactiveqt
	sed -i -e "s/-MD/-MT/" qt5/qtbase/mkspecs/common/msvc-desktop.conf
	@echo "--------------------------------------------------"
	@echo "Now run in qt5/ 'configure.bat -opensource -confirm-license -static -nomake examples -openssl-linked -I%CD%\..\openssl\include OPENSSL_LIBS=" -L%CD%\..\openssl -lUser32 -lAdvapi32 -lGdi32 -lCrypt32 -lws2_32 -llibssl -llibcrypto" -prefix %CD%\..\..\Qt-5.13.0'"
	@echo "http://doc.qt.io/qt-5/windows-building.html"
	read

qt5-uninstall:
qt5-clean:
	cd qt5 && git clean -xdf .
	cd qt5/qtbase && git clean -xdf .
	cd qt5/qttools && git clean -xdf .
	cd qt5/qtmultimedia && git clean -xdf .
	cd qt5/qtactiveqt && git clean -xdf .
