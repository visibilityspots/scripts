#!/bin/bash
#
# Script which disables or enables screen output using tvservice on rasbian
# Author: Jan Collijs

usage()
{
cat << EOF
usage: $0 options

This script can enable or disable the screen output.

OPTIONS:
        -h      Show this message
        -d      Disables screen output
        -e      Enables screen output
EOF
}

while getopts "hde" flag
do
        case "$flag" in
                h)
                        usage
                        exit
                ;;
                d)
                        sudo tvservice -o
                        exit
                ;;
                e)
                        sudo tvservice -p && sudo chvt 1 && sudo chvt 7
                        exit
                ;;
                *)
                        usage
                        exit
                ;;
        esac
done
