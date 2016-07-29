#!/bin/sh

. ~/.cronfile

DB_BACKUP_FOLDER="/home/centos/dbRestore"
OPENMRS_DB_FILE_NAME="openmrs_backup.sql"
OPENELIS_DB_FILE_NAME="openelis_backup.sql"
OPENERP_DB_FILE_NAME="openerp_backup.sql"
OPENELIS_DB_NAME="clinlims"
OPENERP_DB_NAME="openerp"

echo "Restoring the database"
bahmni stop
mysql -u$SQLUSER -p$PASSWORD -e "drop database openmrs"
mysql -u$SQLUSER -p$PASSWORD -e "create database openmrs"
mysql -u$SQLUSER -p$PASSWORD openmrs < $DB_BACKUP_FOLDER/$OPENMRS_DB_FILE_NAME
mysql -u$SQLUSER -p$PASSWORD -e "FLUSH PRIVILEGES"
psql -U$PSQLUSER -c "drop database if exists clinlims;"
psql -U$PSQLUSER -c "create database clinlims;"
psql -U$CLINLIMSUSER $OPENELIS_DB_NAME < $DB_BACKUP_FOLDER/$OPENELIS_DB_FILE_NAME
psql -U$PSQLUSER -c  "drop database if exists openerp;"
psql -U$PSQLUSER -c  "create database openerp;"
psql -U$OPENERPUSER $OPENERP_DB_NAME < $DB_BACKUP_FOLDER/$OPENERP_DB_FILE_NAME
bahmni start
