help:
	@echo "Targets:"
	@echo "	LIBNAME-ARCH"
	@echo "	LIBNAME-ARCH-clean"
	@echo "	LIBNAME-ARCH-uninstall"

JOBS?=4
LIBS=openssl mpc ace ffmpeg libvpx ogg opus opus-tools portaudio speex speexdsp tinyxml zlib qt5 Catch2
LIBS_GITHUB := $(filter-out webrtc, $(LIBS))

MACMINVERSION="-mmacosx-version-min=$(MACOSX_DEPLOYMENT_TARGET)"
MACCFGFLAGS=CFLAGS=$(MACMINVERSION) CPPFLAGS=$(MACMINVERSION)
ARCHS=deb32 deb64 raspi3 mac win android-armeabi-v7a android-arm64 android-x86 ios-i386 ios-x64 ios-armv7 ios-arm64

prepare: prepare-github

prepare-github:
	git submodule update --init --recursive openssl MPC ACE gas-preprocessor FFmpeg libvpx ogg opus opus-tools portaudio speex speexdsp tinyxml zlib Catch2
	@echo "Cloning Qt"
	git submodule update --init qt5
	@echo "Note that 'qt5' submodule is not cloned recursively to limit disk usage."

sync:
	git submodule foreach git fetch -t -p

clean: $(foreach lib,$(LIBS),$(lib)-clean)

uninstall:
	$(MAKE) uninstall-all

uninstall-all: $(foreach lib,$(LIBS),$(lib)-uninstall)

depend-debian9:
	apt install cmake g++ libssl-dev yasm autoconf libtool pkg-config libasound2-dev wget python

depend-ubuntu18:
	apt install cmake g++ libssl-dev yasm autoconf libtool pkg-config libasound2-dev wget python

depend-centos7:
	yum install epel-release # get cmake3
	yum install cmake3 gcc openssl-devel

depend-mac:
	brew install autoconf automake libtool pkg-config yasm

deb32: $(foreach lib,$(LIBS),$(lib)-deb32)

deb64: $(foreach lib,$(LIBS),$(lib)-deb64)

deb64-github: $(foreach lib,$(LIBS_GITHUB),$(lib)-deb64)

mac-github: $(foreach lib,$(LIBS_GITHUB),$(lib)-mac)

raspi3: $(foreach lib,$(LIBS),$(lib)-raspi3)

mac: $(foreach lib,$(LIBS),$(lib)-mac)

win: $(foreach lib,$(LIBS),$(lib)-win)

android-armeabi-v7a: $(foreach lib,$(LIBS),$(lib)-android-armeabi-v7a)

android-arm64: $(foreach lib,$(LIBS),$(lib)-android-arm64)

android-x86: $(foreach lib,$(LIBS),$(lib)-android-x86)

android-x64: $(foreach lib,$(LIBS),$(lib)-android-x64)

ios-i386: $(foreach lib,$(LIBS),$(lib)-ios-i386)
ios-x64: $(foreach lib,$(LIBS),$(lib)-ios-x64)
ios-armv7: $(foreach lib,$(LIBS),$(lib)-ios-armv7)
ios-arm64: $(foreach lib,$(LIBS),$(lib)-ios-arm64)

openssl-clean:
	cd openssl && git clean -xdf .

openssl-uninstall:
	rm -rf $(TTLIBS_ROOT)/openssl

openssl-deb64:
	true
#	cd openssl && git checkout OpenSSL_1_1_1h && ./Configure --prefix=$(TTLIBS_ROOT)/openssl -DPIC -fPIC linux-x86_64 && $(MAKE) install

openssl-deb32:
	true
#	cd openssl && git checkout OpenSSL_1_1_0g && ./Configure --prefix=$(TTLIBS_ROOT)/openssl linux-generic32 && $(MAKE) install

openssl-raspi3:
	true
#	cd openssl && git checkout OpenSSL_1_1_0g && ./Configure --prefix=$(TTLIBS_ROOT)/openssl linux-armv4 && $(MAKE) install

openssl-mac:
	cd openssl && git checkout OpenSSL_1_1_1k && ./Configure --prefix=$(TTLIBS_ROOT)/openssl darwin64-x86_64-cc $(MACMINVERSION) && $(MAKE) install

openssl-android-armeabi-v7a:
	cd openssl && git checkout OpenSSL_1_1_1k && ANDROID_NDK_HOME=$(NDK) ./Configure --prefix=$(TTLIBS_ROOT)/openssl -DPIC -fPIC no-shared android-arm -D__ANDROID_API__=21
	cd openssl && ANDROID_NDK_HOME=$(NDK) $(MAKE) install

openssl-android-arm64:
	cd openssl && git checkout OpenSSL_1_1_1k && ANDROID_NDK_HOME=$(NDK) ./Configure --prefix=$(TTLIBS_ROOT)/openssl -DPIC -fPIC no-shared android-arm64 -D__ANDROID_API__=21
	cd openssl && ANDROID_NDK_HOME=$(NDK) $(MAKE) install

openssl-android-x86:
	cd openssl && git checkout OpenSSL_1_1_1k && ANDROID_NDK_HOME=$(NDK) ./Configure --prefix=$(TTLIBS_ROOT)/openssl -DPIC -fPIC no-shared android-x86 -D__ANDROID_API__=21
	cd openssl && ANDROID_NDK_HOME=$(NDK) $(MAKE) install

openssl-android-x64:
	cd openssl && git checkout OpenSSL_1_1_1k && ANDROID_NDK_HOME=$(NDK) ./Configure --prefix=$(TTLIBS_ROOT)/openssl -DPIC -fPIC no-shared android-x86_64 -D__ANDROID_API__=21
	cd openssl && ANDROID_NDK_HOME=$(NDK) $(MAKE) install

openssl-ios-iphone:
	cd openssl && git checkout OpenSSL_1_1_1j && export CROSS_TOP="$(SDK)/../.." CROSS_SDK="iPhoneOS.sdk -arch $(ARCH) -fembed-bitcode -miphoneos-version-min=7.0" && ./Configure --prefix=$(TTLIBS_ROOT)/openssl iphoneos-cross no-shared no-async no-tests && $(MAKE) install

openssl-ios-armv7: openssl-ios-iphone
openssl-ios-arm64: openssl-ios-iphone

openssl-ios-simulator:
	cd openssl && git checkout OpenSSL_1_1_1j && export CROSS_TOP="$(SDK)/../.." CROSS_SDK="iPhoneSimulator.sdk -arch $(ARCH) -mios-simulator-version-min=7.0" && ./Configure --prefix=$(TTLIBS_ROOT)/openssl $(DARWIN) no-shared no-async no-tests && $(MAKE) install

openssl-ios-i386:
	$(MAKE) DARWIN=iossimulator-xcrun openssl-ios-simulator

openssl-ios-x64:
	$(MAKE) DARWIN=iossimulator-xcrun openssl-ios-simulator

openssl-win:
	# Branch: bdr/vs2019_OpenSSL 1.1.1k
	cd openssl && git checkout 2c3f861718

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
	$(MAKE) TAG=ACE+TAO-6_5_12 mpc-build
mpc-deb32:
	$(MAKE) TAG=ACE+TAO-6_4_5 mpc-build
mpc-raspi3:
	$(MAKE) TAG=ACE+TAO-6_5_12 mpc-build
mpc-mac:
	$(MAKE) TAG=ACE+TAO-6_5_12 mpc-build
mpc-ios-armv7:
	$(MAKE) TAG=ACE+TAO-6_5_6 mpc-build
mpc-ios-arm64:
	$(MAKE) TAG=ACE+TAO-6_5_6 mpc-build
mpc-ios-i386:
	$(MAKE) TAG=ACE+TAO-6_5_6 mpc-build
mpc-ios-x64:
	$(MAKE) TAG=ACE+TAO-6_5_6 mpc-build

mpc-android-armeabi-v7a:
	$(MAKE) TAG=ACE+TAO-6_5_8 mpc-build
mpc-android-arm64:
	$(MAKE) TAG=ACE+TAO-6_5_8 mpc-build
mpc-android-x86:
	$(MAKE) TAG=ACE+TAO-6_5_8 mpc-build
mpc-android-x64:
	$(MAKE) TAG=ACE+TAO-6_5_8 mpc-build
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
	cd ACE/ACE/ace && $(MAKE) install -j$(JOBS)
	cd ACE/ACE/protocols/ace/INet && $(MAKE) install -j$(JOBS)

ace-deb64:
	$(MAKE) BRANCH=bdr/deb64_ACE+TAO-6_5_12 ACE_ROOT=$(PWD)/ACE/ACE ace-build

ace-deb32:
	$(MAKE) BRANCH=bdr/deb32 ACE_ROOT=$(PWD)/ACE/ACE ace-build

ace-raspi3:
	$(MAKE) BRANCH=6312ccc2d1f ACE_ROOT=$(PWD)/ACE/ACE ace-build

ace-android-armeabi-v7a:
	$(MAKE) BRANCH=bdr/android ACE_ROOT=$(PWD)/ACE/ACE ace-build

ace-android-arm64:
	$(MAKE) BRANCH=bdr/android ACE_ROOT=$(PWD)/ACE/ACE ace-build

ace-android-x86:
	$(MAKE) BRANCH=bdr/android ACE_ROOT=$(PWD)/ACE/ACE ace-build

ace-android-x64:
	$(MAKE) BRANCH=bdr/android ACE_ROOT=$(PWD)/ACE/ACE ace-build

ace-ios-armv7:
	$(MAKE) BRANCH=bdr/ios_armv7 ACE_ROOT=$(PWD)/ACE/ACE ace-build

ace-ios-arm64:
	$(MAKE) BRANCH=bdr/ios_arm64 ACE_ROOT=$(PWD)/ACE/ACE ace-build

ace-ios-i386:
	$(MAKE) BRANCH=bdr/ios_i386 ACE_ROOT=$(PWD)/ACE/ACE ace-build

ace-ios-x64:
	$(MAKE) BRANCH=bdr/ios_x86_64 ACE_ROOT=$(PWD)/ACE/ACE ace-build

ace-mac:
	@echo "Testing that SDK environment variable has been specified"
	test -d $(SDK)
	$(MAKE) BRANCH=2b9c1bb43ae ACE_ROOT=$(PWD)/ACE/ACE ace-build

ace-win:
	cd ACE && git checkout 3bd8589385a
	$(MAKE) mpc-win

ffmpeg-clean:
	cd FFmpeg && git clean -xdf .

ffmpeg-uninstall:
	rm -rf $(TTLIBS_ROOT)/ffmpeg

ffmpeg-build:
	cd FFmpeg && git checkout $(BRANCH) && \
	./configure --disable-libxcb --prefix=$(TTLIBS_ROOT)/ffmpeg \
	$(CFGFLAGS) && $(MAKE) install -j$(JOBS)

ffmpeg-deb64:
	$(MAKE) BRANCH=n3.4.7 CFGFLAGS="--enable-pic --enable-openssl --disable-jack" ffmpeg-build

ffmpeg-deb32:
	$(MAKE) BRANCH=n3.4.7 CFGFLAGS="--enable-openssl" ffmpeg-build

ffmpeg-raspi3: ffmpeg-deb32

ffmpeg-android-armeabi-v7a:
	# Options --disable-indev=v4l2 and --disable-neon shouldn't be
	# necessary but this prevents compiler error for v4l2 and neon
	# linker errors during install
	cd FFmpeg && git checkout n3.4.7
	cd FFmpeg && ./configure --cross-prefix=arm-linux-androideabi- --cc="clang --target=armv7a-linux-android21" --arch=arm --enable-cross-compile --sysroot=$(SYSROOT) --target-os=android --prefix=$(TTLIBS_ROOT)/ffmpeg --disable-doc --disable-programs --enable-pic --disable-indev=v4l2 --disable-neon
	$(MAKE) -C FFmpeg -j$(JOBS) install

ffmpeg-android-arm64:
	cd FFmpeg && git checkout n3.4.7
	cd FFmpeg && ./configure --cross-prefix=aarch64-linux-android- --cc="clang --target=aarch64-linux-android21" --arch=aarch64 --enable-cross-compile --sysroot=$(SYSROOT) --target-os=android --prefix=$(TTLIBS_ROOT)/ffmpeg --disable-doc --disable-programs --enable-pic --disable-indev=v4l2
	$(MAKE) -C FFmpeg -j$(JOBS) install

ffmpeg-android-x86:
	cd FFmpeg && git checkout n3.4.7
	cd FFmpeg && ./configure --cross-prefix=i686-linux-android- --cc="clang --target=i686-linux-android21" --arch=x86 --enable-cross-compile --sysroot=$(SYSROOT) --target-os=android --prefix=$(TTLIBS_ROOT)/ffmpeg --disable-doc --disable-programs --enable-pic --disable-asm --disable-indev=v4l2
	$(MAKE) -C FFmpeg -j$(JOBS) install

ffmpeg-android-x64:
	cd FFmpeg && git checkout n3.4.7
	cd FFmpeg && ./configure --cross-prefix=x86_64-linux-android- --cc="clang --target=x86_64-linux-android21" --arch=x86_64 --enable-cross-compile --sysroot=$(SYSROOT) --target-os=android --prefix=$(TTLIBS_ROOT)/ffmpeg --disable-doc --disable-programs --enable-pic --disable-asm --disable-indev=v4l2
	$(MAKE) -C FFmpeg -j$(JOBS) install

ffmpeg-ios-build:
	cd FFmpeg && git checkout n3.4.7

ffmpeg-ios-armv7: ffmpeg-ios-build
	cd FFmpeg && PATH=$(PATH):$(PWD)/gas-preprocessor ./configure --arch=arm --target-os=darwin --cc="clang -arch armv7" --sysroot=$(xcrun --sdk iphoneos --show-sdk-path) --cpu=cortex-a8 --enable-pic --disable-doc --disable-programs --enable-cross-compile --as="gas-preprocessor.pl -arch arm -as-type apple-clang -- clang -arch armv7 -v" --prefix=$(TTLIBS_ROOT)/ffmpeg && $(MAKE) PATH=$(PATH):$(PWD)/gas-preprocessor -j$(JOBS) install

ffmpeg-ios-arm64: ffmpeg-ios-build
	cd FFmpeg && PATH=$(PATH):$(PWD)/gas-preprocessor ./configure --arch=arm64 --target-os=darwin --cc="clang -arch arm64" --sysroot=$(shell xcrun --sdk iphoneos --show-sdk-path)  --enable-pic --disable-doc --disable-programs --enable-cross-compile --as="gas-preprocessor.pl -arch arm64 -as-type apple-clang -- clang -arch arm64 -v" --prefix=$(TTLIBS_ROOT)/ffmpeg && $(MAKE) PATH=$(PATH):$(PWD)/gas-preprocessor -j$(JOBS) install

ffmpeg-ios-i386: ffmpeg-ios-build
	cd FFmpeg && ./configure --arch=i386 --target-os=darwin --cc="clang -arch i386" --sysroot=$(shell xcrun --sdk iphonesimulator --show-sdk-path)  --enable-pic --disable-doc --disable-programs --enable-cross-compile --prefix=$(TTLIBS_ROOT)/ffmpeg && $(MAKE) -j$(JOBS) install

ffmpeg-ios-x64: ffmpeg-ios-build
	cd FFmpeg && ./configure --arch=x86_64 --target-os=darwin --cc="clang -arch x86_64" --sysroot=$(shell xcrun --sdk iphonesimulator --show-sdk-path)  --enable-pic --disable-doc --disable-programs --enable-cross-compile --prefix=$(TTLIBS_ROOT)/ffmpeg && $(MAKE) -j$(JOBS) install

ffmpeg-mac:
	cd FFmpeg && git checkout n3.4.7 && \
	export PKG_CONFIG_PATH=$(TTLIBS_ROOT)/openssl/lib/pkgconfig && \
	./configure --prefix=$(TTLIBS_ROOT)/ffmpeg --disable-iconv \
	--disable-libxcb --disable-libxcb-shm --disable-libxcb-xfixes \
	--disable-libxcb-shape --disable-securetransport \
	--disable-schannel --disable-xlib --disable-jack \
	--disable-lzma \
	--extra-cflags="$(MACMINVERSION)"  \
	--extra-cxxflags="$(MACMINVERSION)"  \
	--extra-ldexeflags="$(MACMINVERSION)" \
	--disable-videotoolbox --disable-sdl2 --pkg-config-flags="--static" \
	--enable-debug=3 --disable-optimizations --disable-stripping --enable-openssl && $(MAKE) -j$(JOBS) install

ffmpeg-win:

libvpx-clean:
	cd libvpx && git clean -xdf .

libvpx-uninstall:
	rm -rf $(TTLIBS_ROOT)/libvpx

libvpx-build:
	cd libvpx && git checkout $(BRANCH) && \
	./configure --prefix=$(TTLIBS_ROOT)/libvpx $(CFGFLAGS) --disable-unit-tests --disable-examples --disable-docs && $(MAKE) install -j$(JOBS)

libvpx-deb64:
	$(MAKE) BRANCH=v1.6.1 CFGFLAGS="--target=x86_64-linux-gcc --enable-pic --disable-tools" libvpx-build

libvpx-deb32:
	$(MAKE) BRANCH=v1.6.1 CFGFLAGS="--disable-tools" libvpx-build

# if v1.6.1 causes "../libraries/libvpx/lib/libvpx.a(vpx_codec.c.o): relocation R_ARM_MOVW_ABS_NC against `a local symbol' can not be used when making a shared object; recompile with -fPIC"
libvpx-raspi3:
	$(MAKE) BRANCH=v1.4.0 libvpx-build

libvpx-mac:
	cd libvpx && git checkout v1.6.1 && \
	./configure --extra-cflags="$(MACMINVERSION)" --prefix=$(TTLIBS_ROOT)/libvpx \
	--target=x86_64-darwin13-gcc && $(MAKE) install -j$(JOBS)

libvpx-android-armeabi-v7a:
	cd libvpx && git checkout v1.8.0
	cd libvpx && CROSS=arm-linux-androideabi- CC='clang --target=armv7a-linux-android21' CXX='clang++ --target=armv7a-linux-android21' ./configure --target=armv7-android-gcc --prefix=$(TTLIBS_ROOT)/libvpx --disable-examples --disable-docs --enable-pic && $(MAKE) -j$(JOBS) install

libvpx-android-arm64:
	cd libvpx && git checkout v1.8.0
	cd libvpx && CROSS=aarch64-linux-android- CC='clang --target=aarch64-linux-android21' CXX='clang++ --target=aarch64-linux-android21' ./configure --target=arm64-android-gcc --prefix=$(TTLIBS_ROOT)/libvpx --disable-examples --disable-docs --enable-pic && $(MAKE) -j$(JOBS) install

libvpx-android-x86:
	cd libvpx && git checkout v1.8.0
	cd libvpx && CROSS=i686-linux-android- CC='clang --target=i686-linux-android21' CXX='clang++ --target=i686-linux-android21' ./configure --target=x86-android-gcc --prefix=$(TTLIBS_ROOT)/libvpx --disable-examples --disable-docs --enable-pic && $(MAKE) -j$(JOBS) install

libvpx-android-x64:
	cd libvpx && git checkout v1.8.0
	cd libvpx && CROSS=x86_64-linux-android- CC='clang --target=x86_64-linux-android21' CXX='clang++ --target=x86_64-linux-android21' ./configure --target=x86_64-android-gcc --prefix=$(TTLIBS_ROOT)/libvpx --disable-examples --disable-docs --enable-pic && $(MAKE) -j$(JOBS) install

# libvpx on iOS cannot build when environment variables are set. It defaults to /Applications/Xcode
libvpx-ios-build:
	$(MAKE) libvpx-build

libvpx-ios-armv7:
	$(MAKE) BRANCH=v1.9.0 CFGFLAGS="--target=armv7-darwin-gcc --disable-examples" libvpx-ios-build

libvpx-ios-arm64:
	$(MAKE) BRANCH=v1.9.0 CFGFLAGS="--target=arm64-darwin-gcc --disable-examples" libvpx-ios-build

libvpx-ios-i386:
	$(MAKE) BRANCH=v1.9.0 CFGFLAGS="--target=x86-iphonesimulator-gcc --disable-examples" libvpx-ios-build

libvpx-ios-x64:
	$(MAKE) BRANCH=v1.9.0 CFGFLAGS="--target=x86_64-iphonesimulator-gcc --disable-examples" libvpx-ios-build

libvpx-win:
	cd libvpx && git checkout v1.9.0
	cd libvpx && mkdir -p build_win32
	@echo "Configuring Win32 build...  (Win64 will be configured afterwards)"
	cd libvpx/build_win32 && ../configure --target=x86-win32-vs16 --disable-examples --disable-docs --enable-static-msvcrt
	cd libvpx && mkdir -p build_win64
	@echo "Configuring Win64 build..."
	cd libvpx/build_win64 && ../configure --target=x86_64-win64-vs16 --disable-examples --disable-docs --enable-static-msvcrt
	cd libvpx/build_win32 && make
	cd libvpx/build_win64 && make
	cd libvpx/build_win32 && sed -i -e "s/<OutDir>.*/<OutDir>..\\\lib\\\\\$$(PlatformName)<\/OutDir>/" vpx.vcxproj
	cd libvpx/build_win64 && sed -i -e "s/<OutDir>.*/<OutDir>..\\\lib\\\\\$$(PlatformName)<\/OutDir>/" vpx.vcxproj
	@echo "Copy yasm.exe for 32-bit to build_win32"
	@echo "Copy yasm.exe for 64-bit to build_win64"

ogg-clean:
	cd ogg && git clean -xdf .

ogg-uninstall:
	rm -rf $(TTLIBS_ROOT)/ogg

ogg-build:
	cd ogg && ./autogen.sh $(GENFLAGS) && git checkout $(BRANCH) && \
	./configure $(CFGFLAGS) --prefix=$(TTLIBS_ROOT)/ogg && $(MAKE) install -j$(JOBS)

ogg-deb64:
	$(MAKE) BRANCH=v1.3.2 CFGFLAGS="--with-pic" ogg-build

ogg-deb32:
	$(MAKE) BRANCH=v1.3.2 ogg-build

ogg-raspi3:
	$(MAKE) BRANCH=v1.3.2 ogg-build

ogg-mac:
	$(MAKE) BRANCH=v1.3.2 CFGFLAGS=$(MACCFGFLAGS) ogg-build

ogg-build-android:
	cd ogg && ./autogen.sh $(GENFLAGS) && git checkout $(BRANCH) && \
	./configure $(CFGFLAGS) --prefix=$(TTLIBS_ROOT)/ogg && $(MAKE) install-exec install-data -j$(JOBS)

ogg-android-armeabi-v7a:
	$(MAKE) BRANCH=v1.3.3 GENFLAGS="--host=arm-linux-androideabi" CFGFLAGS="--host=arm-linux-androideabi --disable-shared CC='clang --target=armv7a-linux-android21'" ogg-build-android

ogg-android-arm64:
	$(MAKE) BRANCH=v1.3.3 GENFLAGS="--host=aarch64-linux-android" CFGFLAGS="--host=aarch64-linux-android --disable-shared CC='clang --target=aarch64-linux-android21'" ogg-build-android

ogg-android-x86:
	$(MAKE) BRANCH=v1.3.3 GENFLAGS="--host=i686-linux-android" CFGFLAGS="--with-pic --host=i686-linux-android --disable-shared CC='clang --target=i686-linux-android21'" ogg-build-android

ogg-android-x64:
	$(MAKE) BRANCH=v1.3.3 GENFLAGS="--host=x86_64-linux-android" CFGFLAGS="--with-pic --host=x86_64-linux-android --disable-shared CC='clang --target=x86_64-linux-android21'" ogg-build-android

ogg-win:
	cd ogg && git checkout e558913

ogg-ios-armv7:
	$(MAKE) BRANCH=v1.3.3 GENFLAGS="--host=arm-apple-darwin" CFGFLAGS="--host=arm-apple-darwin" ogg-build
ogg-ios-arm64:
	$(MAKE) BRANCH=v1.3.3 GENFLAGS="--host=arm-apple-darwin" CFGFLAGS="--host=arm-apple-darwin" ogg-build
ogg-ios-i386:
	$(MAKE) BRANCH=v1.3.3 GENFLAGS="--host=$(ARCH)" CFGFLAGS="--host=$(ARCH)" ogg-build
ogg-ios-x64:
	$(MAKE) BRANCH=v1.3.3 GENFLAGS="--host=$(ARCH)" CFGFLAGS="--host=$(ARCH)" ogg-build

opus-clean:
	cd opus && git clean -xdf .

opus-uninstall:
	rm -rf $(TTLIBS_ROOT)/opus

opus-build:
	cd opus && git checkout v1.3 && ./autogen.sh $(GENFLAGS) && \
	./configure $(CFGFLAGS) --prefix=$(TTLIBS_ROOT)/opus && $(MAKE) install -j$(JOBS)

opus-deb64:
	$(MAKE) CFGFLAGS="--with-pic" opus-build

opus-deb32: opus-build

opus-raspi3:
	$(MAKE) CFGFLAGS="--enable-fixed-point" opus-build

opus-android-armeabi-v7a:
	$(MAKE) GENFLAGS="--host=arm-linux-androideabi" CFGFLAGS="--host=arm-linux-androideabi --enable-fixed-point --disable-extra-programs CC='clang --target=armv7a-linux-android21' --with-pic" opus-build

opus-android-arm64:
	$(MAKE) GENFLAGS="--host=aarch64-linux-android" CFGFLAGS="--host=aarch64-linux-android --enable-fixed-point --disable-extra-programs CC='clang --target=aarch64-linux-android21' --with-pic" opus-build

opus-android-x86:
	$(MAKE) GENFLAGS="--host=i686-linux-android" CFGFLAGS="--host=i686-linux-android --disable-extra-programs CC='clang --target=i686-linux-android21' --with-pic" opus-build

opus-android-x64:
	$(MAKE) GENFLAGS="--host=x86_64-linux-android" CFGFLAGS="--host=x86_64-linux-android --disable-extra-programs CC='clang --target=x86_64-linux-android21' --with-pic" opus-build

opus-ios-armv7:
	$(MAKE) GENFLAGS="--host=arm-apple-darwin" CFGFLAGS="--host=arm-apple-darwin --enable-fixed-point --enable-shared=no --enable-static=yes --disable-extra-programs" opus-build

opus-ios-arm64:
	$(MAKE) GENFLAGS="--host=arm-apple-darwin" CFGFLAGS="--host=arm-apple-darwin --enable-shared=no --enable-static=yes --disable-extra-programs" opus-build

opus-ios-simulator:
	$(MAKE) GENFLAGS="--host=$(ARCH)" CFGFLAGS="--host=$(ARCH) --enable-shared=no --enable-static=yes --disable-extra-programs" opus-build

opus-ios-i386: opus-ios-simulator
opus-ios-x64: opus-ios-simulator

opus-mac:
	$(MAKE) CFGFLAGS=$(MACCFGFLAGS) opus-build

opus-win:
	cd opus && git checkout 41980bc1

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
opus-tools-android-x64: opus-tools-build
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
	--prefix=$(TTLIBS_ROOT)/portaudio && $(MAKE) install

portaudio-deb64:
	$(MAKE) BRANCH=1bdcb9e CFGFLAGS="--with-pic" portaudio-build

portaudio-deb32:
	$(MAKE) BRANCH=1bdcb9e portaudio-build

portaudio-raspi3:
	$(MAKE) BRANCH=1bdcb9e portaudio-build

portaudio-mac:
	$(MAKE) BRANCH=521209c CFGFLAGS="$(MACCFGFLAGS) --disable-mac-universal" portaudio-build

portaudio-win:
	cd portaudio && git checkout 3bd47ce

portaudio-android-armeabi-v7a:
portaudio-android-arm64:
portaudio-android-x86:
portaudio-android-x64:
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
	./configure $(CFGFLAGS) --prefix=$(TTLIBS_ROOT)/speex && $(MAKE) install -j$(JOBS)

speex-deb64:
	$(MAKE) CFGFLAGS="--with-pic" speex-build

speex-deb32: speex-build

speex-mac:
	$(MAKE) CFGFLAGS=$(MACCFGFLAGS) speex-build

speex-raspi3:
	cd speex && git checkout Speex-1.2.0 && ./autogen.sh && \
	./configure --enable-fixed-point --prefix=$(TTLIBS_ROOT)/speex && $(MAKE) install -j$(JOBS)

speex-android-armeabi-v7a:
	$(MAKE) GENFLAGS="--host=arm-linux-androideabi" CFGFLAGS="--disable-binaries --enable-fixed-point --host=arm-linux-androideabi CC='clang --target=armv7a-linux-android21' --with-pic" speex-build

speex-android-arm64:
	$(MAKE) GENFLAGS="--host=aarch64-linux-android" CFGFLAGS="--disable-binaries --enable-fixed-point --host=aarch64-linux-android CC='clang --target=aarch64-linux-android21' --with-pic" speex-build

speex-android-x86:
	$(MAKE) GENFLAGS="--host=i686-linux-android" CFGFLAGS="--disable-binaries --host=i686-linux-android CC='clang --target=i686-linux-android21' --with-pic" speex-build

speex-android-x64:
	$(MAKE) GENFLAGS="--host=x86_64-linux-android" CFGFLAGS="--disable-binaries --host=x86_64-linux-android CC='clang --target=x86_64-linux-android21' --with-pic" speex-build

speex-ios-iphone:
	$(MAKE) GENFLAGS="--host=arm-apple-darwin" CFGFLAGS="--enable-shared=no --enable-static=yes --disable-binaries --enable-fixed-point --host=arm-apple-darwin" speex-build

speex-ios-armv7: speex-ios-iphone
speex-ios-arm64: speex-ios-iphone

speex-ios-simulator:
	$(MAKE) GENFLAGS="--host=$(ARCH)" CFGFLAGS="--host=$(ARCH) --enable-shared=no --enable-static=yes --disable-binaries" speex-build

speex-ios-i386: speex-ios-simulator

speex-ios-x64: speex-ios-simulator

speex-win:
	cd speex && git checkout 62ad6a6

speexdsp-clean:
	cd speexdsp && git clean -xdf .

speexdsp-uninstall:
	rm -rf $(TTLIBS_ROOT)/speex

speexdsp-build:
	cd speexdsp && git checkout SpeexDSP-1.2.0 && ./autogen.sh $(GENFLAGS) && \
	./configure $(CFGFLAGS) --prefix=$(TTLIBS_ROOT)/speex && $(MAKE) install -j$(JOBS)

speexdsp-mac:
	$(MAKE) CFGFLAGS=$(MACCFGFLAGS) speexdsp-build

speexdsp-deb64:
	$(MAKE) CFGFLAGS="--with-pic" speexdsp-build

speexdsp-deb32:
	cd speexdsp && git checkout 4691839 && ./autogen.sh && \
	./configure --prefix=$(TTLIBS_ROOT)/speex && $(MAKE) install -j$(JOBS)

speexdsp-raspi3:
	$(MAKE) CFGFLAGS=--enable-fixed-point speexdsp-build

speexdsp-win:
	cd speexdsp && git checkout 2907b00

speexdsp-android-armeabi-v7a:
	$(MAKE) GENFLAGS="--host=arm-linux-androideabi" CFGFLAGS="--host=arm-linux-androideabi --enable-fixed-point --enable-neon --disable-examples CC='clang --target=armv7a-linux-android21 -mfloat-abi=softfp -mfpu=neon' --with-pic" speexdsp-build

speexdsp-android-arm64:
	$(MAKE) GENFLAGS="--host=aarch64-linux-android" CFGFLAGS="--host=aarch64-linux-android --enable-fixed-point --disable-neon --disable-examples CC='clang --target=aarch64-linux-android21' --with-pic" speexdsp-build

speexdsp-android-x86:
	$(MAKE) GENFLAGS="--host=i686-linux-android" CFGFLAGS="--host=i686-linux-android --disable-neon --disable-examples CC='clang --target=i686-linux-android21' --with-pic" speexdsp-build

speexdsp-android-x64:
	$(MAKE) GENFLAGS="--host=x86_64-linux-android" CFGFLAGS="--host=x86_64-linux-android --disable-neon --disable-examples CC='clang --target=x86_64-linux-android21' --with-pic" speexdsp-build

speexdsp-ios-armv7:
	$(MAKE) GENFLAGS="--host=arm-apple-darwin" CFGFLAGS="--host=arm-apple-darwin --enable-fixed-point --enable-shared=no --enable-static=yes --enable-neon" speexdsp-build

speexdsp-ios-arm64:
	$(MAKE) GENFLAGS="--host=arm-apple-darwin" CFGFLAGS="--host=arm-apple-darwin --enable-shared=no --enable-static=yes --disable-neon" speexdsp-build

speexdsp-ios-simulator:
	$(MAKE) GENFLAGS="--host=$(ARCH)" CFGFLAGS="--host=$(ARCH) --enable-shared=no --enable-static=yes" speexdsp-build

speexdsp-ios-i386: speexdsp-ios-simulator
speexdsp-ios-x64: speexdsp-ios-simulator

tinyxml-clean:
	cd tinyxml && git clean -xdf .
tinyxml-uninstall:
	rm -rf $(TTLIBS_ROOT)/tinyxml

tinyxml-build:
	cd tinyxml && git checkout $(BRANCH) && $(MAKE)
	ln -fs $(PWD)/tinyxml $(TTLIBS_ROOT)/tinyxml

tinyxml-deb64:
	$(MAKE) BRANCH=bdr/deb64 tinyxml-build

tinyxml-deb32:
	$(MAKE) BRANCH=bdr/deb32 tinyxml-build

tinyxml-raspi3: tinyxml-deb32

tinyxml-win:
	cd tinyxml && git checkout bdr/win32

tinyxml-android-armeabi-v7a:
tinyxml-android-arm64:
tinyxml-android-x86:
tinyxml-android-x64:
tinyxml-ios-armv7:
tinyxml-ios-arm64:
tinyxml-ios-i386:
tinyxml-ios-x64:

tinyxml-mac:
	cd tinyxml && git checkout bdr/mac && $(MAKE) CPPFLAGS="-isysroot $(SDK) -fPIC -g -m64 $(MACMINVERSION) -std=c++11"
	ln -fs $(PWD)/tinyxml $(TTLIBS_ROOT)/tinyxml

zlib-clean:
	cd zlib && git clean -xdf .
zlib-uninstall:
	rm -rf $(TTLIBS_ROOT)/zlib

zlib-build:
	cd zlib && git checkout $(BRANCH) && $(CFGFLAGS) ./configure --prefix=$(TTLIBS_ROOT)/zlib --static && $(MAKE) install

zlib-deb64:
	$(MAKE) BRANCH=v1.2.9 CFGFLAGS="CFLAGS=-fPIC" zlib-build

zlib-deb32:
	$(MAKE) BRANCH=v1.2.9 zlib-build

zlib-mac:
	$(MAKE) BRANCH=v1.2.9 CFGFLAGS=$(MACCFGFLAGS) zlib-build

zlib-raspi3:
	$(MAKE) BRANCH=v1.2.9 zlib-build

zlib-win:
	cd zlib && git checkout 56c3219

zlib-android-armeabi-v7a:
zlib-android-arm64:
zlib-android-x86:
zlib-android-x64:
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
Catch2-android-arm64: catch-build
Catch2-android-x86: catch-build
Catch2-android-x64: catch-build
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
qt5-android-x64:
qt5-win:
	cd qt5 && git checkout v5.15.1
	cd qt5 && git submodule update --init qtbase qttools qtmultimedia qtactiveqt qtspeech
	sed -i -e "s/-MD/-MT/" qt5/qtbase/mkspecs/common/msvc-desktop.conf
	# -opensource -confirm-license -static -nomake examples -openssl-linked -IC:\tt5dist\toolchain\build\openssl\lib\x64\include "OPENSSL_LIBS= -LC:\tt5dist\toolchain\build\openssl\lib\x64\lib -lUser32 -lAdvapi32 -lGdi32 -lCrypt32 -lws2_32 -llibssl -llibcrypto" -prefix C:\tt5dist\toolchain\build\qt5\..\..\Qt-5.15.1_x64

qt5-uninstall:
qt5-clean:
	cd qt5 && git clean -xdf .
	cd qt5/qtbase && git clean -xdf .
	cd qt5/qttools && git clean -xdf .
	cd qt5/qtmultimedia && git clean -xdf .
	cd qt5/qtactiveqt && git clean -xdf .
	cd qt5/qtspeech && git clean -xdf .

prepare-webrtc: webrtc-erase
	git submodule update --init --recursive depot_tools
	@echo "Cloning WebRTC"
	$(MAKE) PATH="$(PWD)/depot_tools:$(PATH)" webrtc-clone
	@echo "Done..."

prepare-webrtc-android: webrtc-erase
	git submodule update --init --recursive depot_tools
	@echo "Cloning WebRTC"
	$(MAKE) PATH="$(PWD)/depot_tools:$(PATH)" webrtc-clone-android
	@echo "Done..."

prepare-webrtc-ios: webrtc-erase
	git submodule update --init --recursive depot_tools
	@echo "Cloning WebRTC"
	$(MAKE) PATH="$(PWD)/depot_tools:$(PATH)" webrtc-clone-ios
	@echo "Done..."

webrtc-clone:
	cd webrtc && fetch --nohooks webrtc && gclient sync --with_branch_heads --with_tags && git fetch

webrtc-clone-android:
	cd webrtc && fetch --nohooks webrtc_android && gclient sync --with_branch_heads --with_tags && git fetch

webrtc-clone-ios:
	cd webrtc && fetch --nohooks webrtc_ios && gclient sync --with_branch_heads --with_tags && git fetch

webrtc-erase:
	cd webrtc && git clean -xdf .
	cd webrtc && rm -rf src

webrtc-win:
	@echo "Run webrtc/build_win.bat from Visual Studio Command Prompt"

webrtc-unpatch:
	cd webrtc/src && git checkout modules/audio_processing/BUILD.gn

webrtc-patch: webrtc-unpatch
	cd webrtc/src && test -e $(PATCHFILE) && git apply $(PATCHFILE)

webrtc-copy:
	rm -rf $(TTLIBS_ROOT)/webrtc/include
	mkdir $(TTLIBS_ROOT)/webrtc/include
	cd webrtc/src && find . -type f -name "*.h" -exec cp --parents \{\} $(TTLIBS_ROOT)/webrtc/include/ \;
	@echo "$(TTLIBS_ROOT)/build/webrtc/src can now be deleted"

webrtc-copy-mac:
	rm -rf $(TTLIBS_ROOT)/webrtc/include
	mkdir $(TTLIBS_ROOT)/webrtc/include
	cd webrtc/src && find . -type f -name "*.h" -exec ditto \{\} $(TTLIBS_ROOT)/webrtc/include/\{\} \;
	@echo "$(TTLIBS_ROOT)/build/webrtc/src can now be deleted"

webrtc-android: webrtc-unpatch
	cd webrtc/src && git fetch -t -p && git checkout branch-heads/4332
	$(MAKE) PATCHFILE=../libteamtalk-r4332.patch webrtc-patch
	export PATH=$(PWD)/depot_tools:$(PATH) && cd webrtc/src && gclient sync -D && \
	gn gen $(TTLIBS_ROOT)/webrtc --args='target_os="android" target_cpu="$(ARCH)" is_component_build=false is_debug=false rtc_include_tests=false is_clang=false treat_warnings_as_errors=false use_custom_libcxx=false rtc_disable_logging=true rtc_exclude_field_trial_default=true rtc_enable_protobuf=false rtc_enable_sctp=false gtest_enable_absl_printers=false rtc_include_tests=false rtc_build_examples=false rtc_build_libvpx=false rtc_libvpx_build_vp9=false rtc_build_opus=false rtc_include_opus=false rtc_build_ssl=false rtc_builtin_ssl_root_certificates=false rtc_ssl_root="$(TTLIBS_ROOT)/openssl/include" rtc_include_builtin_video_codecs=false' && \
	ninja -v -C $(TTLIBS_ROOT)/webrtc teamtalk
	$(MAKE) webrtc-copy

webrtc-android-armeabi-v7a:
	$(MAKE) ARCH=arm webrtc-android

webrtc-android-arm64:
	$(MAKE) ARCH=arm64 webrtc-android

webrtc-android-x86:
	$(MAKE) ARCH=x86 webrtc-android

webrtc-android-x64:
	$(MAKE) ARCH=x64 webrtc-android

webrtc-deb64: webrtc-unpatch
	cd webrtc/src && git fetch -t -p && git checkout branch-heads/4332
	$(MAKE) PATCHFILE=../libteamtalk-r4332.patch webrtc-patch
	export PATH=$(PWD)/depot_tools:$(PATH) && cd webrtc/src && gclient sync -D && \
	gn gen $(TTLIBS_ROOT)/webrtc --args='is_clang=false is_debug=false treat_warnings_as_errors=false use_custom_libcxx=false use_udev=false use_aura=false use_ozone=false rtc_use_x11=false rtc_use_x11_extensions=false rtc_disable_logging=true rtc_exclude_field_trial_default=true rtc_enable_protobuf=false rtc_enable_sctp=false gtest_enable_absl_printers=false rtc_use_gtk=false is_component_build=false use_rtti=true rtc_include_tests=false rtc_build_examples=false rtc_build_libvpx=false rtc_libvpx_build_vp9=false rtc_build_opus=false rtc_include_opus=false rtc_build_ssl=false rtc_builtin_ssl_root_certificates=false rtc_ssl_root="/dev/null"' && \
	ninja -v -C $(TTLIBS_ROOT)/webrtc teamtalk && gn gen -ide=qtcreator $(TTLIBS_ROOT)/webrtc
	$(MAKE) webrtc-copy

webrtc-mac: webrtc-unpatch
	cd webrtc/src && git fetch -t -p && git checkout branch-heads/4332
	$(MAKE) PATCHFILE=../libteamtalk-r4332.patch webrtc-patch
	export PATH=$(PWD)/depot_tools:$(PATH) && cd webrtc/src && gclient sync -D && \
	gn gen $(TTLIBS_ROOT)/webrtc --args='is_clang=false treat_warnings_as_errors=false use_aura=false use_ozone=false rtc_disable_logging=true rtc_exclude_field_trial_default=true rtc_enable_protobuf=false rtc_enable_sctp=false gtest_enable_absl_printers=false is_component_build=false use_rtti=true rtc_include_tests=false rtc_build_examples=false rtc_build_libvpx=false rtc_libvpx_build_vp9=false rtc_build_opus=false rtc_include_opus=false rtc_build_ssl=false rtc_builtin_ssl_root_certificates=false rtc_ssl_root="$(TTLIBS_ROOT)/openssl/include" rtc_include_builtin_video_codecs=false is_debug=false clang_base_path="$(shell xcode-select -p)/Toolchains/XcodeDefault.xctoolchain/usr" use_custom_libcxx=false libcxx_is_shared=true' && \
	ninja -v -C $(TTLIBS_ROOT)/webrtc teamtalk && gn gen -ide=qtcreator $(TTLIBS_ROOT)/webrtc
	$(MAKE) webrtc-copy-mac

webrtc-ios: webrtc-unpatch
	cd webrtc/src && git fetch -t -p && git checkout branch-heads/4332
	$(MAKE) PATCHFILE=../libteamtalk-r4332.patch webrtc-patch
	export PATH=$(PWD)/depot_tools:$(PATH) && cd webrtc/src && gclient sync -D && \
	gn gen $(TTLIBS_ROOT)/webrtc --args='$(ARGSEXTRA) target_os="ios" target_cpu="$(IOSARCH)" enable_dsyms=true enable_ios_bitcode=true use_xcode_clang=true ios_deployment_target="7.0" treat_warnings_as_errors=false use_aura=false use_ozone=false rtc_disable_logging=true rtc_exclude_field_trial_default=true rtc_enable_protobuf=false rtc_enable_sctp=false gtest_enable_absl_printers=false is_component_build=false use_rtti=true rtc_include_tests=false rtc_build_examples=false rtc_build_libvpx=false rtc_libvpx_build_vp9=false rtc_build_opus=false rtc_include_opus=false rtc_build_ssl=false rtc_builtin_ssl_root_certificates=false rtc_ssl_root="$(TTLIBS_ROOT)/openssl/include" rtc_include_builtin_video_codecs=false is_debug=false clang_base_path="$(shell xcode-select -p)/Toolchains/XcodeDefault.xctoolchain/usr" use_custom_libcxx=false libcxx_is_shared=true' && \
	ninja -v -C $(TTLIBS_ROOT)/webrtc teamtalk && gn gen -ide=qtcreator $(TTLIBS_ROOT)/webrtc
	$(MAKE) webrtc-copy-mac

webrtc-ios-i386:
	$(MAKE) IOSARCH=x86 webrtc-ios

webrtc-ios-x64:
	$(MAKE) IOSARCH=x64 webrtc-ios

webrtc-ios-armv7:
	$(MAKE) IOSARCH=arm ARGSEXTRA="arm_use_neon=true" webrtc-ios

webrtc-ios-arm64:
	$(MAKE) IOSARCH=arm64 webrtc-ios

webrtc-args:
	export PATH=$(PWD)/depot_tools:$(PATH) && cd webrtc/src && gn args --list $(TTLIBS_ROOT)/webrtc

webrtc-clean:
	export PATH=$(PWD)/depot_tools:$(PATH) && cd webrtc/src && git clean -xdf .

webrtc-uninstall:
	rm -rf $(TTLIBS_ROOT)/webrtc
