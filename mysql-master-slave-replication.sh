#!/bin/bash -x

#Parameters 
MYSQLADMIN_USER=`cat /home/parameters.txt | grep mysqlAdmin | cut -d'=' -f2`
MYSQLADMIN_USER_PASSWD=`cat /home/parameters.txt | grep mysqlPassword | cut -d'=' -f2`


#################### Parsing JSON #########################	


START=0
END=`jq '.comps.comp | length' test.txt`
for (( i=$START; i<=$END; i++ ))
do
   type=`cat test.txt | jq .comps.comp[$i].type`
#echo "$type"
        if [ "$type" == "\"master\"" ]; then
#               echo "This is master server"
                MASTER_IP=`cat test.txt | jq .comps.comp[$i].private_ip | tr -d '"'`
#               echo "Master ip is : $MASTER_IP"
        fi
done
### master done###

### Slave ###

for (( i=$START; i<=$END; i++ ))
do
   type=`cat test.txt | jq .comps.comp[$i].type`
        if [  "$type" == "\"Slave-Local\"" ]; then
                SLAVE_IP=`cat test.txt | jq .comps.comp[$i].private_ip | tr -d '"'`
                echo "Local Slave ip $SLAVE_IP"
		mysql -u$MYSQLADMIN_USER -p'$MYSQLADMIN_USER_PASSWD' -h '$MASTER_IP' --execute "GRANT ALL PRIVILEGES ON *.* TO slave_user@'%' IDENTIFIED BY 'admin';FLUSH PRIVILEGES;"
        fi
done

### Remote Slave ###

for (( i=$START; i<=$END; i++ ))
do
   type=`cat test.txt | jq .comps.comp[$i].type`
        if [  "$type" == "\"Slave-Remote\"" ]; then
 #               echo "This is Remote Slave Server"
                REMOTE_SLAVE_IP=`cat test.txt | jq .comps.comp[$i].natted_public_ip | tr -d '"'`
#                echo "Remote Slave server is : $REMOTE_SLAVE_IP"
        fi
done


echo "master ip $MASTER_IP"
echo "Local Slave ip $SLAVE_IP"
echo "Remote Slave ip $REMOTE_SLAVE_IP"


##############################################################

















































MASTER_IP=`egrep -i "mast" /home/ip_details.txt | awk '{print $1}'`

########## Changes on Master ###########

# Creating slave_user on master
for i in `cat /home/hosts_details.txt  | awk '{print $1}'`; do
mysql -u$MYSQLADMIN_USER -p'$MYSQLADMIN_USER_PASSWD' -h '$MASTER_IP' --execute "GRANT ALL PRIVILEGES ON *.* TO slave_user@'%' IDENTIFIED BY 'admin';FLUSH PRIVILEGES;"
done

# Retriving file_name and position for master and storing in a variable
FILE_NAME = `mysql -u$MYSQLADMIN_USER  -p'$MYSQLADMIN_USER_PASSWD' --execute "SHOW MASTER STATUS\G" | head -2 | tail -1 | awk -F':' '{print $2}'`
POSITION=`mysql -u$MYSQLADMIN_USER  -p'$MYSQLADMIN_USER_PASSWD' --execute "SHOW MASTER STATUS\G" | head -3 | tail -1 | awk -F':' '{print $2}'`

##########################################


########## Changes on Slaves ###########
	#extracting only digit from hostname and reusing it for server-id
j=`hostname -a | sed -e 's/[^0-9]/ /g' -e 's/^ *//g' -e 's/ *$//g' | tr -s ' ' | sed 's/ /\n/g'`
sed -i "s/.*server-id\s.*/server-id = $j/" /etc/my.cnf

mysql -u$MYSQLADMIN_USER -p'$MYSQLADMIN_USER_PASSWD' --execute "STOP SLAVE;CHANGE MASTER TO MASTER_HOST='$MASTER_IP', MASTER_USER='replica_user', MASTER_PASSWORD='r3p1!)@_u53r', MASTER_LOG_FILE='$FILE_NAME', MASTER_LOG_POS=$POSITION;START SLAVE;"

# Status of replica
Slave_IO_Running=`mysql -u$MYSQLADMIN_USER  -p'$MYSQLADMIN_USER_PASSWD' --execute "SHOW SLAVE STATUS\G" | grep 'Slave_IO_Running' | awk '{print $2}'
Slave_SQL_Running=`mysql -uroot  -p'ou812c' --execute "SHOW SLAVE STATUS\G" | grep 'Slave_SQL_Running' | awk '{print $2}'`

if [ $Slave_IO_Running == "Yes" && $Slave_SQL_Running == "Yes" ];then
	echo "Slave Configuration Done Successfully!"
else
	echo "Please check Slave configuration....."
fi

