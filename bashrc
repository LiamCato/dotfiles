# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;35m\]\u\[\033[00;37m\]@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'



# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# added by perl
PATH="/home/$USER/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/$USER/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/$USER/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/$USER/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/$USER/perl5"; export PERL_MM_OPT;

##########
## self added
export EDITOR=vim

function path_remove {
  # Delete path by parts so we can never accidentally remove sub paths
  PATH=${PATH//":$1:"/":"} # delete any instances in the middle
  PATH=${PATH/#"$1:"/} # delete any instance at the beginning
  PATH=${PATH/%":$1"/} # delete any instance in the at the end
}

function _tmux {
tmux new-session -d -s $1
tmux send-keys -t $1 "export PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/var/cfengine/bin:/usr/share/doc/subversion-1.6.11:/opt/mv_pro_5.0/montavista/pro/devkit/arm/v5t_le/bin/:/home/london/$USER/bin" enter
tmux send-keys -t $1 "unset XDG_DATA_DIRS" Enter
tmux send-keys -t $1 "unset X_SCLS" Enter
tmux send-keys -t $1 "unset PKG_CONFIG_PATH" Enter
tmux send-keys -t $1 "unset LD_LIBRARY_PATH" Enter
tmux attach -t $1
}

alias tmuxx=_tmux

export USING_PER_DEV_REPLICATION=1

function glog {
   git log --graph --all --format=format:"%x09%C(yellow)%h%C(reset) %C(green)%ai%x08%x08%x08%x08%x08%x08%C(reset) %C(bold white)%cn%C(reset)%C(auto)%d%C(reset)%n%x09%C(white)%s%C(reset)" --abbrev-commit "$@"
   echo
}

# only ask for my SSH key passphrase once!
# use existing ssh-agent if possible
#if [ -f "${HOME}/.ssh-agent" ]; then
#   . "${HOME}/.ssh-agent" > /dev/null
#fi
#if [ -z "$SSH_AGENT_PID" -o -z "`ps -a|grep -e \"^[ ]+$SSH_AGENT_PID\"`" ]; then
#   /usr/bin/ssh-agent > "${HOME}/.ssh-agent"
#   . "${HOME}/.ssh-agent" > /dev/null
#fi

#eval `ssh-agent -s`
#ssh-add ~/.ssh/id_rsa

if [ -d /opt/rh/rh-python36 ]; then
    source /opt/rh/rh-python36/enable
fi

if [ -d /opt/rh/httpd24 ]; then
    source /opt/rh/httpd24/enable
fi

if [ -f $HOME/.local/autocomplete/make_sh_autocomplete ]; then
    source $HOME/.local/autocomplete/make_sh_autocomplete
fi

export PIPENV_VENV_IN_PROJECT=1

# CUDA et al
if [ -d /usr/local/cuda ]; then
    PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
    LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64"
    export CUDA_HOME=/usr/local/cuda
fi

if [ -f $HOME/.jfrog-env ]; then
    source $HOME/.jfrog-env
fi

