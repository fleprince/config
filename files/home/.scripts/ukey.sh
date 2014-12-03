#!/bin/bash

LAST_COMP=unknown
LAST_PLUGGED=none

IFS=$'\n'
for mtabline in `cat /etc/mtab`; do
    device=`echo $mtabline | cut -f 1 -d ' '`
    udevline=`udevadm info -q path -n $device 2>&1 |grep usb`
    if [ $? == 0 ] ; then
        devpath=`echo $mtabline | cut -f 2 -d ' '`
    fi
done
LAST_PLUGGED=$devpath

if [ $LAST_PLUGGED == none ]; then
    echo "Please plug a USB stick"
else
    LAST_COMP=`find ~/.pinstrc/ -maxdepth 1 -mindepth 1 -type d | cut -f 5 -d '/'`

    case $LAST_COMP in
        jpsumo)
            echo "Copying jpsumo update"
            cp -f ~/.pinstrc/jpsumo_lucie_updater_payload.plf $LAST_PLUGGED/jumpingsumo_usb_update.plf
            ;;
        delos)
            echo "Copying delos update"
            ;;
        ardrone3)
            echo "Copying bebop update"
            ;;
        *)
            echo "$LAST_COMP not supported"
            ;;
    esac
fi

umount $LAST_PLUGGED
