#!/bin/bash
user="admin"
token=""
jenkins_url=""

PS3='Select an option and press Enter: '
option1="athena"
option2="driver-signup"
option3="newcc-client"
options=("$option1"
         "$option2"
         "$option3")
select opt in "${options[@]}"
do
    case $opt in
        *) reply=$REPLY
        read -p "Enter tag of repos: " tag
        read -p "Enter env to build: " env
        break;
    esac
done

curl -X POST "https://$user:$token@$jenkins_url/job/$opt/buildWithParameters?TAG=$tag&ENV=$env"
sleep 10
status=$(curl --silent "https://$user:$token@$jenkins_url/job/$opt/lastBuild/api/json")
echo "$status"
exit 1
