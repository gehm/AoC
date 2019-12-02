#!/usr/local/bin/perl

use strict;
use warnings;

open(my $fh, "<", "input.txt") or die "Ooops! No input.txt";

my $freq =0;

while (my $freq_change = <$fh>) {
	chomp $freq_change;
	my $operator = substr $freq_change,0,1;
	my $value = substr $freq_change, 1;
	#print "$operator,$value \n";
	if ($operator eq "+") {
		$freq += $value;
	} else {
		$freq -= $value;
	}
}

print " $freq \n";

close ($fh);

