#!/bin/sh

# This script will be called from a cron job on the server using the below command
# 0 2 * * curl https://raw.githubusercontent.com/Bahmni/bahmni-scripts/master/demo/db-backups/end-tb/dbRestore.sh | sh  > /home/centos/dbRestoreLog.log

. ~/.cronfile

GITHUB_BASE_URL="https://github.com/Bahmni/bahmni-scripts/raw/master/demo/db-backups/end-tb"


OPENMRS_SQL_FILE="openmrs_backup.sql"
DEST_LOCATION="/home/centos/dbRestore"
OPENMRS_DB_FILE_NAME="openmrs_backup.sql"

setup(){
	rm -rf $DEST_LOCATION
	mkdir $DEST_LOCATION	
}

download_and_unzip(){
	
        wget -O $DEST_LOCATION/$OPENMRS_SQL_FILE.gz $GITHUB_BASE_URL/$OPENMRS_SQL_FILE.gz
        gzip -d $DEST_LOCATION/$OPENMRS_SQL_FILE.gz	
}
restore(){
        echo "Restoring the database"
        bahmni -i inventory stop
        mysql -u$SQLUSER -p$PASSWORD -e "drop database openmrs"
        mysql -u$SQLUSER -p$PASSWORD -e "create database openmrs"
        mysql -u$SQLUSER -p$PASSWORD openmrs < $DEST_LOCATION/$OPENMRS_DB_FILE_NAME
        bahmni -i inventory start
}

setup
download_and_unzip
restore
