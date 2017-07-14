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
mkdir -p aggregated-books
mkdir -p source-books

# Copy all the books
find ../text/en-tranche-1/ -type f -exec cp {} source-books/ \;

#rm source-books/*.txt
#cp ../text/en-tranche-1/vonn.txt source-books/vonn.txt

# Delete the output file so the appends can start with an empty file.
rm corpus_sentences.txt

time find source-books/ -type f -exec ./split-aggregate-one-book.sh en {} $host $port \;

# Sleep to give time for the OS to remove the files
sleep 1

# Report the number of files remaining in source, in case there were errors.
echo "Done aggregating, files NOT aggregated: "
find source-books/ -type f | wc -l
