#!/bin/bash
#
# Batch word-pair counting script for English.
# Loop over all the books in 'en-tranche-1', sentence-split them
# and submit them for word-pair observe.
#

cd $(dirname $0)

# Check that the database server is running and has the right number of atoms.
total_atoms=`psql -d "guten" -t -c "SELECT COUNT(*) FROM atoms"`
if [ $total_atoms -gt 9 ]; then
    echo "WARNING: There are $total_atoms atoms in the database $database."
elif [ $total_atoms -lt 1 ]; then
    echo "There no atoms in the database $database."
    exit 1
fi

# Create directories if missing
mkdir -p split-books
mkdir -p observed-books
mkdir -p source-books

# Copy all the books
find ../text/en-tranche-1/ -type f -exec cp {} source-books/ \;

#rm source-books/*.txt
#cp ../text/en-tranche-1/pascal.txt source-books/pascal.txt
#cp test.txt source-books/test.txt

# Now observe each book
time find source-books/ -type f -exec ./split-observe-one-book.sh en {} localhost 17005 \;

# Sleep to give time for the OS to remove the files
sleep 1

# Report the number of files remaining in source, in case there were errors.
echo "Done observing, files NOT observed: "
find source-books/ -type f | wc -l
