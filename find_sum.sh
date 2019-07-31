#!/bin/bash
workdir=${WORKSPACE}
folder_sum=/home
PS3='Select an option and press Enter: '
folder=("beforeShutdown" "shuttingdown" "startServer")
select f in "${folder[@]}"
do
    case $f in
        *) reply=$REPLY
        select_folder=$(find $workdir -type d -name "$f")
        find $select_folder -type f -name "*.md" -exec cat {} + > $folder_sum/$f-sum.txt
        break;
    esac
done
exit 1
