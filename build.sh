#!/bin/bash

# Just a basic script U can improvise lateron asper ur need xD 

MANIFEST="git://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-11"
DEVICE=X00T
DT_LINK="https://github.com/hraj9258/recovery_device_asus_X00T_twrp"
DT_PATH=device/asus/$DEVICE

echo " ===+++ Setting up Build Environment +++==="
apt install openssh-server -y
apt update --fix-missing
apt install openssh-server -y
mkdir ~/twrp9 && cd ~/twrp9

echo " ===+++ Syncing Recovery Sources +++==="
repo init --depth=1 -u $MANIFEST
repo sync
echo " ===+++ Cloning Device Tree +++==="
git clone --depth=1 $DT_LINK $DT_PATH

echo " ===+++ Building Recovery +++==="
export ALLOW_MISSING_DEPENDENCIES=true
export TW_THEME=portrait_hdpi
. build/envsetup.sh
echo " source build/envsetup.sh done"
lunch omni_${DEVICE}-eng || abort " lunch failed with exit status $?"
echo " lunch omni_${DEVICE}-eng done"
mka recoveryimage || abort " mka failed with exit status $?"
echo " mka recoveryimage done"

# Upload zips & recovery.img (U can improvise lateron adding telegram support etc etc)
echo " ===+++ Uploading Recovery +++==="
version=$(cat bootable/recovery/variables.h | grep "define TW_MAIN_VERSION_STR" | cut -d \" -f2)
OUTFILE=TWRP-${version}-${DEVICE}-$(date "+%Y%m%d-%I%M").zip

cd out/target/product/$DEVICE
mv recovery.img ${OUTFILE%.zip}.img
zip -r9 $OUTFILE ${OUTFILE%.zip}.img

curl -T $OUTFILE https://oshi.at
