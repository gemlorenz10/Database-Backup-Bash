#!bin/bash
#run this script on ~ directory of the current user
#-------------Static Variables
#Database Variables
        userdb=root
        password=root
        database=names_db
        backup_dst=backupdb
        #--------------Dynamic Variables
#get time and date
        #Get the Last Wednesday Add it to as prefix
        #if today >= last 7 days of the Month
        week=$(date +%A)
        min=$(date +%M)
                if [ "$week" = "Thursday" ]; then
                month=$(date +%B_%Y)
                #today directory represented as Monday, Thuesday, Last_Wednesday_of_January_2016 ..etc
                today="Last_Thrusday_of_"$month$min
                else
                today=$week$min
                fi
#------------------------------------------------------
#Backing up process start
    #Scan if the directory exists then create it
    if [ -d "$backup_dst" ]; then
        n=1
        else
        mkdir $backup_dst
    fi
    #create the database dump file
    mysqldump -u$userdb -p$password --single-transaction --quick --lock-tables=false $database > /$backup_dst/$today"_"$database.sql
    if [ "$?" -eq 0 ]
    then
    #compress using gzip tar
       gzip -qf $backup_dst/$today"_"$database.sql
        #Send Backup Everyday
    fi
    
    
 #make sure you installed rsync o both machines
 #run this command via cron in remote backup server
 #make sure the machines can talk to each other via ssh-key
 #rsync --progress --delete-after -r -e ssh root@192.168.0.250:/backupdb/ backup/
 #
 #
 #
    
    
    
    
    
