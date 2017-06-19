#!/bin/bash
cd "$(dirname "$0")"
cd "$(../get_path.sh '/')"

word_concept="$(./Scripts/get_path.sh 'word_concept')"
postag_concept="$(./Scripts/get_path.sh 'postag_concept')"
word_postag="$(./Scripts/get_path.sh 'word_postag')"

concept="$(./Scripts/get_path.sh 'concept')" 
postag="$(./Scripts/get_path.sh 'postag')" 
transducer_model="$(./Scripts/get_path.sh 'TransducerModel')"

tmp1="word_concept$$"
tmp2="postag_concept$$"
tmp3="word_postag$$"
out=${transducer_model}/transducer_word_concept_test3

awk 'FNR==NR{a[$2]=$1 FS $2; next}{print $0, a[$3]}' $concept $word_concept > $tmp1
awk 'FNR==NR{a[$2]=$1 FS $2; next}{print $0, a[$3]}' $concept $postag_concept > $tmp2
awk 'FNR==NR{a[$2]=$1 FS $2; next}{print $0, a[$3]}' $postag $word_postag > $tmp3

awk 'FNR==NR{a[$2]=-log($1/$4); next}{print 0, 0, $2, $3, -log($1/$5)*a[$2]}' $tmp1 $tmp2 > $out
# awk '{print 0, 0, $2, $3, -log($1/$4)}' $tmp1 > $out

awk -v n="$(cat $concept | wc -l)" '{print 0, 0, "<unk>", $2, -log(1/n)}' $concept >> $out
echo "0" >> $out

sed 's/,/\./g' $out > $tmp1
mv $tmp1 $out

echo $out >> paths.config
echo $(basename "$out")

