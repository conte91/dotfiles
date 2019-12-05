# Uncomment the following line to use case-sensitive completion.
fpath=($fpath /usr/share/zsh/5.0.2/functions/ /usr/share/zsh/site-functions/)
CASE_SENSITIVE="true"
#
# User configuration
fpath=(~/dotfiles/zsh_completion $fpath)
autoload -Uz compinit
compinit

export HISTSIZE=10000
export SAVEHIST=10000
setopt autocd

# We're still not ready for vim mode
set_term_key() {
	[[ -n "${terminfo[$1]}" ]] && bindkey "${terminfo[$1]}" $2
}

bindkey -e
set_term_key khome beginning-of-line
set_term_key kend  end-of-line
set_term_key kdch1 delete-char

# Word to be considered with vim boundaries
export WORDCHARS=''

export PS1='[%n@%m %2~] %B%(0?.%F{blue}.%F{red})%(!.#.→)%b%f '

source ~/.shrc_paths
[ -f ~/.bash_functions ] && source ~/.bash_functions
[ -f ~/.bash_aliases ] && source ~/.bash_aliases
source ~/.shrc_common

[ -f ~/.zshrc.local ] && source ~/.zshrc.local
