#!/bin/bash
#
# Batch word-pair counting script for English.
# Loop over all the files in 'gamma-pages', sentence-split them
# and submit them for mst-parsing using the C++ parse request in
# the cogserver.
#
cd $(dirname $0)

# Create directories if missing
mkdir -p split-books
mkdir -p parsed-books
mkdir -p source-books

# Copy all the books
find ../text/en-tranche-1/ -type f -exec cp {} source-books/ \;

#rm source-books/*.txt
#cp ../text/en-tranche-1/vonn.txt source-books/vonn.txt

host=localhost
port=17005

function open_parse {

    echo "parse -open_parse \"/home/inflector/language/guten_parse_out.txt\"\n"
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

time find source-books/ -type f -exec ./split-parse-one-book.sh en {} $host $port \;

# test_parse | nc $host $port || err_exit

# Close the parse output file.
close_parse | nc $host $port || err_exit

# Sleep to give time for the OS to remove the files
sleep 1

# Report the number of files remaining in source, in case there were errors.
echo "Done parsing, files NOT parsed: "
find source-books/ -type f | wc -l
