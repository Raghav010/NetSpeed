#!/bin/bash


echo "Checking speed..."
stats=$(speedtest --csv-delimiter " " --csv)


#YYYY-MM-DDThh:mm
time=$(date +%y%m%d%H%M)
echo "time is $time"

# Mbits/s
stats=($stats)
download=$(echo "scale=4;${stats[6]}/1000000" | bc)
upload=$(echo "scale=4;${stats[7]}/1000000" | bc)

echo "download : $download"
echo "upload : $upload"


cd .

tables=$(echo "select name from sqlite_master where type='table'" | sqlite3 test1.db)

if [[ $tables != "data" ]]
then
echo "create table data (time varchar(100),download float,upload float)" | sqlite3 test1.db
fi

echo "insert into data values ('$time',$download,$upload)" | sqlite3 test1.db





