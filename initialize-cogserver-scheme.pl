#! /usr/bin/env perl
#
# initialize-cogserver-scheme.pl <cogserver-host> <cogserver-port>
#
# Connect to the cogserver located on host ARGV[0] and port ARGV[1]. 
#
# This file initializes the language learning system in preparation for
# further calls to submit text via submit-one.pl.
#

die "Wrong number of args!" if ($#ARGV != 1);

# Verify that the host and port number are OK.
`nc -z $ARGV[0] $ARGV[1]`;
die "Netcat failed! Bad host or port?" if (0 != $?);

my $netcat = "|nc $ARGV[0] $ARGV[1]";

open NC, $netcat || die "nc failed: $!\n";
print NC "scm \n";
print NC "(use-modules (opencog) (opencog cogserver))\n";
print NC "(use-modules(opencog persist) (opencog persist-sql))\n";
print NC "(use-modules (opencog nlp) (opencog nlp learn))\n";

# Tell the cogserver where the relex server is.
print NC "(use-relex-server \"localhost\" 4445)";

# Open the sql database for persistence.
print NC "(sql-open \"postgres:///nlp\")";

# Do a test sentence.
print NC "(observe-text \"This is a test sentence.\")";

print "Done with initialization.\n";
