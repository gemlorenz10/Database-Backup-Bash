#!bin/bash
#run this script on ~ directory of the current user
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
        week=$(date +%A)
                if [ "$week" = "Wed" ]; then
                month=$(date +%Y_%m)
                #today directory represented as Monday, Thuesday ..etc
                today="Last_Wednesday_of_"$month
                else
                today=$week
                fi
        #backup destination
        #~/dev_db/Monday
        backup_dst=$backup_dir/$today
#------------------------------------------------------
#Backing up process start
    #Scan if the directory exists then create it
    if [ -d "$backup_dst" ]; then
        rm -f $backup_dst/*
        else
        mkdir $backup_dst
    fi
    #create the database dump file
    mysqldump -u$userdb -p$password --single-transaction --quick --lock-tables=false $database > $backup_dst/$database.sql
    if [ "$?" -eq 0 ]
    then
    #compress using gzip tar
        tar -cpzf $backup_dst/$database.sql.tar.gz $backup_dst/$database.sql
        if [ "$?" -eq 0 ]
        then
        #after zipping delete the raw dump file
                rm -f $backup_dst/*.sql
        fi
        #Send Backup Everyday
        if [ "$?" -eq 0 ]
        then
                scp -q $backup_dst/$database.sql.tar.gz $user@$backup_server:$remote_dir/$backup_dst
        fi
    fi
