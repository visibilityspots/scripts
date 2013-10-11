#!/bin/bash                                                                                                                                                                                                                                    
#
# This script will cycle through a directory and only leaves the 3 most recent versions of a package in the directory
# the other ones are removed
 
# Grep all rpm files and chop off the version numbers
shopt -s nullglob
for RPM in *.rpm
do
        RPM=`echo $RPM | sed -e 's/[[:digit:]].*$//g' | sed -e 's/-$//g'`
        FILES=("${FILES[@]}" $RPM)
done
 
 
## Initialize an array with only the unique file names
uniqueFiles=$(echo "${FILES[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')
 
## Catch all packages older then 3 versions
for file in $uniqueFiles
do
        TOTAL=$(find $file* -type f -exec stat --format '%Y :%y %n' {} \; | sort -nr | cut -d: -f2- | cut -d ' ' -f4 | wc -l)
        OLDPACKAGES=$(expr $TOTAL - 3)
 
        # If there are more then 3 versions, remove them
        if [ "$OLDPACKAGES" -gt 0 ];then
                ARCHIVEPACKAGES=$(find $file* -type f -exec stat --format '%Y :%y %n' {} \; | sort -nr | cut -d: -f2- | cut -d ' ' -f4 | tail -$OLDPACKAGES)
                for archive in $ARCHIVEPACKAGES
                do
                rm $archive -rf
                echo $archive "package has been removed"
                done
        fi
done

