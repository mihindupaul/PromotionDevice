#!/bin/sh
HOST='192.168.1.4'
USER='forlinx'
PASSWD='123'
#FILE='file.txt'

cd
rm ClubE

ftp -n $HOST << END_SCRIPT
quote USER $USER
quote PASS $PASSWD
#cd /home/ranjana/release
trace
passive
binary
pwd
cd /home
cd ranjana
cd release
pwd
ls
lcd /home/root
get ClubE
END_SCRIPT

pwd
chmod +x ./ClubE
