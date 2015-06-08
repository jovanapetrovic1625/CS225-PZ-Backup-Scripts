HOW TO USE SCRIPTS

1. backup.sh
Script named backups.sh is used for local backup. User can 
define source and destination folder for backup-ing and the backup-ed folder 
will get the name of the actual date and time of the backup.

2. backup_ssh.sh
Script named backup_ssh.sh is used for remote backup. 
User can specify local source and remote destination.
The script uses ssh for remote connection.

3. backup2.sh
Script named backup2.sh can be used for both local and remote connection. 
That depends on the parameters which user enters when starting up the script.
The scripts makes a folder hierarchy depending on the type of the backup - 
latest backup, daily, weekly or monthly. User can define the name of the backup, 
repository name, email address on which the script will send the report, 
or even a specific ssh command,  when he needs a remote connection.
