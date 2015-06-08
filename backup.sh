#!/bin/bash

# backup sources and destination
src1=/home/jovana/Documents
src2=/home/jovana/Downloads
dest=/home/jovana/Backups

# rsync command
rsync -avz --delete --stats --backup --backup-dir=`date +%Y-%m-%d-%T` $src1/ $src2/ $dest/
