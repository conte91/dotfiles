# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source ~/.shrc_common
source ~/.bash_aliases
source ~/.bash_functions

which fasd 2>/dev/null >/dev/null && eval "$(fasd --init posix-alias bash-hook)"

[ -f ~/.bashrc.local ] && source ~/.bashrc.local
