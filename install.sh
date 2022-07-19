#!/bin/bash

# need admin privileges 

# the directory where this script is being run from
runningDir=$(pwd)
# echo "pwd is $runningDir"

# gets the absolute path of the script(replaces ./ with runningDir)
absolutePath="${0/"./"/"$runningDir/"}"
# echo "absolute path is $absolutePath"

# gets the absolute directory for this script
# so that the script can be run from any location
absoluteDir=$(echo "$absolutePath" | awk 'BEGIN {FS="/"};{for(i=1;i<=(NF-1);i++) {printf("%s/",$i)}};')
# echo "absolute directory is $absoluteDir"


# going to the application directory
cd "$absoluteDir"


# temp holds the new crontab
sudo crontab -l -u root > temp

# the cron entry in the crontab for the getSpeed script(every 10 minutes)
cronEntry="*/10 * * * * "$absoluteDir".soft/getSpeed.sh"
# echo "$cronEntry"

# checking if the cron job already exists
aCronned=$(grep -F "$cronEntry" temp)
# echo "$aCronned"

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

