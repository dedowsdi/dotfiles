#!/bin/bash

#used to jscombine javascript  
#used as  jscombined cfgFile combinedFile 
if [ ! $# = 2 ] ; then
    echo "wrong arg number, excepted format is jscombined cfgFile combinedFile"
    exit 1
fi

#build combined file

cfgFile=$1
combinedFile=$2

echo starte combine******************************
echo found cfgFile: $cfgFile, targetFile: $combinedFile

# date at first line
echo -n //  > $combinedFile
echo -n created by zxd at >> $combinedFile
date >> $combinedFile

while read line; do
    echo combine file: $line
    cat $line >> $combinedFile  
done < $cfgFile

echo finishe combine******************************
