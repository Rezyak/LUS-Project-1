#!/bin/bash
cd "$(dirname "$0")"
cd "$(../get_path.sh '/')"

word_postag="$(./Scripts/get_path.sh 'word_postag')"
# word_postag_concept="$(./Scripts/get_path.sh 'word_postag_concept')"
postag="$(./Scripts/get_path.sh 'postag')" 
# postag_concept="$(./Scripts/get_path.sh 'postag_concept')" 

transducer_model="$(./Scripts/get_path.sh 'TransducerModel')"

tmp1="word_postag$$"
# tmp2="word_postag_concept$$"
out=${transducer_model}/transducer_word_postag_test2

awk 'FNR==NR{a[$2]=$1 FS $2; next}{print $0, a[$3]}' $postag $word_postag > $tmp1
awk '{print 0, 0, $2, $3, -log($1/$4)}' $tmp1 > $out
# awk 'FNR==NR{a[$2" "$3]=$1 FS $2 FS $3; next}{print $0, a[$3" "$4]}' $postag_concept $word_postag_concept > $tmp2

# awk 'FNR==NR{a[$2]=-log($1/$4); next}{print 0, 0, $2, $3, -log($1/$5)*a[$2]}' $tmp1 $tmp2 > $out
# rm $tmp2

awk -v n="$(cat $postag | wc -l)" '{print 0, 0, "<unk>", $2, -log(1/n)}' $postag >> $out
echo "0" >> $out

sed 's/,/\./g' $out > $tmp1
mv $tmp1 $out

echo $out >> paths.config
echo $(basename "$out")

