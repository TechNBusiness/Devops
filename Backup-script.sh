#!bin/bash
# This script will backup a file and archive it.

# What to backup.
backup_files="/home/gazzy/myfolder"

 #Where to backup to.
 dest="/homr/gazzy/backup"

 #Create an archive filename
 day=$(date +%A)
 hostname=$(hostname -s)
 archive_file="$hostname-$day.tgz"

 #Print start startup message
 echo "Backing up $backup_files to $dest/$archive_file"
 date
 echo

 #Backup files using tar
 tar czf $dest/$archive_file $backup_files

 #Print end status message
 echo
 echo "Backup finished"
 

