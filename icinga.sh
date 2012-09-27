#!/bin/bash
#
# Written by Dieter Plaetinck
# Updated by Bernhard Brunner: output for conky
# Updated by Jan Collijs: grep variables for icinga 1.6.X, output for custom conky config and if statement depending on ip
#
# Licensed under the GPL V3
# See gnu.org/licenses/gpl-3.0.html
#
# works for Nagios 2.x or nagios 3.x or icinga 1.6.x

# If statement which checks the ip, if matching it will gather the data and displays the output.
# Made check because use of internal icinga service which can only be accessed from within the network
IPADDR=`ip addr show em1 | grep 'inet' | cut -d: -f2 | awk '{ print $2}'`
if [[ "$IPADDR" == "X.X.X.X/X" ]]
then
  echo '${font Liberation Sans:style=Bold:size=8}MONITORING $stippled_hr${font}'

  # Declaration of variables
  URL="http://ICINGASERVERNAME/icinga/cgi-bin/tac.cgi"
  USERNAME=USERNAME
  PASSWORD=PASSWORD
  STATUS=OK
  COLOR=green
  PAGE=$(curl -s -k -u $USERNAME:$PASSWORD $URL)
   
  HOSTS_DOWN=$( echo -e "$PAGE" | grep "class='hostHeader'" | grep Down | awk '{print $5}' | cut -c 20-)
  HOSTS_UNREACHABLE=$( echo -e "$PAGE" | grep "class='hostHeader'" | grep Unreachable | awk '{print $5}' | cut -c 20-)
  HOSTS_UP=$( echo -e "$PAGE" | grep "class='hostHeader'" | grep Up | awk '{print $5}' | cut -c 20-)
  HOSTS_PENDING=$( echo -e "$PAGE" | grep "class='hostHeader'" | grep Pending | awk '{print $5}' | cut -c 20-)
   
  SERVICES_CRIT=$( echo -e "$PAGE" | grep "class='serviceHeader'" | grep Critical | awk '{print $5}' | cut -c 23-)
  SERVICES_WARN=$( echo -e "$PAGE" | grep "class='serviceHeader'" | grep Warning | awk '{print $5}' | cut -c 23-)
  SERVICES_UNKNOWN=$( echo -e "$PAGE" | grep "class='serviceHeader'" | grep Unknown | awk '{print $5}' | cut -c 23-)
  SERVICES_OK=$( echo -e "$PAGE" | grep "class='serviceHeader'" | grep Ok | awk '{print $5}' | cut -c 23-)
  SERVICES_PENDING=$( echo -e "$PAGE" | grep "class='serviceHeader'" | grep Pending | awk '{print $5}' | cut -c 23-)
  
  # Compiling the status depending on the gathered data
  if [[ "$HOSTS_DOWN" == "" ]]
  then
    STATUS=DOWN
    COLOR=red
  else	
    if [[ $(($HOSTS_DOWN + $SERVICES_CRIT)) > 0 ]]
    then
      STATUS=CRITICAL
      COLOR=orange
    else
      if [[ $SERVICES_WARN > 0 ]]
      then
        STATUS=WARN
        COLOR=orange
      else
        STATUS=OK
        COLOR=green
      fi
    fi
  fi
  # Output's the data in conky syntax
  echo '${color2}${font Liberation Sans:size=8}NAME OF MONITORING ENVIRONMENT state: ${font Liberation Sans:size=7:style=Bold}${alignr}${color '$COLOR'}'$STATUS'${font}${color2}'
  echo ''
  echo '${font Liberation Sans:size=8:style=Bold}HOSTS${goto 125}|${alignr} SERVICES${font}'
  echo 'up: '$HOSTS_UP'                                                     ok: '$SERVICES_OK
  echo 'down: '$HOSTS_DOWN'                                        warning: '$SERVICES_WARN
  echo 'unreachable: '$HOSTS_UNREACHABLE'                              critical: '$SERVICES_CRIT
  echo 'pending: '$HOSTS_PENDING'                                 unknown: '$SERVICES_UNKNOWN
else
  echo ''
fi
