#!/bin/bash
#
# Script which sets the msmtp server used in mutt
# Author: Jan Collijs

usage()
{
cat << EOF
usage: $0 options

This script set's the right to use msmtp account for mutt depending on the location

OPTIONS:
   -h      Show this message
   -t      Set Telenet account
   -b      Set Belgacom account
EOF
}

while getopts "htb" flag
do
  case "$flag" in
    t)
      echo "Telenet smtp server configured."
      sed -i 's/^set sendmail.*/set sendmail="\/usr\/bin\/msmtp -a telenet"/' ~/.mutt/telenet.muttrc
    ;;
    b)
      echo "Belgacom smtp server configured."
      sed -i 's/^set sendmail.*/set sendmail="\/usr\/bin\/msmtp -a belgacom"/' ~/.mutt/telenet.muttrc
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
