#!/bin/bash
arg1=${1}
arg2=${2}
arg3=${3}
echo "Argument 1: $arg1"
echo "Argument 2: $arg2"
echo "Argument 3: $arg3"

echo "Hello"
date
#exec /bin/bash -c 'cd wcec; which whoami;  whereis dune; pwd; echo $PATH; export PATH="/home/opam/.opam/4.13/bin:$PATH"; echo $PATH; ls; dune exec wcec /apks/rtp.apk >> test.out; echo "END"; echo date'
exec /bin/bash -c 'cd wcec; echo $PATH; export PATH="/home/opam/.opam/4.13/bin:$PATH"; echo '$arg2'; echo $PATH; dune exec wcec '$arg2''
#exec /bin/bash -c 'cd wcec; export PATH="/home/opam/.opam/4.13/bin:$PATH"; ls -la "/apks/$arg2"; dune exec wcec "/apks/$arg2"'
date