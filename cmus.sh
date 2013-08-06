#!/bin/bash                                                                                                                                                                                                                                    
#
# Script which gets some cmus information
# Author: Jan Collijs
 
if [ ! -x /usr/bin/cmus-remote ];
then
echo "cmus is not installed."
exit
fi
 
ARTIST=$( cmus-remote -Q 2>/dev/null | grep artist | cut -d " " -f 3- | head -1)
TITLE=$( cmus-remote -Q 2>/dev/null | grep title | cut -d " " -f 3- | head -1)
 
if [ -z "$ARTIST" ];
then
echo "No active song selected"
else
echo "$ARTIST - $TITLE"
fi

