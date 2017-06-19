#!/bin/bash
cd "$(dirname "$0")"
train_feats="$(./get_path.sh 'train_feats')"
train_data="$(./get_path.sh 'train_data')"
cd "$(./get_path.sh '/')"

tmp=lexicon$$
tmp2=lexicon2$$

awk '{if (length($1)!=0) {print $1, $3}}' $train_feats | tr ' ' '\n' | sort | uniq > $tmp
awk '{if (length($2)!=0) {print $2}}' $train_feats | sort | uniq >> $tmp
awk '{if (length($2)!=0) {print $2}}' $train_data | sort | uniq >> $tmp

echo "<eps>" > $tmp2; cat $tmp >> $tmp2; echo "<unk>" >> $tmp2; rm $tmp

awk '{print $0, FNR}' $tmp2 > lexicon.lex
echo "./lexicon.lex" >> paths.config

rm $tmp2