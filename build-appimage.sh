#!/bin/bash -e
# build-appimage.sh

ZSYNC_STRING="gh-releases-zsync|athkore|dolphin|latest|Dolphin-SCON4-x86_64.AppImage.zsync"
NETPLAY_APPIMAGE_STRING="Dolphin-SCON4-x86_64.AppImage"

LINUXDEPLOYQT_PATH="https://github.com/probonopd/linuxdeployqt/releases/download/continuous"
LINUXDEPLOYQT_FILE="linuxdeployqt-continuous-x86_64.AppImage"
LINUXDEPLOYQT_URL="${LINUXDEPLOYQT_PATH}/${LINUXDEPLOYQT_FILE}"

#LINUXDEPLOY_PATH="https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous"
#LINUXDEPLOY_FILE="linuxdeploy-x86_64.AppImage"
#LINUXDEPLOY_URL="${LINUXDEPLOY_PATH}/${LINUXDEPLOY_FILE}"

UPDATEPLUG_PATH="https://github.com/linuxdeploy/linuxdeploy-plugin-appimage/releases/download/continuous"
UPDATEPLUG_FILE="linuxdeploy-plugin-appimage-x86_64.AppImage"
UPDATEPLUG_URL="${UPDATEPLUG_PATH}/${UPDATEPLUG_FILE}"

UPDATETOOL_PATH="https://github.com/AppImage/AppImageUpdate/releases/download/continuous"
UPDATETOOL_FILE="appimageupdatetool-x86_64.AppImage"
UPDATETOOL_URL="${UPDATETOOL_PATH}/${UPDATETOOL_FILE}"

APPDIR_BIN="./AppDir/usr/bin/"
APPDIR_HOOKS="./AppDir/apprun-hooks/"

# Grab various appimage binaries from GitHub if we don't have them
if [ ! -e ./Tools/linuxdeploy ]; then
	wget ${LINUXDEPLOY_URL} -O ./Tools/linuxdeploy
fi
if [ ! -e ./Tools/linuxdeployqt ]; then
	wget ${LINUXDEPLOYQT_URL} -O ./Tools/linuxdeployqt
fi
if [ ! -e ./Tools/linuxdeploy-update-plugin ]; then
	wget ${UPDATEPLUG_URL} -O ./Tools/linuxdeploy-update-plugin
fi
if [ ! -e ./Tools/appimageupdatetool ]; then
	wget ${UPDATETOOL_URL} -O ./Tools/appimageupdatetool
fi

chmod +x ./Tools/linuxdeploy
chmod +x ./Tools/linuxdeploy-update-plugin
chmod +x ./Tools/appimageupdatetool

# Delete the AppDir folder to prevent build issues
rm -rf ./AppDir/

# Build the AppDir directory for this image
#mkdir -p AppDir
#mkdir -p ${APPDIR_BIN}


# Add the linux-env script to the AppDir prior to running linuxdeploy
#cp /usr/bin/env ./AppDir/usr/bin/
#mkdir -p ${APPDIR_HOOKS}
#cp Data/linux-env.sh ${APPDIR_HOOKS}

# Add the Sys dir to the AppDir for packaging
cp -r Data/Sys ./AppDir/usr/bin/ #${APPDIR_BIN}

./Tools/linuxdeployqt AppDir/usr/share/applications/dolphin-emu.desktop -bundle-non-qt-libs

cp Data/linux-env.sh AppDir/AppRun
chmod +x AppDir/AppRun

#./Tools/linuxdeploy \
#	--appdir=./AppDir \
#	-e ./build/Binaries/dolphin-emu \
#	-d ./Data/dolphin-emu.desktop \
#	-i ./Data/dolphin-emu.png 

# remove existing appimage just in case
rm -f ${NETPLAY_APPIMAGE_STRING}
	
# Package up the update tool within the AppImage
cp ./Tools/appimageupdatetool ./AppDir/usr/bin/

# Bake an AppImage with the update metadata
UPDATE_INFORMATION="${ZSYNC_STRING}" \
	./Tools/linuxdeploy-update-plugin --appdir=./AppDir/
