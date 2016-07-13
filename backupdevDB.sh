#!bin/bash
#run this script on ~ directory of the user
#filename BackupDB.sh
#filename sample for backup Prefix_JAN_10_Wed_1630DBbackup.tar.gz
#get time and date
        prefix_date=$(date +%b_%d_%a"_"%H"."%M)
#---------------------
#Finding Prefix/labeling i.e Last_Wed_of_$backup_name
            week=$(date +%a)
            last_7day=$(date -d "`date +%Y%m01` +1 month -7days" +%d)
            today=$(date +%d)
            #if today > last 7 days of the Month
                if [ $today -ge $last_7day ] && [ "$week" = "Wed" ];
                then
                #true
                prefix_name="Last_Wednesday_of_"
                else
                prefix_name=""
                fi
#Put Parameters here
#Database Parameters
        userdb=
        password=Wc~0453224133
        database=dev
        backup_name=$prefix_name$prefix_date$database"."sql
#----------------------
#Compress/Zip Variables
#Name of backup when zipped
        zip_name=$prefix_name$prefix_date$database"."tar.gz
#---------------------
#Remote server information
#user, backup_server=domain name or ip address
        user=backup
        backup_server=218.50.181.107
        remote_dir=/backup
#Backing up process start
    #this is your backup directory
    backup_dir=dev_db
    #Scan if the directory exists then create it
    if [ -d "$backup_dir" ]; then
    # Will enter here if $DIRECTORY exists, even if it contains spaces
        mkdir $backup_dir
        cd $backup_dir
        else
        cd $backup_dir
    fi
    if [ "$userdb" != "" ]; then
    #create a database dump file
    mysqldump -u$userdb -p$password --single-transaction --quick --lock-tables=false $database > $backup_name
    else
    mysqldump -p$password --single-transaction --quick --lock-tables=false $database > $backup_name
    fi
    #if successful
    if [ "$?" -eq 0 ]
    then
    #compress using gzip tar
        tar -cpzf $zip_name $backup_name
        #Delete raw dump file if applicable
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
