#!/bin/bash -
# gnuplot script for blackbox plotting

print_help()
{
    echo "Usage: $0 [-f FILENAME] [PATTERN]" >&2
    echo "       where PATTERN is a part of the logged variable name"
}

# checking and installing tools
if ! hash blackbox_parser 2>/dev/null; then
    echo "You must first compile blackbox_parser for pclinux"
    echo "and add it to your PATH environment variable."
    exit
fi

if ! hash gnuplot 2>/dev/null; then
    echo "gnuplot not found. Installing it..."
    sudo apt-get install gnuplot-x11
fi

if ! hash gnuplot 2>/dev/null; then
    echo "Installation failed. Leaving"
    exit
fi



# getting file

NEWERFILE=`ls -t light_run* | head -n 1`
INFILE=""
PATTERN=""

while [ ! -z $1 ]; do
    if [ "${1}" == "-f" ]; then
        shift
        if [ -z "${1}" ]; then
            echo "-f option missing argument"
            print_help
            exit 1
        else
            INFILE="${1}"
        fi
    elif [ "${1}" == "-h" ]; then
        print_help
        exit 0
    else
        PATTERN+="${1} "
    fi
    shift
done

OUTFILE="out.csv"

if [ -z "${PATTERN}" ]; then
    PATTERN="index"
fi

if [ -z "${INFILE}" ]; then
    if [ -f "${NEWERFILE}" ]; then
        INFILE="${NEWERFILE}"
    fi
fi

if [ ! -f "${INFILE}" ]; then
    echo "${INFILE} doesn't seem to exist or being a valid file."
    if [ ! -f "${NEWERFILE}" ]; then
        echo "Abort"
        exit 1
    else
        echo "Using the most recent blackbox file instead."
        INFILE="${NEWERFILE}"
    fi
fi

if [ ! -f $OUTFILE ]; then
    blackbox_parser ${INFILE} ${OUTFILE} > /dev/null
fi

HEAD=`head -n 1 ${OUTFILE}`

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

    res=""
    for word in `echo "$PATTERN"`
    do
        res=`echo ${title} | grep ${word}`
        if [ ! -z ${res} ]; then
            break
        fi
    done

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
