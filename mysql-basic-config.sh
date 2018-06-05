#!/bin/bash

## INPUT FROM USER FOR DB ##
        # Mandatory Parameters
DIR="/data"
USER_INPUT_MYSQLADMIN_USER=`cat /home/parameters.txt | grep mysqlAdmin | cut -d'=' -f2`
USER_INPUT_MYSQLADMIN_PASSWD=`cat /home/parameters.txt | grep mysqlPassword | cut -d'=' -f2`
USER_INPUT_PORT_NUMBER=`cat /home/parameters.txt | grep servicePortNo | cut -d'=' -f2`
USER_INPUT_MAX_CONN=`cat /home/parameters.txt | grep maxConnection | cut -d'=' -f2`
USER_INNODB_BUFFER_SIZE=`cat /home/parameters.txt | grep innodb_buffer_pool_size | cut -d'=' -f2`
#USER_INPUT_MAX_CONN=$4

        # Optional Parameters
USER_INPUT_DATABASENAME=`cat /home/parameters.txt | grep dbName | cut -d'=' -f2`
USER_INPUT_DBUSER=`cat /home/parameters.txt | grep dbUserName | cut -d'=' -f2`
USER_INPUT_DBPASSWD=`cat /home/parameters.txt | grep dbPassword | cut -d'=' -f2`
host=`hostname`

## OS configuration check parameters ##
#cpu_core=`grep --count ^processor /proc/cpuinfo`
#memory=`free -hg | awk 'NR==2 {print $2}'`
#dsk_size_cent=`fdisk -l | grep 'sd.:' | grep -m1 ^Disk | awk '{print $3}'`
#dsk_size_ubunt=`parted -l | head -2 | tail -1 | awk -F' ' '{print $3}'`



######################## MYSQL_CONFIG_CENTOS5_6_STANDALONE ######################


function MYSQL_CONFIG_CENTOS5_6_STANDALONE {
echo "Updating port number in my.cnf...."
# Passing selected parameters to my.cnf file
sed -i "s/.*port\s.*/port = $USER_INPUT_PORT_NUMBER/" /etc/my.cnf
sed -i "s/.*max_connections\s.*/max_connections = $USER_INPUT_MAX_CONN/" /etc/my.cnf
sed -i "s/.*innodb_buffer_pool_size\s.*/innodb_buffer_pool_size = $USER_INNODB_BUFFER_SIZE/" /etc/my.cnf

#/etc/sysctl.conf TCP performance Tuning
sed -i '$ a net.ipv4.tcp_max_syn_backlog = 4096' /etc/sysctl.conf
sed -i '$ a net.core.somaxconn = 1024' /etc/sysctl.conf
sed -i '$ a ### Interface buffering' /etc/sysctl.conf
sed -i '$ a net.core.netdev_max_backlog = 2500' /etc/sysctl.conf
sed -i '$ a ifconfig eth0 txqueuelen 1000' /etc/rc.local
sed -i '$ a ifconfig eth1 txqueuelen 1000' /etc/rc.local
sed -i '$ a ifconfig eth2 txqueuelen 1000' /etc/rc.local
sed -i '$ a ifconfig eth3 txqueuelen 1000' /etc/rc.local
sed -i '$ a net.ipv4.tcp_syn_retries = 6' /etc/sysctl.conf
sed -i '$ a net.ipv4.tcp_synack_retries = 6' /etc/sysctl.conf
sed -i '$ a net.ipv4.tcp_keepalive_time = 30' /etc/sysctl.conf
sed -i '$ a net.ipv4.tcp_keepalive_intvl = 1' /etc/sysctl.conf
sed -i '$ a net.ipv4.tcp_keepalive_probes = 2' /etc/sysctl.conf
sed -i '$ a net.ipv4.tcp_no_metrics_save = 1' /etc/sysctl.conf
sed -i '$ a net.core.netdev_max_backlog = 5000' /etc/sysctl.conf
sysctl -p
# Passing all parameters to my.cnf file
#egrep -v "(mysqlAdmin|mysqlPassword|dbUserName|dbPassword|dbName)" /home/parameters.txt >> /etc/my.cnf



## A) mysqladmin user (mandatory)##
echo "Updating $USER_INPUT_MYSQLADMIN_USER in mysql...."
mysql -u root -p'ou812c' --execute "use mysql;DROP USER ''@'$host';DROP USER ''@'localhost';update user set user='$USER_INPUT_MYSQLADMIN_USER' where user='root';update user set password=PASSWORD('$USER_INPUT_MYSQLADMIN_PASSWD') where user='$USER_INPUT_MYSQLADMIN_USER';GRANT ALL PRIVILEGES ON *.* TO $USER_INPUT_MYSQLADMIN_USER@'%' IDENTIFIED BY '${USER_INPUT_MYSQLADMIN_PASSWD}';flush privileges;"


echo "A) mysqladmin user (mandatory) done!"

## B) Create Database & DBuser grant privileges (optional)##

#Note: - We will hit following queries only when we get input from user for new database and its new user (hit api and get output)
#Condition to check whether there is any input from user for new db and its user

mysql -u $USER_INPUT_MYSQLADMIN_USER -p"${USER_INPUT_MYSQLADMIN_PASSWD}" --execute "create database $USER_INPUT_DATABASENAME;"

echo "Database $USER_INPUT_DATABASENAME has been created successfully...."

if [ $USER_INPUT_DBUSER == $USER_INPUT_MYSQLADMIN_USER ]; then
        exit 0
else
        if [ $USER_INPUT_DBUSER != $USER_INPUT_MYSQLADMIN_USER ]; then
                mysql -u $USER_INPUT_MYSQLADMIN_USER -p"${USER_INPUT_MYSQLADMIN_PASSWD}" --execute "CREATE USER $USER_INPUT_DBUSER@'localhost' identified by '${USER_INPUT_DBPASSWD}';GRANT ALL PRIVILEGES ON $USER_INPUT_DATABASENAME.* TO $USER_INPUT_DBUSER@'localhost' IDENTIFIED BY '${USER_INPUT_DBPASSWD}';FLUSH PRIVILEGES;"
        fi
fi


echo "B) Create Database & DBuser grant privileges (optional)"

## C) Changing data-directory after adding additional disk##
service mysqld stop
if [ -d "$DIR" ]; then
   mkdir -p $DIR/mysql
   cp -r -p /var/lib/mysql/* $DIR/mysql
   chown -R mysql:mysql $DIR/mysql
   sed -i 's#/var/lib#/data#g' /etc/my.cnf
   echo "data-directory changed"
fi

echo "restarting mysql server"
service mysqld stop
service mysqld start

}




######################## MYSQL_CONFIG_CENTOS_7_STANDALONE ######################
function MYSQL_CONFIG_CENTOS_7_STANDALONE {
echo "Updating port number in my.cnf...."
# Passing selected parameters to my.cnf file
sed -i "s/.*port\s.*/port = $USER_INPUT_PORT_NUMBER/" /etc/my.cnf
sed -i "s/.*max_connections\s.*/max_connections = $USER_INPUT_MAX_CONN/" /etc/my.cnf
sed -i "s/.*innodb_buffer_pool_size\s.*/innodb_buffer_pool_size = $USER_INNODB_BUFFER_SIZE/" /etc/my.cnf

#/etc/sysctl.conf TCP performance Tuning
sed -i '$ a net.ipv4.tcp_max_syn_backlog = 4096' /etc/sysctl.conf
sed -i '$ a net.core.somaxconn = 1024' /etc/sysctl.conf
sed -i '$ a ### Interface buffering' /etc/sysctl.conf
sed -i '$ a net.core.netdev_max_backlog = 2500' /etc/sysctl.conf
sed -i '$ a ifconfig eth0 txqueuelen 1000' /etc/rc.local
sed -i '$ a ifconfig eth1 txqueuelen 1000' /etc/rc.local
sed -i '$ a ifconfig eth2 txqueuelen 1000' /etc/rc.local
sed -i '$ a ifconfig eth3 txqueuelen 1000' /etc/rc.local
sed -i '$ a net.ipv4.tcp_syn_retries = 6' /etc/sysctl.conf
sed -i '$ a net.ipv4.tcp_synack_retries = 6' /etc/sysctl.conf
sed -i '$ a net.ipv4.tcp_keepalive_time = 30' /etc/sysctl.conf
sed -i '$ a net.ipv4.tcp_keepalive_intvl = 1' /etc/sysctl.conf
sed -i '$ a net.ipv4.tcp_keepalive_probes = 2' /etc/sysctl.conf
sed -i '$ a net.ipv4.tcp_no_metrics_save = 1' /etc/sysctl.conf
sed -i '$ a net.core.netdev_max_backlog = 5000' /etc/sysctl.conf
sysctl -p
# Passing all parameters to my.cnf file
#egrep -v "(mysqlAdmin|mysqlPassword|dbUserName|dbPassword|dbName)" /home/parameters.txt >> /etc/my.cnf



## A) mysqladmin user (mandatory)##
echo "Updating $USER_INPUT_MYSQLADMIN_USER in mysql...."
mysql -u root -p'ou812c' --execute "use mysql;DROP USER ''@'$host';DROP USER ''@'localhost';update user set user='$USER_INPUT_MYSQLADMIN_USER' where user='root';update user set password=PASSWORD('$USER_INPUT_MYSQLADMIN_PASSWD') where user='$USER_INPUT_MYSQLADMIN_USER';GRANT ALL PRIVILEGES ON *.* TO $USER_INPUT_MYSQLADMIN_USER@'%' IDENTIFIED BY '${USER_INPUT_MYSQLADMIN_PASSWD}';flush privileges;"


echo "A) mysqladmin user (mandatory) done!"

## B) Create Database & DBuser grant privileges (optional)##

#Note: - We will hit following queries only when we get input from user for new database and its new user (hit api and get output)
#Condition to check whether there is any input from user for new db and its user

mysql -u $USER_INPUT_MYSQLADMIN_USER -p"${USER_INPUT_MYSQLADMIN_PASSWD}" --execute "create database $USER_INPUT_DATABASENAME;"

echo "Database $USER_INPUT_DATABASENAME has been created successfully...."

if [ $USER_INPUT_DBUSER == $USER_INPUT_MYSQLADMIN_USER ]; then
        exit 0
else
        if [ $USER_INPUT_DBUSER != $USER_INPUT_MYSQLADMIN_USER ]; then
                mysql -u $USER_INPUT_MYSQLADMIN_USER -p"${USER_INPUT_MYSQLADMIN_PASSWD}" --execute "CREATE USER $USER_INPUT_DBUSER@'localhost' identified by '${USER_INPUT_DBPASSWD}';GRANT ALL PRIVILEGES ON $USER_INPUT_DATABASENAME.* TO $USER_INPUT_DBUSER@'localhost' IDENTIFIED BY '${USER_INPUT_DBPASSWD}';FLUSH PRIVILEGES;"
        fi
fi


echo "B) Create Database & DBuser grant privileges (optional)"

## C) Changing data-directory after adding additional disk##
systemctl stop mysqld
if [ -d "$DIR" ]; then
   mkdir -p $DIR/mysql
   cp -r -p /var/lib/mysql/* $DIR/mysql
   chown -R mysql:mysql $DIR/mysql
   sed -i 's#/var/lib#/data#g' /etc/my.cnf
   echo "data-directory changed"
fi

echo "restarting mysql server"
systemctl stop mysqld
systemctl start mysqld 
}


######################## MYSQL_CONFIG_UBUNTU_COMMON_FOR_12_14_and_16_STANDALONE ######################
function MYSQL_CONFIG_UBUNTU_STANDALONE {
echo "Updating port number in my.cnf...."
# Passing selected parameters to my.cnf file
sed -i "s/.*port\s.*/port = $USER_INPUT_PORT_NUMBER/" /etc/mysql/my.cnf
sed -i "s/.*max_connections\s.*/max_connections = $USER_INPUT_MAX_CONN/" /etc/mysql/my.cnf
sed -i "s/.*innodb_buffer_pool_size\s.*/innodb_buffer_pool_size = $USER_INNODB_BUFFER_SIZE/" /etc/mysql/my.cnf

#/etc/sysctl.conf TCP performance Tuning
sed -i '$ a net.ipv4.tcp_max_syn_backlog = 4096' /etc/sysctl.conf
sed -i '$ a net.core.somaxconn = 1024' /etc/sysctl.conf
sed -i '$ a ### Interface buffering' /etc/sysctl.conf
sed -i '$ a net.core.netdev_max_backlog = 2500' /etc/sysctl.conf
sed -i '$ a ifconfig eth0 txqueuelen 1000' /etc/rc.local
sed -i '$ a ifconfig eth1 txqueuelen 1000' /etc/rc.local
sed -i '$ a ifconfig eth2 txqueuelen 1000' /etc/rc.local
sed -i '$ a ifconfig eth3 txqueuelen 1000' /etc/rc.local
sed -i '$ a net.ipv4.tcp_syn_retries = 6' /etc/sysctl.conf
sed -i '$ a net.ipv4.tcp_synack_retries = 6' /etc/sysctl.conf
sed -i '$ a net.ipv4.tcp_keepalive_time = 30' /etc/sysctl.conf
sed -i '$ a net.ipv4.tcp_keepalive_intvl = 1' /etc/sysctl.conf
sed -i '$ a net.ipv4.tcp_keepalive_probes = 2' /etc/sysctl.conf
sed -i '$ a net.ipv4.tcp_no_metrics_save = 1' /etc/sysctl.conf
sed -i '$ a net.core.netdev_max_backlog = 5000' /etc/sysctl.conf
sysctl -p
# Passing all parameters to my.cnf file
#egrep -v "(mysqlAdmin|mysqlPassword|dbUserName|dbPassword|dbName)" /home/parameters.txt >> /etc/my.cnf



## A) mysqladmin user (mandatory)##
echo "Updating $USER_INPUT_MYSQLADMIN_USER in mysql...."
mysql -u root -p'ou812c' --execute "use mysql;update user set user='$USER_INPUT_MYSQLADMIN_USER' where user='root';update user set password=PASSWORD('$USER_INPUT_MYSQLADMIN_PASSWD') where user='$USER_INPUT_MYSQLADMIN_USER';GRANT ALL PRIVILEGES ON *.* TO $USER_INPUT_MYSQLADMIN_USER@'%' IDENTIFIED BY '${USER_INPUT_MYSQLADMIN_PASSWD}';flush privileges;"


echo "A) mysqladmin user (mandatory) done!"
## B) Create Database & DBuser grant privileges (optional)##

#Note: - We will hit following queries only when we get input from user for new database and its new user (hit api and get output)
#Condition to check whether there is any input from user for new db and its user

mysql -u $USER_INPUT_MYSQLADMIN_USER -p"${USER_INPUT_MYSQLADMIN_PASSWD}" --execute "create database $USER_INPUT_DATABASENAME;"

echo "Database $USER_INPUT_DATABASENAME has been created successfully...."

if [ $USER_INPUT_DBUSER == $USER_INPUT_MYSQLADMIN_USER ]; then
        exit 0
else
        if [ $USER_INPUT_DBUSER != $USER_INPUT_MYSQLADMIN_USER ]; then
                mysql -u $USER_INPUT_MYSQLADMIN_USER -p"${USER_INPUT_MYSQLADMIN_PASSWD}" --execute "CREATE USER $USER_INPUT_DBUSER@'localhost' identified by '${USER_INPUT_DBPASSWD}';GRANT ALL PRIVILEGES ON $USER_INPUT_DATABASENAME.* TO $USER_INPUT_DBUSER@'localhost' IDENTIFIED BY '${USER_INPUT_DBPASSWD}';FLUSH PRIVILEGES;"
        fi
fi


echo "B) Create Database & DBuser grant privileges (optional)"

## C) Changing data-directory after adding additional disk##
service mysql stop
if [ -d "$DIR" ]
then
   mkdir /data/mysql
   cp -r -p /var/lib/mysql/* /data/mysql
   chown -R mysql:mysql /data/mysql
   sed -i 's#/var/lib#/data#g' /etc/mysql/my.cnf
   sed -i 's#/var/lib#/data#g' /etc/apparmor.d/usr.sbin.mysqld
   sudo /etc/init.d/apparmor reload
   echo "data-directory changed"

fi

echo "restarting mysql server"

service mysql stop
service mysql start
}
#####################################################################################################


os_ver=`egrep -o '[0-9]+.[0-9]+' /etc/issue | cut -d '.' -f1`
os=`cat /etc/issue | head -1 | cut -d ' ' -f1`
os_ver_rl7=`egrep -o '[0-9]+.[0-9]+' /etc/redhat-release | cut -d '.' -f1`

case $os in
"CentOS"|"Red"|"\S")
        if [[ "$os_ver" == "5" ||  "$os_ver" == "6" ]]
        then
                MYSQL_CONFIG_CENTOS5_6_STANDALONE
        else
          if [[ `egrep -o '[0-9]+.[0-9]+' /etc/issue` == "" &&  "$os_ver_rl7" == "7" ]]
          then
                MYSQL_CONFIG_CENTOS_7_STANDALONE
          fi
        fi
;;
"Ubuntu")
        if [[ "$os_ver" == "12" ||  "$os_ver" == "14" || "$os_ver" == "16" ]]
        then
                MYSQL_CONFIG_UBUNTU_STANDALONE
        fi
 ;;
esac

