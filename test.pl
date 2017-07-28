#!/usr/bin/perl -w
#
# Multi-language sentence splitter.
#
# Derived from the moses-smt (Moses Statistica Machine Translation)
# sentece splitter; modified slightly for our needs.
#
# moses-smt and this file is licensed under the LGPLv2.1
# (Lesser GNU Public License Version 2.1)
# Based on Preprocessor written by Philipp Koehn

use utf8;
binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");

# This is one paragraph.
my $text = "This is a file with bad characters -- - and __bolded__ and _italicized_ text markers.\n" .
"Some even with _c'est la vie_ type foreign expressions.\n" .
" * * * * * *\n" .
"New text goes here.";

print "Starting text:\n";
print $text . "\n";
print "\n---------------\n";

# Remove dashes.
$text =~ s/ --/ —/g;
$text =~ s/-- /— /g;
$text =~ s/ -//g;
$text =~ s/- //g;
$text =~ s/(\* )+//g;
$text =~ s/( \*)+//g;
$text =~ s/  / /g;

# Remove the italicized and bolded text i.e. _italicized_ and __bolded__.
$text =~ s/__([a-zA-Z0-9']+[ a-zA-Z0-9']*[a-zA-Z0-9']+)__/$1/g;
$text =~ s/_([a-zA-Z0-9']+[ a-zA-Z0-9']*[a-zA-Z0-9']+)_/$1/g;

print $text . "\n";
