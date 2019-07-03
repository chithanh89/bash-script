#!/bin/bash
remote_user="ct"
ssh_key="~/.ssh/id_rsa"
read -p "Enter remote server IP: " remote_sv_ip
if ssh -i $ssh_key $remote_user@$remote_sv_ip "true"
  then
    echo "$remote_sv_ip connect successful"
  else
    echo "$remote_sv_ip cannot connect"
    exit 1
fi

PS3='Select an option and press Enter: '
option1="/var/log/syslog"
option2="/var/log/mongodb/mongod.log"
option3="/opt/tomcat/logs/catalina.out"
options=("$option1"
         "$option2"
         "$option3")

select opt in "${options[@]}"
do
  case $opt in
    "$option1")
    ssh -i $ssh_key $remote_user@$remote_sv_ip "sudo tail -f $opt"
    break
    ;;
    "$option2")
    ssh -i $ssh_key $remote_user@$remote_sv_ip "sudo tail -f $opt"
    break
    ;;
    "$option3")
    ssh -i $ssh_key $remote_user@$remote_sv_ip "sudo tail -f $opt"
    break
    ;;
    *) echo "invalid option";;
  esac
done
