#!/usr/local/bin/perl

use strict;
use warnings;
use List::MoreUtils qw{any}; 

my $freq = 0;
my @frequencies = ( 0, );
for (my $i = 0; $i <1000; $i++) {
	print "Loop $i\n";
	open(my $fh, "<", "input.txt") or die "Ooops! No input.txt";
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
		
		if ( any {$_ == $freq} @frequencies ) {
			print "Duplicate: $freq";
			exit;
		} else {
		#print "$freq\n";
		 push @frequencies,$freq; 
		}
	}
	close ($fh);
}



