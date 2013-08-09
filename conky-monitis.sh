#!/bin/bash
#
# Script which gets some monitoring data from the monitor.us service using the monitorusclt scripts
# Author: Jan Collijs

usage()
{
cat << EOF
usage: $0 options

This script get's some information about the monitis service. Output will 1 for service running well, 0 for a service with issues.

OPTIONS:
   -h      Show this message
   -a      Get's the status of the monitis agent
   -p      Get's the status of a process
   -m	   Get's the memory state of the server
   -l	   Get's the load state of the server
EOF
}

login(){
  $MPATH login $EMAIL $PASSWORD PASSWORD > /dev/null 2>&1
  AGENTID=$($MPATH agents | grep $AGENTNAME | cut -d '|' -f 2 | sed 's/^ //g') 
}

logout(){
  $MPATH logout > /dev/null 2>&1
}

EMAIL='EMAIL@ADDRESS'
PASSWORD='PASSWORD'

MPATH='PATH/TO/MONITISCLT.SH'
DATE=$(date +%d-%m-%Y)

AGENTNAME='NAMEOFAGENT'
PROCESS='PROCESSNAME'

while getopts "hapml" flag
do
  case "$flag" in
    a)
	login
	AGENTSTATE=$($MPATH agents | grep $AGENTID | cut -d '|' -f 5 | sed 's/^ //g')
        if [ $AGENTSTATE = "running" ]; then 
                  AGENTSTATE='1'
          else 
                  AGENTSTATE='0'
        fi
	echo $AGENTSTATE
	logout
    ;;
    p)
    	login
	PROCESSID=$($MPATH agentprocesses $AGENTID | grep $PROCESSNAME | cut -d '|' -f 2 | sed 's/^ //g')
	PROCESSSTATE=$($MPATH processresult $PROCESSID 07-08-2013 | head -6 | tail -1 | cut -d '|' -f 4 | sed 's/^ //g')
        if [ $PROCESSSTATE = "OK" ]; then                                      
                  PROCESSSTATE='1'      
          else                         
                  PROCESSSTATE='0'      
        fi                             
	echo $PROCESSSTATE
	logout
    ;;
    m)
    	login
	MEMORYID=$($MPATH agentmemory $AGENTID | head -6 | tail -1 | cut -d '|' -f 2 | sed 's/^ //g')
	MEMORYSTATE=$($MPATH memoryresult $MEMORYID +60 $DATE | head -6 | tail -1 | cut -d '|' -f 3 | sed 's/^ //g')
        if [ $MEMORYSTATE = "OK" ]; then
                  MEMORYSTATE='1'
          else   
                  MEMORYSTATE='0'
        fi
	echo $MEMORYSTATE
	logout
    ;;
    l)
	login
	LOADID=$($MPATH agentloadavg $AGENTID | head -6 | tail -1 | cut -d '|' -f 2 | sed 's/^ //g')
	LOADSTATE=$($MPATH loadavgresult $LOADID +60 $DATE | head -6 | tail -1 | cut -d '|' -f 3 | sed 's/^ //g')
	
        if [ $LOADSTATE = "OK" ]; then
                LOADSTATE='1'
        else   
                LOADSTATE='0'
        fi
	echo $LOADSTATE
	logout
    ;;
    *)
	usage
	logout
      exit
    ;;
  esac
done
