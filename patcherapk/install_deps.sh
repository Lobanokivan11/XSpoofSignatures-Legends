echo "Updating Apt Sources"
sudo apt update -y
echo "Updating Apt Packages"
sudo apt upgrade -y
echo "Installing Depencies Via Apt"
sudo apt install xmlstarlet apktool java -y
echo "Finished"
