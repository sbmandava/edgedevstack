update_env () {
# update binaries
apt-get -y update
apt-get -y upgrade
}

install_desktop () {
update_env 	
apt-get install -y lubuntu-desktop xrdp
apt-get remove -y --purge libreoffice* transmission* vlc* 2048* skanlite* bluedevil* trojita* qpdfview* pulseaudio* ark* byobu* feather* kcalc*
apt-get remove -y --purge qlipper* compton* noblenote* *speech* *gphoto2* *modem* lximage* usb-creator* qps*
apt-get clean
apt-get -y autoremove
}

install_vscode () {
cd /tmp
wget -O /tmp/vs-code.dpkg https://go.microsoft.com/fwlink/?LinkID=760868;dpkg -i /tmp/vs-code.dpkg 
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
}

#### main
if [ `whoami` != root ]; then
  echo Please run this script with sudo
  exit
fi

install_desktop

