#!/bin/bash
cd "$(dirname "$0")"
string=$1
out=$2
lex="$(./get_path.sh 'lexicon.lex')"
cd "$(./get_path.sh '/')"

tmp=".$$"
echo "${string}" | farcompilestrings --symbols=$lex --unknown_symbol='<unk>' --generate_keys=1 --keep_symbols\
	| farextract --filename_suffix="$tmp"

echo "$out" >> paths.config
mv *${tmp} $out
