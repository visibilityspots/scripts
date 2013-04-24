#!/bin/bash
#
# Script which grabs mails from spam folder, reports them to spamcop, learns them to bayesian SA and removes it.
# Author: Jan Collijs
 
# Declaration of parameters
SPAMMAILBOX=/path/to/.your/spam/cur/
REPORTADDRESS=submit.XXXXXX@spam.spamcop.net

if [ "$(ls -A $SPAMMAILBOX)" ]; then
  cd $SPAMMAILBOX
  for SPAMMESSAGE in * 
  do
    echo $SPAMMESSAGE
    # Create email and submit it to the supplied spamcop address
    echo "Reporting spam" | mutt -s "Reporting suspicious mail" $REPORTADDRESS -a $SPAMMESSAGE
        
    # Train this email to be spam to the bayesian SA filters
    /usr/bin/sa-learn --spam $SPAMMESSAGE
         
    # Delete email
    /bin/rm $SPAMMESSAGE
  done
fi
