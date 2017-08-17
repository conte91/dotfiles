#Typed some random chars to be sure name is unique
vim_open_class_jciuwheviweuhfiwernoqwkciwuenciwesiuveivreiuvheriufh(){
  vim -o $1.cpp $1.h
}

whosthere_jfnwoefwoefi(){
  nmap -sP `ifconfig | grep -e "inet[^6]" | grep -v 127.0.0.1 | sed -e 's/^ *[^ ]* *\([0-9]*\.[0-9]*\.[0-9]*\)\.[0-9]* *.*$/\1\.\*/'`
}
git_patch_jwnfwivnwivnweivnewrivnw(){
  git stash show -p stash@{$1} | git apply
}

lampeggia(){
  while :
    do
      banner "$1"
      sleep 0.3
      clear
      sleep 0.3
    done
}

£(){
  echo "$@" | bc -l
}

cerca(){
  surf "https://www.google.com?q=$@" > /dev/null 2>/dev/null &
}

flashamsp(){
  mspdebug rf2500 "prog $1"
}

source_every_alias_and_function_again(){
   stuff=(~/.bash_aliases ~/.bash_functions)
   for file in "${stuff[@]}"
   do
      [ -f "$file" ] && source "$file" || echo "Sorry, file $file not found (check your config)"
   done
}

find_functions_with_no_type_in_sv(){
   DIR_TO_SCAN=""
   if [ $# != 0 ]
   then
      DIR_TO_SCAN=$1
   else
      DIR_TO_SCAN="."
   fi
   egrep -R "function +\w+\(" "$DIR_TO_SCAN" 2>/dev/null | grep -v "function new" 2>/dev/null | grep ace | grep -v jQuery | cut -f1 -d":" | sort | uniq
}

trailing_whitespace(){
   DIR_TO_SCAN=""
   if [ $# != 0 ]
   then
      DIR_TO_SCAN=$1
   else
      DIR_TO_SCAN="."
   fi
   egrep -R '\s+$' "$DIR_TO_SCAN"
}

trailing_semicolons_in_sv(){
   DIR_TO_SCAN=""
   if [ $# != 0 ]
   then
      DIR_TO_SCAN=$1
   else
      DIR_TO_SCAN="."
   fi
   grep -Re 'end(function|class|task).*;' "$DIR_TO_SCAN"
}

powawhereis(){
   find `echo $PATH | tr ':' ' '` -name $1
}

findpath(){
   find `echo $PATH | tr ':' ' '` $@
}

sclera() {
  for j in `seq 1 10`; do for i in `seq 1 10`; do echo -n $@; done | espeak -v it -s ${j}00; done
}

i_want_to_delete(){
   if ! [ -e $1 ] 
   then
      echo "You already deleted $1 it seems.."
      return 1
   fi

   echo "Kill these processes to remove your file:"
   lsof -- `find $1`

}

lua_path(){
   lua -e "print (package.path..'\n'..package.cpath)"
}

p4_ws_changes () {
   p4 changes -c "./..." --me
}

hello() {
   cowsay 'Hello!'
}

# vim: set filetype=sh :
