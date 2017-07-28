#! /bin/bash

# Strip out project-gutenberrg headers and license:
# the first argument is the filename to split,
# the second is the filename to generate.

sed -e '/\*\*\*.*START.*PROJECT GUTENBERG/,/END OF .* PROJECT GUTENBERG/!d' $1 > temp1
sed '/\*\*\*.*START.*PROJECT GUTENBERG/I d' temp1 > temp2
sed '/END OF .* PROJECT GUTENBERG/I d' temp2 > $2

rm temp1
rm temp2
rm $1
