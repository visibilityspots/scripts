#!/bin/bash
#
# Script which sets the correct servicePort for crashplan and then start CrashPlanDesktop
# Author: Jan Collijs

usage()
{
cat << EOF
usage: $0 [options]

This script set's the correct servicePort and starts the crashplan Desktop

OPTIONS:
   -h      Show this message
   -s      Start crashplan GUI for the server
   -c      Start crashplan GUI for this client
EOF
}

while getopts "hsc" flag
do
  case "$flag" in
    s)
      sudo sed 's/servicePort=4243/servicePort=4200/' -i /usr/local/crashplan/conf/ui.properties
      ssh -fC -L 4200:localhost:4243 SERVERURLORPUBLICIP sleep 30 >/dev/null
      2>/dev/null
      sleep 10
      /usr/local/crashplan/bin/CrashPlanDesktop
      echo "CrashplanDesktop for server started"
    ;;
    c)
      sudo sed 's/servicePort=4200/servicePort=4243/' -i /usr/local/crashplan/conf/ui.properties
      /usr/local/crashplan/bin/CrashPlanDesktop
    ;;
    h)
      usage
      exit
    ;;
    *)
      usage
      exit
    ;;
  esac
done
