#!/bin/bash
user="admin"
token=""
jenkins_url=""

read -p "Enter jenkins jobs name: " jobs
read -p "Enter tag of repos: " tag
read -p "Enter env to build: " env

curl -X POST https://$user:$token@$jenkins_url/job/$jobs/buildWithParameters?TAG=$tag&ENV=$env
sleep 10
status=$(curl --silent https://$user:$token@$jenkins_url/job/$jobs/lastBuild/api/json)
echo "$status"
exit 1
