#!/bin/sh

VERSION_FILE=/home/root/version.txt
HOST=http://updates.mtechlanka.com

rm -f $VERSION_FILE

wget -q -O $VERSION_FILE http://updates.mtechlanka.com/buzz/version.txt || exit 1
if [ "$?" -ne "0" ]; then
        echo "error"
        exit 1
fi

v2=$(head -n 1 $VERSION_FILE)

if [ $(echo "$1 < $v2") ]; then

        #echo "working ..."

        cd /home/root/auto_update/
        rm -f image.bin

        wget -q http://updates.mtechlanka.com/buzz/image.bin || exit 1

        #echo $(head -n 2 $VERSION_FILE)

        md5_new=`cat $VERSION_FILE | tail -n 1`

        if [ $md5_new = `md5sum -t image.bin | awk '{print $1}'` ]; then
                reboot
                exit 2
        fi
fi
echo "updated"
exit 0
