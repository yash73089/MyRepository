#!/bin/bash

PATH='/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/sbin:/sbin:/bin:/usr/local/mcrouter-install/install/bin';
SERVICE_TO_CHECK='mcrouter';

ps -elF | grep -i ${SERVICE_TO_CHECK} | grep -v "grep\|${0}" >/dev/null 2>&1

if test $? -ne 0;
  then
     echo "[$(date)] ${SERVICE_TO_CHECK} service not running, starting it."
     /usr/bin/nohup /usr/local/mcrouter-install/install/bin/mcrouter -p 11211 -f /usr/local/mcrouter/failover.json &
     exit 1
fi

exit 0