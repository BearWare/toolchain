@set TTLIBS_ROOT=%CD%
@set CMAKEDIR=C:\Program Files\CMake\bin
@set PATH=%PATH%;%CMAKEDIR%;

@if %Platform% == x86 GOTO win32
@if %Platform% == x64 GOTO win64

@echo Environment variable 'Platform' is not specified.
@echo Ensure bat-file is called from Visual Studio 2019 Command Prompt (x86 or x64).
GOTO buildfail

:win32
@set ARCH=win32
goto archdone

:win64
@set ARCH=win64
goto archdone

:archdone
@set MSBUILD_PLATFORM=/property:PlatformToolset=v142 /p:Platform=%ARCH%
@set VSGENERATE=-G "Visual Studio 16 2019" -A %ARCH%

:depend
perl -v
@if not %ERRORLEVEL% == 0 GOTO noperl
cmake --version
@if not %ERRORLEVEL% == 0 GOTO nocmake
msbuild /version
@if not %ERRORLEVEL% == 0 GOTO nomsbuild

:openssl
@echo --------------------------------------------------
@echo ----------- Building OpenSSL ---------------------
@cd %TTLIBS_ROOT%
cd openssl
call build_%ARCH%.bat
@if not %ERRORLEVEL% == 0 GOTO buildfail

:ace
@echo --------------------------------------------------
@echo --------------- Building ACE ---------------------
@cd %TTLIBS_ROOT%
cd ACE\ACE
call build.bat
@if not %ERRORLEVEL% == 0 GOTO buildfail
msbuild %MSBUILD_PLATFORM% ace\ace.sln -target:ACE /property:Configuration=Debug /m:4
@if not %ERRORLEVEL% == 0 GOTO buildfail
msbuild %MSBUILD_PLATFORM% ace\ace.sln -target:SSL /property:Configuration=Debug /m:4
@if not %ERRORLEVEL% == 0 GOTO buildfail
msbuild %MSBUILD_PLATFORM% ace\ace.sln -target:ACE /property:Configuration=Release /m:4
@if not %ERRORLEVEL% == 0 GOTO buildfail
msbuild %MSBUILD_PLATFORM% ace\ace.sln -target:SSL /property:Configuration=Release /m:4
@if not %ERRORLEVEL% == 0 GOTO buildfail
msbuild %MSBUILD_PLATFORM% protocols\protocols.sln -target:INet /property:Configuration=Debug /m:4
@if not %ERRORLEVEL% == 0 GOTO buildfail
msbuild %MSBUILD_PLATFORM% protocols\protocols.sln -target:INet_SSL /property:Configuration=Debug /m:4
@if not %ERRORLEVEL% == 0 GOTO buildfail
msbuild %MSBUILD_PLATFORM% protocols\protocols.sln -target:INet /property:Configuration=Release /m:4
@if not %ERRORLEVEL% == 0 GOTO buildfail
msbuild %MSBUILD_PLATFORM% protocols\protocols.sln -target:INet_SSL /property:Configuration=Release /m:4
@if not %ERRORLEVEL% == 0 GOTO buildfail

:libvpx
@echo --------------------------------------------------
@echo ------------ Building libvpx ---------------------
@cd %TTLIBS_ROOT%
cd libvpx\build_%ARCH%
yasm.exe --version
@if not %ERRORLEVEL% == 0 GOTO noyasm
msbuild %MSBUILD_PLATFORM% vpx.sln -target:vpx /property:Configuration=Debug /m:4
@if not %ERRORLEVEL% == 0 GOTO buildfail
msbuild %MSBUILD_PLATFORM% vpx.sln -target:vpx /property:Configuration=Release /m:4
@if not %ERRORLEVEL% == 0 GOTO buildfail

:ogg
@echo --------------------------------------------------
@echo ------------- Building ogg -----------------------
@cd %TTLIBS_ROOT%
mkdir ogg\build_%ARCH%
cd ogg\build_%ARCH%
cmake %VSGENERATE% -DCMAKE_SYSTEM_VERSION=10.0 ..
msbuild %MSBUILD_PLATFORM% libogg.sln -target:ogg /property:Configuration=Debug /m:4
@if not %ERRORLEVEL% == 0 GOTO buildfail
msbuild %MSBUILD_PLATFORM% libogg.sln -target:ogg /property:Configuration=Release /m:4
@if not %ERRORLEVEL% == 0 GOTO buildfail

:opus
@echo --------------------------------------------------
@echo ------------ Building opus -----------------------
@cd %TTLIBS_ROOT%
mkdir opus\build_%ARCH%
cd opus\build_%ARCH%
cmake %VSGENERATE% -DCMAKE_SYSTEM_VERSION=10.0 ..
msbuild %MSBUILD_PLATFORM% opus.sln -target:opus /property:Configuration=Debug /m:4
@if not %ERRORLEVEL% == 0 GOTO buildfail
msbuild %MSBUILD_PLATFORM% opus.sln -target:opus /property:Configuration=Release /m:4
@if not %ERRORLEVEL% == 0 GOTO buildfail

:portaudio
@echo --------------------------------------------------
@echo ------------ Building portaudio ------------------
@cd %TTLIBS_ROOT%
mkdir portaudio\build_%ARCH%
cd portaudio\build_%ARCH%
cmake %VSGENERATE% -DCMAKE_SYSTEM_VERSION=10.0 ..
msbuild %MSBUILD_PLATFORM% portaudio.sln -target:Portaudio\portaudio_static /property:Configuration=Debug /m:4
@if not %ERRORLEVEL% == 0 GOTO buildfail
msbuild %MSBUILD_PLATFORM% portaudio.sln -target:Portaudio\portaudio_static /property:Configuration=Release /m:4
@if not %ERRORLEVEL% == 0 GOTO buildfail

:speex
@echo --------------------------------------------------
@echo ---------------- Building speex ------------------
@cd %TTLIBS_ROOT%
cd speex
msbuild %MSBUILD_PLATFORM% win32\VS2015\libspeex\libspeex.sln -target:libspeex /property:Configuration=Debug /m:4
@if not %ERRORLEVEL% == 0 GOTO buildfail
msbuild %MSBUILD_PLATFORM% win32\VS2015\libspeex\libspeex.sln -target:libspeex /property:Configuration=Release_SSE2 /m:4
@if not %ERRORLEVEL% == 0 GOTO buildfail

:speexdsp
@echo --------------------------------------------------
@echo ------------- Building speexdsp ------------------
@cd %TTLIBS_ROOT%
cd speexdsp
msbuild %MSBUILD_PLATFORM% win32\VS2015\libspeexdsp.sln -target:libspeexdsp /property:Configuration=Debug /m:4
@if not %ERRORLEVEL% == 0 GOTO buildfail
msbuild %MSBUILD_PLATFORM% win32\VS2015\libspeexdsp.sln -target:libspeexdsp /property:Configuration=Release_SSE /m:4
@if not %ERRORLEVEL% == 0 GOTO buildfail

:tinyxml
@echo --------------------------------------------------
@echo -------------- Building tinyxml ------------------
@cd %TTLIBS_ROOT%
cd tinyxml
msbuild %MSBUILD_PLATFORM% tinyxml.sln -target:tinyxml /property:Configuration=Debug /m:4
@if not %ERRORLEVEL% == 0 GOTO buildfail
msbuild %MSBUILD_PLATFORM% tinyxml.sln -target:tinyxml /property:Configuration=Release /m:4
@if not %ERRORLEVEL% == 0 GOTO buildfail

:zlib
@echo --------------------------------------------------
@echo ----------------- Building zlib ------------------
@cd %TTLIBS_ROOT%
cd zlib
msbuild %MSBUILD_PLATFORM% contrib\vstudio\vc14\zlibvc.sln -target:zlibstat /property:Configuration=Debug /m:4
@if not %ERRORLEVEL% == 0 GOTO buildfail
msbuild %MSBUILD_PLATFORM% contrib\vstudio\vc14\zlibvc.sln -target:zlibstat /property:Configuration=ReleaseWithoutASM /m:4
@if not %ERRORLEVEL% == 0 GOTO buildfail

goto done

:qt5
@echo --------------------------------------------------
@echo ----------------- Building Qt --------------------
@cd %TTLIBS_ROOT%
@set OPENSSL=%TTLIBS_ROOT%\openssl
cd qt5
configure.bat -opensource -confirm-license -static -nomake examples -openssl-linked -I%OPENSSL%\include OPENSSL_LIBS=" -L%OPENSSL% -lUser32 -lAdvapi32 -lGdi32 -lCrypt32 -lws2_32 -llibssl -llibcrypto" -prefix %CD%\..\..\Qt-5.14.0
@if not %ERRORLEVEL% == 0 GOTO buildfail
nmake
@if not %ERRORLEVEL% == 0 GOTO buildfail
nmake install
@if not %ERRORLEVEL% == 0 GOTO buildfail

goto done

:noperl
@echo Perl.exe is not in PATH
goto quit

:nocmake
@echo CMake.exe is not in PATH
goto quit

:nomsbuild
@echo msbuild.exe is not in PATH
goto quit

:noyasm
@echo Yasm.exe not found in libvpx\build_%ARCH%
goto quit

:buildfail
@echo Build Failed
goto quit

:done
@echo Build completed
goto quit

:quit
@echo Exiting...
