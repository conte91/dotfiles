alias ls='ls --color=auto'
alias e='emacs -nw'

which nvim > /dev/null 2>&1 && alias vim='nvim' && alias vi='nvim'

alias compile='gcc -Wall -O2'
alias repatcha='git diff versioneDiPartenza -- ./src/ > ../Ade/patch.patch && cd ../Ade  && svn revert -R src && yes "n" | patch -p1 < patch.patch ; cd ../Ade_git'
alias viclass='vim_open_class_jciuwheviweuhfiwernoqwkciwuenciwesiuveivreiuvheriufh'

alias todo='~simo/My_Projects/todo.sh'

alias make='for i in `seq 1 1000`; do echo; done; make -j4'

alias faifintadilavorare='~simo/My_Projects/faifintadilavorare/faifintadilavorare.sh'

alias pullarelazione='pushd  ~simo/Documenti/Poli/Tirocinio/Relazione && git pull && popd'
alias bottles='for i in `seq 0 98`; do j=`expr 99 - $i`; k=`expr $j - 1`;notify-send "$j bottles of beer on the wall, $j bottles of beer on the wall, take one down, pass it around, $k bottles of beer on the wall"; done'

alias badum-tish='mplayer /mnt/media/Sounds/badum-tish.mp3 > /dev/null 2>&1'
alias applause='mplayer /mnt/media/Sounds/applause.mp3 > /dev/null 2>&1'
alias dundundun='mplayer -vo null /mnt/media/Sounds/DUNDUNDUUUUN.mp4 >/dev/null 2>&1 '
alias damn='mplayer -vo null /mnt/media/Sounds/DamnImGood.mp4 >/dev/null 2>&1 '

alias gtfo='exit'

which thefuck > /dev/null 2>&1 && eval $(thefuck --alias)
# --enable-experimental-instant-mode

alias FUCK='fuck'
alias fuck-it='export THEFUCK_REQUIRE_CONFIRMATION=False; fuck; export THEFUCK_REQUIRE_CONFIRMATION=True'

alias wow='git status -- .'
alias such='git'
alias very='git'
