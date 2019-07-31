#!/bin/bash
workdir=""
folder_sum=/home
PS3='Select an option and press Enter: '
folder=("beforeShutdown" "shuttingdown" "startServer")
select f in "${folder[@]}"
do
  cd $workdir
  name=$(printf '%s\n' "${PWD##*/}")  # get current folder name
  if [ -d "$folder_sum/$name" ]
    then
      echo "Folder exists"
    else
      mkdir $folder_sum/$name
  fi
    case $f in
        *) reply=$REPLY
        select_folder=$(find $workdir -type d -name "$f")
        find $select_folder -type f -name "*.md" -exec cat {} + > $folder_sum/$name/$f-sum.txt
        break;
    esac
done
exit 1  # remove when run by jenkins
