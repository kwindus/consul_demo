#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 config_root_dir get_ui_Y_N" >&2
  exit 1
fi
rootdir="$1"

sudo apt-get update
sudo apt-get install -y unzip
sudo apt-get install -y curl

# Get Consul.
echo Downloading and installing consul
cd /tmp
wget https://dl.bintray.com/mitchellh/consul/0.5.2_linux_amd64.zip -O consul.zip
cd /usr/local/bin/
mv /tmp/consul.zip .
sudo unzip consul.zip
sudo rm consul.zip
sudo chmod +x /usr/local/bin/consul

# Get UI if needed.
sudo mkdir -p /usr/local/bin/dist
if [ "$2" == "Y" ]; then
    echo Downloading and installing ui
    cd /tmp
    wget https://releases.hashicorp.com/consul/0.6.0/consul_0.6.0_web_ui.zip -O ui.zip
    cd /usr/local/bin/dist
    mv /tmp/ui.zip .
    sudo unzip ui.zip
    sudo rm ui.zip
fi

# Consul directories and files.
sudo mkdir -p /etc/consul.d
sudo chmod a+w /etc/consul.d
sudo mkdir -p /tmp/consul
sudo chmod a+w /tmp/consul
cp /vagrant/${rootdir}/*.* /etc/consul.d/
sudo chmod a+wrx /etc/consul.d/*.*
sudo cp /vagrant/common/consul.conf /etc/init/consul.conf
sudo rm /etc/motd
sudo cp /vagrant/common/motd.txt /etc/motd

# Start consul.
sudo start consul
