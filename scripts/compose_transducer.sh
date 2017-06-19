#!/bin/bash
cd "$(dirname "$0")"
transducer1=$1
transducer2=$2
lex="$(./get_path.sh 'lexicon.lex')"
fst_dir="$(./get_path.sh 'FSTs')"
eps_dir="$(./get_path.sh 'EPSs')"
cd "$(./get_path.sh '/')"

filename1=$(basename "$transducer1" | cut -d. -f1)
filename2=$(basename "$transducer2" | cut -d. -f1)
filename=${filename1}_${filename2}

fstcompose $transducer1 $transducer2 | fstrmepsilon | fstarcsort > ${fst_dir}/${filename}.fst
fstdraw --isymbols=$lex -osymbols=$lex ${fst_dir}/${filename}.fst | dot -Teps > ${eps_dir}/${filename}.eps

echo "${fst_dir}/${filename}.fst" >> paths.config
echo "${eps_dir}/${filename}.eps" >> paths.config

echo ${fst_dir}/$filename