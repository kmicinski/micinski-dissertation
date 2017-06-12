#!/usr/bin/bash

rm -rf tabulated_medians.csv
touch tabulated_medians.csv
echo "skew,distance,location" >>tabulated_medians.csv

i=1

# Generate the median data for each city, and then collate
for city in $(cat cities.conf);
do
    ruby find_median.rb "${city}.data" >"${city}.medians"
    ruby format_into_csv.rb "${city}.medians" locs.conf $i >>tabulated_medians.csv
    i=$(( $i + 1 ))
done

# Now take all of this data and plot it with R
./plot_medians.R
