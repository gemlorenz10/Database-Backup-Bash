#!bin/bash
#run this script on ~ directory of the current user
#-------------Static Variables
#Database Variables
        userdb=root
        password=root
        database=names_db
#Remote/backup server information
        user=root
        backup_server=192.168.0.251
        remote_dir=/backup
        remote_bash=scandir.sh
#--------------Dynamic Variables
#get time and date
        #Get the Last Wednesday Add it to as prefix
        #if today >= last 7 days of the Month
        week=$(date +%A)
                if [ "$week" = "Wed" ]; then
                month=$(date +%B_%Y)
                #today directory represented as Monday, Thuesday, Last_Wednesday_of_January_2016 ..etc
                today="Last_Wednesday_of_"$month
                else
                today=$week
                fi
        #backup destination
        #~/Monday
        backup_dst=/$today
#------------------------------------------------------
#Backing up process start
    #Scan if the directory exists then create it
    if [ -d "$backup_dst" ]; then
        rm -f $backup_dst/*
        elseqq
        mkdir $backup_dst
    fi
    #create the database dump file
    mysqldump -u$userdb -p$password --single-transaction --quick --lock-tables=false $database > $backup_dst/$database.sql
    if [ "$?" -eq 0 ]
    then
    #compress using gzip tar
        tar -cpzf $backup_dst/$database.sql.tar.gz $backup_dst/$database.sql
        #echo tar
        if [ "$?" -eq 0 ]
        then
        #after zipping delete the raw dump file
                rm -f $backup_dst/*.sql
                #echo rm
        fi
        #Send Backup Everyday
        #Make sure remote directories exists!
        if [ "$?" -eq 0 ]
        then
                ssh 
                #echo send
                scp -q $backup_dst/$database.sql.tar.gz $user@$backup_server:$remote_dir/$backup_dst
        fi
    fi
