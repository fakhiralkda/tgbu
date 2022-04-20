#!/bin/bash

ANDROID_SDK_URL="https://dl.google.com/android/repository/commandlinetools-linux-7302050_latest.zip"
ANDROID_API_LEVEL="android-31"
ANDROID_BUILD_TOOLS_VERSION="31.0.0"
ANDROID_HOME="/usr/local/android-sdk-linux"
ANDROID_NDK_VERSION="21.4.7075529"
ANDROID_VERSION="31"
ANDROID_NDK_HOME="${ANDROID_HOME}/ndk/${ANDROID_NDK_VERSION}/"

export PATH="${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools"

apt update -qqy >/dev/null && apt install ca-certificates git curl -qqy --no-install-recommends >/dev/null
git clone https://github.com/nikitasius/Telegraher
cd Telegraher
TDIR=$(pwd)

mkdir "${ANDROID_HOME}" .android
cd "${ANDROID_HOME}"
curl -o sdk.zip ${ANDROID_SDK_URL}
unzip sdk.zip
rm sdk.zip

yes | ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} --licenses
${ANDROID_HOME}/cmdline-tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} --update
${ANDROID_HOME}/cmdline-tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} "build-tools;30.0.3" "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" "platforms;android-${ANDROID_VERSION}" "platform-tools" "ndk;$ANDROID_NDK_VERSION"
cp ${ANDROID_HOME}/build-tools/30.0.3/dx ${ANDROID_HOME}/build-tools/31.0.0/dx
cp ${ANDROID_HOME}/build-tools/30.0.3/lib/dx.jar ${ANDROID_HOME}/build-tools/31.0.0/lib/dx.jar

export PATH="${ANDROID_NDK_HOME}/prebuilt/linux-x86_64/bin/:${PATH}"

mkdir -p ${TDIR}/TMessagesProj/build/outputs/apk
mkdir -p ${TDIR}//TMessagesProj/build/outputs/native-debug-symbols
cp -R ${TDIR}/. /home/gradle

cd /home/gradle
gradle assembleArm64_v8aRelease assembleArm64_v8a_sdk23Release
cp -R /home/gradle/TMessagesProj/build/outputs/apk/. ${TDIR}/TMessagesProj/build/outputs/apk
cp -R /home/gradle/TMessagesProj/build/outputs/native-debug-symbols/. ${TDIR}/TMessagesProj/build/outputs/native-debug-symbols

cd ${TDIR}
${KOMANDO}