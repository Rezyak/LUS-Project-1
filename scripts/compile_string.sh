#!/bin/bash
cd "$(dirname "$0")"
string=$1
out=$2
lex=$3
cd "$(./get_path.sh '/')"

tmp=".$$"
echo "${string}" | farcompilestrings --symbols=$lex --unknown_symbol='<unk>' --generate_keys=1 --keep_symbols\
	| farextract --filename_suffix="$tmp"


mv *${tmp} $out
# fstdraw --isymbols=$lex -osymbols=$lex ${out} | dot -Teps > ${out}.eps