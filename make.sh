#!/bin/bash
cd "$(dirname "$0")"

lex="$(./scripts/get_path.sh 'lexicon.lex')"
train_feats="$(./scripts/get_path.sh 'train_feats')"
train_data="$(./scripts/get_path.sh 'train_data')"
test_data="$(./scripts/get_path.sh 'test_data')"

language_model="$(./scripts/get_path.sh 'concept_language.lm')"


sentences="$(./scripts/get_path.sh 'test_sentences')"

test_word_concept="$(./scripts/get_path.sh 'results')"/test_word_concept
mkdir $mtest

result=$(scripts/test_word_concept/create_transducer_word_concept.sh)
transducer_word_concept="$(scripts/get_path.sh "$result")"
echo $transducer_word_concept

result=$(./scripts/compile_transducer.sh $transducer_word_concept $lex)
echo $result
transducer_word_concept_fst="$(./scripts/get_path.sh "$result")"
echo $transducer_word_concept_fst

echo -n "" > ${test_word_concept}/result.print

outline=${test_word_concept}/"line"$$
while read line
do
	echo "sentence: $line"

	./scripts/compile_string.sh "$line" ${outline}.fst $lex
	echo "compose string to transducer"
	result=$(./scripts/compose_transducer.sh ${outline}.fst ${transducer_word_concept_fst} ${test_word_concept} $lex)
	echo "compose with language model"
	result2=$(./scripts/compose_transducer.sh ${result}.fst ${language_model} ${test_word_concept} $lex)

	cat ${result2}.fst | fstshortestpath > ${test_word_concept}/shortestpath.fst
	fstprint -isymbols=$lex -osymbols=$lex ${test_word_concept}/shortestpath.fst | sort -r -k1 -n >> ${test_word_concept}/result.print

done <  $sentences

rm ${outline}*
rm ${test_word_concept}/shortestpath.fst
cp $test_data ${test_word_concept}/test_data
tmp=${test_word_concept}/"eval"$$
awk '{tag=substr($4,0,1); if (tag == "O") {print $3, tag} else {print $3, $4}}' ${test_word_concept}/result.print > $tmp
mv $tmp ${test_word_concept}/result.print

awk 'FNR==NR { a[FNR""] = $1 " " $2; next } { print a[FNR""] " " $2 }' ${test_word_concept}/test_data ${test_word_concept}/result.print > $tmp 
mv $tmp ${test_word_concept}/to_eval

