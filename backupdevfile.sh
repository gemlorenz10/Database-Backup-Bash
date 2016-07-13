#!bin/bash
#run everytime you want to backup
#dont forget to change the variables
#Backup everytime we finished an update or add feature on the website

#$raw is the variable of the raw file or directory
#$backupname wil be the name of the archived and zipped raw file
#$remotedir is the directory in your remote backup server where you want your backup files to be saved
raw=/www/file-upload
backupname=file-upload.tar.gz
remotedir=/backup/


#compressed zip the raw file or directory
tar -czpf $backupfile $rawfile 
if [ "$?" -eq 0 ];then
	#Send it to backup directory
	scp -q $backupname backup@218.50.181.107:$remotedir
		if [ "$?" -eq 0 ];then
			#remove backup zipped 
			rm $backupname
		else
			exit
			#if possible 
		fi
else
	exit	
fi
