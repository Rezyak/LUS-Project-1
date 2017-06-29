# Word to Concept
> An OpenGRM and OpenFST solution for word tagging, Eduard Caizer.  

## The system
The system is developed entirely in bash, this is the structure:

```
├── README.md
├── clear.sh
├── init.sh
├── lus.config
├── make.sh
├── originalData
└── scripts
    └── test_word_concept
```
### Installing
The installation is easy, just clone the project and run the following commands:

```
$ git clone https://github.com/Rezyak/LUS-Project-2.git
$ ./init.sh

```
this script creates the project structure from the *lus.config* file
```
utils	
-	single
-	composed
-	language
transducers
-	transducerModel
-	fsts
-	epss
-	languageModel
data
-	test
-	-	split
-	train
results

```
as a result of *init.sh* you will have
```
├── data
│   ├── test
│   │   └── split
│   └── train
├── originalData
├── results
├── scripts
│   └── test_word_concept
├── transducers
│   ├── epss
│   ├── fsts
│   ├── languageModel
│   └── transducerModel
└── utils
    ├── composed
    ├── language
    └── single

```

init calls also the *create_utils.sh* script, this script creates all file used to make the tranduces and calculate the weights
```
└── utils
    ├── composed
    │   ├── lemmaAndWord_concept
    │   ├── lemma_postag
    │   ├── lemma_words
    │   ├── postag_concept
    │   ├── train_united
    │   ├── word_concept
    │   ├── word_lemma
    │   ├── word_postag
    │   └── word_postag_concept
    ├── language
    │   ├── concept_language
    │   └── postag_language
    └── single
        ├── concept
        ├── lemma
        ├── postag
        └── words
```
## Running
To run the script that make the transducer word to concept with language model run:
```
$ ./make.sh

```

it will create a *transducer_word_concept* and for each sentence in the *data/test/split/test_sentences* file, it will compose compiled string with the transducer and the language model

## Evaluation
at the end of the script run
```
$ ./scripts/conlleval.pl < results/test_word_concept/to_eval

```
*
## Built With

* [OpenGRM](http://www.opengrm.org/. Visited 21/04/2017)
* [OpenFST](http://www.openfst.org/twiki/bin/view/FST/WebHome)
## Authors

* **Eduard Caizer** - *See also* - [Lus Proj 2](https://github.com/Rezyak/LUS-Project-2)
