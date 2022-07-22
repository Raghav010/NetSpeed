#!/bin/bash

# need admin privileges 

runningDir=$(pwd)

# gets the absolute path of the script(replaces ./ with runningDir)
absolutePath="${0/"./"/"$runningDir/"}"

# gets the absolute directory for this script
# so that the script can be run from any location
absoluteDir=$(echo "$absolutePath" | awk 'BEGIN {FS="/"};{for(i=1;i<=(NF-1);i++) {printf("%s/",$i)}};')

cronEntry="*/10 * * * * "$absoluteDir".soft/getSpeed.sh"

cd $absoluteDir

# removing aliases from bashrc
grep -v -F -e "alias plotSpeed='cd $absoluteDir && python3 .soft/speedPlot.py &'" -e "alias NSpause='sudo crontab -l -u root | grep -v -F \"$cronEntry\" | sudo crontab -u root - &'" $HOME/.bashrc > temp

cat temp > $HOME/.bashrc
source $HOME/.bashrc
rm temp

#removing the cronentry
sudo crontab -l -u root | grep -v -F "$cronEntry" | sudo crontab -u root -

