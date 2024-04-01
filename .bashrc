# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source ~/.shrc_paths
source ~/.bash_functions
source ~/.bash_aliases
source ~/.shrc_common

which fasd 2>/dev/null >/dev/null && eval "$(fasd --init posix-alias bash-hook)"

[ -f ~/.bashrc.local ] && source ~/.bashrc.local

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/anaconda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/anaconda/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda/etc/profile.d/conda.sh"
    else
        export PATH="/opt/anaconda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

