#!/bin/bash
cd "$(dirname "$0")"
cd "$(../get_path.sh '/')"

word_lemma="$(./Scripts/get_path.sh 'word_lemma')"
lemma="$(./Scripts/get_path.sh 'lemma')" 
transducer_model="$(./Scripts/get_path.sh 'TransducerModel')"

tmp1="word_lemma$$"
out=${transducer_model}/transducer_word_lemma_test1

awk 'FNR==NR{a[$2]=$1 FS $2; next}{print $0, a[$3]}' $lemma $word_lemma > $tmp1
awk '{print 0, 0, $2, $3, -log($1/$4)}' $tmp1 > $out
echo "0 0 <unk> <unk> 0" >> $out
echo "0" >> $out

sed 's/,/\./g' $out > $tmp1
mv $tmp1 $out

echo $out >> paths.config
echo $(basename "$out")


