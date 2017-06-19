#!/bin/bash
cd "$(dirname "$0")"

lex="$(./scripts/get_path.sh 'lexicon.lex')"
train_feats="$(./scripts/get_path.sh 'train_feats')"
train_data="$(./scripts/get_path.sh 'train_data')"
test_data="$(./scripts/get_path.sh 'test_data')"
language_model="$(./scripts/get_path.sh 'concept_language.lm')"


sentences="$(./scripts/get_path.sh 'test_sentences')"

test3="$(./scripts/get_path.sh 'results')"/test3
mkdir $test3

result=$(scripts/Test3/create_transducer_word_concept.sh)
transducer_word_concept="$(scripts/get_path.sh "$result")"
echo $transducer_word_concept

result=$(./scripts/compile_transducer.sh $transducer_word_concept)
echo $result
transducer_word_concept_fst="$(./scripts/get_path.sh "$result")"
echo $transducer_word_concept_fst

echo -n "" > ${test3}/result.print

outline=${test3}/"line"$$
while read line
do
	echo "sentence: $line"

	./scripts/compile_string.sh "$line" ${outline}.fst
	echo "compose string to transducer"
	result=$(./scripts/compose_transducer.sh ${outline}.fst ${transducer_word_concept_fst} ${test3})
	echo "compose with language model"
	result2=$(./scripts/compose_transducer.sh ${result}.fst ${language_model} ${test3})

	cat ${result2}.fst | fstshortestpath > ${test3}/shortestpath.fst
	fstprint -isymbols=$lex -osymbols=$lex ${test3}/shortestpath.fst | sort -r -k1 -n >> ${test3}/result.print

done <  $sentences

rm ${outline}*
rm ${test3}/shortestpath.fst
cp $test_data ${test3}/test_data
tmp=${test3}/"eval"$$
awk '{tag=substr($4,0,1); if (tag == "O") {print $3, tag} else {print $3, $4}}' ${test3}/result.print > $tmp
mv $tmp ${test3}/result.print

awk 'FNR==NR { a[FNR""] = $1 " " $2; next } { print a[FNR""] " " $2 }' ${test3}/test_data ${test3}/result.print > $tmp 
mv $tmp ${test3}/to_eval

