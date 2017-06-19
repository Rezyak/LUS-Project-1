#!/bin/bash
cd "$(dirname "$0")"
paths="paths.config"

{
    read; # get rid of the first line
    while read path
    do
        rm -rf $path
    done
} < $paths

rm $paths