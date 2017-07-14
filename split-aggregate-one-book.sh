#!/bin/bash
#
# split-aggregate-one-book.sh <lang> <filename> <cogserver-host> <cogserver-port>
#
# Support script for batch parsing of wikipedia articles.
# Sentence-split one file, submit it, via perl script, to the parser.
# When done, move the file over to a 'finished' directory.
#
# Example usage:
#    ./split-aggregate-one.sh en "vonn.txt" localhost 17001
#

cd $(dirname $0)

# Set up assorted constants needed to run.
lang=$1
fullpath=$2
filename="${fullpath##*/}"
# coghost="localhost"
# cogport=17002
coghost="$3"
cogport=$4

splitter=./split-sentences.pl
aggregator=./aggregate-one.pl

splitdir=split-books
donedir=aggregated-books

echo "Splitting and parsing $fullpath as '$filename'"

# Sentence split the book 
cat "$fullpath" | $splitter -l $lang >  "$splitdir/$filename"

# Aggregate the split article
cat "$splitdir/$filename" | $aggregator

# Move article to the done-queue
mv "$splitdir/$filename" "$donedir/$filename"
rm "$fullpath"
