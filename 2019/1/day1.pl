#!/usr/local/bin/perl

use strict;
use warnings;

open(my $fh, "<", "input.txt") or die "Ooops! No input.txt";

my $total_fuel;

while (my $module_mass = <$fh>) {
	chomp $module_mass;
 	my $mod_fuel = int($module_mass/3) - 2;
 	$total_fuel += $mod_fuel;			
	print $mod_fuel."\n";
}

print "Total fuel requiered: $total_fuel \n";

close ($fh);

