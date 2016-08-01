#!/bin/sh

# This script will be called from a cron job on the server using the below command
# 0 2 * * curl https://raw.githubusercontent.com/Bahmni/bahmni-scripts/master/demo/db-backups/v0.82/dbRestore.sh | sh  > /home/centos/dbRestoreLog.log

. ~/.cronfile

GITHUB_BASE_URL="https://github.com/Bahmni/bahmni-scripts/raw/master/demo/db-backups/v0.82"

OPENELIS_SQL_FILE="openelis_backup.sql"
OPENERP_SQL_FILE="openerp_backup.sql"
OPENMRS_SQL_FILE="openmrs_backup.sql"
DEST_LOCATION="/home/centos/dbRestore"
OPENMRS_DB_FILE_NAME="openmrs_backup.sql"
OPENELIS_DB_FILE_NAME="openelis_backup.sql"
OPENERP_DB_FILE_NAME="openerp_backup.sql"
OPENELIS_DB_NAME="clinlims"
OPENERP_DB_NAME="openerp"


setup(){
	rm -rf $DEST_LOCATION
	mkdir $DEST_LOCATION	
}

download_and_unzip(){
	wget -O $DEST_LOCATION/$OPENELIS_SQL_FILE.gz $GITHUB_BASE_URL/$OPENELIS_SQL_FILE.gz
	wget -O $DEST_LOCATION/$OPENERP_SQL_FILE.gz $GITHUB_BASE_URL/$OPENERP_SQL_FILE.gz
	wget -O $DEST_LOCATION/$OPENMRS_SQL_FILE.gz $GITHUB_BASE_URL/$OPENMRS_SQL_FILE.gz

	gzip -d $DEST_LOCATION/$OPENELIS_SQL_FILE.gz $DEST_LOCATION/$OPENERP_SQL_FILE.gz $DEST_LOCATION/$OPENMRS_SQL_FILE.gz	
}

restore(){
	echo "Restoring the database"
	bahmni stop
	mysql -u$SQLUSER -p$PASSWORD -e "drop database openmrs"
	mysql -u$SQLUSER -p$PASSWORD -e "create database openmrs"
	mysql -u$SQLUSER -p$PASSWORD openmrs < $DEST_LOCATION/$OPENMRS_DB_FILE_NAME
	mysql -u$SQLUSER -p$PASSWORD -e "FLUSH PRIVILEGES"
	psql -U$PSQLUSER -c "drop database if exists clinlims;"
	psql -U$PSQLUSER -c "create database clinlims;"
	psql -U$CLINLIMSUSER $OPENELIS_DB_NAME < $DEST_LOCATION/$OPENELIS_DB_FILE_NAME
	psql -U$PSQLUSER -c  "drop database if exists openerp;"
	psql -U$PSQLUSER -c  "create database openerp;"
	psql -U$OPENERPUSER $OPENERP_DB_NAME < $DEST_LOCATION/$OPENERP_DB_FILE_NAME
	bahmni start	
}

setup
download_and_unzip
restore
