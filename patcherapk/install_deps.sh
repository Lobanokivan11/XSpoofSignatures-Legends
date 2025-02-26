echo "Updating Apt Sources"
sudo apt update -y > logs/aptupdate.log
echo "Updating Apt Packages"
sudo apt upgrade -y > logs/aptupgrade.log
echo "Installing Depencies Via Apt"
sudo apt install apksigner xmlstarlet zipalign apktool java -y > logs/aptdeps.log
echo "Finished, Please Check 3 Logs Files On 'logs' Folder to Understand For Succerful Depencies Install"
