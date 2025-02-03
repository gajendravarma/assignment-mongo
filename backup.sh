#!/bin/bash
TIMESTAMP=$(date +%F-%H%M)
BACKUP_DIR="/home/ubuntu/mongo_backups"
mkdir -p $BACKUP_DIR
mongodump --out $BACKUP_DIR/mongodump-$TIMESTAMP
find $BACKUP_DIR -type d -mtime +7 -exec rm -rf {} \;  # delete backups older than 7 days(optional)
