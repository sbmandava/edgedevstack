update_env () {
# update binaries
apt-get -y update
apt-get -y upgrade
}

install_desktop () {
update_env 	
apt-get install -y lubuntu-desktop xrdp
apt-get remove -y --purge libreoffice* transmission* vlc* 2048* skanlite* bluedevil* trojita* qpdfview* pulseaudio* ark* byobu* feather* kcalc*
apt-get remove -y --purge qlipper* compton* noblenote* *speech* *gphoto2* *modem* lximage* usb-creator* qps* *fcitx*
apt-get clean
apt-get -y autoremove
}

install_vscode () {
cd /tmp
snap install code --classic
snap install helm3 
snap install kubectl --classic
snap install kontena-lens --classic
}

#### main
if [ `whoami` != root ]; then
  echo Please run this script with sudo
  exit
fi

install_desktop

