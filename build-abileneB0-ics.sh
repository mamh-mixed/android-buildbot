# Used by AABS framework
export ABS_SOC=abileneB0
export ABS_BUILDHOST_DEF=buildhost.def

# Used only in droid.mk
export ABS_DROID_PRODUCT=abilene
export ABS_DROID_VARIANT=userdebug
export ABS_DROID_TYPE=release

# Misc
# Are they redundant?
export ABS_DROID_BRANCH=ics
export ABS_PRODUCT_NAME=MMP3
export ABS_BOARD=abileneB0


core/autobuild.sh $*

