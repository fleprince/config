#!/bin/bash -
# gnuplot script for blackbox plotting


if [ -z "${1}" ]; then
    echo "Missing variable pattern"
    echo "graph.sh <pattern>"
    exit
fi


NEWERFILE=`ls -t light_run* | head -n 1`

OUTFILE="out.csv"

if [ -z "${NEWERFILE}" ]; then
    echo "No blackbox binary file found."
    echo "Abort"
    exit
fi

if [ ! -f $OUTFILE ]; then
    blackbox_parser ${NEWERFILE} ${OUTFILE} > /dev/null
fi

HEAD=`grep ${1} ${OUTFILE}`

if [ -z "${HEAD}" ]; then
    echo "Pattern not found in csv file"
    exit
fi

col_eol=1
col_count=1

cols=""

STR_M="
  set datafile separator ';'
  set key autotitle columnhead
"

while [ $col_eol -eq 1 ]
do
    title=`echo ${HEAD} | cut -d \; -f ${col_count}`
    if [ -z "${title}" ]; then
        col_eol=0
    fi

    res=`echo ${title} | grep ${1}`
    if [ ! -z ${res} ]; then
        if [ -z ${cols} ]; then
            cols="${col_count}"
            STR_M="${STR_M} plot '${OUTFILE}' using ${col_count} with lines"
        else
            cols="${cols}:${col_count}"
            STR_M="${STR_M}, '${OUTFILE}' using ${col_count} with lines"
        fi
    fi

    col_count=$(( $col_count + 1 ))
done

echo "${STR_M}" | gnuplot --persist
