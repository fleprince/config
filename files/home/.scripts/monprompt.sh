#!/bin/bash -

function do_prompt()
{
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

    #
    LIGNE=" ${USER}@${HOSTNAME}  ${newPWD} ${GITVAL}"

    MAX_COLUMNS=$((COLUMNS))
    TOP=""
    while [ ${#TOP} -lt ${MAX_COLUMNS} ]; do
        TOP="${TOP}_"
    done

    LIGNE1="${fNOIR} ${USER}@${HOSTNAME} ${fBLEU} ${newPWD} ${fCYAN}${GITVAL}${RESET}"

    PS1="${TOP}\n${LIGNE1} "
}
