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

# Set up assorted constants needed to run.
lang=$1
filename="$2"
# coghost="localhost"
# cogport=17002
coghost="$3"
cogport=$4

#splitter=./split-sentences.pl

#splitdir=split-articles
subdir=submitted-articles
parsedir=parsed-articles

# Punt if the cogserver has crashed. The grep is looking for the
# uniquely-named config file.
# Alternate cogserver test: use netcat to ping it.
haveping=`echo foo | nc $coghost $cogport`
if [[ $? -ne 0 ]] ; then
	exit 1
fi


# Split the filename into two parts
base=`echo $filename | cut -d \/ -f 1`
rest=`echo $filename | cut -d \/ -f 3-20`

echo "PWD $PWD"
echo "Processing file >>>$rest<<<"

# Create directories if missing
mkdir -pv $(dirname "$parsedir/$rest")

# Sentence split the article itself
#cat "$filename" | $splitter -l $lang >  "$splitdir/$rest"
#echo "Submitting"
#echo "$splitdir/$rest"

# Submit the split article
cat "$subdir/$rest" | ./parse-one.pl $coghost $cogport

# Punt if the cogserver has crashed (second test,
# before doing the mv and rm below)
# haveserver=`ps aux |grep cogserver |grep opencog-$lang`
# if [[ -z "$haveserver" ]] ; then
# 	exit 1
# fi
haveping=`echo foo | nc $coghost $cogport`
if [[ $? -ne 0 ]] ; then
	exit 1
fi

# Move article to the done-queue
mv "$subdir/$rest" "$parsedir/$rest"
#rm "$bas/$rest"
