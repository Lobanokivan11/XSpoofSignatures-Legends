if [ ! -f "original.apk" ]; then 
	echo "You Need to get APK (Not Apks) from apkmirror to Add Spoof Signature Permission"
    echo "You Also Need to Patch Rom For To add Spoof Signature Permission Support"
    echo "To Spoof Apk's Signature you need patch rom for Add System-wide Spoof Signature Permission"
	exit 1
fi

echo "Unpacking Original APK"
java -jar apktool.jar d -s original.apk -o SourceApk

echo "Add Spoof Signature Permission"
xmlstarlet edit --inplace -s "/manifest" -t elem -n uses-permission-temp -v "" -a "/manifest/uses-permission-temp" -t 'attr' -n 'android:name' -v 'android.permission.FAKE_PACKAGE_SIGNATURE' -r "/manifest/uses-permission-temp" -v uses-permission ./SourceApk/AndroidManifest.xml

echo "ADD SIGNATURE FROM original.apk FOR SPOOF"
CERTORIGINAL="$(java -jar ApkSig.jar original.apk)"
xmlstarlet edit --inplace -s "/manifest/application" -t elem -n meta-data-temp -v "" -a "/manifest/application/meta-data-temp" -t 'attr' -n 'android:name' -v 'fake-signature' -a "/manifest/application/meta-data-temp" -t 'attr' -n 'android:value' -v '$CERTORIGINAL' -r "/manifest/application/meta-data-temp" -v meta-data ./SourceApk/AndroidManifest.xml

echo "Add Signature Using By System"
xmlstarlet edit --inplace -s "/manifest/application" -t elem -n meta-data-temp -v "" -a "/manifest/application/meta-data-temp" -t 'attr' -n 'android:name' -v 'fake-signature-only' -a "/manifest/application/meta-data-temp" -t 'attr' -n 'android:value' -v 'true' -r "/manifest/application/meta-data-temp" -v meta-data ./SourceApk/AndroidManifest.xml

echo "Rebuilding APK ..."
java -jar apktool.jar b SourceApk -o patched-unsigned.apk

echo "Signing APK ..."
zipalign -p 4 patched-unsigned.apk patched-unsigned-aligned.apk
apksigner sign --ks-key-alias lob --ks sign.keystore --ks-pass pass:369852 --key-pass pass:369852 patched-unsigned-aligned.apk

cp patched-unsigned-aligned.apk patched.apk
rm patched-unsigned-aligned.apk
rm patched-unsigned.apk
rm -rf SourceApk
