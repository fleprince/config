#!/bin/bash

LAST_COMP=unknown
LAST_PLUGGED=none
DEMO_MODE=no

IFS=$'\n'
for mtabline in `cat /etc/mtab`; do
    device=`echo $mtabline | cut -f 1 -d ' '`
    udevline=`udevadm info -q path -n $device 2>&1 |grep usb`
    if [ $? == 0 ] ; then
        LAST_PLUGGED=`echo $mtabline | cut -f 2 -d ' '`
    fi
done

if [ $LAST_PLUGGED == none ]; then
    echo "Please plug a USB stick"
else
    LAST_COMP=`find ~/.pinstrc/ -maxdepth 1 -mindepth 1 -type d | cut -f 5 -d '/'`

    case $LAST_COMP in
        jpsumo)
            echo "Copying jpsumo update on ${LAST_PLUGGED}"
            cp -f ~/.pinstrc/jpsumo_lucie_updater_payload.plf ${LAST_PLUGGED}/jumpingsumo_usb_update.plf
            sync
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

    DEMO_MODE=$1
    if [ "${DEMO_MODE}" == "demo" ]; then
        DEMO_MODE=$2
        if [ -z "${DEMO_MODE}" ]; then
            echo "Copying newest demo script"
            SRC=`ls -t ~/Projects/mykonos/dragon/Modules/Demos/SIMU/output/*.xml | head -n 1`
            cp -f ${SRC} ${LAST_PLUGGED}/demo.xml
        else
            echo "Copying demo JS_${DEMO_MODE}.xml script"
            cp -f ~/Projects/mykonos/dragon/Modules/Demos/SIMU/EVENTS/CES_2015/DEMO_DELOS_JS/JS_DIR/JS_${DEMO_MODE}.xml ${LAST_PLUGGED}/demo.xml
        fi
        sync
    fi
    umount $LAST_PLUGGED
fi

