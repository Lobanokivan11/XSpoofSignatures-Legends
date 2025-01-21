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
        TMP_FILE="./SourceApk/AndroidManifest.xml.updating"
        xmlstarlet ed -S \
            -s /manifest -t elem -n uses-permission-temp -v "" \
            -i //uses-permission-temp -t attr -n android:name -v ${ATTR_VALUE} \
            -r //uses-permission-temp -v uses-permission ${MANIFEST_FILE} > ${TMP_FILE}
        cp ${TMP_FILE} ${MANIFEST_FILE}
    fi
}

addUsesPermission 'android.permission.FAKE_PACKAGE_SIGNATURE'

echo "ADD SIGNATURE FROM original.apk FOR SPOOF"
CERTORIGINAL="$(java -jar ApkSig.jar original.apk)"
xmlstarlet ed -S \
    -s /manifest/application -t elem -n meta-data -v "" \
    -i /manifest/application/meta-data -t attr -n android:name -v "fake-signature" \
    -i /manifest/application/meta-data -t attr -n android:value -v "$CERTORIGINAL" \
    -r /manifest/application/meta-data -v meta-data ./SourceApk/AndroidManifest.xml > ./SourceApk/AndroidManifest.xml.updating2
cp ./SourceApk/AndroidManifest.xml.updating2 ./SourceApk/AndroidManifest.xml

echo "Add Signature Using By System"
xmlstarlet ed -S \
    -s /manifest/application -t elem -n meta-data -v "" \
    -i /manifest/application/meta-data -t attr -n android:name -v "fake-signature-only" \
    -i /manifest/application/meta-data -t attr -n android:value -v "true" \
    -r /manifest/application/meta-data -v meta-data ./SourceApk/AndroidManifest.xml > ./SourceApk/AndroidManifest.xml.updating3
cp ./SourceApk/AndroidManifest.xml.updating3 ./SourceApk/AndroidManifest.xml

echo "Rebuilding APK ..."
java -jar apktool.jar b SourceApk -o patched-unsigned.apk

echo "Signing APK ..."
zipalign -p 4 patched-unsigned.apk patched-unsigned-aligned.apk
apksigner sign --ks-key-alias lob --ks ../sign.keystore --ks-pass pass:369852 --key-pass pass:369852 patched-unsigned-aligned.apk

cp patched-unsigned-aligned.apk patched.apk
rm patched-unsigned-aligned.apk
rm patched-unsigned.apk
rm -rf SourceApk