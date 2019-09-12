#!/bin/bash
workdir=$WORKSPACE
version=$VERSION
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
        path=$(find $select_folder -type f -name "*.md")
 	      find $path -type f -name "*.md" \( -exec echo {} \; -o -exec true \; \) -exec cat {} \;  > $workdir/sum-$version/$f-sum.txt
    esac
done
exit 1 # remove when run by jenkins
