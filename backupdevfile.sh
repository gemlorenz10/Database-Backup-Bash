#!bin/bash
#run everytime you want to backup
#dont forget to change the variables

#$raw the raw file or directory you want to backup
#$backupname wil be the name of the archived and zipped raw file
#$remotedir is the directory in your remote backup server where you want your backup files to be saved
#$date will be used as prefix name for backup files
date=$(date +%a_%b_%d_)
raw=/www/file-upload
backupname=$date''file-upload.tar.gz
remotedir=/backup/

#compressed zip the raw file or directory
tar -czpf $backupname $raw 
if [ "$?" -eq 0 ];then
	#Send it to backup server
	scp -q $backupname backup@218.50.181.107:$remotedir
		if [ "$?" -eq 0 ];then
			#remove backup zipped on local machine 
			rm $backupname
		else
			exit
		fi
else
	exit	
fi
