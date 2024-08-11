#!/system/bin/sh
#
# Universal GMS Doze by the gloeyisk
# Created NR By @KazuyooOpenSources
# open-source loving GL-DP and all contributors;
# Patches Google Play services app and certain processes/services to be able to use battery optimization
#

# // replace echo to ui_print
ui_print() {
  echo "$1"
}

# // array & PATH
API=$(getprop ro.build.version.sdk )
NAME="GMS Doze | Kzyo"
VERSION="1.3"
ANDROIDVERSION=$(getprop ro.build.version.release)
DATE="12 - 5 - 2024"
DEVICES=$(getprop ro.product.board)
MANUFACTURER=$(getprop ro.product.manufacturer)

# // The message that appears in the terminal
sleep 0.5
ui_print 
ui_print "▒█▀▀█ ▒█▀▄▀█ ▒█▀▀▀█ 　 ▒█▀▀▄ ▒█▀▀▀█ ▒█▀▀▀█ ▒█▀▀▀ 
▒█░▄▄ ▒█▒█▒█ ░▀▀▀▄▄ 　 ▒█░▒█ ▒█░░▒█ ░▄▄▄▀▀ ▒█▀▀▀ 
▒█▄▄█ ▒█░░▒█ ▒█▄▄▄█ 　 ▒█▄▄▀ ▒█▄▄▄█ ▒█▄▄▄█ ▒█▄▄▄"
ui_print
echo "     Power Optimization Mechanism\n"
sleep 1
echo "***************************************"
sleep 0.2
echo "• Name            : ${NAME}"
sleep 0.2
echo "• Version         : ${VERSION}"
sleep 0.2
echo "• Android Version : ${ANDROIDVERSION}"
sleep 0.2
echo "• Build Date      : ${DATE}"
sleep 0.2
echo "***************************************"
sleep 0.2
echo "• Devices         : ${DEVICES}"
sleep 0.2
echo "• Manufacturer    : ${MANUFACTURER}"
sleep 0.2
echo "***************************************\n"
sleep 0.2

# // Check Android API
if [ $API -ge 23 ]; then
    echo "[ ! ] Currently Doze Google GMS"
else
    echo "[ ! ] Unsupported API Version: $API" && exit 1
fi

# // run component
gms_doze() {
# // path & array
    GMS=$(curl -s https://raw.githubusercontent.com/Kazuyoo-stuff/GMS-Doze-NR/main/services/components.sh | cat)
    GMS1="auth.managed.admin.DeviceAdminReceiver"
    GMS2="mdm.receivers.MdmDeviceAdminReceiver"
    GMS3="com.google.android.gms"
    appops_background=ignore
    appops_foreground=ignore
    standby_bucket=never
    inactive=true

# // Disable Collective Device Administrators [ Rooted ]
for root in $GMS1 $GMS2; do
    pm disable --user "$gms/.$root"
done

# // Disable GMS In Background
for noroot in $GMS; do
    am force-stop "$noroot"
    cmd activity force-stop "$noroot"
    cmd activity kill "$noroot"
    am kill-all "$noroot"
done

# // GMS Fix Drain For [ Rooted ]
    pm disable com.google.android.gms/.chimera.GmsIntentOperationService 

# // Add GMS To Battery Optimization
    dumpsys deviceidle whitelist -$GMS3
    cmd appops set $GMS3 RUN_ANY_IN_BACKGROUND $appops_background
    cmd appops set $GMS3 RUN_IN_BACKGROUND $appops_foreground
    am set-inactive --user 0 $GMS3 $inactive
    am set-standby-bucket --user 0 $GMS3 $standby_bucket
}

# // check failed or success
check_function() {
if gms_doze > /dev/null 2>&1; then
    sleep 5 && ui_print "[ - ] Success GMS Has Been Doze"
else
    sleep 0.5 && ui_print "[ ! ] Failed GMS Not Doze" && exit 1
fi
}

# // call function
check_function
sleep 1


# // Clean Up 
# // Don't change the code below if you don't want all your data to be deleted
ui_print "[ - ] Cleaning Obsolete Files"
find /sdcard/Android/data/*/cache/* -delete &>/dev/null
rm -rf /data/local/tmp/* > /dev/null 2>&1
sleep 3

# // The message that appears in the terminal
ui_print "[ - ] Finalizing Installation"
sync # Sync to data in the rare case a device crashes

# // The message that appears in the terminal
sleep 2
ui_print "[ - ] All Done"
ui_print

#
# Credits
# topjohnwu / Magisk - Magisk Module Template
# JumbomanXDA, MrCarb0n / Script fixer and helper
# Source Code: [GitHub](https://github.com/gloeyisk/universal-gms-doze)
#
