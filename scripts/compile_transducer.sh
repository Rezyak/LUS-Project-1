#!/bin/bash
cd "$(dirname "$0")"
transducer=$1
lex="$(./get_path.sh 'lexicon.lex')"
fst_dir="$(./get_path.sh 'fsts')"
eps_dir="$(./get_path.sh 'epss')"
cd "$(./get_path.sh '/')"

filename=$(basename "$transducer" | cut -d. -f1)

fstcompile --isymbols=$lex --osymbols=$lex $transducer | fstarcsort > ${fst_dir}/${filename}.fst
fstdraw --isymbols=$lex -osymbols=$lex ${fst_dir}/${filename}.fst | dot -Teps > ${eps_dir}/${filename}.eps

echo "${fst_dir}/${filename}.fst" >> paths.config
echo "${eps_dir}/${filename}.eps" >> paths.config

echo "${filename}.fst"
