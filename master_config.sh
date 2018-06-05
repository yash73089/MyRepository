#!/bin/bash -x
#Parameters
MYSQLADMIN_USER=`cat /home/parameters.txt | grep mysqlAdmin | cut -d'=' -f2`
MYSQLADMIN_USER_PASSWD=`cat /home/parameters.txt | grep mysqlPassword | cut -d'=' -f2`
MASTER_IP="MASTER_IP_TO_REPLACE"
SLAVE_IP="SLAVE_IP_TO_REPLACE"

########## Changes on Master ###########

# Creating slave_user on master
#for i in `cat /home/hosts_details.txt  | awk '{print $1}'`; do
mysql -u "${MYSQLADMIN_USER}" -p"${MYSQLADMIN_USER_PASSWD}" --execute "GRANT ALL PRIVILEGES ON *.* TO slave_user@'%' IDENTIFIED BY 'A3hnPrfDVgxw';FLUSH PRIVILEGES;"
#done

# Retriving file_name and position for master and storing in a variable
#FILE_NAME = `mysql -u "${MYSQLADMIN_USER}"  -p"${MYSQLADMIN_USER_PASSWD}" --execute "SHOW MASTER STATUS\G" | head -2 | tail -1 | awk -F':' '{print $2}'`
#POSITION=`mysql -u "${MYSQLADMIN_USER}"  -p"${MYSQLADMIN_USER_PASSWD}" --execute "SHOW MASTER STATUS\G" | head -3 | tail -1 | awk -F':' '{print $2}'`

##########################################

