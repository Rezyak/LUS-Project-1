#!/bin/bash
cd "$(dirname "$0")"
cd "$(./get_path.sh '/')"
lex="$(./scripts/get_path.sh 'lexicon.lex')"
create_language () { 
	language=$1
	lex=$2
	language_name=$(basename $language)
	farcompilestrings --symbols=$lex -keep_symbols=1 $language > ${language_model}/${language_name}.far
	ngramcount --order=3 --require_symbols=false ${language_model}/${language_name}.far >  ${language_model}/${language_name}.cnt
	ngrammake --method=witten_bell ${language_model}/${language_name}.cnt > ${language_model}/${language_name}.lm
	echo "${language_model}/${language_name}.lm" >> paths.config
} 

concept_language="$(./scripts/get_path.sh "concept_language")"
postag_language="$(./scripts/get_path.sh "postag_language")"
language_model="$(./scripts/get_path.sh 'languageModel')"
create_language $concept_language $lex
create_language $postag_language $lex