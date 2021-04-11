#!/bin/bash

# Just a basic script U can improvise lateron asper ur need xD 

mkdir -p /tmp/recovery

cd /tmp/recovery

sudo apt install git -y

repo init --depth=1 -u git://github.com/PitchBlackRecoveryProject/manifest_pb.git -b android-10.0 -g default,-device,-mips,-darwin,-notdefault 

repo sync -j$(nproc --all)

git clone https://github.com/hraj9258/android_device_xiaomi_phoenix-pbrp.git device/xiaomi/phoenix

rm -rf out

. build/envsetup.sh && lunch omni_phoenix-eng && export ALLOW_MISSING_DEPENDENCIES=true && export LC_ALL="C" && mka recoveryimage

# Upload zips & recovery.img (U can improvise lateron adding telegram support etc etc)

cd out/target/product/phoenix

curl -sL https://git.io/file-transfer | sh 

./transfer wet *.zip

./transfer wet recovery.img
