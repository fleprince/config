#!/bin/bash -

NOIR="\[\e[30;1m\]"
ROUGE="\[\e[31;1m\]"
VERT="\[\e[32;1m\]"
JAUNE="\[\e[33;1m\]"
BLEU="\[\e[34;1m\]"
ROSE="\[\e[35;1m\]"
CYAN="\[\e[36;1m\]"
BLANC="\[\e[37;1m\]"
fNOIR="\[\e[40m\]"
fROUGE="\[\e[41m\]"
fVERT="\[\e[42m\]"
fJAUNE="\[\e[43m\]"
fBLEU="\[\e[44m\]"
fROSE="\[\e[45m\]"
fCYAN="\[\e[46m\]"
fBLANC="\[\e[47m\]"
RESET="\[\e[m\]"

function find_project_name()
{
    PROJECTNAME=""
    PROJECTFOLDERS="/home/florian/Projects/repos/ /home/florian/Projects/bacasable/ /home/florian/Projects/github/"
    for PPATH in $PROJECTFOLDERS ; do
        tpath=`pwd | grep "$PPATH"`
        if [ ! -z "$tpath" ]; then
            pathlevel=$(($(grep -o "/" <<< "$PPATH" | wc -l)+1))
            pfolder=`pwd | cut -d '/' -f $pathlevel`
            if [ "$PWD" != "$PPATH$pfolder" ]; then
                PROJECTNAME=" $pfolder "
            fi
            break;
        fi
    done
    echo "${PROJECTNAME}"
}

function do_line()
{
    export GIT_PS1_SHOWDIRTYSTATE=true
    export GIT_PS1_SHOWSTASHSTATE=true
    export GIT_PS1_SHOWUNTRACKEDFILES=true
    TIME=$(date +%H:%M)
    GITVAL=$(__git_ps1 " %s ")

    PROJECTNAME=$(find_project_name)

    tput cr
    LIGNE1="${fNOIR} ${HOSTNAME} ${fBLEU}${PROJECTNAME}${fCYAN} ${PWD##*/} ${fNOIR}${GITVAL}"
    LIGNEFAKE=" ${HOSTNAME} ${PROJECTNAME} ${PWD##*/} ${GITVAL}"

    MAX_COLUMNS=$((COLUMNS-${#LIGNEFAKE}))
    TOPFAKE="    ${TIME} "
    TOP="${BLANC}\$(if [[ \$? == 0 ]]; then echo \"${fVERT} \342\234\223\"; else echo \"${fROUGE} \342\234\227\"; fi) ${fBLANC}${NOIR} ${TIME} "
    while [ ${#TOPFAKE} -lt ${MAX_COLUMNS} ]; do
        TOP=" ${TOP}"
        TOPFAKE="_${TOPFAKE}"
    done

    PS1="${RESET}${LIGNE1}${TOP}${RESET}\n>"
}

function do_prompt()
{
    tput cup $((LINES-1)) 1
    do_line
}
