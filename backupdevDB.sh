#!bin/bash
#run this script on ~ directory of the current user
#filename BackupDB.sh
#filename sample for backup Prefix_JAN_10_Wed_1630DBbackup.tar.gz
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
prefix_date=$(date +%b_%d_%a"_"%H"."%M)
        #Get the Last Wednesday Add it to as prefix
            week=$(date +%a)
            last_7day=$(date -d "`date +%Y%m01` +1 month -7days" +%d)
            today=$(date +%d)
            #if today >= last 7 days of the Month
                if [ $today -ge $last_7day ] && [ "$week" = "Wed" ];
                then
                prefix_name="Last_Wednesday_of_"
                else
                prefix_name=""
                fi
        #Name of raw dumfile
        backup_name=$prefix_name$prefix_date$database"."sql
        #Name of zipped backup file
        zip_name=$prefix_name$prefix_date$database"."tar.gz
#---------------------
#Backing up process start
    #Scan if the directory exists then create it
    if [ -d "$backup_dir" ]; then
        cd $backup_dir
        else
        mkdir $backup_dir
        cd $backup_dir
    fi
    #create the database dump file
    mysqldump -u$userdb -p$password --single-transaction --quick --lock-tables=false $database > $backup_name
    #if successful
    if [ "$?" -eq 0 ]
    then
    #compress using gzip tar
        tar -cpzf $zip_name $backup_name
        #Delete raw dump file
        if [ "$?" -eq 0 ]
        then
                #after zipping delete the raw dump file
                rm -f *.sql
        fi
        #Send Backup Weekly to Remote Server
        if [ "$?" -eq 0 ] && [ $week = "Wed" ]
        then
                #Send the Backup
                scp -q $zip_name $user@$backup_server:$remote_dir
        fi
    fi
