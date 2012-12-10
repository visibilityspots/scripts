#!/bin/bash
#
# Script which mounts some remote samba shares
# Author: Jan Collijs

# Declaration of parameters
IP='X.X.X.X'
USERNAME='USERNAME'
PASSWORD='PASSWORD'
LOCATION='LOCATION WHERE TO MOUNT (/mnt/boxee for example)'

usage()
{
cat << EOF
usage: $0 options

This script decrypts some predefined directories using encfs.

OPTIONS:
   -h      Show this message
   -d      Mount data share
   -p      Mount pictures share
   -f      Mount movies (films) share
   -m      Mount music share
   -u      Umount all shares
EOF
}

while getopts "hdpfmu" flag
do
  case "$flag" in
    d)
      echo "Mount data share:"
      sudo mount -t cifs //$IP/data -o username=$USERNAME,password=$PASSWORD $LOCATION/data
    ;;
    p) 
      echo "Mount pictures share:"
      sudo mount -t cifs //$IP/My-Pictures -o username=$USERNAME,password=$PASSWORD $LOCATION/pictures
    ;;
    f)
      echo "Mount movies share:"
      sudo mount -t cifs //$IP/My-Movies -o username=$USERNAME,password=$PASSWORD $LOCATION/movies
    ;;
    m)
      echo "Mount music share:"
      sudo mount -t cifs //$IP/My-Music -o username=$USERNAME,password=$PASSWORD $LOCATION/music
    ;;
    u)
      sudo umount $LOCATION/data
      sudo umount $LOCATION/pictures
      sudo umount $LOCATION/movies
      sudo umount $LOCATION/music
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
