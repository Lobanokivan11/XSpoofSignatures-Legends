if [ ! -f "original.apk" ]; then 
	echo "You Need to get APK (Not Apks) from apkmirror to Add Spoof Signature Permission"
    echo "You Also Need to Patch Rom For To add Spoof Signature Permission Support"
    echo "To Spoof Apk's Signature you need patch rom for Add System-wide Spoof Signature Permission"
	break
fi

echo "Unpacking Original APK"
java -jar apktool.jar d original.apk -o SourceApk

echo "Add Spoof Signature Permission"
MANIFEST_FILE="./SourceApk/AndroidManifest.xml"
function addUsesPermission ()
{
    [ -z "$1" ] && {  echo "ERROR: No attribute value"; exit 1; }
    ATTR_VALUE=$1
    if [ -n "$(xmlstarlet sel -T -t -v "/manifest/uses-permission[@android:name=\"${ATTR_VALUE}\"]/@android:name" $MANIFEST_FILE)" ]
    then
        echo Found ${ATTR_VALUE}. Skipping
    else
        echo Adding ${ATTR_VALUE}
        TMP_FILE=`mktemp -q /tmp/$(basename ${MANIFEST_FILE}).tmp`
        xmlstarlet ed -S \
            -s /manifest -t elem -n uses-permission-temp -v "" \
            -i //uses-permission-temp -t attr -n android:name -v ${ATTR_VALUE} \
            -r //uses-permission-temp -v uses-permission ${MANIFEST_FILE} > ${TMP_FILE}
        mv ${TMP_FILE} ${MANIFEST_FILE}
    fi
}

addUsesPermission 'android.permission.FAKE_PACKAGE_SIGNATURE'

echo "ADD SIGNATURE FROM original.apk FOR SPOOF"
CERTORIGINAL="$(java -jar ApkSig.jar original.apk)"
xmlstarlet ed -i 'manifest/application' -t meta-data -n android:name="fake-signature" -v android:value="$CERTORIGINAL" AndroidManifest.xml

echo "Applying Android 5.x patch ..."
bspatch PSM/lib/armeabi/libdefault.so PSM/lib/armeabi/libdefault_real.so patches/android_5.bpatch

echo "Copying NoPsmDrm libraries."
cp -rv lib/* PSM/lib/armeabi/

echo "Rebuilding APK ..."
java -jar apktool.jar b PSM -o PSM_patched.apk

echo "Signing APK ..."
jarsigner -storepass "password" -keypass "password" -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore pssuite.keystore PSM_patched.apk pssuite
zipalign -f -v 4 PSM_patched.apk PSM_patched_align.apk

rm PSM_patched.apk
mv PSM_patched_align.apk PSM_NoPsmDrm_NoRoot.apk
