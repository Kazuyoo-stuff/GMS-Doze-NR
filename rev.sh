#!/system/bin/sh

echo
echo "[ ! ] Deleting Please Wait"
echo
sleep 2
uninstall () {
pm enable com.google.android.gms/.auth.managed.admin.DeviceAdminReceiver
pm enable com.google.android.gms/.mdm.receivers.MdmDeviceAdminReceiver
pm enable com.google.android.gms/.chimera.GmsIntentOperationService
dumpsys deviceidle whitelist +com.google.android.gms
cmd appops set com.google.android.gms RUN_ANY_IN_BACKGROUND allow
cmd appops set com.google.android.gms RUN_IN_BACKGROUND allow
am set-inactive --user 0 com.google.android.gms false
am set-standby-bucket --user 0 com.google.android.gms active
}
uninstall > /dev/null 2>&1 &
echo "[ ! ] All Tweaks Has Been Delete"
echo
