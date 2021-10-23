# sync rom
repo init --depth=1 --no-repo-verify -u git://github.com/PixelExperience-Staging/manifest -b twelve -g default,-mips,-darwin,-notdefault
git clone https://github.com/hsx02/Local-Manifests.git --depth 1 -b pe-12 .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
. build/envsetup.sh
export SELINUX_IGNORE_NEVERALLOWS=true
lunch aosp_pine-userdebug
export TZ=Asia/Dhaka #put before last build commanda
mka bacon

# upload rom (if you don't need to upload multiple files, then you don't need to edit next line)
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
