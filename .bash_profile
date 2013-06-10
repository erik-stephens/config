
# -*- mode: shell-script -*- vim:ft=shell-script

if test -z "$PS1"; then
  # If not running interactively, don't do anything
  return
fi

function on-bsd {
    uname | grep -iq 'darwin'
}

COMPLETIONRC="/etc/bash_completion /usr/local/etc/bash_completion"
for src in $COMPLETIONRC; do
  test -f $src && source $src
done

if test -x /usr/bin/lesspipe; then
  # Make less more friendly for non-text input files, see lesspipe(1)
  eval "$(lesspipe)"
fi

if test -x /usr/bin/dircolors; then
  # Enable color support of ls and also add handy aliases
  file=""
  if test -r ~/.bash/dircolors; then
    file="~/.bash/dircolors"
  fi
  eval "$(dircolors -b $file)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

export VIRTUAL_ENV_DISABLE_PROMPT="Get off me!"
function virtual-ps1 {
  if test x$VIRTUAL_ENV != x; then
    echo " - virtual-env:$(basename $VIRTUAL_ENV)"
  fi
}
# PS1="\n\d \t - \[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$(__git_ps1 ' - \033[01;32mgit\033[0m:%s')\$(virtual-ps1)\n\! \\$ "
PS1="\n\d \t - \[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$(__git_ps1 ' - \033[01;32mgit\033[0m:%s')\n\! \\$ "
case "$TERM" in
xterm*|rxvt*|urxvt*)
  # If this is an xterm set the title to user@host:dir
  PS1="\[\e]0;\u@\h\a\]$PS1"
  ;;
*)
  ;;
esac

export PATH=/usr/local/share/npm/bin:/usr/local/bin:/usr/local/sbin:$PATH
if on-bsd; then
  export EDITOR="~/MyApps/Emacs.app/Contents/MacOS/bin/emacsclient -c"
  export PATH=/usr/local/share/python3:$HOME/.rvm/bin:$PATH
else
  export EDITOR="emacsclient -nw"
fi
export INPUTRC=~/.inputrc
export LC_CTYPE=en_US.UTF-8
export HISTFILE=~/.bash_history
export HISTCONTROL=ignoreboth
export command_oriented_history=1
export notify=100
shopt -s dotglob checkwinsize cmdhist extglob histappend histverify progcomp sourcepath
if ! on-bsd; then
  shopt -s checkjobs
fi

alias e="$EDITOR"
alias em='dtach -A /tmp/erik-edit.dtach emacs'
alias db='dtach -A /tmp/erik-db.dtach psql '
alias py='dtach -A /tmp/erik-python.dtach ipython'

if on-bsd; then
  alias flushcache="sudo dscacheutil -flushcache"
  alias services="netstat -p tcp -an | grep -i listen"
else
  alias services='netstat -ntulp'
fi

alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias ll="ls -l"

export NODE_PATH=/usr/local/share/npm/lib/node_modules

alias g='git'
complete -o default -o nospace -F _git g
