#!/usr/local/bin/perl

use strict;
use warnings;

open(my $fh, "<", "input.txt") or die "Ooops! No input.txt";

my $total_fuel;

while (my $module_mass = <$fh>) {
	chomp $module_mass;
 	my $mod_fuel = int($module_mass/3) - 2;
 	$total_fuel += fuel($mod_fuel);			
}

sub fuel {
	my $m = shift;
	my $extra;
	if($m <= 0) {
		$extra = 0;
	} else { 
	  $extra = $m + fuel( (int($m/3) -2 ) ); 
	}
	
	return $extra;
}

print "Total fuel requiered: $total_fuel \n";

close ($fh);

