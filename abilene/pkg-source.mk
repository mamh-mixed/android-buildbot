include core/pkg-source.mk

INTERNAL_PROJECTS :=vendor/marvell/external/helix
INTERNAL_PROJECTS +=vendor/marvell/external/flash
INTERNAL_PROJECTS +=vendor/marvell/generic/apps/CmmbPlayer
INTERNAL_PROJECTS +=vendor/marvell/generic/apps/CmmbStack
INTERNAL_PROJECTS +=boot/obm/.git
INTERNAL_PROJECTS +=boot/obm/binaries/Wtm_rel_mmp2.bin

EXCLUDE_VCS=--exclude-vcs --exclude=.repo

KERNEL_BASE_COMMIT:=2f335ee1d83da389756edce8e13d282ad761d40e
UBOOT_BASE_COMMIT:=1d4b28457dfcef99869dffa5142273c180351191

ifeq ($(ANDROID_VERSION),donut)
	DROID_BASE:=shgit/donut-release
else
ifeq ($(ANDROID_VERSION),eclair)
	DROID_BASE:=android-2.1_r2
else
ifeq ($(ANDROID_VERSION),froyo)
	DROID_BASE:=android-2.2.1_r1
else
	DROID_BASE:=android-2.3.1_r1
	KERNEL_BASE_COMMIT:=2f335ee1d83da389756edce8e13d282ad761d40e
endif
endif
endif

.PHONY:pkgsrc
pkgsrc: output_dir get_source_for_pkg
	$(hide)echo "  save project list"
	$(hide)cd $(OUTPUT_DIR)/source && repo forall -c "echo -n \$$(pwd):;echo \$$REPO_PROJECT" > $(OUTPUT_DIR)/prjlist

	$(hide)echo "  remove internal source code..."
	$(hide)cd $(OUTPUT_DIR)/source && for prj in $(INTERNAL_PROJECTS); do rm -fr $$prj; done

	$(hide)echo "  package all source code..."
	$(hide)cd $(OUTPUT_DIR) && tar czf droid_all_src.tgz $(EXCLUDE_VCS) source/

	$(hide)echo "  package kernel source code..."
	$(hide)cd $(OUTPUT_DIR) && $(TOP_DIR)/core/gen_kernel_src_patch.sh $(KERNEL_BASE_COMMIT)

	$(hide)echo "  package uboot obm source code..."
	$(hide)cd $(OUTPUT_DIR) && $(TOP_DIR)/core/gen_uboot_obm_src_patch.sh $(UBOOT_BASE_COMMIT)

	$(hide)echo "  package android source code..."
	$(hide)cd $(OUTPUT_DIR) && $(TOP_DIR)/core/gen_droid_src_patch.sh $(DROID_BASE) $(TOP_DIR)/core

	$(hide)cp $(TOP_DIR)/core/setup_android.sh $(OUTPUT_DIR)
	$(log) "  done."


#format: <file name>:[m|o]:[md5]
#m:means mandatory
#o:means optional
#md5: need to generate md5 sum
PUBLISHING_FILES+=droid_all_src.tgz:o:md5 
PUBLISHING_FILES+=android_src.tgz:m:md5 
PUBLISHING_FILES+=android_patches.tgz:m:md5 
PUBLISHING_FILES+=kernel_src.tgz:m:md5 
PUBLISHING_FILES+=kernel_patches.tgz:m:md5 
PUBLISHING_FILES+=uboot_src.tgz:m:md5 
PUBLISHING_FILES+=uboot_patches.tgz:m:md5 
PUBLISHING_FILES+=obm_src.tgz:m:md5 
PUBLISHING_FILES+=marvell_manifest.xml:m
PUBLISHING_FILES+=setup_android.sh:m

