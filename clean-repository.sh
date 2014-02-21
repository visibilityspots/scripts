#!/bin/bash
#
# Author: Jan Collijs
# URL: https://github.com/visibilityspots/scripts#clean-repositorysh
#
# This script will cycle through a repository directory containing architecture subdirectories and looking for rpm packages older then X
#
# | EL6Server
# | - i686
# | - noarch
# | - x86_64
#
# Those architecture subdirectories exits of a series of subdirectories, for every piece of software a subdirectory has been created
# Subdirectories in those architure dirs containing *repo* in their name will be skipped by this script.
# The rpm packages created by automated jobs needs to follow the semantic versioning scheme (http://semver.org/) and
# may NOT contain numbers as name
#
# For example:
# | EL6Server
# | - x86_68
# | -- monitis-agent
# | --- monitis-agent-4.2.38.x86_64.rpm
# | --- monitis-agent-4.2.37.x86_64.rpm
# | --- monitis-agent-4.2.36-43.x86_64.rpm
#
# Parameters used by this script are the path to the directory containing the architecture dirs and the number of packages to keep:
#
# $ ./clean-repository.sh /dir/to/yum/repository/EL6Server 3
#
# By default the script will only ouput a list of files, to actually remove those old packages uncomment line 84 :)

# Initialize variables
REPO=$(echo $1 | sed -e 's+/$++g')
VERSIONSTOKEEP=$(echo $2 | sed -e 's+/$++g')

# Go to the repo directory to clean up
cd $REPO

# Select the architecture directories to clean
shopt -s nullglob
for DIR in $(ls -d ${REPO}/*/);
do
  if [[ "$DIR" != *repo* ]]; then
          for SUBDIR in $(ls -d ${DIR}*/);
          do
                # Select the subdirectories which contains rpm packages to clean
                if [[ "$SUBDIR" != *repo* ]] ; then
                unset FILES
                # Grep all rpm files and chop off the version numbers
                for RPM in $SUBDIR*.rpm
                do
                        RPM=`echo $RPM | awk -F / '{print $NF}'`
                        RPM=`echo $RPM | sed -e 's/[[:digit:]].*$//g' | sed -e 's/-$//g'`
                        FILES=("${FILES[@]}" $RPM)
                done

                ## Initialize an array with only the unique file names
                uniqueFiles=$(echo "${FILES[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')

                ## Catch all packages older then 3 versions
                for file in $uniqueFiles
                do
			# Calculate the old packages to remove
                        TOTAL=$(find ${SUBDIR}$file* -type f -exec stat --format '%Y :%y %n' {} \; | sort -nr | cut -d: -f2- | cut -d ' ' -f4 | wc -l)
                        OLDPACKAGES="$(( $TOTAL - $VERSIONSTOKEEP ))"

                        # Remove the calculated old packages if there are
                        if [ "$OLDPACKAGES" -gt 0 ];then
                                ARCHIVEPACKAGES=$(find ${SUBDIR}$file* -type f -exec stat --format '%Y :%y %n' {} \; | sort -nr | cut -d: -f2- | cut -d ' ' -f4 | tail -$OLDPACKAGES)
                                ## Colored title
                                echo -e "\n\e[1;34m[\e[00m --- \e[00;32mClean repository directory: ${SUBDIR} --- \e[1;34m]\e[00m\n"
                                echo "$file: total: $TOTAL | old: $OLDPACKAGES"
                                for archive in $ARCHIVEPACKAGES
                                do
                                        # The action for each old package
#                                       sudo rm $archive -rf
                                        echo "* $archive package has been removed"
                                done
                                echo "---------------------------------------------------------------------------------------------"
                        fi
                done
                fi
          done
  fi
done
