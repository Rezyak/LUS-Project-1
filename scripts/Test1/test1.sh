#!/bin/bash
cd "$(dirname "$0")"

result=$(./create_transducer_word_lemma.sh)
# echo "creating word lemma $result"
transducer_word_lemma="$(../get_path.sh "$result")"
echo $transducer_word_lemma

result=$(./create_transducer_lemma_postag.sh)
# echo "creating lemma postag $result"
transducer_lemma_postag="$(../get_path.sh "$result")"
echo $transducer_lemma_postag

result=$(./create_transducer_postag_concept.sh)
# echo "creating postag concept $result"
transducer_postag_concept="$(../get_path.sh "$result")"
echo $transducer_postag_concept

cd "$(../get_path.sh '/')"

result=$(./Scripts/compile_transducer.sh $transducer_word_lemma)
# echo "compiling word lemma $result"
transducer_word_lemmaFST="$(./Scripts/get_path.sh "$result")"
echo "$transducer_word_lemmaFST"

result=$(./Scripts/compile_transducer.sh $transducer_lemma_postag)
# echo "compiling lemma postag $result"
transducer_lemma_postagFST="$(./Scripts/get_path.sh "$result")"
echo $transducer_lemma_postagFST

result=$(./Scripts/compile_transducer.sh $transducer_postag_concept)
# echo "compiling postag concept $result"
transducer_postag_conceptFST="$(./Scripts/get_path.sh "$result")"
echo $transducer_postag_conceptFST

lex="$(./Scripts/get_path.sh 'lexicon.lex')"
train_feats="$(./Scripts/get_path.sh 'train_feats')"
train_data="$(./Scripts/get_path.sh 'train_data')"
test_data="$(./Scripts/get_path.sh 'test_data')"

test1="$(basename "$0" | cut -d. -f1)"
test1="$(./Scripts/get_path.sh 'Results')""/"$(echo ${test1:0:1} | tr '[a-z]' '[A-Z]')"${test1:1}"

mkdir $test1
echo $test1 >> paths.config

sentences="$(./Scripts/get_path.sh 'test_sentences')"
echo $sentences

echo -n "" > ${test1}/result.print
while read line
do
	echo "sentence: $line"
	outline="${test1}/"$(echo "$line" | tr ' ' '_')
	# echo "${outline}"

	./Scripts/compile_string.sh "$line" ${outline}.fst

	result=$(./Scripts/compose_transducer.sh ${outline}.fst ${transducer_word_lemmaFST})

	result=$(./Scripts/compose_transducer.sh ${result}.fst ${transducer_lemma_postagFST})

	result=$(./Scripts/compose_transducer.sh ${result}.fst ${transducer_postag_conceptFST})

	cat ${result}.fst | fstshortestpath > ${test1}/shortestpath.fst
	fstprint -isymbols=$lex -osymbols=$lex ${test1}/shortestpath.fst | sort -r -k1 -n >> ${test1}/result.print

done <  $sentences

cp $test_data ${test1}/test_data
awk 'FNR==NR { a[FNR""] = $1 " " $2; next } { print a[FNR""] " " $4 }' ${test1}/test_data ${test1}/result.print > test1_evaluate 

