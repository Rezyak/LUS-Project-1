#!/bin/bash
cd "$(dirname "$0")"
cd "$(../get_path.sh '/')"

postag_concept="$(./Scripts/get_path.sh 'postag_concept')"
concept="$(./Scripts/get_path.sh 'concept')" 
transducer_model="$(./Scripts/get_path.sh 'TransducerModel')"

tmp1="postag_concept$$"
out=${transducer_model}/transducer_postag_concept_test2

awk 'FNR==NR{a[$2]=$1 FS $2; next}{print $0, a[$3]}' $concept $postag_concept > $tmp1
awk '{print 0, 0, $2, $3, -log($1/$4)}' $tmp1 > $out

awk -v n="$(cat $concept | wc -l)" '{print 0, 0, "<unk>", $2, -log(1/n)}' $concept >> $out
echo "0" >> $out

sed 's/,/\./g' $out > $tmp1
mv $tmp1 $out

echo $out >> paths.config
echo $(basename "$out")