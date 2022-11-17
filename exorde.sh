#!/bin/bash

wget -O get-docker.sh https://get.docker.com
sudo bash get-docker.sh

sudo docker run -d --restart unless-stopped --pull always --name exorde-cli rg.fr-par.scw.cloud/exorde-labs/exorde-cli -m $1 -l 3
