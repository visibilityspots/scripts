#!/bin/bash
#
# Script which reads messages on a remote irssi setup using the fnotify plugin based on 
# http://thorstenl.blogspot.be/2007/01/thls-irssi-notification-script.html
# Author: Jan Collijs
# 
# You could use a different notifier depending on which window manager you use like:
# mate-notify-send -i gtk-dialog-warning -- "${heading}" "${message}"
# notify-send -i gtk-dialog-warning -- "${heading}" "${message}"

server='YOUR SERVER ADDRESS'

usage()
{
cat << EOF
usage: $0 options

This script reads highlighted messages from irssi server.

OPTIONS:
   -h      Show this message
   -s      Start monitoring irssi messages
   -k      Stop monitoring irssi messages
EOF
}

while getopts "hsk" flag
do
  case "$flag" in
    h)
      usage
      exit
    ;;
    s) 
        serviceState=$(ps -ef | grep .irssi/fnotify | grep -v grep | awk '{print $2}')
        if [ -z "$serviceState" ]; then
	  ssh ${server} "tail -n 10 .irssi/fnotify ; : > .irssi/fnotify ; tail -f .irssi/fnotify " | sed -u 's/[<@&]//g' | while read heading message; do ratpoison -c "echo ${heading}: ${message}"; done &   
	fi
    ;;
    k)
      serviceState=$(ps -ef | grep .irssi/fnotify | grep -v grep | awk '{print $2}')
        if [ ! -z "$serviceState" ]; then
          kill $serviceState
      fi
    ;;
    *)
      usage
      exit
    ;;
  esac
done
