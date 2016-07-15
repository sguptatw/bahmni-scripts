#!/bin/sh

echo "Restroing the database"
sudo bahmni stop
sudo mysql -uroot -ppassword -e "drop database openmrs"
sudo mysql -uroot -ppassword -e "create database openmrs"
sudo mysql -uroot -ppassword openmrs < /home/centos/dbRestore/openmrs_demo_dump.sql
sudo mysql -uroot -ppassword -e "FLUSH PRIVILEGES"
sudo psql -Upostgres -c "drop database if exists clinlims;"
sudo psql -Upostgres -c "create database clinlims;"
sudo psql -Uclinlims clinlims < /home/centos/dbRestore/openelis_demo_dump.sql
sudo psql -Upostgres -c  "drop database if exists openerp;"
sudo psql -Upostgres -c  "create database openerp;"
sudo psql -Uopenerp openerp < /home/centos/dbRestore/openerp_demo_dump.sql
sudo bahmni start
