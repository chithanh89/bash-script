#!/bin/bash
if [ $# -ne 4 ]
then
  echo "Usage: $0 <host> <port> <pattern> <seconds>"
  exit 1
fi

cursor=-1
keys=""
ttl=0
expire="$4"

while [ $cursor -ne 0 ]; do
  if [ $cursor -eq -1 ]
  then
    cursor=0
  fi

  reply=`redis-cli -h $1 -p $2 SCAN $cursor MATCH $3`
  cursor=`expr "$reply" : '\([0-9]*[0-9 ]\)'`
  keys=`echo $reply | cut -d' ' -f2-`

  for key in ${keys// / } ; do
    ttl=`redis-cli -h $1 -p $2 TTL $key`
    act=""

    if [ $ttl -eq -1 ] || [ $ttl != -2 ]
    then
      result=`redis-cli -h $1 -p $2 EXPIRE $key $expire`
      act=" -> $expire"
    fi
    echo "$key: $ttl$act"
  done
done
