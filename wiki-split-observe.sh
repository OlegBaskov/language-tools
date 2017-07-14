#!/bin/bash
#
# Batch word-pair counting script for English.
# Loop over all the files in 'beta-pages', sentence-split them
# and submit them for word-pair counting.
#



time find ../text/beta-pages-a-l -type f -exec ./split-observe-one.sh en {} localhost 17005 \;
