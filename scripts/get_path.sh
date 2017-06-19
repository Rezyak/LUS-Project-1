#!/bin/bash
cd "$(dirname "$0")"
cat ../paths.config | grep -m1 $1