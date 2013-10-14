#!/bin/bash
#
# This script will cycle through a directory and only leaves the # most recent versions of a package in the directory
# the other ones will be removed
#
# Parameters:
#	repository-directory
#	# version to keep
#
# Example:
#	./clean-repository.sh /path/to/rpm/directory 2
#
#	This will remove every version of a package older then 2

# Initialize variables
REPO=$(echo $1 | sed -e 's+/$++g')
VERSIONSTOKEEP=$(echo $2 | sed -e 's+/$++g')

# Go to the repo directory to clean up
cd $REPO

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
        # Calculate the old packages to remove 
	TOTAL=$(find $file* -type f -exec stat --format '%Y :%y %n' {} \; | sort -nr | cut -d: -f2- | cut -d ' ' -f4 | wc -l)
        OLDPACKAGES="$(( $TOTAL - $VERSIONSTOKEEP ))"

        # Remove the calculated old packages if there are calculate
        if [ "$OLDPACKAGES" -gt 0 ];then
                ARCHIVEPACKAGES=$(find $file* -type f -exec stat --format '%Y :%y %n' {} \; | sort -nr | cut -d: -f2- | cut -d ' ' -f4 | tail -$OLDPACKAGES)
                for archive in $ARCHIVEPACKAGES
                do
			# The action for each old package 
                	rm $archive -rf
                	echo $archive "package has been removed"
                done
        fi
done

