# android.permission.FAKE_PACKAGE_SIGNATURE Permission Apk Patcher

## Note
Not all Apk's May Be Added TO Spoof Signature

Please, check AndroidManifest.xml by Apktool To understand for succerful Signature Spoofing Permission patch

## What You Need


[Magisk](https://github.com/topjohnwu/Magisk) + Zygisk

[LSPosed](https://github.com/LSPosed/LSPosed)

[XSpoofSignatures-Legends](https://github.com/Lobanokivan11/XSpoofSignatures-Legends/releases/latest) (Activated In Lsposed Manager)

## Usage (Linux)

### Note
If You Are Do It At First Time, You Need Execute As Sudo
```sudo bash install_deps.sh```
To Install Need Depencies

### Before Patching
After Depencies Installing or Apk Patching You Will see Folder Named ```logs``` it contains Debug Information You May Read If You Can't Patch APK

### Steps

1. Get Any Clean Apk (No Mod, ONLY CLEAN APK), place to patcherapk folder and rename to original.apk

2. Execute ```bash build_patched_apk.sh```

3. If Patching will Complete with no errors, You Need To see patched.apk, It,s patched apk with android.permission.FAKE_PACKAGE_SIGNATURE Permission.

4. You may install patched.apk To Android Phone Using 2 ways

4.1 copy patched.apk to Phone's Memory, grant Allow Install From Unknown Sources, click To patched.apk inside of file manager, and click Install.

4.2 Install patched.apk From Pc Using ADB. (```adb install patched.apk```).

5. Open permission Manager form Installed Patched App(patched.apk), grant Spoof Signature Permission and That's all.
