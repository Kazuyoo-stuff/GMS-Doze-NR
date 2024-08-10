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

# // array
API=$(getprop ro.build.version.sdk )
tele=https://t.me/KazuyooSourcesCh
yete=https://youtube.com/@KazuyooOpenSource

# // The message that appears in the terminal
sleep 0.5
ui_print 
ui_print "▒█▀▀█ ▒█▀▄▀█ ▒█▀▀▀█ 　 ▒█▀▀▄ ▒█▀▀▀█ ▒█▀▀▀█ ▒█▀▀▀ 
▒█░▄▄ ▒█▒█▒█ ░▀▀▀▄▄ 　 ▒█░▒█ ▒█░░▒█ ░▄▄▄▀▀ ▒█▀▀▀ 
▒█▄▄█ ▒█░░▒█ ▒█▄▄▄█ 　 ▒█▄▄▀ ▒█▄▄▄█ ▒█▄▄▄█ ▒█▄▄▄"
ui_print
ui_print "[ Version 1.3 ]"
sleep 1
ui_print 
ui_print "[ 𝐒𝐮𝐩𝐩𝐨𝐫𝐭 𝐌𝐞 ]"
ui_print "-> Developer   : @KazuyooInHere"
ui_print "-> Ch Telegram : $tele"
ui_print "-> Ch YouTube  : $yete"
sleep 1
ui_print 
ui_print "[ 𝐋𝐎𝐆 𝐈𝐍𝐅𝐎𝐑𝐌𝐀𝐓𝐈𝐎𝐍 ]"

# // Check Android API
if [ $API -ge 23 ]; then
    echo "[ ! ] Currently Doze Google GMS"
else
    echo "[ ! ] Unsupported API Version: $API" && exit 1
fi

# // run component
gms_doze() {
# // path & array
    GMS=$(cat /sdcard/Doze/.settings/gms.sh)
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
    sleep 10 && ui_print "[ - ] Success GMS Has Been Doze"
else
    sleep 1 && ui_print "[ ! ] Failed GMS Not Doze" && exit 1
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

ui_print "[ - ] Finalizing Installation"
sync
sleep 2

ui_print "[ - ] All Done"
ui_print
#
# Credits
# topjohnwu / Magisk - Magisk Module Template
# JumbomanXDA, MrCarb0n / Script fixer and helper
# Source Code: [GitHub](https://github.com/gloeyisk/universal-gms-doze)
#
