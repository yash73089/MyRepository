#!/bin/bash -x
#Parameters
MYSQLADMIN_USER=`cat /home/parameters.txt | grep mysqlAdmin | cut -d'=' -f2`
MYSQLADMIN_USER_PASSWD=`cat /home/parameters.txt | grep mysqlPassword | cut -d'=' -f2`
USER_INPUT_PORT_NUMBER=`cat /home/parameters.txt | grep servicePortNo | cut -d'=' -f2`
MASTER_IP="MASTER_IP_TO_REPLACE"
SLAVE_IP="SLAVE_IP_TO_REPLACE"

/etc/init.d/mysqld status >> /home/slave.out
service mysqld status >> /home/slave.out
service mysql status >> /home/slave.out


# Retriving file_name and position for master and storing in a variable
FILE_NAME=`mysql -u "${MYSQLADMIN_USER}"  -p"${MYSQLADMIN_USER_PASSWD}" -h "${MASTER_IP}" --execute "SHOW MASTER STATUS\G" | head -2 | tail -1 | awk -F':' '{print $2}' | cut -d ' ' -f2`
POSITION=`mysql -u "${MYSQLADMIN_USER}"  -p"${MYSQLADMIN_USER_PASSWD}" -h "${MASTER_IP}" --execute "SHOW MASTER STATUS\G" | head -3 | tail -1 | awk -F':' '{print $2}' | cut -d ' ' -f2`



########## Changes on Slaves ###########
        #extracting only digit from hostname and reusing it for server-id
#j=`hostname -a | sed -e 's/[^0-9]/ /g' -e 's/^ *//g' -e 's/ *$//g' | tr -s ' ' | sed 's/ /\n/g'`
j="SERVER_ID_TO_REPLACE"
sed -i "s/.*server-id\s.*/server-id = $j/" /etc/my.cnf


mysql -u "${MYSQLADMIN_USER}" -p"${MYSQLADMIN_USER_PASSWD}" --execute "SET GLOBAL server_id=$j"  >> /home/slave.out

### Original query without bin-log file and position ###
#mysql -u "${MYSQLADMIN_USER}" -p"${MYSQLADMIN_USER_PASSWD}" --execute "STOP SLAVE;CHANGE MASTER TO MASTER_HOST=\"$MASTER_IP\", MASTER_USER='slave_user', MASTER_PASSWORD='admin';START SLAVE;"
#__________#


### New query with bin-log file and position ###
mysql -u "${MYSQLADMIN_USER}" -p"${MYSQLADMIN_USER_PASSWD}" --execute "STOP SLAVE;CHANGE MASTER TO MASTER_HOST=\"$MASTER_IP\", MASTER_PORT="${USER_INPUT_PORT_NUMBER}", MASTER_USER='slave_user', MASTER_PASSWORD='A3hnPrfDVgxw', MASTER_LOG_FILE=\"$FILE_NAME\", MASTER_LOG_POS=$POSITION;START SLAVE;" >> /home/slave.out
#______________________#


# Status of replica
Slave_IO_Running=`mysql -u "${MYSQLADMIN_USER}"  -p"${MYSQLADMIN_USER_PASSWD}" --execute "SHOW SLAVE STATUS\G" | grep 'Slave_IO_Running' | awk '{print $2}'`
Slave_SQL_Running=`mysql -u "${MYSQLADMIN_USER}"  -p"${MYSQLADMIN_USER_PASSWD}" --execute "SHOW SLAVE STATUS\G" | grep 'Slave_SQL_Running' | awk '{print $2}'`

if [ $Slave_IO_Running == "Yes" ] && [ $Slave_SQL_Running == "Yes" ]; then
        echo "Slave Configuration Done Successfully!"
else
        echo "Please check Slave configuration....."
fi

