#! /usr/bin/env perl
#
# aggregate-one.pl
#
# Aggregate the sentences from standard in to a file for
# archiving and external use by programs that need to see
# the same text that we've observed or parsed.
#
# Example usage:
#    cat file | ./aggregate-one.pl
#

my $filename = 'corpus_sentences.txt';

# Open file in '>>' (append) mode.
open(my $out_file, '>>', $filename) or die "Could not open file '$filename' $!";

while (<STDIN>)
{
	if (/<P>/) { next; }
	chop;

	$sentence = $_;
	$out_file->print($_ . "\n");
}

close $out_file;