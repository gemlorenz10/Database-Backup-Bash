#!bin/bash
#run everytime you want to backup
#dont forget to change the variables

raw=file-upload
backupfile=file-upload.tar.gz
remotedir=/backup/
#test if rawfile exist
#then
tar -czpf $backupfile $rawfile 
#test if zip is successful
#then
scp -q $backupfile backup@218.50.181.107:$remotedir
#test if sending is successful
#then
rm $backupfile