alias ls='ls --color=auto'
alias e='emacs -nw'

which nvim > /dev/null 2>&1 && alias vim='nvim' && alias vi='nvim'

alias viclass='vim_open_class_jciuwheviweuhfiwernoqwkciwuenciwesiuveivreiuvheriufh'

alias todo='~simo/My_Projects/todo.sh'

alias make='for i in `seq 1 1000`; do echo; done; make -j4'

alias bottles='for i in `seq 0 98`; do j=`expr 99 - $i`; k=`expr $j - 1`;notify-send "$j bottles of beer on the wall, $j bottles of beer on the wall, take one down, pass it around, $k bottles of beer on the wall"; done'


alias gtfo='exit'

which thefuck > /dev/null 2>&1 && eval $(thefuck --alias)
# --enable-experimental-instant-mode

alias FUCK='fuck'
alias fuck-it='export THEFUCK_REQUIRE_CONFIRMATION=False; fuck; export THEFUCK_REQUIRE_CONFIRMATION=True'

alias wow='git status -- .'
alias such='git'
alias very='git'
