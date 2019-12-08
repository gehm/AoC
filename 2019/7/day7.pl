#!/usr/local/bin/perl

package IntComp;

use strict;
use warnings;
use Data::Dumper;
use List::Permutor;
use List::Util qw( max );

use lib ".";
use IntComp;

open(my $fh, "<", "input.txt") or die "Ooops! No input.txt";
my @int_prog = split(',', <$fh>);
close $fh;


# generate hash with all possible sequences
# value will be final output
my @signals;

my $perm = new List::Permutor qw/ 0 1 2 3 4 /;
while (my @set = $perm->next) {
	my @freshprog = @int_prog;
    #print "Order is: @set. ";
	
	# Amp A
	# First Input Pahse, 2nd 0 
	my $amp_a = IntComp::run( $set[0], "0", \@freshprog );
	#print $amp_a;
	
	my $amp_b = IntComp::run( $set[1], $amp_a, \@freshprog );
	my $amp_c = IntComp::run( $set[2], $amp_b, \@freshprog );
	my $amp_d = IntComp::run( $set[3], $amp_c, \@freshprog );
	my $thruster = IntComp::run( $set[4], $amp_d, \@freshprog );
	#print "Thrust: $thruster\n";
	push @signals, $thruster;
	
}
my $max = max @signals;
print "Maximum: $max \n";

