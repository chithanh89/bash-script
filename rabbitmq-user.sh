#!/bin/bash
users=("u1" "u2" "u3")
pass=""
tags=""
for u in "${users[@]}"
do
    case $u in
        *) reply=$REPLY
        rabbitmqctl add_user $u $pass
        sleep 1
        rabbitmqctl set_user_tags $u $tags
        sleep 1
        rabbitmqctl set_permissions -p / $u ".*" ".*" ".*"
        sleep 1
    esac
        rabbitmqctl list_users && rabbitmqctl list_user_permissions $u
done
exit 1 # remove when run by jenkins
