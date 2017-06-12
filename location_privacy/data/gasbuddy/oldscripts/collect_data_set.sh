#!/bin/bash
#find -name *.out -exec 
dos2unix $1 &>/dev/null;
cat $1 | grep -B 3 " mi$" >$1.processed;
ruby generate_hashes.rb $1.processed  >"$1.hashed";
