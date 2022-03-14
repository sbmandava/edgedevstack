update_env () {
# update binaries
apt-get -y update
apt-get -y upgrade
}

install_desktop () {
update_env 	
# apt-get install -y lubuntu-desktop xrdp
# apt-get remove -y --purge libreoffice* transmission* vlc* 2048* skanlite* bluedevil* trojita* qpdfview* pulseaudio* ark* byobu* feather* kcalc*
# apt-get remove -y --purge qlipper* compton* noblenote* *speech* *gphoto2* *modem* lximage* usb-creator* qps* *fcitx*
apt-get install -y xubuntu-core^ xrdp firefox
apt-get clean
apt-get -y autoremove
}

install_k8s () {
cd /tmp
snap install microk8s --classic
microk8s enable storage
microk8s enable registry
microk8s enable metrics-server
microk8s enable prometheus
microk8s enable ingress metallb:192.168.55.10-192.168.55.30
mkdir /home/ubuntu/.kube
microk8s config > /home/ubuntu/.kube/config
chmod 600 /home/ubuntu/.kube/config
usermod -a -G microk8s ubuntu
newgrp microk8s
chown -R ubuntu:ubuntu /home/ubuntu/.kube
snap install helm
snap install kubectl --classic
snap install kontena-lens --classic
}

install_vscode () {
snap install code --classic
su - ubuntu -c "code --install-extension nocalhost.nocalhost"
# wget -O /usr/local/bin/nhctl https://github.com/nocalhost/nocalhost/releases/download/v0.6.15/nhctl-linux-amd64
# chmod +x /usr/local/bin/nhctl
echo "fs.inotify.max_user_watches=204800" | sudo tee -a /etc/sysctl.conf
}

install_drupal () {
 su - ubuntu -c "helm repo add bitnami https://charts.bitnami.com/bitnami"
 su - ubuntu -c "helm repo update"
 su - ubuntu -c "helm install bitnami/drupal --generate-name"
}

#### main
if [ `whoami` != root ]; then
  echo Please run this script with sudo
  exit
fi

install_desktop
install_k8s
install_vscode
# install_drupal

