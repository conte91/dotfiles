# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source ~/.shrc_paths
source ~/.bash_functions
source ~/.bash_aliases
source ~/.shrc_common

which fasd 2>/dev/null >/dev/null && eval "$(fasd --init posix-alias bash-hook)"

[ -f ~/.bashrc.local ] && source ~/.bashrc.local
