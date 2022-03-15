##########################################################################################
#
# Magisk Module Installer Script
#
##########################################################################################
##########################################################################################
#
# Instructions:
#
# 1. Place your files into system folder (delete the placeholder file)
# 2. Fill in your module's info into module.prop
# 3. Configure and implement callbacks in this file
# 4. If you need boot scripts, add them into common/post-fs-data.sh or common/service.sh
# 5. Add your additional or modified system properties into common/system.prop
#
##########################################################################################

##########################################################################################
# Unity Logic - Don't change/move this section
##########################################################################################

##########################################################################################
# Config Flags
##########################################################################################

# Set to true if you do *NOT* want Magisk to mount
# any files for you. Most modules would NOT want
# to set this flag to true
SKIPMOUNT=false

# Set to true if you need to load system.prop
PROPFILE=false

# Set to true if you need post-fs-data script
POSTFSDATA=false

# Set to true if you need late_start service script
LATESTARTSERVICE=false

##########################################################################################
# Replace list
##########################################################################################

# List all directories you want to directly replace in the system
# Check the documentations for more info why you would need this

# Construct your list in the following format
# This is an example
REPLACE_EXAMPLE="
/system/app/Youtube
/system/priv-app/SystemUI
/system/priv-app/Settings
/system/framework
"

# Construct your own list here
REPLACE="
"

##########################################################################################
#
# Function Callbacks
#
# The following functions will be called by the installation framework.
# You do not have the ability to modify update-binary, the only way you can customize
# installation is through implementing these functions.
#
# When running your callbacks, the installation framework will make sure the Magisk
# internal busybox path is *PREPENDED* to PATH, so all common commands shall exist.
# Also, it will make sure /data, /system, and /vendor is properly mounted.
#
##########################################################################################
##########################################################################################
#
# The installation framework will export some variables and functions.
# You should use these variables and functions for installation.
#
# ! DO NOT use any Magisk internal paths as those are NOT public API.
# ! DO NOT use other functions in util_functions.sh as they are NOT public API.
# ! Non public APIs are not guranteed to maintain compatibility between releases.
#
# Available variables:
#
# MAGISK_VER (string): the version string of current installed Magisk
# MAGISK_VER_CODE (int): the version code of current installed Magisk
# BOOTMODE (bool): true if the module is currently installing in Magisk Manager
# MODPATH (path): the path where your module files should be installed
# TMPDIR (path): a place where you can temporarily store files
# ZIPFILE (path): your module's installation zip
# ARCH (string): the architecture of the device. Value is either arm, arm64, x86, or x64
# IS64BIT (bool): true if $ARCH is either arm64 or x64
# API (int): the API level (Android version) of the device
#
# Availible functions:
#
# ui_print <msg>
#     print <msg> to console
#     Avoid using 'echo' as it will not display in custom recovery's console
#
# abort <msg>
#     print error message <msg> to console and terminate installation
#     Avoid using 'exit' as it will skip the termination cleanup steps
#
# set_perm <target> <owner> <group> <permission> [context]
#     if [context] is empty, it will default to "u:object_r:system_file:s0"
#     this function is a shorthand for the following commands
#       chown owner.group target
#       chmod permission target
#       chcon context target
#
# set_perm_recursive <directory> <owner> <group> <dirpermission> <filepermission> [context]
#     if [context] is empty, it will default to "u:object_r:system_file:s0"
#     for all files in <directory>, it will call:
#       set_perm file owner group filepermission context
#     for all directories in <directory> (including itself), it will call:
#       set_perm dir owner group dirpermission context
#
##########################################################################################
##########################################################################################
# If you need boot scripts, DO NOT use general boot scripts (post-fs-data.d/service.d)
# ONLY use module scripts as it respects the module status (remove/disable) and is
# guaranteed to maintain the same behavior in future Magisk releases.
# Enable boot scripts by setting the flags in the config section above.
##########################################################################################


# Set what you want to display when installing your module

print_modname() {
  ui_print "*******************************"
  ui_print "     𝘼𝙡𝙡 𝙞𝙣 𝙊𝙣𝙚 𝙋𝙚𝙧𝙨𝙤𝙣𝙖𝙡   "
  ui_print "      𝙈𝙤𝙙𝙪𝙡𝙚𝙨 𝙍𝙖𝙫𝙚𝙣𝙨𝙞𝙖    "
  ui_print "*******************************"
}

on_install() {
  # The following is the default implementation: extract $ZIPFILE/system to $MODPATH
  # Extend/change the logic to whatever you want
  ui_print "- Extracting module files"
  unzip -o "$ZIPFILE" 'addon/*' -d $TMPDIR >&2
  unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
  module=$TMPDIR/module.prop
  rvntouch=$TMPDIR/ravenstouch.idc
  sysmagisk=$MODPATH/system/usr/idc
  venmagisk=$MODPATH/system/vendor/usr/idc
  mods=/data/adb/modules
  tpanel=$(for i in /dev/input/event*; do j="$(getevent -i $i | grep -i touch)"; j=${j#*name: }; [[ -z $j ]] || echo ${j//\"/}; done)
  input=$(for i in /dev/input/event*; do j="$(getevent -i $i | grep -i name)"; j=${j#*name: }; [[ -z $j ]] || echo ${j//\"/}; done)
  . $TMPDIR/addon/Volume-Key-Selector/preinstall.sh

  R='\e[01;91m' > /dev/null 2>&1;
  G='\e[01;92m' > /dev/null 2>&1;


AUTH="@WᴇAʀᴇRᴀᴠᴇɴS, @Titidebin"
TVERSION="𝕧➊.➏";
ui_print "   "
ui_print "   "
ui_print "   "
  ui_print "- 🛡️ Touchscreen Calibration Config🛡️"
  ui_print "    1. @Titidebin"
  ui_print "    2. @WeAreRavenS"
  ui_print "   "
  ui_print "   "
ui_print "  Choose Config:"
TC=1
while true; do
	ui_print "  $TC"
	if $VKSEL; then
		TC=$((TC + 1))
	else 
		break
	fi
	if [ $TC -gt 2 ]; then
		TC=1
	fi
done
ui_print "  Touchscreen Calibration Config: $TC"
  ui_print "   "
  ui_print "   "
#
case $TC in
    1 )
  ui_print "   "
  ui_print "         @Titidebin Config"
  ui_print "- 🛡️ Fingerprint On Display Panel🛡️"
  ui_print "    1. Yes, My Device With FOD."
  ui_print "    2. No, My Device Without FOD."
  ui_print "   "
  ui_print "   "
ui_print "  Select Touchscreen Panel:"
FD=1
while true; do
	ui_print "  $FD"
	if $VKSEL; then
		FD=$((FD + 1))
	else 
		break
	fi
	if [ $FD -gt 2 ]; then
		FD=1
	fi
done
ui_print "  Touchscreen Panel: $FD"
#
case $FD in
     1 ) MODSF="Yes, My Device With FOD"; echo "# With FOD
# @Titidebin

device.internal = 1
touch.deviceType = touchScreen
touch.orientationAware = 1
touch.filter.level=2

# Size
touch.size.calibration = diameter
touch.size.scale = 1.011925
touch.size.bias = -11.988075
touch.toolSize.isSummed = 0

# Pressure
touch.pressure.calibration = physical
touch.pressure.scale = 0.001

# Orientation
touch.orientation.calibration = none
touch.distance.calibration = none
touch.distance.scale = 0.001" >> $rvntouch;;

	2 ) MODSF="No, My Device Without FOD"; echo "# Without FOD
# @Titidebin

device.internal = 1
touch.deviceType = touchScreen
touch.orientationAware = 1
touch.filter.level=2

# Size
touch.size.calibration = diameter
touch.size.scale = 1.011925
touch.size.bias = -11.988075
touch.toolSize.isSummed = 0

# Pressure
touch.pressure.calibration = physical
touch.pressure.scale = 0.001

# Orientation
touch.orientation.calibration = none
touch.distance.calibration = none
touch.distance.scale = 0.001" >> $rvntouch;;
esac
ui_print "  $MODSF ";;
    2 ) 
  ui_print "   "
  ui_print "         @WeAreRavenS Config"
  ui_print "- 🛡️ Fingerprint On Display Panel🛡️"
  ui_print "    1. Yes, My Device With FOD."
  ui_print "    2. No, My Device Without FOD."
  ui_print "   "
  ui_print "   "
ui_print "  Select Touchscreen Panel:"
FD=1
while true; do
	ui_print "  $FD"
	if $VKSEL; then
		FD=$((FD + 1))
	else 
		break
	fi
	if [ $FD -gt 2 ]; then
		FD=1
	fi
done
ui_print "  Touchscreen Panel: $FD"
#
case $FD in
	1 ) MODSF="Yes, My Device With FOD"; echo "#With FOD
# @WeAreRavenS

device.internal = 1
touch.deviceType = touchScreen
touch.orientationAware = 1
touch.filter.level=0

# Size
touch.size.calibration = diameter
touch.size.scale = 1
touch.size.bias = 0
touch.size.isSummed = 0

# Pressure
touch.pressure.calibration = physical
touch.pressure.scale = 0.001

# Orientation
touch.orientation.calibration = none
touch.distance.calibration = none" >> $rvntouch;;

	2 ) MODSF="No, My Device Without FOD"; echo "# Without FOD
# @WeAreRavenS

device.internal = 1
touch.deviceType = touchScreen
touch.orientationAware = 1
touch.filter.level=0

# Size
touch.size.calibration = diameter
touch.size.scale = 1
touch.size.bias = 0
touch.size.isSummed = 0

# Pressure
touch.pressure.calibration = physical
touch.pressure.scale = 0.001

# Orientation
touch.orientation.calibration = none
touch.distance.calibration = none
touch.distance.scale = 0
touch.coverage.calibration = box" >> $rvntouch;;
esac
ui_print "  $MODSF ";;
esac
#ui_print "  $MODSC "
ui_print "   "
ui_print "   "
  ui_print "- 🛡️ Touchscreen Panel Devices🛡️"
  ui_print "    1. ATMEL_MXT_TS"
  ui_print "    2. FT5346"
  ui_print "    3. FT5435_TS"
  ui_print "    4. FT5X06/FT5X06_720P"
  ui_print "    5. FT5X46"
  ui_print "    6. FTS/FTS_TS"
  ui_print "    7. GOODIX/GOODIX_TS"
  ui_print "    8. NVT-TS/NVTCAPACITIVETOUCHSCREEN"
  ui_print "    9. SYNAPTICS_DSX"
  ui_print "   10. SYNAPTICS_TCM_TOUCH"
  ui_print "   11. TOUCH_XSFER"
  ui_print "   12. NOT IN THE LIST (EXPERIMENTAL)"
  ui_print "   "
  ui_print "   "
  ui_print "YOUR INPUT DEVICES :"
  ui_print "$input"
  ui_print "   "
ui_print "⚠️NOTES :"
  ui_print "•  If your Touchscreen Device doesn't detected below,"
  ui_print "   You should check using app such as Device Info HW"
  ui_print "   and choose correctly from options above."
  ui_print "•  𝗘𝘅𝗽𝗲𝗿𝗶𝗺𝗲𝗻𝘁𝗮𝗹 𝗢𝗽𝘁𝗶𝗼𝗻𝘀 (12) 𝘄𝗶𝗹𝗹 𝗻𝗼𝘁 𝘄𝗼𝗿𝗸 𝗶𝗳 𝗬𝗼𝘂𝗿 𝗧𝗼𝘂𝗰𝗵𝘀𝗰𝗿𝗲𝗲𝗻"
  ui_print "   𝗱𝗲𝘁𝗲𝗰𝘁𝗲𝗱 𝘄𝗶𝘁𝗵 𝘀𝘆𝗺𝗯𝗼𝗹𝘀 𝗹𝗶𝗸𝗲 /: 𝗼𝗿 𝗳𝗼𝗿 𝗲𝘅𝗮𝗺𝗽𝗹𝗲:"
  ui_print "   𝙡𝙤𝙘𝙖𝙩𝙞𝙤𝙣: 𝙨𝙮𝙣𝙖𝙥𝙩𝙞𝙘𝙨_𝙙𝙨𝙭/𝙩𝙤𝙪𝙘𝙝_𝙞𝙣𝙥𝙪𝙩"
  ui_print "•  Visit @WeAreRavenS Telegram Channel and read instructions"
  ui_print "   how to check Touch Responsiveness working or not."
  ui_print "   "
  ui_print "   🔰 𝗬𝗢𝗨𝗥 𝗧𝗢𝗨𝗖𝗛𝗦𝗖𝗥𝗘𝗘𝗡 𝗣𝗔𝗡𝗘𝗟 𝗗𝗘𝗩𝗜𝗖𝗘 𝗜𝗦 :"
  ui_print "   $tpanel"
  ui_print "   "
ui_print "  𝗖𝗛𝗢𝗢𝗦𝗘 𝗬𝗢𝗨𝗥 𝗧𝗢𝗨𝗖𝗛𝗦𝗖𝗥𝗘𝗘𝗡 𝗗𝗘𝗩𝗜𝗖𝗘 𝗖𝗢𝗥𝗥𝗘𝗖𝗧𝗟𝗬:"
TP=1
while true; do
	ui_print "  $TP"
	if $VKSEL; then
		TP=$((TP + 1))
	else 
		break
	fi
	if [ $TP -gt 12 ]; then
		TP=1
	fi
done
ui_print "  Touchscreen Panel: $TP"
#
case $TP in
	1 ) MODS0="✅ ATMEL_MXT_TS"; cp -af $rvntouch $sysmagisk/atmel_mxt_ts.idc; cp -af $rvntouch $venmagisk/atmel_mxt_ts.idc; cp -af $rvntouch $sysmagisk/$tpanel.idc; cp -af $rvntouch $venmagisk/$tpanel.idc; NAME="Touch Responsiveness Config"; TDESC="Improve Touchscreen Responsiveness Config for ATMEL_MXT_TS touchscreen panel.";;

	2 ) MODS0="✅ FT5346"; cp -af $rvntouch $sysmagisk/ft5346.idc; cp -af $rvntouch $venmagisk/ft5346.idc; cp -af $rvntouch $sysmagisk/ft5346_ts.idc; cp -af $rvntouch $venmagisk/ft5346_ts.idc; cp -af $rvntouch $sysmagisk/$tpanel.idc; cp -af $rvntouch $venmagisk/$tpanel.idc; NAME="Touch Responsiveness Config"; TDESC="Improve Touchscreen Responsiveness Config for FT5346 touchscreen panel.";;

	3 ) MODS0="✅ FT5435_TS"; cp -af $rvntouch $sysmagisk/ft5435.idc; cp -af $rvntouch $venmagisk/ft5435.idc; cp -af $rvntouch $sysmagisk/ft5435_ts.idc; cp -af $rvntouch $venmagisk/ft5435_ts.idc; cp -af $rvntouch $sysmagisk/$tpanel.idc; cp -af $rvntouch $venmagisk/$tpanel.idc; NAME="Touch Responsiveness Config"; TDESC="Improve Touchscreen Responsiveness Config for FT5435_TS touchscreen panel.";;

	4 ) MODS0="✅ FT5X06/FT5X06_720P"; cp -af $rvntouch $sysmagisk/ft5x06_720p.idc; cp -af $rvntouch $venmagisk/ft5x06_720p.idc; cp -af $rvntouch $sysmagisk/ft5x06_720p_ts.idc; cp -af $rvntouch $venmagisk/ft5x06_720p_ts.idc; cp -af $rvntouch $sysmagisk/ft5x06.idc; cp -af $rvntouch $venmagisk/ft5x06.idc; cp -af $rvntouch $sysmagisk/ft5x06_ts.idc; cp -af $rvntouch $venmagisk/ft5x06_ts.idc; cp -af $rvntouch $sysmagisk/$tpanel.idc; cp -af $rvntouch $venmagisk/$tpanel.idc; NAME="Touch Responsiveness Config"; TDESC="Improve Touchscreen Responsiveness Config for FT5X06/FT5X06_720P touchscreen panel.";;

	5 ) MODS0="✅ FT5X46"; cp -af $rvntouch $sysmagisk/ft5x46.idc; cp -af $rvntouch $venmagisk/ft5x46.idc; cp -af $rvntouch $sysmagisk/ft5x46_ts.idc; cp -af $rvntouch $venmagisk/ft5x46_ts.idc; cp -af $rvntouch $sysmagisk/$tpanel.idc; cp -af $rvntouch $venmagisk/$tpanel.idc; NAME="Touch Responsiveness Config"; TDESC="Improve Touchscreen Responsiveness Config for FT5X46 touchscreen panel.";;

	6 ) MODS0="✅ FTS/FTS_TS"; cp -af $rvntouch $sysmagisk/fts.idc; cp -af $rvntouch $venmagisk/fts.idc; cp -af $rvntouch $sysmagisk/fts_ts.idc; cp -af $rvntouch $venmagisk/fts_ts.idc; cp -af $rvntouch $sysmagisk/$tpanel.idc; cp -af $rvntouch $venmagisk/$tpanel.idc; NAME="Touch Responsiveness Config"; TDESC="Improve Touchscreen Responsiveness Config for FTS/FTS_TS touchscreen panel.";;

	7 ) MODS0="✅ GOODIX/GOODIX_TS"; cp -af $rvntouch $sysmagisk/goodix.idc; cp -af $rvntouch $venmagisk/goodix.idc; cp -af $rvntouch $sysmagisk/goodix_ts.idc; cp -af $rvntouch $venmagisk/goodix_ts.idc; cp -af $rvntouch $sysmagisk/$tpanel.idc; cp -af $rvntouch $venmagisk/$tpanel.idc; NAME="Touch Responsiveness Config"; TDESC="Improve Touchscreen Responsiveness Config for GOODIX/GOODIX_TS touchscreen panel.";;

	8 ) MODS0="✅ NVTCAPACITIVETOUCHSCREEN"; cp -af $rvntouch $sysmagisk/NVTCapacitiveTouchScreen.idc; cp -af $rvntouch $venmagisk/NVTCapacitiveTouchScreen.idc; cp -af $rvntouch $sysmagisk/$tpanel.idc; cp -af $rvntouch $venmagisk/$tpanel.idc; NAME="Touch Responsiveness Config"; TDESC="Improve Touchscreen Responsiveness Config for NVT-TS/NVTCAPACITIVETOUCHSCREEN touchscreen panel.";;

	9 ) MODS0="✅ SYNAPTICS_DSX"; cp -af $rvntouch $sysmagisk/synaptics_dsx.idc; cp -af $rvntouch $venmagisk/synaptics_dsx.idc; cp -af $rvntouch $sysmagisk/synaptics_dsx_ts.idc; cp -af $rvntouch $venmagisk/synaptics_dsx_ts.idc; cp -af $rvntouch $sysmagisk/synaptics_dsx_s2.idc; cp -af $rvntouch $venmagisk/synaptics_dsx_s2.idc; cp -af $rvntouch $sysmagisk/synaptics_dsx_v21.idc; cp -af $rvntouch $venmagisk/synaptics_dsx_v21.idc; cp -af $rvntouch $sysmagisk/$tpanel.idc; cp -af $rvntouch $venmagisk/$tpanel.idc; NAME="Touch Responsiveness Config"; TDESC="Improve Touchscreen Responsiveness Config for SYNAPTICS_DSX touchscreen panel.";;

	10) MODS0="✅ SYNAPTICS_TCM_TOUCH"; cp -af $rvntouch $sysmagisk/synaptics_tcm_touch.idc; cp -af $rvntouch $venmagisk/synaptics_tcm_touch.idc; cp -af $rvntouch $sysmagisk/$tpanel.idc; cp -af $rvntouch $venmagisk/$tpanel.idc; NAME="Touch Responsiveness Config"; TDESC="Improve Touchscreen Responsiveness Config for SYNAPTICS_TCM_TOUCH touchscreen panel.";;

	11 ) MODS0="✅ TOUCH_XSFER"; cp -af $rvntouch $sysmagisk/touch_xsfer.idc; cp -af $rvntouch $venmagisk/touch_xsfer.idc; cp -af $rvntouch $sysmagisk/touch_xsfer_ts.idc; cp -af $rvntouch $venmagisk/touch_xsfer_ts.idc; cp -af $rvntouch $sysmagisk/$tpanel.idc; cp -af $rvntouch $venmagisk/$tpanel.idc; NAME="Touch Responsiveness Config"; TDESC="Improve Touchscreen Responsiveness Config for TOUCH_XSFER touchscreen panel.";;

	12 ) MODS0="✅ $tpanel"; cp -af $rvntouch $sysmagisk/$tpanel.idc; cp -af $rvntouch $venmagisk/$tpanel.idc; NAME="Touch Responsiveness Config"; TDESC="Improve Touchscreen Responsiveness Config for $tpanel touchscreen panel.";;
esac
ui_print "  $MODS0 "
ui_print "   "
ui_print "   "
  sed -i "/name=/c name=${NAME}" $module
  sed -i "/version=/c version=${TVERSION}" $module
  sed -i "/author=/c author=${AUTH}" $module
  sed -i "/description=/c description=${TDESC}" $module

  }

# Only some special files require specific permissions
# This function will be called after on_install is done
# The default permissions should be good enough for most cases

set_permissions() {
  # The following is the default rule, DO NOT remove
  set_perm_recursive $MODPATH 0 0 0755 0644

  # Here are some examples:
  # set_perm_recursive  $MODPATH/system/lib       0     0       0755      0644
  # set_perm  $MODPATH/system/bin/app_process32   0     2000    0755      u:object_r:zygote_exec:s0
  # set_perm  $MODPATH/system/bin/dex2oat         0     2000    0755      u:object_r:dex2oat_exec:s0
  # set_perm  $MODPATH/system/lib/libart.so       0     0       0644
}

# Custom Variables for Install AND Uninstall - Keep everything within this function - runs before uninstall/install
unity_custom() {
  : # Remove this if adding to this function
}

# You can add more functions to assist your custom script code
