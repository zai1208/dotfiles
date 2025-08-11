#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --colour=auto'

if [$XDG_SESSION_TYPE != tty]
then
  source ~/trueline.sh
fi

fastfetch
