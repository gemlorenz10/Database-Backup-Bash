#!bin/bash
#run this script on ~ directory of the current user
#filename BackupDB.sh
#-------------Static Variables
#Database Variables
        userdb=dev
        password=Wc~0453224133
        database=dev
        #Backup Directory
        backup_dir=dev_db
#Remote/backup server information
        user=backup
        backup_server=218.50.181.107
        remote_dir=/backup
#--------------Dynamic Variables
#get time and date
        #Get the Last Wednesday Add it to as prefix
        #if today >= last 7 days of the Month
        week=$(date +%a)
                if [ "$week" = "Wed" ]; then
                month=$(date +%Y_%m)
                today="Last_Wednesday_of_"$month
                else
                today=$week
                fi
        #backup destination
        backup_dst=$backup_dir/$today
#---------------------
#Backing up process start
    #Scan if the directory exists then create it
    if [ -d "$backup_dst" ]; then
        rm -f $backup_dst/*
        else
        mkdir $backup_dst
    fi
    #create the database dump file
    mysqldump -u$userdb -p$password --single-transaction --quick --lock-tables=false $database > $backup_dst/$database.sql
    #if successful
    if [ "$?" -eq 0 ]
    then
    #compress using gzip tar
        tar -cpzf $database.tar.gz $backup_dst/$database
        #Delete raw dump file
        if [ "$?" -eq 0 ]
        then
        #after zipping delete the raw dump file
                rm -f $backup_dst/*.sql
        fi
        #Send Backup Weekly to Remote Server
        if [ "$?" -eq 0 ]
        then
        #Send the Backup
                scp -q $database.tar.gz $user@$backup_server:$remote_dir
        fi
    fi
