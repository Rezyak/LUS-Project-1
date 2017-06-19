#!/bin/bash
cd "$(dirname "$0")"
language=$1
cd "$(./get_path.sh '/')"

lex="$(./Scripts/get_path.sh 'lexicon.lex')"
m_language="$(./Scripts/get_path.sh "$language")"
language_model="$(./Scripts/get_path.sh 'LanguageModel')"

farcompilestrings --symbols=$lex -keep_symbols=1 $m_language > ${language_model}/${language}.far
ngramcount --order=3 --require_symbols=false ${language_model}/${language}.far >  ${language_model}/${language}.cnt
ngrammake --method=witten_bell ${language_model}/${language}.cnt > ${language_model}/${language}.lm
echo "${language_model}/${language}.lm" >> paths.config
