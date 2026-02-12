#!/bin/bash

sudo useradd --no-create-home --shell /bin/false prometheus
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus

cd /tmp
wget https://github.com/prometheus/prometheus/releases/latest/download/prometheus-linux-amd64.tar.gz
tar -xvf prometheus-linux-amd64.tar.gz

sudo mv prometheus-linux-amd64/prometheus /usr/local/bin/
sudo mv prometheus-linux-amd64/promtool /usr/local/bin/

echo "Prometheus Installed Successfully"
