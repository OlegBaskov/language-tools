#! /usr/bin/env perl
#
# observe-one.pl <cogserver-host> <cogserver-port>
#
# Submit a collection of sentences, one sentence at a time, to the
# cogserver located on host ARGV[0] and port ARGV[1].  The sentences
# are read from standard input, and must be arranged with one sentence
# per line. They are sent to the cogserver using ARGV[2] as the command.
#
# Example usage:
#    cat file | ./observe-one.pl localhost 17001
#
use Time::HiRes qw/ time sleep /;
use constant { true => 1, false => 0 };

die "Wrong number of args!" if ($#ARGV != 1 && $#ARGV != 2);

# Verify that the host and port number are OK.
`nc -z $ARGV[0] $ARGV[1]`;
die "Netcat failed! Bad host or port?" if (0 != $?);

my $netcat = "|nc $ARGV[0] $ARGV[1]";
my $start_time = time();
my $last_time = $start_time;
my $count = 0;
my $average_time = 0.0;
my $sentence = "";
my $current_time = $start_time;
my $total_time = 1.0;

my $report_interval = 100;

my $verbose = 0;
my $check_pairs = false;

# Pair distance defines the maximum distance between words in pairs
# for the observe. NOTE: This should be greater or equal to the value 
# parsed in the sentence parsing pass so that there are MI values for
# all the pairs during parsing. If the pairs have not been observed,\
# then the parsing pass will have "missing pair" errors.
my $pair_distance = 2;

if ($#ARGV == 2) {
	$verbose = 1;
}

while (<STDIN>)
{
	if (/<P>/) { next; }
	chop;

	$sentence = $_;
	$command = "observe -pair_distance $pair_distance \"$sentence\"\n";

	$current_time = time();
	$total_time = $current_time - $start_time;
	$sentence_time = $current_time - $last_time;
	$last_time = $current_time;
	$count = $count + 1;
	$average_time = $total_time / $count;

	if ($verbose) {
		printf "parsing - %d (time %.2f, total %.2f, average %.2f): %s\n", $count, $sentence_time, $total_time, $average_time, $sentence;
	}
	
	open NC, $netcat || die "nc failed: $!\n";
	print NC "$command";
	close NC;
	
	if (($count % $report_interval) == 0) {
		printf "Processed sentence - %5d - %d seconds, average %.4f\n", $count, $total_time, $average_time;
	}

	if ($check_pairs)
	{
		$command = "parse -check_pairs -pair_distance $pair_distance \"$sentence\"\n";
		open NC, $netcat || die "nc failed: $!\n";
		print NC "$command";
		close NC;
		if ($verbose) {
			printf "checked - %d (time %.2f, total %.2f, average %.2f): %s\n", $count, $sentence_time, $total_time, $average_time, $sentence;
		}
	}
}

printf "Processed sentence - %5d - %d seconds, average %.4f\n", $count, $total_time, $average_time;

print "observe-one - Done with article.\n";
