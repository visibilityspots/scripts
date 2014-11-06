#!/bin/bash
#
# Scripts which checks remote and local maintenance modes
#
# Author: Jan Collijs

# Parameter declaration
URL=${1:-HTTP://URL/TO/STATUSPAGE.HTML}

OVERALL_STATE=$(curl -s $URL | cut -d ' ' -f 1)
LOCAL_STATE=$(cat /root/state.puppet)

# Loop to check if there is already a puppet run busy
while true
do
	[ ! -f /var/lib/puppet/state/agent_catalog_run.lock ] && break
	sleep 2
done

# Process the overal maintenance mode
if [[ ! $OVERALL_STATE =~ ^free* ]]; then
  OVERALL_STATE=0
else
  OVERALL_STATE=1
fi

# Process the server maintenance mode
if [[ ! $LOCAL_STATE =~ ^enable* ]]; then
  LOCAL_STATE=0
else
  LOCAL_STATE=1
fi

# Check if puppet is in overall or individual maintenance mode
if [ $OVERALL_STATE -eq 0 -o $LOCAL_STATE -eq 0 ]; then
  exit 0;
elif [ $OVERALL_STATE -gt 0 -a $LOCAL_STATE -gt 0 ]; then
  yum clean all
#  yum clean all --disablerepo="*" --enablerepo="YOURCUSTOMREOP"
  puppet agent --test
  exit 0;
else
  exit 0;
fi
