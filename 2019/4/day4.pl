#!/usr/local/bin/perl

use strict;
use warnings;
use Array::Utils qw(:all);
use List::MoreUtils qw(firstidx);
use List::Util qw( min );
use Data::Dumper;

my @list;
# 172930-683082
foreach (my $i=172930; $i < 683082; $i++) {
		if (nondecnr($i) && hasDupes($i)) {
			push @list, $i;
		} 
}


#print Dumper \@list;
my $listsize = @list;
print "Part 1: $listsize\n";

sub nondecnr {
	my $n = shift; 		
	my $x = $n % 10; 	
	my $y = int($n / 10); 
	
	while ($y) {
		return 0 if ( ($y % 10) > $x );
		$x = $y % 10;
		$y /= 10;
	}
	
	return 1;
}

sub hasDupes {
	my $n = shift;
    my @used;
    return 1 if ( $n > 9999999999 );

    for (my $i = 0; $i < 10; $i++) {
        $used[$i] = 0;
	}
	
    while ($n) {
        return 1 if ($used[ $n % 10 ] == 1 );
        $used[ $n % 10 ] = 1;
        $n = int( $n / 10 );
    }
    return 0;
}