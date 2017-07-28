#! /bin/bash

# Strip out project-gutenberrg headers and license:
# the first argument is the filename to split,
# the second is the filename to generate.

sed -e '/\*END\*THE SMALL PRINT\!/,/The End of Project Gutenberg Etext/!d' $1 > temp1
sed '/\*END\*THE SMALL PRINT\!/I d' temp1 > temp2
sed '/The End of Project Gutenberg Etext/I d' temp2 > $2

rm temp1
rm temp2
rm $1
