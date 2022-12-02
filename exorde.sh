#!/bin/bash

PS3='Select an action: '
options=(
"Install Node"
"Restart Node"
"Restart Single"
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

echo -e "\e[1m\e[32m    Enter worker number:\e[0m"
echo "_|-_|-_|-_|-_|-_|-_|"
read num
echo "_|-_|-_|-_|-_|-_|-_|"

wget -O get-docker.sh https://get.docker.com
sudo bash get-docker.sh

echo 'export ETH_ADDR='${addr} >> $HOME/.profile
source $HOME/.profile

for((i=1; i<=$num; i++)); do
  echo "========== Start worker $i =========="
  sudo docker run -d --restart unless-stopped --pull always --name exorde-cli-$i exordelabs/exorde-cli -m $ETH_ADDR -l 3
done

crontab -l > restartcron
echo "0 */12 * * * bash /home/${USER}/restart.sh" >> restartcron
crontab restartcron
rm restartcron


break
;;

"Restart Node")

echo -e "\e[1m\e[32m    Enter worker number:\e[0m"
echo "_|-_|-_|-_|-_|-_|-_|"
read num
echo "_|-_|-_|-_|-_|-_|-_|"

source ~/.profile

for((i=1; i<=$num; i++)); do
  echo "========== Restart worker $i =========="
  docker_id=$(sudo docker ps -a | grep "exorde-cli-${i}$" | cut -d ' ' -f 1)
  echo "$docker_id"

  if [[ -n $docker_id ]]
  then
    echo "delete old instance"
    sudo docker stop $docker_id
    sudo docker rm $docker_id
  else
    echo "docker instance is empty"
  fi

  sudo docker run -d --restart unless-stopped --pull always --name exorde-cli-$i exordelabs/exorde-cli -m $ETH_ADDR -l 3
done


break
;;

"Restart Single")

echo -e "\e[1m\e[32m    Enter worker id:\e[0m"
echo "_|-_|-_|-_|-_|-_|-_|"
read wid
echo "_|-_|-_|-_|-_|-_|-_|"

docker_id=$(sudo docker ps | grep "exorde-cli-${wid}$" | cut -d ' ' -f 1)
echo "$docker_id"

if [[ -n $docker_id ]]
then
  echo "delete old instance"
  sudo docker stop $docker_id
  sudo docker rm $docker_id
else
  echo "docker instance is empty"
fi

sudo docker run -d --restart unless-stopped --pull always --name exorde-cli-${wid} exordelabs/exorde-cli -m $ETH_ADDR -l 3

break
;;

"Check Log")

echo -e "\e[1m\e[32m    Enter worker id:\e[0m"
echo "_|-_|-_|-_|-_|-_|-_|"
read wid
echo "_|-_|-_|-_|-_|-_|-_|"

docker_id=$(sudo docker ps | grep "exorde-cli-${wid}$" | cut -d ' ' -f 1)
echo "$docker_id"
sudo docker logs $docker_id -f

break
;;

"Exit")
exit

esac
done
