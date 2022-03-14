update_env () {
# update binaries
echo "apt repo update..."
apt-get -y -qq update
apt-get -y -qq upgrade
}

install_desktop () {
update_env 	
# apt-get install -y lubuntu-desktop xrdp
# apt-get remove -y --purge libreoffice* transmission* vlc* 2048* skanlite* bluedevil* trojita* qpdfview* pulseaudio* ark* byobu* feather* kcalc*
# apt-get remove -y --purge qlipper* compton* noblenote* *speech* *gphoto2* *modem* lximage* usb-creator* qps* *fcitx*
echo ".....installing desktop..."
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq ubuntu-budgie-desktop xrdp firefox
apt-get clean
apt-get -y -qq autoremove
rdm=`date +%s | sha256sum | base64 | head -c 5 ; echo`
echo "ubuntu:passw0rd$rdm" | chpasswd
echo "..................................remote desktop login:ubuntu password:passw0rd$rdm"
}

install_k8s () {
cd /tmp
echo ".....installing microk8s..."
snap install microk8s --classic
microk8s enable storage
microk8s enable registry
microk8s enable metrics-server
microk8s enable prometheus
microk8s enable ingress metallb:192.168.55.10-192.168.55.30
if [ ! -d /home/ubuntu/.kube ];then
 mkdir /home/ubuntu/.kube
fi 
microk8s config > /home/ubuntu/.kube/config
chmod 600 /home/ubuntu/.kube/config
usermod -a -G microk8s ubuntu
chown -R ubuntu:ubuntu /home/ubuntu/.kube
snap install helm --classic
snap install kubectl --classic
snap install kontena-lens --classic
}

install_vscode () {
echo ".....installing vscode..."
snap install code --classic
su - ubuntu -c "code --install-extension nocalhost.nocalhost"
# wget -O /usr/local/bin/nhctl https://github.com/nocalhost/nocalhost/releases/download/v0.6.15/nhctl-linux-amd64
# chmod +x /usr/local/bin/nhctl
echo "fs.inotify.max_user_watches=204800" | sudo tee -a /etc/sysctl.conf
}

install_drupal () {
echo "installing drupal..."
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

