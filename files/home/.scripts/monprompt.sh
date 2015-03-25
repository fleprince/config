#!/bin/bash -

function do_prompt()
{
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

    newPWD=$(sed "s=$HOME=~=" <<< "${PWD}")
    TIME=$(date +%H:%M)
    GITVAL=$(__git_ps1 " %s ")

    LIGNE=" ${USER}@${HOSTNAME}  ${newPWD} ${GITVAL}"

    MAX_COLUMNS=$((COLUMNS))
    TOPFAKE="   ${TIME} "
    TOP="${fBLANC} \$(if [[ \$? == 0 ]]; then echo \"${BLEU}\342\234\223\"; else echo \"${ROUGE}\342\234\227\"; fi) ${NOIR}${TIME} ${RESET}"
    while [ ${#TOPFAKE} -lt ${MAX_COLUMNS} ]; do
        TOP="_${TOP}"
        TOPFAKE="_${TOPFAKE}"
    done

    PROJECTNAME=""
    PROJECTFOLDERS="/home/florian/Projects/mykonos/ /home/florian/Projects/bacasable/"
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
    #PROJECTNAME=

    LIGNE1="${fNOIR} ${HOSTNAME} ${fVERT}${PROJECTNAME}${fBLEU} \W ${fCYAN}${GITVAL}${RESET}"

    PS1="${TOP}\n${LIGNE1} "
}
