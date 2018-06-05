#!/bin/bash -x
1> /tmp/rundeck_test.txt
START=0
server_id=2
END=$(jq '.comps.comp | length' /usr/local/netmagic/cloud/bin/shell_scripts/mysql/json_output.txt)
echo $END

for (( i=$START; i<=$END; i++ ))
do
   type=`cat /usr/local/netmagic/cloud/bin/shell_scripts/mysql/json_output.txt | jq .comps.comp[$i].type |  tr -d '"'`
#echo "$type"
	if [ "$type" == "master" ]; then
#		echo "This is master server"
		master_ip=`cat /usr/local/netmagic/cloud/bin/shell_scripts/mysql/json_output.txt | jq .comps.comp[$i].private_ip | tr -d '"'`
		natted_master_ip=`cat /usr/local/netmagic/cloud/bin/shell_scripts/mysql/json_output.txt | jq .comps.comp[$i].natted_public_ip | tr -d '"'`
		master_component_id=`cat /usr/local/netmagic/cloud/bin/shell_scripts/mysql/json_output.txt | jq .comps.comp[$i].cloud_app_component_id | tr -d '"'`
#		echo "Master ip is : $master_ip"
#		echo "master component id : $master_component_id"
                echo "$master_component_id:Success" >> /tmp/rundeck_test.txt
	fi
done
### master done###

### Slave ###

for (( i=$START; i<=$END; i++ ))
do
   type=`cat /usr/local/netmagic/cloud/bin/shell_scripts/mysql/json_output.txt | jq .comps.comp[$i].type | tr -d '"'`
	if [  "$type" == "Slave-Local" ]; then
		slave_ip=`cat /usr/local/netmagic/cloud/bin/shell_scripts/mysql/json_output.txt | jq .comps.comp[$i].private_ip | tr -d '"'`
		slave_component_id=`cat /usr/local/netmagic/cloud/bin/shell_scripts/mysql/json_output.txt | jq .comps.comp[$i].cloud_app_component_id | tr -d '"'`
#		echo "Local Slave ip $slave_ip"	
#		echo "slave component id : $slave_component_id"
		### master ###
		sed -i -e "s/MASTER_IP_TO_REPLACE/$master_ip/g" /usr/local/netmagic/cloud/bin/shell_scripts/mysql/master_config.sh		
		sed -i -e "s/SLAVE_IP_TO_REPLACE/$slave_ip/g" /usr/local/netmagic/cloud/bin/shell_scripts/mysql/master_config.sh
		/usr/local/bin/perl  /usr/local/netmagic/cloud/bin/perl/mysql/mysql-master-config.pl $master_component_id
		ext_stat=`echo $?`
                 if [ $ext_stat -ne 0 ]; then
                                echo "Failed"
                                exit 1
                        fi
		sed -i -e "s/$master_ip/MASTER_IP_TO_REPLACE/g" /usr/local/netmagic/cloud/bin/shell_scripts/mysql/master_config.sh
		sed -i -e "s/$slave_ip/SLAVE_IP_TO_REPLACE/g" /usr/local/netmagic/cloud/bin/shell_scripts/mysql/master_config.sh
		### slave ###
		sed -i -e "s/SERVER_ID_TO_REPLACE/$server_id/g" /usr/local/netmagic/cloud/bin/shell_scripts/mysql/slave_config.sh
		sed -i -e "s/MASTER_IP_TO_REPLACE/$master_ip/g" /usr/local/netmagic/cloud/bin/shell_scripts/mysql/slave_config.sh		
		sed -i -e "s/SLAVE_IP_TO_REPLACE/$slave_ip/g" /usr/local/netmagic/cloud/bin/shell_scripts/mysql/slave_config.sh
		
		/usr/local/bin/perl  /usr/local/netmagic/cloud/bin/perl/mysql/mysql-slave-config.pl $slave_component_id
		 ext_stat=`echo $?`
                 if [ $ext_stat -ne 0 ]; then
                                echo "Failed"
                                exit 1
                        fi
		sed -i -e "s/$master_ip/MASTER_IP_TO_REPLACE/g" /usr/local/netmagic/cloud/bin/shell_scripts/mysql/slave_config.sh
		sed -i -e "s/$slave_ip/SLAVE_IP_TO_REPLACE/g" /usr/local/netmagic/cloud/bin/shell_scripts/mysql/slave_config.sh
		sed -i -e "s/j=\"$server_id\"/j=\"SERVER_ID_TO_REPLACE\"/g" /usr/local/netmagic/cloud/bin/shell_scripts/mysql/slave_config.sh
		server_id=$((server_id+1))
                echo "$slave_component_id:Success" >> /tmp/rundeck_test.txt

	fi
done	


### Remote Slave ###

for (( i=$START; i<=$END; i++ ))
do
   type=`cat /usr/local/netmagic/cloud/bin/shell_scripts/mysql/json_output.txt | jq .comps.comp[$i].type | tr -d '"'`
        if [  "$type" == "Slave-Remote" ]; then
 #               echo "This is Remote Slave Server"
                remote_slave_ip=`cat /usr/local/netmagic/cloud/bin/shell_scripts/mysql/json_output.txt | jq .comps.comp[$i].natted_public_ip | tr -d '"'`
		remote_slave_component_id=`cat /usr/local/netmagic/cloud/bin/shell_scripts/mysql/json_output.txt | jq .comps.comp[$i].cloud_app_component_id | tr -d '"'`
#		echo "remote slave component id : $remote_slave_component_id"
		### master ###
                sed -i -e "s/MASTER_IP_TO_REPLACE/$master_ip/g" /usr/local/netmagic/cloud/bin/shell_scripts/mysql/master_config.sh
                sed -i -e "s/SLAVE_IP_TO_REPLACE/$remote_slave_ip/g" /usr/local/netmagic/cloud/bin/shell_scripts/mysql/master_config.sh
                /usr/local/bin/perl  /usr/local/netmagic/cloud/bin/perl/mysql/mysql-master-config.pl $master_component_id

		 ext_stat=`echo $?`
                 if [ $ext_stat -ne 0 ]; then
                                echo "Failed"
                                exit 1
                        fi

                sed -i -e "s/$master_ip/MASTER_IP_TO_REPLACE/g" /usr/local/netmagic/cloud/bin/shell_scripts/mysql/master_config.sh
                sed -i -e "s/$remote_slave_ip/SLAVE_IP_TO_REPLACE/g" /usr/local/netmagic/cloud/bin/shell_scripts/mysql/master_config.sh
                ### slave ###
		sed -i -e "s/SERVER_ID_TO_REPLACE/$server_id/g" /usr/local/netmagic/cloud/bin/shell_scripts/mysql/slave_config.sh
                sed -i -e "s/MASTER_IP_TO_REPLACE/$natted_master_ip/g" /usr/local/netmagic/cloud/bin/shell_scripts/mysql/slave_config.sh
                sed -i -e "s/SLAVE_IP_TO_REPLACE/$remote_slave_ip/g" /usr/local/netmagic/cloud/bin/shell_scripts/mysql/slave_config.sh
                /usr/local/bin/perl  /usr/local/netmagic/cloud/bin/perl/mysql/mysql-slave-config.pl $remote_slave_component_id

		 ext_stat=`echo $?`
                 if [ $ext_stat -ne 0 ]; then
                                echo "Failed"
                                exit 1
                        fi

                sed -i -e "s/$natted_master_ip/MASTER_IP_TO_REPLACE/g" /usr/local/netmagic/cloud/bin/shell_scripts/mysql/slave_config.sh
                sed -i -e "s/$remote_slave_ip/SLAVE_IP_TO_REPLACE/g" /usr/local/netmagic/cloud/bin/shell_scripts/mysql/slave_config.sh
		sed -i -e "s/j=\"$server_id\"/j=\"SERVER_ID_TO_REPLACE\"/g" /usr/local/netmagic/cloud/bin/shell_scripts/mysql/slave_config.sh
		server_id=$((server_id+1))
                echo "$remote_slave_component_id:Success" >> /tmp/rundeck_test.txt
        fi
done


#echo "master ip $master_ip"
#echo "Local Slave ip $slave_ip"
#echo "Remote Slave ip $remote_slave_ip"

