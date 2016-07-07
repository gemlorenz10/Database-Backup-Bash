#!bin/bash
#filename BackupDB.sh
#filename sample for backup Prefix_JAN_10_Wed_1630DBbackup.tar.gz
#get time and date
        min=$(date +%M)
        hour=$(date +%H)
        dom=$(date +%d)
        mname=$(date +%b)
        mnum=$(date +%m)
        dow=$(date +%a)
        year=$(date +%Y)
#---------------------
#Finding Prefix/labeling i.e Last_Wedof$backup_name
            week=$(date +%a)
            last_7day=$(date -d "`date +%Y%m01` +1 month -7day" +%d)
            today=$(date +%d)
            #if today > last 7 days of the Month
                if [ $today -ge $last_7day ] && [ "$week" = "Wed" ];
                then
                #true
                prefix_name="Last_Wedof_"
                else
                prefix_name=""
                fi
#Put Parameters here
#Database Parameters
        userdb=root
        password=root
        database=names_db
        backup_name=$prefix_name$mname"_"$dom"_"$dow"_"$hour"."$min$database"."sql
        backup_dir=backupdb/
#----------------------
#Compress/Zip Variables
#Name of backup when zipped
        zip_name=$prefix_name$mname"_"$dom"_"$dow"_"$hour"."$min$database"."tar.gz
#---------------------
#SCP Variables
        user=root
        server=192.168.0.251
        remote_dir=/home/gem/
#Backing up rocess start
    #go to backup directory
    cd $backup_dir
    #create a database dump file
    mysqldump -u$userdb -p$password --single-transaction --quick --lock-tables=false $database > $backup_name
    #if successful
    if [ "$?" -eq 0 ]
    then
    #compress using gzip tar
        tar -cpzf $zip_name $backup_name
        #Delete raw dump file if applicable
        #Send Backup Weekly to Remote Server  
        if [ "$?" -eq 0 ] && [ $week = "Wed" ]
                then
                #Send the Backup
                scp -q $zip_name $user@$server:$remote_dir
        fi
    #end if for zipping
    fi
