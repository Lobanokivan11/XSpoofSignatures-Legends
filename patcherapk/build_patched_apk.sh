if [ ! -f "original.apk" ]; then 
	echo "You Need to get APK (Not Apks) from apkmirror to Add Spoof Signature Permission"
    echo "You Also Need to Patch Rom For To add Spoof Signature Permission Support"
    echo "To Spoof Apk's Signature you need patch rom for Add System-wide Spoof Signature Permission"
	exit 1
fi

echo "Unpacking Original APK"
java -jar apktool.jar d -s original.apk -o SourceApk

echo "Add Spoof Signature Permission"
xmlstarlet edit --inplace -a "/manifest/uses-permission[not(@android:name)]" -t 'attr' -n 'android:name' -v 'android.permission.FAKE_PACKAGE_SIGNATURE' ./SourceApk/AndroidManifest.xml

echo "ADD SIGNATURE FROM original.apk FOR SPOOF"
CERTORIGINAL="$(java -jar ApkSig.jar original.apk)"
xmlstarlet edit --inplace -a "/manifest/application/meta-data[not(@android:name)]" -t 'attr' -n 'android:name' -v 'fake-signature' --inplace -a "/manifest/application/meta-data[not(@android:value)]" -t 'attr' -n 'android:value' -v '$CERTORIGINAL' ./SourceApk/AndroidManifest.xml

echo "Add Signature Using By System"
xmlstarlet edit --inplace -a "/manifest/application/meta-data[not(@android:name)]" -t 'attr' -n 'android:name' -v 'fake-signature-only' --inplace -a "/manifest/application/meta-data[not(@android:value)]" -t 'attr' -n 'android:value' -v 'true' ./SourceApk/AndroidManifest.xml

echo "Rebuilding APK ..."
java -jar apktool.jar b SourceApk -o patched-unsigned.apk

echo "Signing APK ..."
zipalign -p 4 patched-unsigned.apk patched-unsigned-aligned.apk
apksigner sign --ks-key-alias lob --ks sign.keystore --ks-pass pass:369852 --key-pass pass:369852 patched-unsigned-aligned.apk

cp patched-unsigned-aligned.apk patched.apk
rm patched-unsigned-aligned.apk
rm patched-unsigned.apk
rm -rf SourceApk
