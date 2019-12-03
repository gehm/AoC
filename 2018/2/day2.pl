#!/usr/local/bin/perl

use strict;
use warnings;
my ($two, $three) = 0;

open(my $fh, "<", "input.txt") or die "Ooops! No input.txt"; #26 chars long


while (my $boxid = <$fh>) {
	chomp $boxid;
	my $this_two = 0;
	my $this_three = 0;
	
	for (my $i = 'a'; $i le 'z'; $i++) {	
		my $count = () = $boxid =~ /$i/g;
		$this_two++ if $count == 2;
		$this_three++ if $count == 3;
		
	}
	$two++ if $this_two > 0;
	$three++ if $this_three > 0;
	
}

print "Checksum : ". ($two * $three) ."\n";

close ($fh);




