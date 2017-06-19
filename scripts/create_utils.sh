#!/bin/bash
cd "$(dirname "$0")"
train_feats_in=$1
train_data_in=$2
test_feats_in=$3
test_data_in=$4

train_feats="`echo "$(./get_path.sh 'Train')/train_feats" | tee -a ../paths.config`"
train_data="`echo "$(./get_path.sh 'Train')/train_data" | tee -a ../paths.config`"
test_feats="`echo "$(./get_path.sh 'Test')/test_feats" | tee -a ../paths.config`"
test_data="`echo "$(./get_path.sh 'Test')/test_data" | tee -a ../paths.config`"

cd "$(./get_path.sh '/')"

cp $train_feats_in $train_feats
cp $train_data_in $train_data
cp $test_feats_in $test_feats
cp $test_data_in $test_data

single="$(./Scripts/get_path.sh 'Single')"
composed="$(./Scripts/get_path.sh 'Composed')"
language="$(./Scripts/get_path.sh 'Language')"

word="$(echo "${single}/words" | tee -a ./paths.config)"
awk '{if (length($1)!=0) {print $1}}' $train_feats | sort | uniq -c > $word
postag="$(echo "${single}/postag" | tee -a ./paths.config)"
awk '{if (length($2)!=0) {print $2}}' $train_feats | sort | uniq -c > $postag
lemma="$(echo "${single}/lemma" | tee -a ./paths.config)"
awk '{if (length($3)!=0) {print $3}}' $train_feats | sort | uniq -c > $lemma
concept="$(echo "${single}/concept" | tee -a ./paths.config)"
awk '{if (length($2)!=0) {print $2}}' $train_data | sort | uniq -c > $concept

word_lemma="$(echo "${composed}/word_lemma" | tee -a ./paths.config)"
awk '{if (length($1)!=0) {print $1, $3}}' $train_feats | sort | uniq -c > $word_lemma
word_postag="$(echo "${composed}/word_postag" | tee -a ./paths.config)"
awk '{if (length($1)!=0) {print $1, $2}}' $train_feats | sort | uniq -c > $word_postag
lemma_postag="$(echo "${composed}/lemma_postag" | tee -a ./paths.config)"
awk '{if (length($1)!=0) {print $2, $3}}' $train_feats | sort | uniq -c > $lemma_postag
word_concept="$(echo "${composed}/word_concept" | tee -a ./paths.config)"
awk '{if (length($1)!=0) {print $1, $2}}' $train_data | sort | uniq -c > $word_concept

train_united="$(echo "${composed}/train_united" | tee -a ./paths.config)"
awk 'NR==FNR{a[NR]=$0;next}{print a[FNR], $2}' $train_feats $train_data > $train_united

united="$(./Scripts/get_path.sh 'train_united')"

postag_concept="$(echo "${composed}/postag_concept" | tee -a ./paths.config)"
awk '{if (length($1)!=0) {print $2, $4}}' $united | sort | uniq -c > $postag_concept

word_postag_concept="$(echo "${composed}/word_postag_concept" | tee -a ./paths.config)"
awk '{if (length($1)!=0) {print $1, $2, $4}}' $united | sort | uniq -c > $word_postag_concept

test_split="$(./Scripts/get_path.sh 'Split')"

test_sentences="$(echo "${test_split}/test_sentences" | tee -a ./paths.config)"
tmp1=sentence$$
awk '{print $1}' $test_data > $tmp1
cat $tmp1 | tr '\n' '+' | sed 's/\+\+/ /g' | tr ' ' '\n' | tr '+' ' ' > $test_sentences
rm $tmp1

tmp2=postag_language$$
tmp3=concept_laguage$$

postag_language="$(echo "${language}/postag_language" | tee -a ./paths.config)"
concept_language="$(echo "${language}/concept_language" | tee -a ./paths.config)"

awk '{print $2}' $train_feats > $tmp2
cat $tmp2 | tr '\n' '+' | sed 's/\+\+/ /g' | tr ' ' '\n' | tr '+' ' ' > $postag_language
rm $tmp2

awk '{print $2}' $train_data > $tmp3
cat $tmp3 | tr '\n' '+' | sed 's/\+\+/ /g' | tr ' ' '\n' | tr '+' ' ' > $concept_language
rm $tmp3

