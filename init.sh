#!/bin/bash
cd "$(dirname "$0")"
config="lus.config"

#creating folder structure for the project
echo "$(pwd)" > paths.config
awk '
{
	look_up=0
	for(column=1; column<=NF; column++){
		if($column=="-"){
			look_up+=1
		}
		else if(length($column)!=0){
			dir="."
			for(i=1; i<=look_up; i++){
				dir=dir"/"a[i]
			}
			system("mkdir \"" dir"/"$column "\"")
			print dir"/"$column
			a[look_up+1]=$column
		}
	}
}' $config >> paths.config
