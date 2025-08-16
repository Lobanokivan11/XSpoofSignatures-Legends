echo "Updating Apt Sources"
apt update -y
echo "Updating Apt Packages"
apt upgrade -y
echo "Installing Depencies Via Apt"
apt install apksigner xmlstarlet zipalign apktool openjdk-17-jdk -y
