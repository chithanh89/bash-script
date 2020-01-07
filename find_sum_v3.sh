#!/bin/bash
workdir=$WORKSPACE
version=$VERSION
slack_upload_script_dir=/home/thanhho
channel='#team-itops'
slack_token=
file_dir=$workdir/sum-$version/*
title='Releases-Note-Summary'
options=("beforeShutdown" "shuttingdown" "startServer")
for f in "${options[@]}"
do
  if [ -d "$workdir/sum-$version" ]
    then
    echo "Folder exists"
  else
    mkdir $workdir/sum-$version
  fi
    case $f in
        *) reply=$REPLY
        select_folder=$(find $workdir/$version -type d -name "$f")
        find $select_folder -type f -name "*.md" \( -exec echo {} \; -o -exec true \; \) -exec cat {} \;  > $workdir/sum-$version/$f-sum.txt
    esac
done

for f1 in $file_dir
do
  if [ -f "$slack_upload_script_dir/slack-upload.sh" ]
    then
    echo "Script is existed"
  else
    git clone "https://github.com/guzzijason/slack-upload-bash.git"
  fi
cd $slack_upload_script_dir
  ./slack-upload.sh -f $f1 -c $channel -s $slack_token -n $f1
done
exit 0
