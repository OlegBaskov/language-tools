#! /usr/bin/env perl
#
# pair-check-one.pl <cogserver-host> <cogserver-port>
#
# Submit a collection of sentences for pair checking, 
# one sentence at a time, to the cogserver. The sentences
# are read from standard input, and must be arranged with 
# one sentence  per line.
#
# Example usage:
#    cat file | ./pair-check-one.pl localhost 17005
#
use Time::HiRes qw/ time sleep /;

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

my $chunk_size = 1;
my $report_interval = 100;

my $command_chunks = "";

my $verbose = 0;

# Pair distance defines the maximum distance between words in pairs
# for the parse. NOTE: This should be less or equal to the value 
# observed in the pair observation pass used to compute the MI values.
my $pair_distance = 2;

if ($#ARGV == 2) {
	$verbose = 1;
}

while (<STDIN>)
{
	if (/<P>/) { next; }
	chop;

	$sentence = $_;
	$command = "parse -check_pairs -pair_distance $pair_distance \"$_\"\n";
	$command_chunks .= $command;

	$current_time = time();
	$total_time = $current_time - $start_time;
	$sentence_time = $current_time - $last_time;
	$last_time = $current_time;
	$count = $count + 1;
	$average_time = $total_time / $count;


	if (($count % $chunk_size) == 0) {

		if ($verbose)
		{
			printf "-----\nchunk\n-----\n%s\n", $command_chunks;
			printf "sentence - %d (time %.2f, total %.2f, average %.2f): %s\n", $count, $sentence_time, $total_time, $average_time, $sentence;
		}
		open NC, $netcat || die "nc failed: $!\n";
		print NC "$command_chunks";
		close NC;
		$command_chunks = "";
	}

	if (($count % $report_interval) == 0) {
		printf "Processed sentence - %5d - %d seconds, average %.4f\n", $count, $total_time, $average_time;
	}
}

if ($count % $chunk_size != 0) {

	if ($verbose)
	{
		printf "-----\nchunk\n-----\n%s\n", $command_chunks;
		printf "sentence - %d (time %.2f, total %.2f, average %.2f): %s\n", $count, $sentence_time, $total_time, $average_time, $sentence;
	}
	open NC, $netcat || die "nc failed: $!\n";
	print NC "$command_chunks";
	close NC;
}

printf "Processed sentence - %5d - %d seconds, average %.4f\n", $count, $total_time, $average_time;
