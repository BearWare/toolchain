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
@set GENARCH=win32
goto archdone

:win64
@set ARCH=win64
@set GENARCH=x64
goto archdone

:archdone
@set MSBUILD_PLATFORM=/property:PlatformToolset=v142 /p:Platform=%GENARCH%
@set VSGENERATE=-G "Visual Studio 16 2019" -A %GENARCH%

:depend
perl -v
@if not %ERRORLEVEL% == 0 GOTO noperl
cmake --version
@if not %ERRORLEVEL% == 0 GOTO nocmake
msbuild /version
@if not %ERRORLEVEL% == 0 GOTO nomsbuild

echo.
echo Choose what to build. Default is All minus Qt
@set BUILDSEL=single
@choice /C:da0123456789b /M "D:Default; A:All; 0:OpenSSL; 1:ACE; 2:libvpx; 3:ogg; 4:Opus; 5:PortAudio; 6:Speex; 7:SpeexDSP; 8:TinyXML; 9:ZLib; B:Qt;"
@if %ERRORLEVEL% == 1 set BUILDSEL=default
@if %ERRORLEVEL% == 2 set BUILDSEL=all
@if %ERRORLEVEL% == 3 goto openssl
@if %ERRORLEVEL% == 4 goto ace
@if %ERRORLEVEL% == 5 goto libvpx
@if %ERRORLEVEL% == 6 goto ogg
@if %ERRORLEVEL% == 7 goto opus
@if %ERRORLEVEL% == 8 goto portaudio
@if %ERRORLEVEL% == 9 goto speex
@if %ERRORLEVEL% == 10 goto speexdsp
@if %ERRORLEVEL% == 11 goto tinyxml
@if %ERRORLEVEL% == 12 goto zlib
@if %ERRORLEVEL% == 13 goto qt


:openssl
@echo --------------------------------------------------
@echo ----------- Building OpenSSL ---------------------
@cd %TTLIBS_ROOT%
cd openssl
call build_%ARCH%.bat
@if not %ERRORLEVEL% == 0 GOTO buildfail

@if %BUILDSEL% == single goto done

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

@if %BUILDSEL% == single goto done

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

@if %BUILDSEL% == single goto done

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

@if %BUILDSEL% == single goto done

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

@if %BUILDSEL% == single goto done

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

@if %BUILDSEL% == single goto done

:speex
@echo --------------------------------------------------
@echo ---------------- Building speex ------------------
@cd %TTLIBS_ROOT%
cd speex
msbuild %MSBUILD_PLATFORM% win32\VS2015\libspeex\libspeex.sln -target:libspeex /property:Configuration=Debug /m:4
@if not %ERRORLEVEL% == 0 GOTO buildfail
msbuild %MSBUILD_PLATFORM% win32\VS2015\libspeex\libspeex.sln -target:libspeex /property:Configuration=Release_SSE2 /m:4
@if not %ERRORLEVEL% == 0 GOTO buildfail

@if %BUILDSEL% == single goto done

:speexdsp
@echo --------------------------------------------------
@echo ------------- Building speexdsp ------------------
@cd %TTLIBS_ROOT%
cd speexdsp
msbuild %MSBUILD_PLATFORM% win32\VS2015\libspeexdsp.sln -target:libspeexdsp /property:Configuration=Debug /m:4
@if not %ERRORLEVEL% == 0 GOTO buildfail
msbuild %MSBUILD_PLATFORM% win32\VS2015\libspeexdsp.sln -target:libspeexdsp /property:Configuration=Release_SSE /m:4
@if not %ERRORLEVEL% == 0 GOTO buildfail

@if %BUILDSEL% == single goto done

:tinyxml
@echo --------------------------------------------------
@echo -------------- Building tinyxml ------------------
@cd %TTLIBS_ROOT%
cd tinyxml
msbuild %MSBUILD_PLATFORM% tinyxml.sln -target:tinyxml /property:Configuration=Debug /m:4
@if not %ERRORLEVEL% == 0 GOTO buildfail
msbuild %MSBUILD_PLATFORM% tinyxml.sln -target:tinyxml /property:Configuration=Release /m:4
@if not %ERRORLEVEL% == 0 GOTO buildfail

@if %BUILDSEL% == single goto done

:zlib
@echo --------------------------------------------------
@echo ----------------- Building zlib ------------------
@cd %TTLIBS_ROOT%
cd zlib
msbuild %MSBUILD_PLATFORM% contrib\vstudio\vc14\zlibvc.sln -target:zlibstat /property:Configuration=Debug /m:4
@if not %ERRORLEVEL% == 0 GOTO buildfail
msbuild %MSBUILD_PLATFORM% contrib\vstudio\vc14\zlibvc.sln -target:zlibstat /property:Configuration=ReleaseWithoutASM /m:4
@if not %ERRORLEVEL% == 0 GOTO buildfail

@if %BUILDSEL% == single goto done
@if %BUILDSEL% == default goto done

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

@goto done

:noperl
@echo Perl.exe is not in PATH
@goto quit

:nocmake
@echo CMake.exe is not in PATH
@goto quit

:nomsbuild
@echo msbuild.exe is not in PATH
@goto quit

:noyasm
@echo Yasm.exe not found in libvpx\build_%ARCH%
@goto quit

:buildfail
@echo Build Failed
@goto quit

:done
@echo Build completed
@goto quit

:quit
@echo Exiting...
