#!/bin/bash
for dir in $(ls -d */);
do
    echo "Processing directory $dir"
    rm "$dir/results"
    touch "$dir/results"
    for file in $(ls $dir*.hashed);
    do
	echo "Doing file $file"
	ruby compare_files.rb "$dir/0.out.hashed" $file >>$dir/results
    done
    sort -n -r $dir/results >$dir/sortedresults
done