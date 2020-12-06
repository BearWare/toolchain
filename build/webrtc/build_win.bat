@ECHO ------------------------------------------------------------------
@ECHO Build WebRTC for TeamTalk
@ECHO ------------------------------------------------------------------
@ECHO Ensure 'Windows Search' (WSearch) service is Disabled and Stopped.
@ECHO Failure to do so may result in file system errors.
@ECHO ------------------------------------------------------------------
@ECHO This Command Prompt must run in Visual Studio x86 or x64 mode
@PAUSE
@ECHO ------------------------------------------------------------------
@ECHO Download 'depot_tools' from Chromium Projects and extract it in C:\webrtc\depot_tools.
@ECHO Trying to place WebRTC in another directory will most likely give problems.
@PAUSE

@SET WEBRTC_ROOT=C:\webrtc
@SET TTLIBS_ROOT=%CD%\..
@SET INITWEBRTC=%CD%
@SET DEPOT_TOOLS_WIN_TOOLCHAIN=0
@ECHO Adding depot_tools to PATH
CD %WEBRTC_ROOT%\depot_tools
SET PATH=%CD%;%PATH%
@ECHO ------------------------------------------------------------------
@ECHO Cloning WebRTC is a slow process so here's a menu to skip steps.
@ECHO Start at 1 if this is the first time running this BAT file.
@CHOICE /C:1234 /M "1 for Clone WebRTC, 2 for checkout WebRTC, 3 for Generate GN files, 4 for Build"
@IF %ERRORLEVEL% == 1 GOTO clone
@IF %ERRORLEVEL% == 2 GOTO checkout
@IF %ERRORLEVEL% == 3 GOTO gengnfiles
@IF %ERRORLEVEL% == 4 GOTO build

:clone
@ECHO ------------------------------------------------------------------
@ECHO Fetching WebRTC repository. This will take a long time.
CD %WEBRTC_ROOT%
CALL fetch --nohooks webrtc

:checkout
@ECHO ------------------------------------------------------------------
@ECHO Checking out branch
CD %WEBRTC_ROOT%\src
CALL git checkout branch-heads/4093
@ECHO Synchronizing checkout
CALL gclient sync -D --with_branch_heads --with_tags
@ECHO ------------------------------------------------------------------
@ECHO Applying patch to build TeamTalk.lib
CALL git checkout modules/audio_processing/BUILD.gn
CALL git apply %INITWEBRTC%\libteamtalk-r4093.patch

:gengnfiles
@ECHO ------------------------------------------------------------------
@ECHO Set up Visual Studio version for WebRTC
@CHOICE /C:12 /M "1 for VS2015, 2 for VS2019"
@IF %ERRORLEVEL% == 1 GOTO vs2015
@IF %ERRORLEVEL% == 2 GOTO vs2019
:vs2015
SET vs2015_install=%VSINSTALLDIR%
@GOTO done
:vs2019
SET vs2019_install=%VSINSTALLDIR%
@GOTO done

:done
@CHOICE /C:12 /M "1 for x86, 2 for x86_64"
@IF %ERRORLEVEL% == 1 GOTO win32
@IF %ERRORLEVEL% == 2 GOTO win64

:win32
@SET ARCH=x86
@GOTO generate
:win64
@SET ARCH=x64
@GOTO generate

:generate
@ECHO ------------------------------------------------------------------
CD %WEBRTC_ROOT%\src
CALL gn gen %INITWEBRTC%\debug --args="is_clang=false target_cpu=\"%ARCH%\" rtc_disable_logging=true rtc_exclude_field_trial_default=true rtc_enable_protobuf=false rtc_enable_sctp=false rtc_include_tests=false rtc_build_examples=false rtc_build_libvpx=false rtc_libvpx_build_vp9=false rtc_include_opus=false rtc_build_ssl=false rtc_builtin_ssl_root_certificates=false rtc_ssl_root=\"%TTLIBS_ROOT%\openssl\include\" is_debug=true use_custom_libcxx=false enable_iterator_debugging=true"

CALL gn gen %INITWEBRTC%\release --args="is_clang=false target_cpu=\"%ARCH%\" rtc_disable_logging=true rtc_exclude_field_trial_default=true rtc_enable_protobuf=false rtc_enable_sctp=false rtc_include_tests=false rtc_build_examples=false rtc_build_libvpx=false rtc_libvpx_build_vp9=false rtc_include_opus=false rtc_build_ssl=false rtc_builtin_ssl_root_certificates=false rtc_ssl_root=\"%TTLIBS_ROOT%\openssl\include\" is_debug=false use_custom_libcxx=false"

:build
@ECHO ------------------------------------------------------------------
CD %WEBRTC_ROOT%\src
CALL ninja -v -C %INITWEBRTC%\debug teamtalk
CALL ninja -v -C %INITWEBRTC%\release teamtalk

:copyfiles
CD %WEBRTC_ROOT%\src
DEL /S /Q %INITWEBRTC%\include
MKDIR %INITWEBRTC%\include
XCOPY *.h /S %INITWEBRTC%\include

@ECHO ------------------------------------------------------------------
@ECHO Finishing building WebRTC for TeamTalk
@ECHO You can now delete %WEBRTC_ROOT%
