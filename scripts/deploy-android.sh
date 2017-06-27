#!/bin/sh

# Build the Android apk in debug/release mode or deploy the game to the Love2d app (from the play store)

LOVE_ANDROID=../love-10.2-android-source

# debug/release
BUILD=release

# e.g. com.mycompany.myproject
PACKAGE=com.voodoocactus.games.puzzler

FILES="common
entities
gamestates
modules
resources
conf.lua
main.lua"

# Write the debug/release configuration
echo "return '$BUILD'" > common/build.lua

if [ "$1" == "app" ]; then
  mkdir -p build
  rm build/game.love
  zip -r build/game.love $FILES -x *.DS_Store
  # Unlock the screen
  adb shell input keyevent 82
  adb shell input swipe 100 100 800 200

  adb shell am force-stop "$PACKAGE"

  # Upload the app on the sdcard
  adb push build/game.love /sdcard/game.love

  # Start the app Love passing the game file as parameter
  adb shell am start -S -n "$PACKAGE/.GameActivity" -d "file:///sdcard/game.love"
  # Show application log for the tag "SDL/APP" level "V" (verbose) and silence all other tag (*:S)
  adb logcat "SDL/APP":D *:S
  exit 0
fi

# Create the game zip. Must not contain the root folder
rm $LOVE_ANDROID/assets/game.love
zip -r $LOVE_ANDROID/assets/game.love $FILES -x *.DS_Store

pushd ../love-10.2-android-source

# Build the native framework
# ndk-build clean
# ndk-build

# Build the APK and install/start the app
ant clean && ant $BUILD && \
adb uninstall $PACKAGE && \
adb install "bin/love-android-$BUILD.apk" && \
adb shell am start -n "$PACKAGE/.GameActivity" && \
adb logcat "SDL/APP":D *:S
popd
