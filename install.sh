#!/bin/bash

# need admin privileges 

runningDir=$(pwd)

# gets the absolute path of the script(replaces ./ with runningDir)
absolutePath="${0/"./"/"$runningDir/"}"

# gets the absolute directory for this script
# so that the script can be run from any location
absoluteDir=$(echo "$absolutePath" | awk 'BEGIN {FS="/"};{for(i=1;i<=(NF-1);i++) {printf("%s/",$i)}};')


# going to the application directory
cd "$absoluteDir"
chmod +x .soft/getSpeed.sh
chmod +x uninstall.sh

# temp holds the new crontab
sudo crontab -l -u root > temp


cronEntry="*/10 * * * * "$absoluteDir".soft/getSpeed.sh"

# checking if the cron job already exists
aCronned=$(grep -F "$cronEntry" temp)

if [[ $aCronned == "" ]]
then
echo "$cronEntry" >> temp
echo "" >> temp # newline after the last cron entry
fi

sudo crontab -u root temp
rm temp




#adding the alias to run the plotting software
abash=$(grep -F "alias plotSpeed='cd $absoluteDir && python3 .soft/speedPlot.py &'" $HOME/.bashrc)

if [[ $abash == "" ]]
then
echo "alias plotSpeed='cd $absoluteDir && python3 .soft/speedPlot.py &'" >> $HOME/.bashrc
echo "" >> $HOME/.bashrc
source $HOME/.bashrc
fi


#alias to pause the speed data collection
abash=$(grep -F "alias NSpause='sudo crontab -l -u root | grep -v -F \"$cronEntry\" | sudo crontab -u root - &'" $HOME/.bashrc)

if [[ $abash == "" ]]
then
echo "alias NSpause='sudo crontab -l -u root | grep -v -F \"$cronEntry\" | sudo crontab -u root - &'" >> $HOME/.bashrc
echo "" >> $HOME/.bashrc
source $HOME/.bashrc
fi



