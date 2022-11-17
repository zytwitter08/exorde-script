#!/bin/bash

PS3='Select an action: '
options=(
"Install Node"
"Restart Node"
"Check Log"
"Exit")

select opt in "${options[@]}"
do
case $opt in

"Install Node")

echo -e "\e[1m\e[32m	Enter eth address:\e[0m"
echo "_|-_|-_|-_|-_|-_|-_|"
read addr
echo "_|-_|-_|-_|-_|-_|-_|"

wget -O get-docker.sh https://get.docker.com
sudo bash get-docker.sh

echo 'export ETH_ADDR='${addr} >> $HOME/.profile
source $HOME/.profile

sudo docker run -d --restart unless-stopped --pull always --name exorde-cli rg.fr-par.scw.cloud/exorde-labs/exorde-cli -m $ETH_ADDR -l 3


break
;;

"Restart Node")
echo -e "\e[1m\e[32m    Enter eth address:\e[0m"
echo "_|-_|-_|-_|-_|-_|-_|"
read addr
echo "_|-_|-_|-_|-_|-_|-_|"

docker_id=$(sudo docker ps | grep exorde | cut -d ' ' -f 1)
echo "$docker_id"
sudo docker stop $docker_id
sudo docker rm $docker_id

sudo docker run -d --restart unless-stopped --pull always --name exorde-cli rg.fr-par.scw.cloud/exorde-labs/exorde-cli -m $ETH_ADDR -l 3

break
;;

"Check Log")
docker_id=$(sudo docker ps | grep exorde | cut -d ' ' -f 1)
echo "$docker_id"
sudo docker logs $docker_id -f

break
;;

"Exit")
exit

esac
done
