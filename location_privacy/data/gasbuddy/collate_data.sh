#!/bin/bash

for location in collegepark new_york newhaven redmond 
do
    echo $location;
    rm $location.data;
    loc=$location;
    for num in 1 2 3 4 5 6 7 8;
    do
	echo "${loc}_${num}";
	directory="${loc}_${num}";
	printf "%d 0 " $num >>"${loc}.data";
	awk '{printf "%d ", $2}' "$directory/sortedresults" >>"${loc}.data";
	echo "" >>"${loc}.data";
    done

done