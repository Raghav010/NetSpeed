#!/bin/bash


#echo "Checking speed..."
#gets the stats in space separated format
stats=$(speedtest --csv-delimiter " " --csv)


#YYYY-MM-DDThh:mm
time=$(date +%y%m%d%H%M)
#echo "time is $time"

# Mbits/s
stats=($stats)
download=$(echo "scale=4;${stats[6]}/1000000" | bc)
upload=$(echo "scale=4;${stats[7]}/1000000" | bc)

#echo "download : $download"
#echo "upload : $upload"

#echo $0
# gets the path where the database needs to be created(usually the path of this script)
# so that this script can be run from any location
path=$(echo $0 | awk 'BEGIN {FS="/"};{for(i=1;i<=(NF-2);i++) {printf("%s/",$i)}};')
#echo $path

# since its running on cron, it runs this script from a separate place
cd "$path"
mkdir -p .data
cd .data/

tables=$(echo "select name from sqlite_master where type='table'" | sqlite3 speeds.db)

# checking if table exists
if [[ $tables != "data" ]]
then
echo "create table data (time varchar(100),download float,upload float)" | sqlite3 speeds.db
fi

echo "insert into data values ('$time',$download,$upload)" | sqlite3 speeds.db





