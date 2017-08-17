# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source ~/.shrc_common
source ~/.bash_aliases
source ~/.bash_functions

[ -f ~/.bashrc.local ] && source ~/.bashrc.local
