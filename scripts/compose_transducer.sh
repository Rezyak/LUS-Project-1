#!/bin/bash
cd "$(dirname "$0")"
transducer1=$1
transducer2=$2
outdir=$3

lex="$(./get_path.sh 'lexicon.lex')"
cd "$(./get_path.sh '/')"

filename1=$(basename "$transducer1" | cut -d. -f1)
filename2=$(basename "$transducer2" | cut -d. -f1)
filename=${filename1}_${filename2}

fstcompose $transducer1 $transducer2 | fstrmepsilon | fstarcsort > ${outdir}/${filename}.fst
# fstdraw --isymbols=$lex -osymbols=$lex ${outdir}/${filename}.fst | dot -Teps > ${outdir}/${filename}.eps

echo ${outdir}/$filename