mipsgrr(){
   [ -z $MIPS_HOME ] && echo "MIPS_HOME not set" || grep -R "$@" "$MIPS_HOME" 2>/dev/null
}
mipsfungrr(){
   if [ $# != 1 ]
   then
      echo "Try mipsfungrr function_name"
      return 1
   fi
   mipsgrr -E "(function|task) *$1 *"'(' 
}

mipsdefgrr(){
   mipsgrr "$@" | grep define
}
sbgrr(){
   [ -z $MIPS_HOME ] && echo "MIPS_HOME not set" || grep -R "$@" "${MIPS_HOME}/sys_base"
}
cmgrr(){
   [ -z $MIPS_HOME ] && echo "MIPS_HOME not set" || grep -R "$@" "${MIPS_HOME}/cm3"
}
mipsfind(){
   filename="$1"
   shift
   [ -z $MIPS_HOME ] && echo "MIPS_HOME not set" || find "${MIPS_HOME}/" -name "$filename" $@
}
sbfind(){
   [ -z $MIPS_HOME ] && echo "MIPS_HOME not set" || find "${MIPS_HOME}/sys_base" -name "$filename" $@
}
cmfind(){
   [ -z $MIPS_HOME ] && echo "MIPS_HOME not set" || find "${MIPS_HOME}/cm3" -name "$filename" $@
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

grep_logs(){
   grep $@ `find . -name "*.log"`
}

cm3_prefix(){
   if [ $# != 0 ]
   then
      source ~/utils/cm3_prefix.sh $@
      export RUN_HOME=~/Stuff"$1"
      export SANITY_HOME="$RUN_HOME/sanity"
      export ACESIM_HOME="$RUN_HOME/acesim"
   else
      echo "Speficy a prefix please"
   fi
}

strip_date_from_log(){
   myfn='sim.log'
   if [ $# != 0 ]
   then
      myfn=$1
   fi
   sed -e 's?^\[..../../.. ..:..:..\] *??' $myfn
}

powawhereis(){
   find `echo $PATH | tr ':' ' '` -name $1
}

findpath(){
   find `echo $PATH | tr ':' ' '` $@
}

TCLsim(){
   myTCL=$1
   shift
   myTCLPath=`dirname $myTCL`
   myTestName=`basename $myTCL`
   echo simulate.py $@ -o +cpuTCL="$myTestName" -o +simple_tcl_test=1 -o +tclPath="$myTCLPath"
   simulate.py $@ -o +cpuTCL="$myTestName" -o +simple_tcl_test=1 -o +tclPath="$myTCLPath"
}

copy_sanity_test(){
   [ $# != 1 ] && echo "Specify a name for the test please" && return 1
   myTestName=$1
   myNewTest="/home/cm_scratch/simone/acesim_$myTestName"
   mkdir -p "${myNewTest}/results/mysim"
   cp -r ./* "${myNewTest}/results/mysim"
   cp ../../rebuild "$myNewTest"
   cp sim.log "${myNewTest}/sim_freeze.log"
}

save_fixed_test(){
   [ $# != 0 ] || ( echo "Specify a name for the test please" && return 1 )
   myTestName=$1
   myNewTest="/home/cm_scratch/simone/acesim_$myTestName"
   myDestDir="$HOME/fixedSims/$myTestName/"
   [ -d "$myNewTest" ] || ( echo "Specified test ($myNewTest) does not exist sorry" && return 1 )
   mkdir -p "$myDestDir"

   if [ -f $myNewTest/buildme.sh ]
   then
      cp "$myNewTest/buildme.sh"  "$myDestDir/rebuild"
      cp "$myNewTest/sim_freeze.log"  "$myDestDir/sim_freeze.log"
      cp "$myNewTest/simulateme.sh"  "$myDestDir/rerun"
   fi

   if [ -f $myNewTest/rebuild ]
   then
      mkdir -p "$myDestDir/results/sim"
      hopefullyOnlyDir=`ls "$myNewTest/results"`
      cp "$myNewTest/rebuild"  "$myDestDir"
      [ -f "$myNewTest/sim_freeze.log" ] && cp "$myNewTest/sim_freeze.log"  "$myDestDir"
      cp $myNewTest/results/$hopefullyOnlyDir/save.* "$myDestDir/results/sim/" 2>/dev/null
      cp "$myNewTest/results/$hopefullyOnlyDir/rerun"  "$myDestDir/results/sim/"
   fi
}

generate_sorted_fail_list(){
   cat regress_summary.txt | grep 'FAIL ' | sed 's/^FAIL //g' > failfile
   cat failfile | sed -e '/^$/d' | cut -d' ' -f1 > failfilelist
   for file in `cat failfilelist`
   do
      echo -n $file
      echo -n ' & ' 
      grep 'DUT Error' $file | head -n 1
   done | sort -t'&' -k 2 > failfilesorted
   rm failfile
   rm failfilelist
}

grep_slashstar_comments(){
   mipsfind "*.sv" -exec grep -H -e '/\*' '{}' ';'
   mipsfind "*.svh" -exec grep -H -e '/\*' '{}' ';'
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

find_regressions(){
   echo 'Check this paths:'
   find . -maxdepth 4 -type d -name vbuild -or -name sim_results -or -name DVEfiles -or -name 'regress_*' -or -name '*.vdb' -or -name '*.urg.report' -exec dirname '{}' ';' | sort | uniq
}

p4_ws_changes () {
   p4 changes -c "./..." --me
}

hello() {
   cowsay 'Hello!'
}
