#!/bin/bash

PS3='Select an action: '
options=(
"Install Dependency"
"Install Node"
"Restart Node"
"Check Log"
"Exit")

select opt in "${options[@]}"
do
case $opt in

"Install Dependency")

wget -O get-docker.sh https://get.docker.com
sudo bash get-docker.sh

sudo groupadd docker
sudo usermod -aG docker $USER

break
;;

"Install Node")

echo -e "\e[1m\e[32m	Enter eth address:\e[0m"
echo "_|-_|-_|-_|-_|-_|-_|"
read addr
echo "_|-_|-_|-_|-_|-_|-_|"

echo -e "\e[1m\e[32m    Enter worker number:\e[0m"
echo "_|-_|-_|-_|-_|-_|-_|"
read num
echo "_|-_|-_|-_|-_|-_|-_|"

echo 'export ETH_ADDR='${addr} >> $HOME/.profile
source $HOME/.profile

for((i=1; i<=$num; i++)); do
  echo "========== Start worker $i =========="
  docker run -d --restart unless-stopped --pull always --name exorde-cli-$i rg.fr-par.scw.cloud/exorde-labs/exorde-cli -m $ETH_ADDR -l 3
done

crontab -l > restartcron
echo "0 */12 * * * bash /home/${USER}/restart1.sh" >> restartcron
crontab restartcron
rm restartcron

break
;;

"Restart Node")

echo -e "\e[1m\e[32m    Enter worker number:\e[0m"
echo "_|-_|-_|-_|-_|-_|-_|"
read num
echo "_|-_|-_|-_|-_|-_|-_|"

source $HOME/.profile

for((i=1; i<=$num; i++)); do
  echo "========== Restart worker $i =========="
  docker_id=$(docker ps -a | grep "exorde-cli-${i}$" | cut -d ' ' -f 1)
  echo "$docker_id"

  if [[ -n $docker_id ]]
  then
    echo "delete old instance"
    docker stop $docker_id
    docker rm $docker_id
  else
    echo "docker instance is empty"
  fi

  docker run -d --restart unless-stopped --pull always --name exorde-cli-$i rg.fr-par.scw.cloud/exorde-labs/exorde-cli -m $ETH_ADDR -l 3
done

break
;;

"Check Log")

echo -e "\e[1m\e[32m    Enter worker id:\e[0m"
echo "_|-_|-_|-_|-_|-_|-_|"
read wid
echo "_|-_|-_|-_|-_|-_|-_|"

docker_id=$(docker ps | grep "exorde-cli-${wid}$" | cut -d ' ' -f 1)
echo "$docker_id"
docker logs $docker_id -f

break
;;

"Exit")
exit

esac
done
