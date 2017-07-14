#!/bin/bash
#
# split-parse-one.sh <lang> <filename> <cogserver-host> <cogserver-port>
#
# Support script for batch parsing of wikipedia articles.
# Sentence-split one file, submit it, via perl script, to the parser.
# When done, move the file over to a 'finished' directory.
#
# Example usage:
#    ./split-parse-one.sh en "A/aardvark" localhost 17001
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
parser=./parse-one.pl

splitdir=split-books
donedir=parsed-books

echo "Splitting and parsing $fullpath as '$filename'"

# Punt if the cogserver has crashed. The grep is looking for the
# uniquely-named config file.
# Alternate cogserver test: use netcat to ping it.
haveping=`echo foo | nc $coghost $cogport`
if [[ $? -ne 0 ]] ; then

    # sleep for a few seconds to give the cogserver time to process
    # since there are limited sockets taking inputs and if these
    # back up we don't want to quit.
    echo "cogserver busy... waiting 15 seconds"
    sleep 15
    haveping=`echo foo | nc $coghost $cogport`
    result=$?
    if [[ $result -ne 0 ]] ; then
        echo "cogserver died $result"
        exit 1
    fi
fi

# Sentence split the book 
cat "$fullpath" | $splitter -l $lang >  "$splitdir/$filename"

# Submit the split article
cat "$splitdir/$filename" | $parser $coghost $cogport

# Punt if the cogserver has crashed
haveping=`echo foo | nc $coghost $cogport`
if [[ $? -ne 0 ]] ; then

    # sleep for a few seconds to give the cogserver time to process
    # since there are limited sockets taking inputs and if these
    # back up we don't want to quit.
    echo "cogserver busy... waiting 15 seconds"
    sleep 15
    haveping=`echo foo | nc $coghost $cogport`
    result=$?
    if [[ $result -ne 0 ]] ; then
        echo "cogserver died $result"
        exit 1
    fi
fi

# Move article to the done-queue
mv "$splitdir/$filename" "$donedir/$filename"
rm "$fullpath"
