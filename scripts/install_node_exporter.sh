#!/bin/bash

cd /tmp
wget https://github.com/prometheus/node_exporter/releases/latest/download/node_exporter-linux-amd64.tar.gz
tar -xvf node_exporter-linux-amd64.tar.gz

sudo mv node_exporter-linux-amd64/node_exporter /usr/local/bin/

echo "Node Exporter Installed Successfully"
