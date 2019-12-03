#!/usr/local/bin/perl

use strict;
use warnings;

my @boxes = ( );
open(my $fh, "<", "input.txt") or die "Ooops! No input.txt"; #26 chars long

while (my $boxid = <$fh>) {
	chomp $boxid;
	push @boxes, $boxid;
}

foreach ( @boxes ) {

		print $_;
		my $count = ( $boxid ^ $_ ) =~ tr/\0//c;
		if ($count == 1) { 
			print "$boxid and $_\n";
		} else {
			print "$count\n";
			push @boxes, $boxid;
		}
	}
}

close ($fh);




