#!/bin/bash
#
# Script which get your todo list from your tracks instance
# The url can be found in your http://tracksurl:3000/integrations under the topic
# 'Automatically Email Yourself Upcoming Actions'
#
# https://github.com/visibilityspots/scripts#conky-trackssh
#
# Author: Jan Collijs

# Parameters
USER='your tracks username'
PASSWORD='your tracks password'
URL='url to your tracks instance'

TMPfile='/path/to/a/tmp/file/'
CONKYfile='/path/to/file/used/in/conky'

# Getting your tasks overview and storing it temporarily
wget --quiet -O $TMPfile --user=$USER --password=$PASSWORD $URL &
wait

# Stripping out the tmp file for having a nice text file to integrate with conky
cat $TMPfile | sed -r 's/\[.+\]\ //' > $CONKYfile

# Remvoving the tempfile
rm $TMPfile -rf
