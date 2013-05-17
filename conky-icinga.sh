#!/bin/bash
#
# Script which get your icinga infrastructure states and passes the parsed output to your conky setup
#
# Author: Jan Collijs

# Parameters
URL="https://URLTOYOURICINGAINSTANCE/icinga/cgi-bin/tac.cgi"
USERNAME=ICINGAUSERNAME
PASSWORD=ICINGAPASSWORD
STATUS=OK
 
# Grab your online service states
PAGE=$(curl -s -k -u $USERNAME:$PASSWORD $URL)
 
# Split services states into variables
HOSTS_DOWN=$( echo -e "$PAGE" | grep "class='hostHeader'" | grep Down | awk '{print $5}' | cut -c 20-)
HOSTS_UP=$( echo -e "$PAGE" | grep "class='hostHeader'" | grep Up | awk '{print $5}' | cut -c 20-)
 
SERVICES_CRIT=$( echo -e "$PAGE" | grep "class='serviceHeader'" | grep Critical | awk '{print $5}' | cut -c 23-)
SERVICES_WARN=$( echo -e "$PAGE" | grep "class='serviceHeader'" | grep Warning | awk '{print $5}' | cut -c 23-)
SERVICES_OK=$( echo -e "$PAGE" | grep "class='serviceHeader'" | grep Ok | awk '{print $5}' | cut -c 23-)

# Determine overall state depending on individual service states
if [[ "$HOSTS_DOWN" == "" ]]
then
  STATUS=DOWN
else	
  if [[ $(($HOSTS_DOWN + $SERVICES_CRIT)) > 0 ]]
  then
    STATUS=CRITICAL
  else
    if [[ $SERVICES_WARN > 0 ]]
    then
      STATUS=WARN
    else
      STATUS=OK
    fi
  fi
fi

# Pass the parsed output to your conky setup
echo ''$STATUS' ( '$HOSTS_UP'/'$HOSTS_DOWN' | '$SERVICES_OK'/'$SERVICES_WARN'/'$SERVICES_CRIT' )'
