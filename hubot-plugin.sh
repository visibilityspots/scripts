#!/bin/bash
# Script which will configure the necessary dependencies and commands according the 
# written documentation of a hubot-script from https://github.com/github/hubot-scripts 

## Author: Jan Collijs
 
# Parameters
PLUGIN=$1
URL=https://raw.github.com/github/hubot-scripts/master/src/scripts/$PLUGIN.coffee
 
COUNTDEPS=`curl -s $URL | sed -n '/Dependencies:/,/Configuration/p' | sed '1d;$d' | wc -l`
COUNTDEPS=$((COUNTDEPS-1))
 
CONFIGDEPS=`curl -s $URL | sed -n '/Configuration:/,/Commands/p' | sed '1d;$d' | wc -l`
CONFIGDEPS=$((CONFIGDEPS-1))
 
## Add plugin into hubot-scripts.json
if [ $(cat hubot-scripts.json | grep $PLUGIN | wc -l) -le 0 ];then
        sed -i 's/].*$/, "'$PLUGIN'.coffee"]/' hubot-scripts.json
fi
 
# Grab dependecies and pull them into package.json
if [ $COUNTDEPS -gt 0 ];then
  for i in $(seq 1 $COUNTDEPS); do
        DEP=`curl -s $URL | sed -n '/Dependencies:/,/Configuration/p' | sed '1d;$d' | sed 's/#   //' | head -$i | tail -1`
        if [[ $DEP != "None" ]]; then
        DEPGREP=`curl -s $URL | sed -n '/Dependencies:/,/Configuration/p' | sed '1d;$d' | sed 's/#   //' | head -$i | tail -1 | cut -d ':' -f 1`
        DEP=$(echo "$DEP" | sed 's/: \"/: \">= /g')
                DEP=$(echo "$DEP" | sed 's/"/\\"/g')
                if [ $(cat package.json | grep $DEPGREP | wc -l) -le 0 ];then
                        sed -i "/"hubot-scripts"/i \\    ${DEP}," package.json;
                fi
        fi
  done
fi

# Update npm environment
npm update
 
# Add configuration parameters into hubot.env
if [ $CONFIGDEPS -gt 0 ];then
  for i in $(seq 1 $CONFIGDEPS); do
        COMMAND=`curl -s $URL | sed -n '/Configuration:/,/Commands/p' | sed '1d;$d' | sed 's/#   //' | cut -d ' ' -f 1 | head -$i | tail -1` 
        if [ $COMMAND != "None" ]; then
                if [ $(cat hubot.env | grep $COMMAND | wc -l) -le 0 ];then
                        echo "export ${COMMAND}=\"UNDEFINED\"" >> hubot.env;
                fi
        fi
  done
fi
 
# Restart service
service hubot restart
