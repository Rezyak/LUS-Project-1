#!/bin/bash
cd "$(dirname "$0")"
cd "$(../get_path.sh '/')"

lemma_postag="$(./scripts/get_path.sh 'lemma_postag')"
postag="$(./scripts/get_path.sh 'postag')" 
transducer_model="$(./scripts/get_path.sh 'transducerModel')"

tmp1="lemma_postag$$"
out=${transducer_model}/transducer_lemma_postag_test1

awk 'FNR==NR{a[$2]=$1 FS $2; next}{print $0, a[$2]}' $postag $lemma_postag > $tmp1
awk '{print 0, 0, $3, $2, -log($1/$4)}' $tmp1 > $out
awk -v n="$(cat $postag | wc -l)" '{print 0, 0, "<unk>", $2, -log(1/n)}' $postag >> $out
echo "0" >> $out

sed 's/,/\./g' $out > $tmp1
mv $tmp1 $out

echo $out >> paths.config
echo $(basename "$out")

