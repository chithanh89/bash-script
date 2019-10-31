#!/bin/bash
set -e
# Zabbix Database credentials
USER=""
PASSWORD=""
HOST=""
DB_NAME=""
# Prometheus directory
DATA_DIR="/data/prometheus"
# Backup_Directory_Locations
DATE_TIME=$(date +"%d-%b-%Y")
S3BUCKET=""
S3BUCKET_PRO="$S3BUCKET/prometheus/sea"
S3BUCKET_ZABBIX="$S3BUCKET/zabbix/sea"
BACKUP_DIR="/home/thanhho"
# Log Directory
LOG_DIR="/var/log/backup_monitoring_$DATE_TIME.log"
exec &>> $LOG_DIR
# Slack hook url
SLACK=""
# Backup Command
# Prometheus Data
zip -r -q "$BACKUP_DIR/$DATE_TIME.zip" $DATA_DIR
aws s3 cp --quiet "$BACKUP_DIR/$DATE_TIME.zip" s3://$S3BUCKET_PRO/"$DATE_TIME.zip"
# Zabbix Database
mysqldump -h$HOST -u$USER $DB_NAME -p$PASSWORD --single-transaction | zip -q > "$BACKUP_DIR/$DB_NAME-$DATE_TIME.sql.zip"
aws s3 cp --quiet "$BACKUP_DIR/$DB_NAME-$DATE_TIME.sql.zip" s3://$S3BUCKET_ZABBIX/"$DB_NAME-$DATE_TIME.sql.zip"
# Check result on S3
s3_result=$(aws s3 ls s3://$S3BUCKET_PRO/ | grep -e "$DATE_TIME.zip" && aws s3 ls s3://$S3BUCKET_ZABBIX/ | grep -e "$DB_NAME-$DATE_TIME.sql.zip")
echo "File is uploaded to S3: $s3_result"
echo "####################################################################################"
# Check file on local and remove
local_result=$(find $BACKUP_DIR -type f -name "*.zip" | sort -n)
echo "File in local found: $local_result"
if [ "$local_result = $DATE_TIME.zip" ] || [ "$local_result = $DB_NAME-$DATE_TIME.sql.zip" ]
then
  rm -f "$BACKUP_DIR/$DATE_TIME.zip" && rm -f "$BACKUP_DIR/$DB_NAME-$DATE_TIME.sql.zip"
  echo "Local file has been removed"
else
  echo "No file to remove"
fi
# Stream content log file to slack
tail -n 15 "$LOG_DIR" | while read LINE; do
  (echo "$LINE") && curl -X POST --silent --data-urlencode \
    "payload={\"text\": \"$(echo $LINE | sed "s/\"/'/g")\"}" "$SLACK"
done
exit 1
