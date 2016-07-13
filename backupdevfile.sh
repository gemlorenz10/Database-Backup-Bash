#!bin/bash
#run everytime you want to backup
#dont forget to change the variables

#$raw the raw file or directory you want to backup
#$remotedir is the directory in your remote backup server where you want your backup files to be saved
	raw=/www/file-upload
	backupname=file-upload
#remote/backupdatabase
	remotedir=/backup/
	user=backup
	server=218.50.181.107
#--Dynamic variables
#$date will be used as prefix name for backup files
	date=$(date +%a_%b_%d_)
#$backupname wil be the name of the archived and zipped raw file
	backupname=$date$backupname.tar.gz
#compressed zip the raw file or directory
	tar -czpf $backupname $raw 
	if [ "$?" -eq 0 ];then
	#Send it to backup server
	scp -q $backupneame $user@$server:$remotedir
		if [ "$?" -eq 0 ];then
		#remove backup zipped on local machine 
		rm $backupname
		else
		exit
		fi
else
exit	
fi
