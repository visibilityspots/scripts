#!/bin/bash
#
# Script which deletes existing mysql db backups from the previous month, creates new ones and informs by mail.
# Author: Jan Collijs

usage()
{
cat << EOF
usage: $0 options

This script will create a mysqldump backup gzip file, removes existing ones of the previous month and informs by mail.

OPTIONS:
   -h      Show this message
   -c      Create backup
EOF
}

USER='MYSQLUSER'
PASSWORD='MYSQLPASSWORD'
BACKUPLOCATION="BACKUP/DESTINATION"
EMAIL='EMAIL@ADDRESS'
BACKUPDATE=$( date +%d-%m-%Y )

MONTHAGO=$(date +%m)
MONTHAGO=`expr $MONTHAGO - 1`

EXPIREDDATE=0$MONTHAGO-$( date +%Y )

DATABASES=$(mysql -u$USER -p$PASSWORD -Bse "show databases")
DATABASES=(${DATABASES[@]/mysql})
DATABASES=(${DATABASES[@]/information_schema})

while getopts "hc" flag
do
  case "$flag" in
    c)
        eval cd ${BACKUPLOCATION}
        rm mail -rf
        echo "This mail is send by $hostname to inform about the mysql backups." > mail
        echo "" >> mail
        echo "Result of backupped databases:" >> mail
        echo "" >> mail
        rm ./*$EXPIREDDATE.sql.gz -rf
        for db in ${DATABASES[@]}; do
                mysqldump -u$USER -p$PASSWORD --databases $db | gzip -c > ${db}-${BACKUPDATE}.sql.gz
                echo "* ${db}-${BACKUPDATE}.sql.gz => OK" >> mail
        done
        echo "" >> mail
        echo "Stored at ${BACKUPLOCATION}:" >> mail
        echo "" >> mail
        eval ls -latr ${BACKUPLOCATION} >> mail
        echo "" >> mail
        echo "Greetz" >> mail
        cat mail | mailx -s 'Weekly backup of mysql databases' $EMAIL
    ;;
    h)
      usage
      exit
    ;;
    *)
      usage
      exit
    ;;
  esac
done
