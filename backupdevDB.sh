#!/bin/sh
#run this script on ~ directory of the current user
#-------------Static Variables
#Database Variables
        userdb=root
        password=root
        database=names_db
#Directories
        backup_dst=/backupdb
        error_log=backupdb/error.log
        #--------------Dynamic Variables
#get time and date
        #Get the Last Wednesday Add it to as prefix
        #if today >= last 7 days of the Month
        week=$(date +%A)
                if [ "$week" = "Thursday" ]; then
                month=$(date +%B_%Y)
                #today directory represented as Monday, Thuesday, Last_Wednesday_of_January_2016 ..etc
                today="Last_Thrusday_of_"$month
                else
                today=$week
                fi
#------------------------------------------------------
#Backing up process start
    #Scan if the directory exists then create it
    if [ -d "$backup_dst" ]; then
        echo existing >> /dev/null
        else
        mkdir $backup_dst
    fi
    #create the database dump file
mysqldump -u$userdb -p$password --single-transaction --quick --lock-tables=false $database > $backup_dst/$today"_"$database.sql 2>> $error_log
if [ "$?" -eq 0 ]
then
    #compress using gzip tar
       gzip -qf $backup_dst/$today"_"$database.sql 2>> $error_log       
        #Send Backup Everyday
        if [ "$?" -eq 0 ]; then
        #this echo will just redirected to null, to nothing
            echo "success" >> /dev/null
        else
        #if zipping fails write on error log
            echo $(date +%d_%B_%Y)" Error Zipping the dump file" >> $error_log
        fi
else
#if Dumping fails write an error log and remove failed dump file
    echo $(date +%d_%B_%Y)" Error While dumping database(mysqldump on $database)" >> $error_log
    rm -f $backup_dst/$today"_"$database.sql
fi
