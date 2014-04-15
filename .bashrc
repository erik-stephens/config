
# -*- mode: shell-script -*- vim:ft=shell-script

umask 0002

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

PATH=/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin
if on-bsd; then
  EDITOR="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -c"
  # EDITOR="subl --wait"

  # Python
  # PATH=$HOME/anaconda/bin:/usr/local/share/python3:$PATH
  export WORKON_HOME="~/.pyvm"
  export PIP_VIRTUALENV_BASE=$WORKON_HOME
  source /usr/local/bin/virtualenvwrapper.sh

  # Java
  # PATH=$HOME/Development/Android/sdk/platform-tools:~/Development/Android/sdk/tools:$PATH
  JAVA_HOME=$(/usr/libexec/java_home)

  # Ruby
  # export PATH $HOME/.rvm/bin:$PATH
  # source ~/.rvm/scripts/rvm

  # Node
  # PATH=/usr/local/share/npm/bin:$PATH
  # export NODE_PATH=/usr/local/share/npm/lib/node_modules
else
  EDITOR="emacsclient -nw"
fi
export PATH
export EDITOR
export LC_CTYPE=en_US.UTF-8
export command_oriented_history=1
export notify=100
shopt -s autocd dotglob checkjobs checkwinsize cmdhist extglob histappend histverify progcomp sourcepath

export HISTTIMEFORMAT="%Y-%m-%dT%H:%M:%S  "
export HISTFILE=~/.history
export HISTFILESIZE=10000
export HISTCONTROL="ignorespace:ignoredups"

export VIRTUAL_ENV_DISABLE_PROMPT="Get off me!"
function python-env {
  if test x$VIRTUAL_ENV != x; then
    basename $VIRTUAL_ENV
  else
    echo -n system
  fi
}
function ruby-env {
  rvm current
}
function git-branch {
  if test -d .git; then
    git branch | awk '$1 == "*" { print $2 }'
  else
    echo -n none
  fi
}

# Better hostname on AWS instances.
if hostname | grep -Eq '^ip-'; then
  ip=$(grep $(hostname) /etc/hosts | awk '{print $1}')
  hostname=$(grep $ip /etc/hosts | head -1 | awk '{print $2}')
  if test -n "$hostname"; then
    export HOSTNAME=$(echo $hostname | awk -F '[.]' '{print $1}')
  fi
fi

PS1="\n\d \t - \[\033[01;32m\]\u@$HOSTNAME\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] - git:\[\033[01;34m\]\$(git-branch)\[\033[00m\] - python:\[\033[01;34m\]\$(python-env)\[\033[00m\]\n\! \\$ "

if echo $TERM | grep -Eq '(xterm|rxvt|urxvt)'; then
  # If this is an xterm set the title to host:dir
  PS1="\[\e]0;\h\a\]$PS1"
fi

if ! test -d ~/.dtach; then
  mkdir ~/.dtach
fi
alias e="$EDITOR"
alias em='dtach -A ~/.dtach/edit emacs'
alias db='dtach -A ~/.dtach/db psql '
alias py='dtach -A ~/.dtach/python ipython'

if on-bsd; then
  alias flushcache="sudo dscacheutil -flushcache"
  alias srvs="netstat -p tcp -an | grep -i listen"
else
  alias srvs='netstat -plunt'
fi

alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias ll="ls -l"

alias g='git'
complete -o default -o nospace -F _git g

# Consult `bind -P` for list of current bindings.
bind -x '"\C-SPACE":set-mark'
bind -x '"\C-x\C-x":exchange-point-and-mark'
bind -x '"\C-]":character-search'
bind -x '"\C-[":character-search-backward'
bind -x '"\M-9":start-kbd-macro'
bind -x '"\M-0":end-kbd-macro'
bind -x '"\M--":call-last-kbd-macro'

# if ! on-bsd; then
#   # Unbind C-w so we can bind it to something more emacs-like.
#   stty werase undef
#   bind -x '"\C-w":kill-region'
# fi
