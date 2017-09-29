#!/bin/bash
#
# Batch word-pair counting script for English.
# Loop over all the files in 'gamma-pages', sentence-split them
# and submit them for mst-parsing using the C++ parse request in
# the cogserver.
#

host=localhost
port=17005
outputFile=/home/inflector/MST_test.txt # absolute path needed
subdir=./submitted-articles/text/training_data/verbs # relative path needed

function open_parse {

    echo "parse -open_parse \"$outputFile\"\n"
}

function test_parse {

    echo "parse -verbose -pair_distance 2 \"This page is about the first letter in the alphabet.\""
}

function close_parse {

    echo "parse -close_parse \n"
}

function err_exit { echo -e 1>&2; exit 1; }


# Open the parse output file. NOTE: This will be one huge file containing all
# the parses for all the sentences in this portion of wikipedia.
#
open_parse | nc $host $port || err_exit

# time find ../text/gamma-pages-a-l -type f -exec ./split-observe-one.sh en {} $host $port \;

echo $PWD
time find $subdir -type f -exec ./split-parse-one.sh en {} $host $port \;
#time find ~/NLP_files/semeval2014Task14/training_data/verbs_txt/test_split -type f -exec ./split-parse-one.sh en {} $host $port \;

# test_parse | nc $host $port || err_exit

# Close the parse output file.
close_parse | nc $host $port || err_exit


