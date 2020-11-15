SET INITWEBRTC=%CD%
ECHO "Ensure 'Windows Search' (WSearch) service is Disabled and Stopped."
ECHO "Failure to do so may result in file system errors."
PAUSE
ECHO "Download 'depot_tools' from Chromium Projects and extract it in C:\webrtc\depot_tools."
ECHO "Trying to place WebRTC in another directory will most likely give problems."
PAUSE
ECHO "Adding depot_tools to PATH"
CD C:\webrtc\depot_tools
SET PATH=%CD%;%PATH%
ECHO "Fetching WebRTC repository. This will take a long time."
CD C:\webrtc
SET DEPOT_TOOLS_WIN_TOOLCHAIN=0
fetch --nohooks webrtc
ECHO "Checking out branch"
CD src
git checkout branch-heads/4093
ECHO "Synchronizing checkout"
gclient sync -D --with_branch_heads --with_tags
ECHO "Applying patch to build TeamTalk.lib
git checkout modules/audio_processing/BUILD.gn
git apply %INITWEBRTC%\libteamtalk.patch
