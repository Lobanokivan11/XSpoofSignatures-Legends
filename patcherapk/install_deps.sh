rm -rf logs
mkdir logs
echo "Updating Apt Sources"
apt update -y > logs/aptupdate.log
echo "Updating Apt Packages"
apt upgrade -y > logs/aptupgrade.log
echo "Installing Depencies Via Apt"
apt install apksigner xmlstarlet zipalign apktool openjdk-17-jdk -y > logs/aptdeps.log
echo "Finished, Please Check 3 Logs Files On 'logs' Folder to Understand For Succerful Depencies Install"
