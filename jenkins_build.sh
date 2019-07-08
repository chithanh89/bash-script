#!/bin/bash
user="admin"
token=""
jenkins_url=""

PS3='Select an option and press Enter: '
job1="athena"
job2="driver-signup"
job3="newcc-client"
jobs=("$job1"
         "$job2"
         "$job3")
select job in "${jobs[@]}"
do
    case $job in
        *) reply=$REPLY
        read -p "Enter tag of repos: " tag
        read -p "Enter env to build: " env
        break;
    esac
done

curl -X POST "https://$user:$token@$jenkins_url/job/$job/buildWithParameters?TAG=$tag&ENV=$env"
sleep 10
status=$(curl --silent "https://$user:$token@$jenkins_url/job/$job/lastBuild/api/json")
echo "$status"
exit 1
