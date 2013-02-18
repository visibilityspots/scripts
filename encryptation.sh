#!/bin/bash
#
# Script which decrypts predefined folders to work with
# Written by Jan Collijs

usage()
{
cat << EOF
usage: $0 [options]

This script decrypts some predefined directories using encfs.

OPTIONS:
   -h      Show this message
   -w      Decrypt work related directories
   -p      Decrypt personal related directories
   -e      Decrypt evolution directory (inuits)
   -u      Umount all decrypted folders
EOF
}

while getopts "pwehu" flag
do
  case "$flag" in
    p)
      echo "Personal directory:"
      encfs ~/Personal/Dropbox/.encrypted-personal/ ~/Personal/Private-personal/
    ;;
    w) 
      echo "Work directory:"
      encfs ~/Dropbox/.encrypted/ ~/Private/
    ;;
    e)
      echo "Evolution directory (work)"
      encfs ~/Dropbox/.encrypted-evolution/ ~/.private-evolution/
    ;;
    u)
      sudo umount ~/Private
      sudo umount ~/.private-evolution
      sudo umount ~/Personal/Private-personal
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
