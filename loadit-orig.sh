#!/bin/bash

for topic in `jq -r 'keys[]' ${1} `; do
  echo;
  for key in `jq .$topic ${1} | jq -r 'keys[]'`; do
    echo "$topic/$key:";
    myVal=`jq -r [".$topic | .$key"] ${1} | jq -r .[]`;
    echo "myVal: $myVal";
    ETCDCTL_API=3 etcdctl --endpoints=127.0.0.1:2379 put $topic/$key $myVal ;
    curl http://127.0.0.1:2379/v2/keys/$topic/$key -XPUT -d value="$myVal"
  done;
  echo;
done


