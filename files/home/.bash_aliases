#!/bin/bash

# Global definitions.
if [ -f ~/.globals.sh ]; then
    source ~/.globals.sh
fi

# moving
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'

# safe commands
alias mv='mv -i'
alias rm='rm -i'
alias cp='cp -i'
alias gvim='gvim -p'

# dragon tools
alias dragon='cd ~/Projects/mykonos/dragon'
alias dragon3='cd ~/Projects/mykonos/dragon3'

# displays
alias ls='ls --color=auto --group-directories-first -h'
alias ll='ls -alF'
alias lla='ls -al'
alias l='ls -CF'
alias la='ls -A'

# git
alias gti='git'
alias gits='git status'
alias gitc='git checkout'
alias gk='gitk'
alias gl='git log --pretty=format:"%Cred%h%Cblue %ai %Cgreen%an %Cred%d %Creset%n    %f"'
alias gl1='git log --pretty=format:"%Cred%h%Cblue %ai %Cgreen%an %Cred%d %Creset %f"'
alias gll='git log --pretty=format:"%Cred%h%Cblue %ai %Cgreen%an %Creset%Cred%d%n%Creset%B"'
alias gph='git push'
alias gpl='git pull'
alias ga='gitk --all'
alias gb='git branch'
alias gg='git gui'
alias ggl='gl --graph'
alias ggl1='gl1 --graph'
alias ggll='gll --graph'

# grep & find
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias myfind='find . -name'
alias mygrep='grep -rnEi --exclude=.#* --exclude=*.svn-base'
alias mygrepc='mygrep --include=*.c --include=*.cpp'
alias mygrepch='mygrep --include=*.c --include=*.cpp --include=*.h --include=*.hpp'
alias mygreph='mygrep --include=*.h --include=*.hpp'

# mount NAS folders
alias docmount="sudo mount -t cifs //nas.parrot.biz/docs /mnt/doc/ -o user=f.leprince,rw"
alias binmount="sudo mount -t cifs //nas.parrot.biz/binarypackages /mnt/bin/ -o user=f.leprince,rw"

# others
alias F='make flash'
alias K9='kill -9'
alias M='make'
alias MF='make && make flash'
alias ProcSearch='ps -aux | grep'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias reIndex='./RCFindSrcFiles.sh && echo "### cscope -bqk ###" && cscope -bqk'
alias wifi_scan='sudo iwlist scan | grep ESSID'
