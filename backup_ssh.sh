#!/bin/bash

rsync -a --delete -e ssh /home/jovana/Documents jovana@192.168.47.128:/home/jovana/Desktop/backup &> /dev/null
