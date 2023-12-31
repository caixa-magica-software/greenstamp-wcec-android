#!/bin/sh

mkdir sootOutput
mkdir resources/files_to_analyse/
#clear

start_time=$(date +%s)
echo "Starting - Current time: $(date -d @$start_time +%T)"

java -cp soot-infoflow-cmd-jar-with-dependencies.jar CFG.java $1 > resources/cg.txt
if [ -s resources/cg.txt ]; then
    echo "Have resources - Current time: $(date +%T)"
    #clear
    echo "$(ls -A sootOutput/)"
    while [ -z  "$(ls -A sootOutput/)" ]
    do
        echo "Process... - Current time: $(date +%T)"
        java -cp soot-infoflow-cmd-jar-with-dependencies.jar soot.tools.CFGViewer -w -allow-phantom-refs -android-jars "/usr/lib/android-sdk/platforms" -process-multiple-dex -output-format jimple -src-prec apk -process-dir $1
        #clear
    done

    #Call graph refinements
    echo "Call graph refinements - Current time: $(date +%T)"

    #echo '|-->                  |'

    sed -i '/Exception/d' resources/cg.txt
    # cg refine
    sed -i 's/.*\sin\s//g' resources/cg.txt
    sed -i 's/ ==> /=/g' resources/cg.txt
    sed -i 's/\$\$/../g' resources/cg.txt
    sed -i 's/://g' resources/cg.txt
    sed -i 's/\$1/.1/g' resources/cg.txt
    #Replace <> in text
    sed -i 's/<init>/init/g' resources/cg.txt
    sed -i 's/<clinit>/clinit/g' resources/cg.txt
    sed -i 's/<//g' resources/cg.txt
    sed -i 's/>//g' resources/cg.txt
    sed -i 's/\sclinit/ <clinit>/g' resources/cg.txt
    sed -i 's/\sinit/ <init>/g' resources/cg.txt

    #################

    # get *.dot files (or any pattern you like) into one place
    echo "Get *.dot files (or any pattern you like) into one place - Current time: $(date +%T)"
    find sootOutput/ -name "androidx.*" -print0 | xargs -0 rm
    find sootOutput/ -name "org.*" -print0 | xargs -0 rm
    find sootOutput/ -name "android.*" -print0 | xargs -0 rm
    find sootOutput/ -name "com.google.*" -print0 | xargs -0 rm
    find sootOutput/ -name "*.R.*" -print0 | xargs -0 rm
    find sootOutput/ -name "*.BuildConfig*" -print0 | xargs -0 rm
    find sootOutput/ -name "*.jimple" -print0 | xargs -0 rm
    find sootOutput/ -name "kotlin.*" -print0 | xargs -0 rm
    find sootOutput/ -name "kotlinx.*" -print0 | xargs -0 rm
    find sootOutput/ -name "*.sun.*" -print0 | xargs -0 rm
    #clear
    
    #delete lines
    echo "delete lines - Current time: $(date +%T)"
    find sootOutput/ -type f  -exec  sed -i '/->/d' {} \;
    find sootOutput/ -type f  -exec  sed -i '/specialinvoke/d' {} \;
    find sootOutput/ -type f  -exec  sed -i '/style/d' {} \;
    find sootOutput/ -type f  -exec  sed -i '/node/d' {} \;
    find sootOutput/ -type f  -exec  sed -i '/\@/d' {} \;
    
    #clear   
    echo "clear - Current time: $(date +%T)"
    find sootOutput/ -type f  -exec  sed -i '/[^\[]label=/d' {} \;
    find sootOutput/ -type f  -exec  sed -i '/\"if/d' {} \;
    find sootOutput/ -type f  -exec  sed -i -e '/{/d' {} \;
    find sootOutput/ -type f  -exec  sed -i -e '/}/d' {} \;

    #replace strings
    echo "Replace strings - Current time: $(date +%T)"
    find sootOutput/ -type f  -exec  sed -i 's/,//g' {} \;
    find sootOutput/ -type f  -exec  sed -i 's/]//g' {} \;
    find sootOutput/ -type f  -exec  sed -i 's/\[//g' {} \;
    find sootOutput/ -type f  -exec  sed -i 's/label=//g' {} \;
    find sootOutput/ -type f  -exec  sed -i 's/;//g' {} \;
    find sootOutput/ -type f  -exec  sed -i -E 's/"[0-9]+"//g' {} \;
    find sootOutput/ -type f  -exec  sed -i -E 's/"//g' {} \;

    #move sootOutput files to files_to_analyse folder
    echo "Move sootOutput files to files_to_analyse folder - Current time: $(date +%T)"
    find sootOutput/ -type f -name "*.dot" -exec cp {} resources/files_to_analyse/ \;

    #delete more lines
    echo "Delete more lines - Current time: $(date +%T)"
    find resources/files_to_analyse/ -type f  -exec  sed -i '/(/d' {} \;
    find resources/files_to_analyse/ -type f  -exec  sed -i '/&/d' {} \;
    find resources/files_to_analyse/ -type f  -exec  sed -i '/)/d' {} \;
    find resources/files_to_analyse/ -type f  -exec  sed -i '/\./d' {} \;
    find resources/files_to_analyse/ -type f  -exec  sed -i '/cmp/d' {} \;
    find resources/files_to_analyse/ -type f  -exec  sed -i '/\|/d' {} \;
    find resources/files_to_analyse/ -type f  -exec  sed -i '/\^/d' {} \;
    find resources/files_to_analyse/ -type f  -exec  sed -i '/\\\"/d' {} \;
    find resources/files_to_analyse/ -type f  -exec  sed -i '/new/d' {} \;
    find resources/files_to_analyse/ -type f  -exec  sed -i -E '/r[0-9]+/d' {} \;
    #clear
    
    #delete empty files
    echo "delete empty files from resources - Current time: $(date +%T)"
    find resources/files_to_analyse/ -size 0 -print -delete

    echo 'delete empty files from sootOutput - Current time: $(date +%T)'
    find sootOutput/ -size 0 -print -delete
    #clear

    end_time=$(date +%s)
    echo "Finished - Current time: $(date -d @$end_time +%T)"
 
    diff_seconds=$((end_time - start_time))
    echo "Test execution time in seconds: $diff_seconds"

else 
    echo "Soot error. Try again - Current time: $(date +%T)"
fi
