#!/bin/bash
LOGFILE="/var/log/clamav/clamav-$(date +'%Y-%m-%d').log"
DIRTOSCAN="/var /opt"
# Host Details
HOST=$(hostname)
IP=$(hostname -I)
HOST_ENV=$(env)
# Slack Webhook
SLACK_WEBHOOK=""
SLACK_CHANNEL=""
SLACK_BOTNAME="clamav"
SLACK_ICON=":skull:"

for S in ${DIRTOSCAN}; do
 DIRSIZE=$(du -sh "$S" 2>/dev/null | cut -f1)

 echo "Starting a daily scan of "$S" directory.Amount of data to be scanned is "$DIRSIZE"."

 clamscan -ri "$S" >> "$LOGFILE"

 # get the value of "Infected lines"
 MALWARE=$(tail "$LOGFILE"|grep Infected|cut -d" " -f3)

 function notify() {
   # Get "Infected lines"
   MALWARE=$(tail "$LOGFILE"|grep Infected|cut -d" " -f3)
   if [ "$MALWARE" -ne "0" ]; then
     VIRUSES_FOUND=$(cat "$LOGFILE" | grep FOUND | cut -d" " -f2 | sort -u)
     MESSAGE="Found ${MALWARE} infected files on daily virus scan."
     SLACK_PAYLOAD="payload={\"channel\":\"${SLACK_CHANNEL}\",\"icon_emoji\":\":skull:\",\"username\":\"${SLACK_BOTNAME}\",\"attachments\":[{\"fallback\":\"${MESSAGE}\",\"color\":\"#333\",\"pretext\":\"${MESSAGE}\",\"fields\":[{\"title\":\"Host\",\"value\":\"${HOST}\",\"short\":true},{\"title\":\"Log Location\",\"value\":\"${LOGFILE}\",\"short\":true},{\"title\":\"Host IP(s)\",\"value\":\"${IP}\",\"short\":false},{\"title\":\"Viruses found\",\"value\":\"${VIRUSES_FOUND}\",\"short\":false}]}]}"
     curl -X POST --data-urlencode "${SLACK_PAYLOAD}" "${SLACK_WEBHOOK}"
   fi
 }
done

exit 0
