#!/bin/bash

URL=${1:-HTTP://URL/TO/STATUSPAGE.HTML}

STATUS=$(curl -s $URL | cut -d ' ' -f 1)
if [[ "$STATUS" == "busy" ]]; then
  exit
elif [[ "$STATUS" == "free" ]]; then
  puppet agent --test
else
  exit
fi

